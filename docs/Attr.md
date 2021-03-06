class LibXML::Attr
------------------

LibXML Attribute nodes

Synopsis
--------

    use LibXML::Attr;
    use LibXML::Element;
    # Only methods specific to Attribute nodes are listed here,
    # see the LibXML::Node documentation for other methods

    my LibXML::Attr $attr .= new(:$name, :$value);
    my Str $value = $attr.value;
    $att.value = $value;
    my LibXML::Element $node = $attr.getOwnerElement();
    $attr.setNamespace($nsURI, $prefix);
    my Bool $is-id = $attr.isId;
    my Str $content = $attr.serializeContent;

Description
-----------

This is the interface to handle Attributes like ordinary nodes. The naming of the class relies on the W3C DOM documentation.

Methods
-------

The class inherits from [LibXML::Node](https://libxml-raku.github.io/LibXML-raku/Node). The documentation for Inherited methods is not listed here.

Many functions listed here are extensively documented in the DOM Level 3 specification ([http://www.w3.org/TR/DOM-Level-3-Core/](http://www.w3.org/TR/DOM-Level-3-Core/)). Please refer to the specification for extensive documentation.

### method new

    method new(QName :$name!, Str :$value!, LibXML::Document :$doc) returns LibXML::Attribue

Class constructor.

### method value

```perl6
method value() returns Str
```

Gets or sets the attribute stored for the value

Str:U is returned if the attribute has no value

### method getOwnerElement

    method getOwnerElement() returns LibXML::Element;

Returns the node the attribute belongs to. If the attribute is not bound to a node, LibXML::Element:U will be returned.

### method setNamespace

    method setNamespace(Str $nsURI, NCName $prefix);

This function tries to bound the attribute to a given namespace. If `$nsURI` is undefined or empty, the function discards any previous association of the attribute with a namespace. If the namespace was not previously declared in the context of the attribute, this function will fail. In this case you may wish to call setNamespace() on the ownerElement. If the namespace URI is non-empty and declared in the context of the attribute, but only with a different (non-empty) prefix, then the attribute is still bound to the namespace but gets a different prefix than `$prefix`. The function also fails if the prefix is empty but the namespace URI is not (because unprefixed attributes should by definition belong to no namespace). This function returns True on success, Failure otherwise.

If you don't want the overheads of managing namespaces, a quick way of ensuring that the namespace is not rejected is to call the `requireNamespace` method on the containing node:

    # re-use any existing definitions in the current scope, or add to the
    # parent with a generated prefix
    my $prefix = $att.parent.requireNamespace($uri);
    $att.setNamespace($uri, $prefix);

### method isId

    method isId() returns Bool

Determine whether an attribute is of type ID. For documents with a DTD, this information is only available if DTD loading/validation has been requested. For HTML documents parsed with the HTML parser ID detection is done automatically. In XML documents, all "xml:id" attributes are considered to be of type ID.

### method serializeContent

    method serializeContent() returns Bool

This function is not part of DOM API. It returns attribute content in the form in which it serializes into XML, that is with all meta-characters properly quoted and with raw entity references (except for entities expanded during parse time).

Copyright
---------

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

License
-------

This program is free software; you can redistribute it and/or modify it under the terms of the Artistic License 2.0 [http://www.perlfoundation.org/artistic_license_2_0](http://www.perlfoundation.org/artistic_license_2_0).

