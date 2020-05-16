use LibXML::Node;
use LibXML::_StringyNode;

#| LibXML Comment nodes
unit class LibXML::Comment
    is LibXML::Node
    does LibXML::_StringyNode;

use LibXML::Native;

multi submethod TWEAK(LibXML::Node :doc($)!, xmlCommentNode:D :native($)!) { }
multi submethod TWEAK(LibXML::Node :doc($doc-obj), Str :$content!) {
    my xmlDoc:D $doc = .native with $doc-obj;
    my xmlCommentNode $comment-struct .= new: :$content, :$doc;
    self.set-native: $comment-struct;
}

method native { callsame() // xmlCommentNode }
method content is rw handles<substr substr-rw> { $.native.content };

=begin pod
=head2 Synopsis

=begin code :lang<raku>
use LibXML::Comment;
# Only methods specific to Comment nodes are listed here,
# see the LibXML::Node documentation for other methods
my LibXML::Comment $comment .= new( :$content );

$comment.data ~~ s/xxx/yyy/; # Stringy Interface - see LibXML::Text
=end code

=head2 Description

This class provides all functions of L<<<<<< LibXML::Text >>>>>>, but for comment nodes. This can be done, since only the output of the node
types is different, but not the data structure. :-)

=head2 Methods

The class inherits from L<<<<<< LibXML::Node >>>>>>. The documentation for Inherited methods is not listed here.

Many functions listed here are extensively documented in the DOM Level 3 specification (L<<<<<< http://www.w3.org/TR/DOM-Level-3-Core/ >>>>>>). Please refer to the specification for extensive documentation.

=head3 method new
=begin code :lang<raku>
method new( Str :$content ) returns LibXML::Comment
=end code
The constructor is the only provided function for this package. It is required,
because I<<<<<< libxml2 >>>>>> treats text nodes and comment nodes slightly differently.

=head2 Copyright

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

=head2 LICENSE

This program is free software; you can redistribute it and/or modify it under
the terms of the Artistic License 2.0 L<http://www.perlfoundation.org/artistic_license_2_0>.

=end pod