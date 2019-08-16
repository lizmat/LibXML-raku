use v6;
#  -- DO NOT EDIT --
# generated by: etc/generator.p6 

unit module LibXML::Native::Gen::dict;
# string dictionary:
#    dictionary of reusable strings, just used to avoid allocation and freeing operations. 
use LibXML::Native::Defs :LIB, :XmlCharP;

struct xmlDict is repr('CPointer') {
    sub xmlDictCreate( --> xmlDict) is native(LIB) {*};

    method xmlDictCreateSub( --> xmlDict) is native(LIB) {*};
    method xmlDictExists(xmlCharP $name, int32 $len --> xmlCharP) is native(LIB) {*};
    method xmlDictFree() is native(LIB) {*};
    method xmlDictGetUsage( --> size_t) is native(LIB) {*};
    method xmlDictLookup(xmlCharP $name, int32 $len --> xmlCharP) is native(LIB) {*};
    method xmlDictOwns(xmlCharP $str --> int32) is native(LIB) {*};
    method xmlDictQLookup(xmlCharP $prefix, xmlCharP $name --> xmlCharP) is native(LIB) {*};
    method xmlDictReference( --> int32) is native(LIB) {*};
    method xmlDictSetLimit(size_t $limit --> size_t) is native(LIB) {*};
    method xmlDictSize( --> int32) is native(LIB) {*};
}

sub xmlDictCleanup() is native(LIB) {*};
sub xmlInitializeDict( --> int32) is native(LIB) {*};