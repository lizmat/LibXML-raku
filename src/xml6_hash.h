#ifndef __XML6_HASH_H
#define __XML6_HASH_H

#include <libxml/hash.h>

DLLEXPORT void xml6_hash_keys(xmlHashTablePtr, void**);
DLLEXPORT void xml6_hash_values(xmlHashTablePtr, void**);
DLLEXPORT void xml6_hash_key_values(xmlHashTablePtr, void**);
DLLEXPORT void xml6_hash_add_pairs(xmlHashTablePtr, void**, unsigned int, xmlHashDeallocator);
DLLEXPORT xmlHashTablePtr xml6_hash_xpath_node_children(xmlNodePtr, int);
DLLEXPORT xmlHashTablePtr xml6_hash_xpath_nodeset(xmlNodeSetPtr, int);

#endif /* __XML6_HASH_H */
