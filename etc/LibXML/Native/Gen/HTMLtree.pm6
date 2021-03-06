use v6;
#  -- DO NOT EDIT --
# generated by: etc/generator.p6 

unit module LibXML::Native::Gen::HTMLtree;
# specific APIs to process HTML tree, especially serialization:
#    this module implements a few function needed to process tree in an HTML specific way. 
use LibXML::Native::Defs :$lib, :xmlCharP;

our sub htmlDocDump(FILE * $f, xmlDoc $cur --> int32) is native(XML2) is export {*}
our sub htmlGetMetaEncoding(htmlDoc $doc --> xmlCharP) is native(XML2) is export {*}
our sub htmlIsBooleanAttr(xmlCharP $name --> int32) is native(XML2) is export {*}
our sub htmlNewDoc(xmlCharP $URI, xmlCharP $ExternalID --> htmlDoc) is native(XML2) is export {*}
our sub htmlNewDocNoDtD(xmlCharP $URI, xmlCharP $ExternalID --> htmlDoc) is native(XML2) is export {*}
our sub htmlNodeDumpFile(FILE * $out, xmlDoc $doc, xmlNode $cur) is native(XML2) is export {*}
our sub htmlNodeDumpFileFormat(FILE * $out, xmlDoc $doc, xmlNode $cur, Str $encoding, int32 $format --> int32) is native(XML2) is export {*}
our sub htmlSaveFile(Str $filename, xmlDoc $cur --> int32) is native(XML2) is export {*}
our sub htmlSaveFileEnc(Str $filename, xmlDoc $cur, Str $encoding --> int32) is native(XML2) is export {*}
our sub htmlSaveFileFormat(Str $filename, xmlDoc $cur, Str $encoding, int32 $format --> int32) is native(XML2) is export {*}
our sub htmlSetMetaEncoding(htmlDoc $doc, xmlCharP $encoding --> int32) is native(XML2) is export {*}
