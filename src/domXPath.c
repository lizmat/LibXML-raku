/* $Id$
 *
 * This is free software, you may use it and distribute it under the same terms as
 * Perl itself.
 *
 * Copyright 2001-2003 AxKit.com Ltd., 2002-2006 Christian Glahn, 2006-2009 Petr Pajas
 * Ported from Perl 5 to 6 by David Warring
*/

#include <libxml/hash.h>
#include <libxml/tree.h>
#include <libxml/xpath.h>
#include <libxml/xpathInternals.h>
#include <libxml/uri.h>

#include "dom.h"
#include "domXPath.h"
#include "xml6.h"
#include "xml6_node.h"

void
perlDocumentFunction(xmlXPathParserContextPtr ctxt, int nargs){
    xmlXPathObjectPtr obj = NULL, obj2 = NULL;
    xmlChar* base = NULL;
    xmlChar* URI = NULL;


    if ((nargs < 1) || (nargs > 2)) {
        ctxt->error = XPATH_INVALID_ARITY;
        return;
    }
    if (ctxt->value == NULL) {
        ctxt->error = XPATH_INVALID_TYPE;
        return;
    }

    if (nargs == 2) {
        if (ctxt->value->type != XPATH_NODESET) {
            ctxt->error = XPATH_INVALID_TYPE;
            return;
        }

        obj2 = valuePop(ctxt);
    }


    /* first assure the XML::LibXML error handler is deactivated
       otherwise strange things might happen
     */

    if (ctxt->value->type == XPATH_NODESET) {
        int i;
        xmlXPathObjectPtr newobj, ret;

        obj = valuePop(ctxt);
        ret = xmlXPathNewNodeSet(NULL);

        if (obj->nodesetval) {
            for (i = 0; i < obj->nodesetval->nodeNr; i++) {
                valuePush(ctxt,
                          xmlXPathNewNodeSet(obj->nodesetval->nodeTab[i]));
                xmlXPathStringFunction(ctxt, 1);
                if (nargs == 2) {
                    valuePush(ctxt, xmlXPathObjectCopy(obj2));
                } else {
                    valuePush(ctxt,
                              xmlXPathNewNodeSet(obj->nodesetval->nodeTab[i]));
                }
                perlDocumentFunction(ctxt, 2);
                newobj = valuePop(ctxt);
                ret->nodesetval = xmlXPathNodeSetMerge(ret->nodesetval,
                                                       newobj->nodesetval);
                newobj->nodesetval = NULL;
                xmlXPathFreeObject(newobj);
            }
        }

        xmlXPathFreeObject(obj);
        if (obj2 != NULL)
            xmlXPathFreeObject(obj2);
        valuePush(ctxt, ret);

        /* reset the error old error handler before leaving
         */
        return;
    }
    /*
     * Make sure it's converted to a string
     */
    xmlXPathStringFunction(ctxt, 1);
    if (ctxt->value->type != XPATH_STRING) {
        ctxt->error = XPATH_INVALID_TYPE;
        if (obj2 != NULL)
            xmlXPathFreeObject(obj2);

        /* reset the error old error handler before leaving
         */

        return;
    }
    obj = valuePop(ctxt);
    if (obj->stringval == NULL) {
        valuePush(ctxt, xmlXPathNewNodeSet(NULL));
    } else {
        if ((obj2 != NULL) && (obj2->nodesetval != NULL) &&
            (obj2->nodesetval->nodeNr > 0)) {
            xmlNodePtr target;

            target = obj2->nodesetval->nodeTab[0];
            if (target->type == XML_ATTRIBUTE_NODE) {
                target = ((xmlAttrPtr) target)->parent;
            }
            base = xmlNodeGetBase(target->doc, target);
        } else {
            base = xmlNodeGetBase(ctxt->context->node->doc, ctxt->context->node);
        }
        URI = xmlBuildURI(obj->stringval, base);
        if (base != NULL)
            xmlFree(base);
        if (URI == NULL) {
            valuePush(ctxt, xmlXPathNewNodeSet(NULL));
        } else {
            if (xmlStrEqual(ctxt->context->node->doc->URL, URI)) {
                valuePush(ctxt, xmlXPathNewNodeSet((xmlNodePtr)ctxt->context->node->doc));
            }
            else {
                xmlDocPtr doc;
                doc = xmlParseFile((const char *)URI);
                if (doc == NULL)
                    valuePush(ctxt, xmlXPathNewNodeSet(NULL));
                else {
                    /* TODO: use XPointer of HTML location for fragment ID */
                    /* pbm #xxx can lead to location sets, not nodesets :-) */
                    valuePush(ctxt, xmlXPathNewNodeSet((xmlNodePtr) doc));
                }
            }
            xmlFree(URI);
        }
    }
    xmlXPathFreeObject(obj);
    if (obj2 != NULL)
        xmlXPathFreeObject(obj2);

    /* reset the error old error handler before leaving
     */
}

void
domReferenceNodeSet(xmlNodeSetPtr self) {
  int i;

  for (i = 0; i < self->nodeNr; i++) {
    xmlNodePtr cur = self->nodeTab[i];

    if (cur != NULL) {
      if (cur->type != XML_NAMESPACE_DECL) {
        xml6_node_add_reference(cur);
      }
    }
  }
}

static void
_domNodeSetDeallocator(void *entry, unsigned char *key ATTRIBUTE_UNUSED) {
  xmlNodePtr twig = (xmlNodePtr) entry;
  if (domNodeIsReferenced(twig) == 0) {
    xmlFreeNode(twig);
  }
}

void
domReleaseNodeSet(xmlNodeSetPtr self) {
  int i;
  xmlHashTablePtr hash = xmlHashCreate(self->nodeNr);
  xmlNodePtr last_twig = NULL;

  for (i = 0; i < self->nodeNr; i++) {
    xmlNodePtr cur = self->nodeTab[i];

    if (cur != NULL) {
      if (cur->type == XML_NAMESPACE_DECL) {
        xmlXPathNodeSetFreeNs((xmlNsPtr) cur);
      }
      else {
        xmlNodePtr twig = xml6_node_find_root(cur);
        if (twig != last_twig) {
          char key[20];
          sprintf(key, "%ld", (long) cur);

          if (xmlHashLookup(hash, (xmlChar*)key) == NULL) {
            xmlHashAddEntry(hash, xmlStrdup((xmlChar*)key), twig);
          }

          last_twig = twig;
        }
        xml6_node_remove_reference(cur);
      }
    }
  }

  xmlHashFree(hash, _domNodeSetDeallocator);
  xmlFree(self);
}

void
domReferenceXPathObject(xmlXPathObjectPtr self) {
  if (self->type == XPATH_NODESET && self->nodesetval != NULL) {
    domReferenceNodeSet(self->nodesetval);
  }
}

void
domReleaseXPathObject(xmlXPathObjectPtr self) {
  if (self->type == XPATH_NODESET && self->nodesetval != NULL) {
    domReleaseNodeSet(self->nodesetval);
    self->nodesetval = NULL;
  }
  else if (self->type == XPATH_RANGE) {
    xml6_warn("todo: cleanup of XPath range objects");
  }
  xmlXPathFreeObject(self);
}

xmlXPathObjectPtr
domXPathFind( xmlNodePtr refNode, xmlChar* path, int to_bool ) {
    xmlXPathObjectPtr rv = NULL;
    xmlXPathCompExprPtr comp;
    comp = xmlXPathCompile( path );
    if ( comp == NULL ) {
        return NULL;
    }
    rv = domXPathCompFind(refNode,comp,to_bool);
    xmlXPathFreeCompExpr(comp);
    return rv;
}

static xmlNodeSetPtr
_domVetNodeSet(xmlNodeSetPtr node_set) {

  if (node_set != NULL ) {
    int i = 0;
    int skipped = 0;

    for (i = 0; i < node_set->nodeNr; i++) {
      xmlNodePtr tnode = node_set->nodeTab[i];
      int skip = 0;
      if (tnode == NULL) {
        skip = 1;
      }
      else if (tnode->type == XML_NAMESPACE_DECL) {
        xmlNsPtr ns = (xmlNsPtr)tnode;
        const xmlChar* prefix = ns->prefix;
        const xmlChar* href = ns->href;
        if ((prefix != NULL) && (xmlStrEqual(prefix, BAD_CAST "xml"))) {
          if (xmlStrEqual(href, XML_XML_NAMESPACE))
            xmlFreeNs(ns);
            skip = 1;
        }
      }
      if (skip) {
        skipped++;
      }
      else if (skipped) {
        node_set->nodeTab[i - skipped] = node_set->nodeTab[i];
      }
    }
    node_set->nodeNr -= skipped;
  }
  return node_set;
}

static xmlXPathObjectPtr
_domVetXPathObject(xmlXPathObjectPtr self) {
  if (self->type == XPATH_NODESET && self->nodesetval != NULL) {
    _domVetNodeSet(self->nodesetval);
  }
  return self;
}

xmlXPathContextPtr
domXPathNewCtxt(xmlNodePtr refNode) {
  xmlXPathContextPtr ctxt;

  /* prepare the xpath context */
  ctxt = xmlXPathNewContext( refNode->doc );
  ctxt->node = refNode;
  /* get the namespace information */
  if (refNode->type == XML_DOCUMENT_NODE) {
    ctxt->namespaces = xmlGetNsList( refNode->doc,
                                     xmlDocGetRootElement( refNode->doc ) );
  }
  else {
    ctxt->namespaces = xmlGetNsList(refNode->doc, refNode);
  }
  ctxt->nsNr = 0;
  if (ctxt->namespaces != NULL) {
    while (ctxt->namespaces[ctxt->nsNr] != NULL)
      ctxt->nsNr++;
  }

  xmlXPathRegisterFunc(ctxt,
                       (const xmlChar*) "document",
                       perlDocumentFunction);
  return ctxt;
}

void
domXPathFreeCtxt(xmlXPathContextPtr ctxt) {
  if (ctxt->namespaces != NULL) {
    xmlFree( ctxt->namespaces );
    ctxt->namespaces = NULL;
  }
  xmlXPathFreeContext(ctxt);
}


xmlXPathObjectPtr
domXPathCompFind( xmlNodePtr refNode, xmlXPathCompExprPtr comp, int to_bool ) {
    xmlXPathObjectPtr rv = NULL;
    if ( refNode != NULL && comp != NULL ) {
        xmlXPathContextPtr ctxt = domXPathNewCtxt(refNode);
        rv = domXPathCompFindCtxt(ctxt, comp, to_bool);
        domXPathFreeCtxt(ctxt);
    }
    return rv;
}


xmlNodeSetPtr
domSelectNodeSet(xmlXPathObjectPtr xpath_obj) {
    xmlNodeSetPtr rv = NULL;
    if (xpath_obj != NULL) {
      /* here we have to transfer the result from the internal
         structure to the return value */
      /* get the result from an xpath query */
      /* we have to unbind the nodelist, so free object can
         not kill it */
      rv = xpath_obj->nodesetval;
      xpath_obj->nodesetval = NULL;
    }
    return rv;
}

static xmlNodeSetPtr
_domSelect(xmlXPathObjectPtr xpath_obj) {
    xmlNodeSetPtr rv = domSelectNodeSet(xpath_obj);
    xmlXPathFreeObject(xpath_obj);
    _domVetNodeSet(rv);
    return rv;
}

xmlNodeSetPtr
domXPathSelect( xmlNodePtr refNode, xmlChar* path ) {
    return _domSelect( domXPathFind( refNode, path, 0 ) );
}


xmlNodeSetPtr
domXPathCompSelect( xmlNodePtr refNode, xmlXPathCompExprPtr comp ) {
    return _domSelect( domXPathCompFind( refNode, comp, 0 ));
}

xmlXPathObjectPtr
domXPathFindCtxt( xmlXPathContextPtr ctxt, xmlChar* path, int to_bool ) {
    xmlXPathObjectPtr rv = NULL;
    if ( ctxt->node != NULL && path != NULL ) {
        xmlXPathCompExprPtr comp;
        comp = xmlXPathCompile( path );
        if ( comp == NULL ) {
            return NULL;
        }
        rv = domXPathCompFindCtxt(ctxt,comp,to_bool);
        xmlXPathFreeCompExpr(comp);
    }
    return rv;
}

xmlXPathObjectPtr
domXPathCompFindCtxt( xmlXPathContextPtr ctxt, xmlXPathCompExprPtr comp, int to_bool ) {
    xmlXPathObjectPtr rv = NULL;
    if ( ctxt != NULL && ctxt->node != NULL && comp != NULL ) {
        if (to_bool) {
#if LIBXML_VERSION >= 20627
          int val = xmlXPathCompiledEvalToBoolean(comp, ctxt);
          rv = xmlXPathNewBoolean(val);
#else
          rv = xmlXPathCompiledEval(comp, ctxt);
          if (rv!=NULL) {
            int val = xmlXPathCastToBoolean(rv);
            xmlXPathFreeObject(rv);
            rv = xmlXPathNewBoolean(val);
          }
#endif
        } else {
          rv = xmlXPathCompiledEval(comp, ctxt);
        }
    }
    return _domVetXPathObject(rv);
}

xmlNodeSetPtr
domXPathCompSelectCtxt( xmlXPathContextPtr ctxt, xmlXPathCompExprPtr comp) {
  return _domSelect(domXPathCompFindCtxt(ctxt, comp, 0));
}

xmlNodeSetPtr
domXPathSelectCtxt( xmlXPathContextPtr ctxt, xmlChar* path ) {
    return _domSelect( domXPathFindCtxt( ctxt, path, 0 ) );
}

