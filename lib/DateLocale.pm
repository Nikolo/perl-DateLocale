package DateLocale;

use strict;
use utf8;
use POSIX qw/setlocale/;
use Locale::Messages qw(:locale_h :libintl_h);
our $VERSION = '0.09';
our $LANG;

sub import {
	my $path = __FILE__;
	$path =~ s{\.pm$}{/share/locale};
	textdomain "perl-DateLocale";
	bindtextdomain "perl-DateLocale", $path;
}

sub locale {
	my $pkg = '';
	if( $LANG ){
		$LANG =~ s/^([a-zA-Z_]+).*$/$1/;
		my $tmp = "DateLocale::Language::$LANG";
		eval "use $tmp;";
		$pkg = $tmp unless $@;
	}
	unless( $pkg ){
		my $tmp = setlocale(POSIX::LC_TIME);
		$tmp =~ s/^([a-zA-Z_]+).*$/$1/;
		$tmp = "DateLocale::Language::$tmp";
		eval "use $tmp;";
		$pkg = $tmp unless $@;
		print $@;
	}
	$pkg ||= 'C';
	return $pkg;
}

sub _fmt_redef {
	my ($fmt) = shift;
	my $pkg = locale();
	$fmt =~ s/%(O?[%a-zA-Z])/($pkg->can("format_$1") || sub { '%'.$1 })->(@_);/sge;
	$fmt;
}

sub strftime {
	my ($fmt) = shift;
	my $fmt_redef = _fmt_redef($fmt, @_);
	return POSIX::strftime($fmt_redef, @_);
} 

sub get_ndays {
	my $count = shift;
	my $word = dcngettext("perl-DateLocale", "day", "day", $count, LC_TIME);
	die "Not localized for ".locale() if $word eq 'day';
	return $count." ".$word;
}

1;
__END__
use Mouse;
use FindBin;

has provider => (is => 'rw', isa => 'Object');

sub BEGIN {
	my $path = $INC{__PACKAGE__.'.pm'};
	substr($path, 0, -3, '/');
	my %langs = ();
	my %locales = ();
	my $DIR;
	foreach ( readdir $DIR, $path ){
		next unless /\.pm$/;
		my $lang = __PACKAGE__."::".(/(.*)\.pm$/);
		eval "use $lang";
		die $@ if $@;
		$langs{$lang->lang_name()} = $lang;
		$locales{$lang->locale_name()} = $lang;
	}
	__PACKAGE__->meta->add_attribute('locales' => (is => 'ro', isa => 'Hash', default => %locales));
	__PACKAGE__->meta->add_attribute('languages' => (is => 'ro', isa => 'Hash', default => %langs));
}

sub BUILD {
	my ($self, %param) = @_;
	if( $param{locale} ){
		$self->provider($self->meta->locales->{$param{locale}});
	}
	elsif( $param{language} ){
		$self->provider($self->meta->languages->{$param{language}});
	}
	else {
		die "locale or language must be set!";
	}
	die "Language file not found for ".values(%param) unless $self->provider();
}

1;
