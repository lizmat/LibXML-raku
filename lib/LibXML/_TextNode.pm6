unit role LibXML::_TextNode;

method nodeValue { ... }
method content {...}

method data is rw { $.nodeValue }

# DOM Boot-leather
method substringData(UInt:D $off, UInt:D $len) { $.substr($off, $len) }
method appendData(Str:D $val) { $.content ~= $val }
method insertData(UInt:D $pos, Str:D $val) { $.content.substr-rw($pos, 0) = $val; }
method setData(Str:D $val) { $.content = $val; }
method getData { $.content; }
multi method replaceData(UInt:D $off, UInt:D $length, Str:D $val) {
    my $len = $.content.chars;
    if $len > $off {
        $.substr-rw($off, $length) = $val;
    }
}

my subset StrOrRegex where Str|Regex;
my subset StrOrCode where Str|Code;
multi method replaceData(StrOrRegex:D $old, StrOrCode:D $new, |c) {
    $.content = $.content.subst($old, $new, |c);
}
multi method deleteData(UInt:D $off, UInt:D $length) {
    $.replaceData($off, $length, '');
}
multi method deleteData(StrOrRegex $old, |c) {
    $.replaceData($old, '', |c);
}