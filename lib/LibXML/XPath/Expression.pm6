use v6;
class LibXML::XPath::Expression {

    use LibXML::Native;
    use Method::Also;

    has xmlXPathCompExpr $!native;
    method native { $!native }
    # for the LibXML::ErrorHandling role
    use LibXML::ErrorHandling;
    use LibXML::_Options;
    has $.sax-handler is rw;
    has Bool ($.recover, $.suppress-errors, $.suppress-warnings) is rw;
    also does LibXML::_Options[%( :recover, :suppress-errors, :suppress-warnings)];
    also does LibXML::ErrorHandling;

    multi submethod TWEAK(Str:D :$expr!) {
        my $*XML-CONTEXT = self;
        $!native .= new(:$expr);
        self.flush-errors;
        die "invalid xpath expression: $expr"
            without $!native;
    }
    submethod DESTROY {
        .Free with $!native;
    }

    method parse(Str:D $expr) {
        self.new: :$expr;
    }
}

=begin pod
=head1 NAME

LibXML::XPath::Expression - interface to libxml2 pre-compiled XPath expressions

=head1 SYNOPSIS



  use LibXML::XPath::Expression;
  my LibXML::XPath::Expression $compiled-xpath .= parse('//foo[@bar="baz"][position()<4]');
  
  # interface from LibXML::Node
  
  my $result = $node.find($compiled-xpath);
  my @nodes = $node.findnodes($compiled-xpath);
  my $value = $node.findvalue($compiled-xpath);
  
  # interface from LibXML::XPathContext
  
  my $result = $xpc.find($compiled-xpath,$node);
  my @nodes = $xpc.findnodes($compiled-xpath,$node);
  my $value = $xpc.findvalue($compiled-xpath,$node);

  $compiled = LibXML::XPath::Expression.new( xpath-string );

=head1 DESCRIPTION

This is a perl interface to libxml2's pre-compiled XPath expressions.
Pre-compiling an XPath expression can give in some performance benefit if the
same XPath query is evaluated many times. C<<<<<< LibXML::XPath::Expression >>>>>> objects can be passed to all C<<<<<< find... >>>>>> functions C<<<<<< LibXML >>>>>> that expect an XPath expression. 

=begin item1
new()

  LibXML::XPath::Expression $compiled  = .new( :expr($xpath-string) );

The constructor takes an XPath 1.0 expression as a string and returns an object
representing the pre-compiled expressions (the actual data structure is
internal to libxml2). 

=end item1

=begin item1
parse()

  LibXML::XPath::Expression $compiled  = .parse( $xpath-string );

Alternative constructor.

=end item1

=head1 COPYRIGHT

2001-2007, AxKit.com Ltd.

2002-2006, Christian Glahn.

2006-2009, Petr Pajas.

=head1 LICENSE

This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.

=end pod
