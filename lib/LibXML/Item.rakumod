# methods implemented by LibXML::Node and LibXML::Namespace
#| LibXML Nodes and Namespaces interface role
unit role LibXML::Item;

=begin pod
=head2 Descripton

LibXML::Item is a role performed by L<LibXML::Namespace> and L<LibXML::Node> based classes.

These are distinct classes in libxml2, but do share common methods: getNamespaceURI, localname(prefix), name(nodeName), type (nodeType), string-value, URI.

Also note that the L<LibXML::Node> `findnodes` method can sometimes return either L<LibXML::Node> or L<LibXML::Namespace> items, e.g.:
  =begin code :lang<raku>
  use LibXML::Item;
  for $elem.findnodes('namespace::*|attribute::*') -> LibXML::Item $_ {
     when LibXML::Namespace { say "namespace: " ~ .Str }
     when LibXML::Attr      { say "attribute: " ~ .Str }
  }
  =end code

Please see L<LibXML::Node> and L<LibXML::Namespace>.

=head2 Functions and Methods
=end pod

use LibXML::Native;
use LibXML::Native::DOM::Node;
use LibXML::Enums;
 
method getNamespaceURI {...}
method localname {...}
method name {...}
method nodeName {...}
method nodeType {...}
method prefix {...}
method string-value {...}
method Str {...}
method URI {...}
method type {...}
method value {...}

my constant @ClassMap = do {
    my Str @map;
    for (
        'LibXML::Attr'             => XML_ATTRIBUTE_NODE,
        'LibXML::Dtd::Attr'        => XML_ATTRIBUTE_DECL,
        'LibXML::CDATA'            => XML_CDATA_SECTION_NODE,
        'LibXML::Comment'          => XML_COMMENT_NODE,
        'LibXML::Dtd'              => XML_DTD_NODE,
        'LibXML::DocumentFragment' => XML_DOCUMENT_FRAG_NODE,
        'LibXML::Document'         => XML_DOCUMENT_NODE,
        'LibXML::Document'         => XML_HTML_DOCUMENT_NODE,
        'LibXML::Document'         => XML_DOCB_DOCUMENT_NODE,
        'LibXML::Element'          => XML_ELEMENT_NODE,
        'LibXML::Dtd::Element'     => XML_ELEMENT_DECL,
        'LibXML::Entity'           => XML_ENTITY_DECL,
        'LibXML::EntityRef'        => XML_ENTITY_REF_NODE,
        'LibXML::Namespace'        => XML_NAMESPACE_DECL,
        'LibXML::PI'               => XML_PI_NODE,
        'LibXML::Text'             => XML_TEXT_NODE,
    ) {
        @map[.value] = .key
    }
    @map;
}

sub item-class($class-name) is export(:item-class) {
    my $class = ::($class-name);
    $class ~~ LibXML::Item
        ?? $class
        !! (require ::($class-name));
}

sub box-class(UInt $_) is export(:box-class) {
    item-class(@ClassMap[$_] // 'LibXML::Item');
}

#| Node constructor from data
proto sub ast-to-xml(| --> LibXML::Item) is export(:ast-to-xml) {*}
=begin pod
    =para
    This function can be useful as a succent of building nodes from data. For example:

    =begin code :lang<raku>
    use LibXML::Element;
    use LibXML::Item :&ast-to-xml;
    my LibXML::Element $elem = ast-to-xml(
        :dromedaries[
                 "\n  ", # white-space
                 '#comment' => ' Element Construction. ',
                 "\n  ", :species[:name<Camel>, :humps["1 or 2"], :disposition["Cranky"]],
                 "\n  ", :species[:name<Llama>, :humps["1 (sort of)"], :disposition["Aloof"]],
                 "\n  ", :species[:name<Alpaca>, :humps["(see Llama)"], :disposition["Friendly"]],
         "\n",
         ]);
    say $elem;
    =end code
Produces:
    =begin code :lang<xml>
    <dromedaries>
      <!-- Element Construction. -->
      <species name="Camel"><humps>1 or 2</humps><disposition>Cranky</disposition></species>
      <species name="Llama"><humps>1 (sort of)</humps><disposition>Aloof</disposition></species>
      <species name="Alpaca"><humps>(see Llama)</humps><disposition>Friendly</disposition></species>
    </dromedaries>
    =end code
=end pod

multi sub ast-to-xml(Pair $_) {
    my $name = .key;
    my $value := .value;

    my UInt $node-type := itemNode::NodeType($name);

    if $value ~~ Str:D {
        when $name.starts-with('#') {
            box-class($node-type).new: :content($value);
        }
        when $name.starts-with('?') {
            $name .= substr(1);
            item-class('LibXML::PI').new: :$name, :content($value);
        }
        when $name.starts-with('xmlns:') {
            my $prefix = $name.substr(6);
            item-class('LibXML::Namespace').new: :$prefix, :URI($value)
        }
        default {
            $name .= substr(1) if $name.starts-with('@');
            item-class('LibXML::Attr').new: :$name, :$value;
        }
    }
    else {
        if $name.starts-with('&') {
            $name .= substr(1);
            $name .= chop() if $name.ends-with(';');
        }
        my $node := box-class($node-type).new: :$name;
        for $value.List {
            $node.add( ast-to-xml($_) ) if .defined;
        }
        $node;
    }
}

multi sub ast-to-xml(Positional $_) {
    ast-to-xml('#fragment' => $_);
}

multi sub ast-to-xml(Str:D $content) {
    item-class('LibXML::Text').new: :$content;
}

multi sub ast-to-xml(LibXML::Item:D $_) { $_ }

multi sub ast-to-xml(*%p where .elems == 1) {
    ast-to-xml(%p.pairs[0]);
}

#| Dump data for a node
method ast { ... }
=begin pod

    =para
    All DOM nodes have an `.ast()` method that can be used to output an intermediate dump of data. In the above example `$elem.ast()` would reproduce thw original data that was used to construct the element.

    Possible terms that can be used are:

    =begin table
    Term | Description
    =====+============  
    name => [term, term, ...] | Construct an element and its child items
    name => str-val | Construct an attribute
    'xmlns:prefix' => str-val | Construct a namespace
    'text content' | Construct text node
    '?name' => str-val | Construct a processing instruction
    '#cdata' => str-val | Construct a CData node
    '#comment' => str-val | Construct a comment node
    [elem, elem, ..] | Construct a document fragment
    '#xml'  => [root-elem] | Construct an XML document
    '#html' => [root-elem] | Construct an HTML document
    '&name' => [] | Construct an entity reference
    LibXML::Item | Reuse an existing node or namespace
    =end table

=end pod

#| Wrap a native object in a containing class
method box(LibXML::Native::DOM::Node $struct,
           :$doc = $.doc, # reusable document object
           --> LibXML::Item
          ) {
    do with $struct {
        die $_ with .domFailure;
        my $class := box-class(.type);
        die "mismatch between DOM node of type {.type} ({$class.perl}) and container object of class {self.WHAT.perl}"
            unless $class ~~ self.WHAT;
        my $native := .delegate;
        $class.new: :$native, :$doc;
    } // self.WHAT; 
}
=begin pod
    =para
    By convention native classes in the LibXML module are not directly exposed, but have a containing class
    that holds the object in a `$.native` attribute and provides an API interface for it. The `box` method is used to stantiate
    a containing object, of an appropriate class. The containing object will in-turn reference-count or copy the object
    to ensure that the underlying native object is not destroyed while it is still alive.

    For example to box xmlElem native object:
     =begin code :lang<raku>
     use LibXML::Native;
     use LibXML::Node;
     use LibXML::Element;

     my xmlElem $native .= new: :name<Foo>;
     say $native.type; # 1 (element)
     my LibXML::Element $elem .= box($native);
     $!native := Nil;
     say $elem.Str; # <Foo/>
     =end code
    A containing object of the correct type (LibXML::Element) has been created for the native object.

=end pod

method unbox { $.native }

multi trait_mod:<is>(
    Method $m where {.yada, && .returns ~~ LibXML::Item && !.signature.params>>.type.first(LibXML::Item)},
    :$boxed!) is export(:boxed) {
    my $name = $boxed ~~ Str:D ?? $boxed !! $m.name;
    $m.wrap: method (|c) {
        $m.returns.box: $.native."$name"(|c);
    }
}

method keep(LibXML::Native::DOM::Node $rv,
            :$doc = $.doc, # reusable document object
            --> LibXML::Item) {
    do with $rv {
        do with self -> $obj {
            die "returned unexpected node: {$.Str}"
                unless $obj.native.isSameNode($_);
            $obj;
        } // self.box: $_, :$doc;
    } // self.WHAT;
}
=begin pod
method keep
=begin code :lang<raku>
method keep(xmlItem $rv) returns LibXML::Item;
=end code
Utility method that verifies that `$rv` is the same native struct as the current object.
=end pod

=begin pod
=head2 Copyright

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

=head2 License

This program is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0 L<http://www.perlfoundation.org/artistic_license_2_0>.

=end pod