package DateLocale::Language::uk_UA;

#use utf8;
use strict;
use Locale::Messages qw(:locale_h :libintl_h);

sub format_OB {
	return dgettext "perl-DateLocale", "mon".($_[4]+1);
}

sub format_B {
	return dgettext "perl-DateLocale", "mon".($_[4]+1)."g";
}

1;

