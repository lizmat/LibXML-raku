use v6;
#  -- DO NOT EDIT --
# generated by: etc/generator.p6 

unit module LibXML::Native::Gen::parser;
# the core parser module:
#    Interfaces, constants and types related to the XML parser 
use LibXML::Native::Defs :LIB, :XmlCharP;

enum xmlFeature is export {
    XML_WITH_AUTOMATA => 23,
    XML_WITH_C14N => 14,
    XML_WITH_CATALOG => 15,
    XML_WITH_DEBUG => 28,
    XML_WITH_DEBUG_MEM => 29,
    XML_WITH_DEBUG_RUN => 30,
    XML_WITH_EXPR => 24,
    XML_WITH_FTP => 9,
    XML_WITH_HTML => 12,
    XML_WITH_HTTP => 10,
    XML_WITH_ICONV => 19,
    XML_WITH_ICU => 32,
    XML_WITH_ISO8859X => 20,
    XML_WITH_LEGACY => 13,
    XML_WITH_LZMA => 33,
    XML_WITH_MODULES => 27,
    XML_WITH_NONE => 99999,
    XML_WITH_OUTPUT => 3,
    XML_WITH_PATTERN => 6,
    XML_WITH_PUSH => 4,
    XML_WITH_READER => 5,
    XML_WITH_REGEXP => 22,
    XML_WITH_SAX1 => 8,
    XML_WITH_SCHEMAS => 25,
    XML_WITH_SCHEMATRON => 26,
    XML_WITH_THREAD => 1,
    XML_WITH_TREE => 2,
    XML_WITH_UNICODE => 21,
    XML_WITH_VALID => 11,
    XML_WITH_WRITER => 7,
    XML_WITH_XINCLUDE => 18,
    XML_WITH_XPATH => 16,
    XML_WITH_XPTR => 17,
    XML_WITH_ZLIB => 31,
}

enum xmlParserInputState is export {
    XML_PARSER_ATTRIBUTE_VALUE => 12,
    XML_PARSER_CDATA_SECTION => 8,
    XML_PARSER_COMMENT => 5,
    XML_PARSER_CONTENT => 7,
    XML_PARSER_DTD => 3,
    XML_PARSER_END_TAG => 9,
    XML_PARSER_ENTITY_DECL => 10,
    XML_PARSER_ENTITY_VALUE => 11,
    XML_PARSER_EOF => -1,
    XML_PARSER_EPILOG => 14,
    XML_PARSER_IGNORE => 15,
    XML_PARSER_MISC => 1,
    XML_PARSER_PI => 2,
    XML_PARSER_PROLOG => 4,
    XML_PARSER_PUBLIC_LITERAL => 16,
    XML_PARSER_START => 0,
    XML_PARSER_START_TAG => 6,
    XML_PARSER_SYSTEM_LITERAL => 13,
}

enum xmlParserMode is export {
    XML_PARSE_DOM => 1,
    XML_PARSE_PUSH_DOM => 3,
    XML_PARSE_PUSH_SAX => 4,
    XML_PARSE_READER => 5,
    XML_PARSE_SAX => 2,
    XML_PARSE_UNKNOWN => 0,
}

enum xmlParserOption is export {
    XML_PARSE_BIG_LINES => 4194304,
    XML_PARSE_COMPACT => 65536,
    XML_PARSE_DTDATTR => 8,
    XML_PARSE_DTDLOAD => 4,
    XML_PARSE_DTDVALID => 16,
    XML_PARSE_HUGE => 524288,
    XML_PARSE_IGNORE_ENC => 2097152,
    XML_PARSE_NOBASEFIX => 262144,
    XML_PARSE_NOBLANKS => 256,
    XML_PARSE_NOCDATA => 16384,
    XML_PARSE_NODICT => 4096,
    XML_PARSE_NOENT => 2,
    XML_PARSE_NOERROR => 32,
    XML_PARSE_NONET => 2048,
    XML_PARSE_NOWARNING => 64,
    XML_PARSE_NOXINCNODE => 32768,
    XML_PARSE_NSCLEAN => 8192,
    XML_PARSE_OLD10 => 131072,
    XML_PARSE_OLDSAX => 1048576,
    XML_PARSE_PEDANTIC => 128,
    XML_PARSE_RECOVER => 1,
    XML_PARSE_SAX1 => 512,
    XML_PARSE_XINCLUDE => 1024,
}

struct xmlParserNodeInfo is repr('CStruct') {
    has const struct _xmlNode * $.node; # Position & line # that text that created the node begins & ends on
    has unsigned long $.begin_pos;
    has unsigned long $.begin_line;
    has unsigned long $.end_pos;
    has unsigned long $.end_line;
}

struct xmlParserNodeInfoSeq is repr('CStruct') {
    has unsigned long $.maximum;
    has unsigned long $.length;
    has xmlParserNodeInfo * $.buffer;
    method xmlClearNodeInfoSeq( --> void) is native(LIB) {*};
    method xmlInitNodeInfoSeq( --> void) is native(LIB) {*};
}

struct xmlSAXHandlerV1 is repr('CStruct') {
    has internalSubsetSAXFunc $.internalSubset;
    has isStandaloneSAXFunc $.isStandalone;
    has hasInternalSubsetSAXFunc $.hasInternalSubset;
    has hasExternalSubsetSAXFunc $.hasExternalSubset;
    has resolveEntitySAXFunc $.resolveEntity;
    has getEntitySAXFunc $.getEntity;
    has entityDeclSAXFunc $.entityDecl;
    has notationDeclSAXFunc $.notationDecl;
    has attributeDeclSAXFunc $.attributeDecl;
    has elementDeclSAXFunc $.elementDecl;
    has unparsedEntityDeclSAXFunc $.unparsedEntityDecl;
    has setDocumentLocatorSAXFunc $.setDocumentLocator;
    has startDocumentSAXFunc $.startDocument;
    has endDocumentSAXFunc $.endDocument;
    has startElementSAXFunc $.startElement;
    has endElementSAXFunc $.endElement;
    has referenceSAXFunc $.reference;
    has charactersSAXFunc $.characters;
    has ignorableWhitespaceSAXFunc $.ignorableWhitespace;
    has processingInstructionSAXFunc $.processingInstruction;
    has commentSAXFunc $.comment;
    has warningSAXFunc $.warning;
    has errorSAXFunc $.error;
    has fatalErrorSAXFunc $.fatalError; # unused error() get all the errors
    has getParameterEntitySAXFunc $.getParameterEntity;
    has cdataBlockSAXFunc $.cdataBlock;
    has externalSubsetSAXFunc $.externalSubset;
    has unsigned int $.initialized;
}
    sub xmlCleanupParser( --> void) is native(LIB) {*};
    sub xmlGetExternalEntityLoader( --> xmlExternalEntityLoader) is native(LIB) {*};
    sub xmlGetFeaturesList(int * $len, const char ** $result --> int32) is native(LIB) {*};
    sub xmlHasFeature(xmlFeature $feature --> int32) is native(LIB) {*};
    sub xmlInitParser( --> void) is native(LIB) {*};
    sub xmlKeepBlanksDefault(int32 $val --> int32) is native(LIB) {*};
    sub xmlLineNumbersDefault(int32 $val --> int32) is native(LIB) {*};
    sub xmlParserFindNodeInfo(const xmlParserCtxt $ctx, const xmlNode $node --> const xmlParserNodeInfo *) is native(LIB) {*};
    sub xmlParserFindNodeInfoIndex(const xmlParserNodeInfoSeq $seq, const xmlNode $node --> unsigned long) is native(LIB) {*};
    sub xmlPedanticParserDefault(int32 $val --> int32) is native(LIB) {*};
    sub xmlSetExternalEntityLoader(xmlExternalEntityLoader $f --> void) is native(LIB) {*};
    sub xmlSubstituteEntitiesDefault(int32 $val --> int32) is native(LIB) {*};