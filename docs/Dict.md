Synopsis
--------

    my LibXML::Dict $dict .= new;
    $dict.see('a');
    $dict.see: <x y z>;
    say $dict.seen('a'); # True
    say $dict.seen('b'); # False
    say $dict<a>:exists; # True
    say $dict<b>:exists; # False
    say $dict.elems; # a x y z

Description
-----------

A LibXML::Dict bins to the xmlDict data structure, which is used to uniquely identify and store strings.

Please see also [LibXML::HashMap](https://libxml-raku.github.io/LibXML-raku/HashMap), for a more general-purpose associative interface.

