# this test checks the DOM element and attribute interface of XML::LibXML

use v6;
use Test;
plan 204;

use LibXML;
use LibXML::Document;
use LibXML::Enums;

my $foo       = "foo";
my $bar       = "bar";
my $nsURI     = "http://foo";
my $prefix    = "x";
my $attname1  = "A";
my $attvalue1 = "a";
my $attname2  = "B";
my $attvalue2 = "b";
my $attname3  = "C";

my @badnames= ("1A", "<><", "&", "-:");

# 1. bound node
{
    my $doc = LibXML::Document.new();
    my $elem = $doc.createElement( $foo );
    ok($elem, ' TODO : Add test name');
    is($elem.tagName, $foo, ' TODO : Add test name');

    {
        for @badnames -> $name {
            dies-ok { $elem.setNodeName( $name ); }, "setNodeName throws an exception for $name";
        }
    }

    $elem.setAttribute( $attname1, $attvalue1 );
    ok( $elem.hasAttribute($attname1), ' TODO : Add test name' );
    is( $elem.getAttribute($attname1), $attvalue1, ' TODO : Add test name');

    my $attr = $elem.getAttributeNode($attname1);
    ok($attr, ' TODO : Add test name');
    is($attr.name, $attname1, ' TODO : Add test name');
    is($attr.value, $attvalue1, ' TODO : Add test name');

    $attr = $elem.attribute($attname1);
    ok($attr, ' TODO : Add test name');
    is($attr.name, $attname1, ' TODO : Add test name');
    is($attr.value, $attvalue1, ' TODO : Add test name');

    $elem.setAttribute( $attname1, $attvalue2 );
    is($elem.getAttribute($attname1), $attvalue2, ' TODO : Add test name');
    is($attr.value, $attvalue2, ' TODO : Add test name');

    my $attr2 = $doc.createAttribute($attname2, $attvalue1);
    ok($attr2, ' TODO : Add test name');

    $elem.setAttributeNode($attr2);
    ok($elem.hasAttribute($attname2), ' TODO : Add test name' );
    is($elem.getAttribute($attname2),$attvalue1, ' TODO : Add test name');

    my $tattr = $elem.getAttributeNode($attname2);
    ok($tattr.isSameNode($attr2), ' TODO : Add test name');

    $elem.setAttribute($attname2, "");
    ok($elem.hasAttribute($attname2), ' TODO : Add test name' );
    is($elem.getAttribute($attname2), "", ' TODO : Add test name');

    $elem.setAttribute($attname3, "");
    ok($elem.hasAttribute($attname3), ' TODO : Add test name' );
    is($elem.getAttribute($attname3), "", ' TODO : Add test name');

    {
        for @badnames -> $name {
            dies-ok {$elem.setAttribute( $name, "X" );}, "setAttribute throws an exception for '$name'";
        }

    }


    # 1.1 Namespaced Attributes

    $elem.setAttributeNS( $nsURI, $prefix ~ ":" ~ $foo, $attvalue2 );
    ok( $elem.hasAttributeNS( $nsURI, $foo ), ' TODO : Add test name' );
    ok( ! $elem.hasAttribute( $foo ), ' TODO : Add test name' );
    ok( $elem.hasAttribute( $prefix~":"~$foo ), ' TODO : Add test name' );
    # warn $elem.toString() , "\n";
    $tattr = $elem.getAttributeNodeNS( $nsURI, $foo );
    ok($tattr, ' TODO : Add test name');
    is($tattr.name, $foo, ' TODO : Add test name');
    is($tattr.nodeName, $prefix~":"~$foo, ' TODO : Add test name');
    is($tattr.value, $attvalue2, ' TODO : Add test name' );

    $elem.removeAttributeNode( $tattr );
    ok( !$elem.hasAttributeNS($nsURI, $foo), ' TODO : Add test name' );


    # empty NS
    $elem.setAttributeNS( '', $foo, $attvalue2 );
    ok( $elem.hasAttribute( $foo ), ' TODO : Add test name' );
    $tattr = $elem.getAttributeNode( $foo );
    ok($tattr.defined, ' TODO : Add test name');
    is($tattr.name, $foo, ' TODO : Add test name');
    is($tattr.nodeName, $foo, ' TODO : Add test name');
    ok(!$tattr.namespaceURI.defined, 'namespaceURI N/A is not defined');
    is($tattr.value, $attvalue2, ' TODO : Add test name' );


    ok($elem.hasAttribute($foo) == 1, ' TODO : Add test name');
    ok($elem.hasAttributeNS(Str, $foo) == 1, ' TODO : Add test name');
    ok($elem.hasAttributeNS('', $foo) == 1, ' TODO : Add test name');

    $elem.removeAttributeNode( $tattr );
    ok( !$elem.hasAttributeNS('', $foo), ' TODO : Add test name' );
    ok( !$elem.hasAttributeNS(Str, $foo), ' TODO : Add test name' );

    # node based functions
    my $e2 = $doc.createElement($foo);
    $doc.setDocumentElement($e2);
    my $nsAttr = $doc.createAttributeNS( $nsURI~".x", $prefix~":"~$foo, $bar);
    ok( $nsAttr, ' TODO : Add test name' );
    $elem.setAttributeNodeNS($nsAttr);
    ok( $elem.hasAttributeNS($nsURI~".x", $foo), ' TODO : Add test name' );
    $elem.removeAttributeNS( $nsURI~".x", $foo);
    ok( !$elem.hasAttributeNS($nsURI~".x", $foo), ' TODO : Add test name' );

    # warn $elem.toString;
    $elem.setAttributeNS( $nsURI, $prefix ~ ":"~ $attname1, $attvalue2 );
    # warn $elem.toString;


    $elem.removeAttributeNS("",$attname1);
    # warn $elem.toString;


    ok( ! $elem.hasAttribute($attname1), ' TODO : Add test name' );
    ok( $elem.hasAttributeNS($nsURI,$attname1), ' TODO : Add test name' );
    # warn $elem.toString;

    {
        for @badnames -> $name {
            dies-ok {$elem.setAttributeNS( Str, $name, "X" );}, "setAttributeNS throws an exception for '$name'";
        }
    }
}

# 2. unbound node
{
    my $elem = LibXML::Element.new: :name($foo);
    ok($elem, ' TODO : Add test name');
    is($elem.tagName, $foo, ' TODO : Add test name');

    $elem.setAttribute( $attname1, $attvalue1 );
    ok( $elem.hasAttribute($attname1), ' TODO : Add test name' );
    is( $elem.getAttribute($attname1), $attvalue1, ' TODO : Add test name');

    my $attr = $elem.getAttributeNode($attname1);
    ok($attr, ' TODO : Add test name');
    is($attr.name, $attname1, ' TODO : Add test name');
    is($attr.value, $attvalue1, ' TODO : Add test name');

    $elem.setAttributeNS( $nsURI, $prefix ~ ":"~ $foo, $attvalue2 );
    ok( $elem.hasAttributeNS( $nsURI, $foo ), ' TODO : Add test name' );
    # warn $elem.toString() , "\n";
    my $tattr = $elem.getAttributeNodeNS( $nsURI, $foo );
    ok($tattr, ' TODO : Add test name');
    is($tattr.name, $foo, ' TODO : Add test name');
    is($tattr.nodeName, $prefix~ ":" ~$foo, ' TODO : Add test name');
    is($tattr.value, $attvalue2, ' TODO : Add test name' );

    $elem.removeAttributeNode( $tattr );
    ok( !$elem.hasAttributeNS($nsURI, $foo), ' TODO : Add test name' );
    # warn $elem.toString() , "\n";
}

# 3. Namespace handling
# 3.1 Namespace switching
{
    my $elem = LibXML::Element.new: :name($foo);
    ok($elem, ' TODO : Add test name');

    my $doc = LibXML::Document.new();
    my $e2 = $doc.createElement($foo);
    $doc.setDocumentElement($e2);
    my $nsAttr = $doc.createAttributeNS( $nsURI, $prefix ~ ":"~ $foo, $bar);
    ok( $nsAttr, ' TODO : Add test name' );

    $elem.setAttributeNodeNS($nsAttr);
    ok( $elem.hasAttributeNS($nsURI, $foo), ' TODO : Add test name' );

    ok( ! defined($nsAttr.ownerDocument), ' TODO : Add test name');
    # warn $elem.toString() , "\n";
}

# 3.2 default Namespace and Attributes
{
    my $doc  = LibXML::Document.new();
    my $elem = $doc.createElementNS( "foo", "root" );
    $doc.setDocumentElement( $elem );

    $elem.setNamespace( "foo", "bar" );

    $elem.setAttributeNS( "foo", "x:attr",  "test" );
    $elem.setAttributeNS( Str, "attr2",  "test" );


    is( $elem.getAttributeNS( "foo", "attr" ), "test", ' TODO : Add test name' );
    is( $elem.getAttributeNS( "", "attr2" ), "test", ' TODO : Add test name' );

    # warn $doc.toString;
    # actually this doesn't work correctly with libxml2 <= 2.4.23
    $elem.setAttributeNS( "foo", "attr2",  "bar" );
    is( $elem.getAttributeNS( "foo", "attr2" ), "bar", ' TODO : Add test name' );
    # warn $doc.toString;
}

# 4. Text Append and Normalization
# 4.1 Normalization on an Element node
{
    my $doc = LibXML::Document.new();
    my $t1 = $doc.createTextNode( "bar1" );
    my $t2 = $doc.createTextNode( "bar2" );
    my $t3 = $doc.createTextNode( "bar3" );
    my $e  = $doc.createElement("foo");
    my $e2 = $doc.createElement("bar");
    $e.appendChild( $e2 );
    $e.appendChild( $t1 );
    $e.appendChild( $t2 );
    $e.appendChild( $t3 );

    my @cn = $e.childNodes;

    # this is the correct behaviour for DOM. the nodes are still
    # referred
    is( +@cn , 4, ' TODO : Add test name' );

    $e.normalize;

    @cn = $e.childNodes;
    is( +@cn, 2, ' TODO : Add test name' );


    ok(! defined($t2.parentNode), ' TODO : Add test name');
    ok(! defined($t3.parentNode), ' TODO : Add test name');
}

# 4.2 Normalization on a Document node
{
    my $doc = LibXML::Document.new();
    my $t1 = $doc.createTextNode( "bar1" );
    my $t2 = $doc.createTextNode( "bar2" );
    my $t3 = $doc.createTextNode( "bar3" );
    my $e  = $doc.createElement("foo");
    my $e2 = $doc.createElement("bar");
    $doc.setDocumentElement($e);
    $e.appendChild( $e2 );
    $e.appendChild( $t1 );
    $e.appendChild( $t2 );
    $e.appendChild( $t3 );

    my @cn = $e.childNodes;

    # this is the correct behaviour for DOM. the nodes are still
    # referred
    is( +@cn, 4, ' TODO : Add test name' );

    $doc.normalize;

    @cn = $e.childNodes;
    is( +@cn, 2, ' TODO : Add test name' );


    ok(! defined($t2.parentNode), ' TODO : Add test name');
    ok(! defined($t3.parentNode), ' TODO : Add test name');
}

# 5. LibXML extensions
{
    my $plainstring = "foo";
    my $stdentstring= "$foo & this";

    my $doc = LibXML::Document.new();
    my $elem = $doc.createElement( $foo );
    $doc.setDocumentElement( $elem );

    $elem.appendText( $plainstring );
    is( $elem.string-value , $plainstring, ' TODO : Add test name' );

    $elem.appendText( $stdentstring );
    is( $elem.string-value , $plainstring ~ $stdentstring, ' TODO : Add test name' );

    $elem.appendTextChild( "foo");
    my LibXML::Element $text-child = $elem.appendTextChild( "foo" => "foo&bar" );
    is $text-child, '<foo>foo&amp;bar</foo>';
    is $text-child.name, 'foo';
    is $text-child.textContent, "foo&bar";
    ok $text-child.parent.isSame($elem);

    my @cn = $elem.childNodes;
    ok( @cn, ' TODO : Add test name' );
    is( +@cn, 3, ' TODO : Add test name' );
    ok( !@cn[1].hasChildNodes, ' TODO : Add test name');
    ok( @cn[2].hasChildNodes, ' TODO : Add test name');
}

# 6. LibXML::Attr nodes
{
    my $dtd = q:to<EOF>;
<!DOCTYPE root [
<!ELEMENT root EMPTY>
<!ATTLIST root fixed CDATA  #FIXED "foo">
<!ATTLIST root a:ns_fixed CDATA  #FIXED "ns_foo">
<!ATTLIST root name NMTOKEN #IMPLIED>
<!ENTITY ent "ENT">
]>
EOF
    my $ns = 'urn:xx';
    my $xml_nons = '<root foo="&quot;bar&ent;&quot;" xmlns:a="%s"/>'.sprintf($ns);
    my $xml_ns = '<root xmlns="%s" xmlns:a="%s" foo="&quot;bar&ent;&quot;"/>'.sprintf($ns, $ns);

    for ($xml_nons, $xml_ns) -> $xml {
        my $parser = LibXML.new;
        $parser.complete-attributes = False;
        $parser.expand-entities = False;
        my $doc = $parser.parse: :string($dtd ~ $xml);


        ok ($doc, ' TODO : Add test name');
        my $root = $doc.getDocumentElement;
        {
            my $attr = $root.getAttributeNode('foo');
            ok($attr, ' TODO : Add test name');
            isa-ok($attr, 'LibXML::Attr', ' TODO : Add test name');
            ok($root.isSameNode($attr.ownerElement), ' TODO : Add test name');
            is($attr.value, '"barENT"', ' TODO : Add test name');
            is($attr.serializeContent, '&quot;bar&ent;&quot;', ' TODO : Add test name');
            is($attr.gist, 'foo="&quot;bar&ent;&quot;"', ' TODO : Add test name');
        }
        {
            my $attr = $root.getAttributeNodeNS(Str,'foo');
            ok($attr, ' TODO : Add test name');
            isa-ok($attr, 'LibXML::Attr', ' TODO : Add test name');
            ok($root.isSameNode($attr.ownerElement), ' TODO : Add test name');
            is($attr.value, '"barENT"', ' TODO : Add test name');
        }
        # fixed values are defined
        is($root.getAttribute('fixed'),'foo', ' TODO : Add test name');

        SKIP:
        {
            is($root.getAttributeNS($ns,'ns_fixed'),'ns_foo', 'ns_fixed is ns_foo')
        }

        is($root.getAttribute('a:ns_fixed'),'ns_foo', ' TODO : Add test name');


        is($root.hasAttribute('fixed'), False, ' TODO : Add test name');
        is($root.hasAttributeNS($ns,'ns_fixed'), False, ' TODO : Add test name');
        is($root.hasAttribute('a:ns_fixed'), False, ' TODO : Add test name');


        # but no attribute nodes correspond to them
        ok(!defined($root.getAttributeNode('a:ns_fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNode('fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNode('name')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNode('baz')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS($ns,'foo')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS($ns,'fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS($ns,'ns_fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS(Str, 'fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS(Str, 'name')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS(Str, 'baz')), ' TODO : Add test name');
    }

    {
    my @names = ("nons", "ns");
    for ($xml_nons, $xml_ns) -> $xml {
        my $n = shift(@names);
        my $parser = LibXML.new;
        $parser.complete-attributes = True;
        $parser.expand-entities = True;
        my $doc = $parser.parse: :string($dtd ~ $xml);
        ok($doc, "Could parse document $n");
        my $root = $doc.getDocumentElement;
        {
            my $attr = $root.getAttributeNode('foo');
            ok($attr, "Attribute foo exists for $n");
            isa-ok($attr, 'LibXML::Attr',
                "Attribute is of type LibXML::Attr - $n");
            ok($root.isSameNode($attr.ownerElement),
                "attr owner element is root - $n");
            is($attr.value, q{"barENT"},
                "attr value is OK - $n");
            is($attr.serializeContent,
                '&quot;barENT&quot;',
                "serializeContent - $n");
            is($attr.gist, 'foo="&quot;barENT&quot;"',
                "toString - $n");
        }
        # fixed values are defined
        is($root.getAttribute('fixed'),'foo', ' TODO : Add test name');
        is($root.getAttributeNS($ns,'ns_fixed'),'ns_foo', ' TODO : Add test name');
        is($root.getAttribute('a:ns_fixed'),'ns_foo', ' TODO : Add test name');

        # and attribute nodes are created
        {
            my $attr = $root.getAttributeNode('fixed');
            isa-ok($attr, 'LibXML::Attr', ' TODO : Add test name');
            is($attr.value,'foo', ' TODO : Add test name');
            is($attr.gist, 'fixed="foo"', ' TODO : Add test name');
        }
        {
            my $attr = $root.getAttributeNode('a:ns_fixed');
            isa-ok($attr, 'LibXML::Attr', ' TODO : Add test name');
            is($attr.value,'ns_foo', ' TODO : Add test name');
        }
        {
            my $attr = $root.getAttributeNodeNS($ns,'ns_fixed');
            isa-ok($attr, 'LibXML::Attr', ' TODO : Add test name');
            is($attr.value,'ns_foo', ' TODO : Add test name');
            is($attr.gist, 'a:ns_fixed="ns_foo"', ' TODO : Add test name');
        }


        ok(!defined($root.getAttributeNode('ns_fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNode('name')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNode('baz')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS($ns,'foo')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS($ns,'fixed')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS(Str, 'name')), ' TODO : Add test name');
        ok(!defined($root.getAttributeNodeNS(Str, 'baz')), ' TODO : Add test name');
    }
    }
}

# 7. Entity Reference construction
{
    use LibXML::EntityRef;
    my $doc = LibXML::Document.new();
    my $elem = $doc.createElement( $foo );
    $elem.appendText('a');
    my $ent-ref = LibXML::EntityRef.new(:$doc, :name<bar>);
    is $ent-ref.type, +XML_ENTITY_REF_NODE;
    is $ent-ref.nodeName, 'bar';
    is $ent-ref.ast-key, '&bar';
    is-deeply $ent-ref.xpath-key, Str; # /n/a to xpath
    $elem.appendChild: $ent-ref;
    $elem.appendText('b');
    is $elem.Str, '<foo>a&bar;b</foo>';
}

subtest "issue #41 Traversion order" => {
    plan 6;
    use LibXML::Document;
    my LibXML::Document $doc .= parse: :file<example/dromeds.xml>;
    my @elems = $doc.getElementsByTagName('*');
    is +@elems, 10;
    is @elems[0].tagName, 'dromedaries', 'first element';
    is @elems[1].tagName, 'species', 'second element';
    is @elems[2].tagName, 'humps', 'third element';
    is @elems[3].tagName, 'disposition', 'fourth element';
    is @elems[4].tagName, 'species', 'the fifth element';
}
