use v6.c;

use Test;
use LibXML;

my $x   = LibXML.parse(string => '<a>link desc<bar/>yada yada<bar/></a>');
my $lnk = $x.find('//a',);
my @t   := $x.find('//text()', :lnk[0]);

is @t.elems, 2, 'found two element';
is @t[0].text, 'link desc', 'found link desc';
is @t[1].text, 'yada yada', 'found yada yada';

done-testing;
