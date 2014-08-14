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

my %ext_formaters = (
    'long' => {
        'less_1min'         => sub { dgettext("perl-DateLocale", 'recent' ) },
        'less_1hour'        => sub { 
            my ($date, $secs_diff) = @_; 
            my $mins = int($secs_diff / 60) || 0;
            return "$mins ".dgettext("perl-DateLocale", 'shortmin' );
        },
        'today'             => sub {
            my ($date, $secs_diff) = @_;
            my $hours = int($secs_diff / 3600) || 0;
            return "$hours ".dngettext("perl-DateLocale", 'hour', 'hour', $hours );
        },
        'yesterday'         => sub { 
            my ($date, $secs_diff) = @_;        
			return strftime(dgettext("perl-DateLocale", 'yesterday' ), @$date );
		},
        'between_2_5days'   => sub {    
            my ($date, $secs_diff) = @_;        
            return lc(strftime("%A", @$date));
        },
        'this_year'         => sub { 
            my ($date, $secs_diff) = @_;
            return strftime("%d %B", @$date);
        },
        'before_year'       => sub {
            my ($date, $secs_diff) = @_;
            return strftime("%d %b %y", @$date);
        },
    },
    'long_tooltip' => {
        'less_1min'         => sub { dgettext("perl-DateLocale", 'recent' ) },
        'less_1hour'        => sub { 
            my ($date, $secs_diff) = @_; 
            my $mins = int($secs_diff / 60) || 0;
			return "$mins ".dngettext("perl-DateLocale", 'min', 'min', $mins );
        },
        'today'             => sub {
            my ($date, $secs_diff) = @_;
            my $hours = int($secs_diff / 3600) || 0;
			return "$hours ".dngettext("perl-DateLocale", 'hour', 'hour', $hours );
        },
        'yesterday'         => sub { 
            my ($date, $secs_diff) = @_;        
            return period_name_by_days(1, $date);
        },
        'between_2_5days'   => sub {    
            my ($date, $secs_diff) = @_;        
			return strftime(dgettext("perl-DateLocale", 'weekdaywithtime' ), @$date);
        },
        'this_year'         => sub { 
            my ($date, $secs_diff) = @_;
			return strftime(dgettext("perl-DateLocale", 'monthdaywithtime' ), @$date);
        },
        'before_year'       => sub {
            my ($date, $secs_diff) = @_;
			return strftime(dgettext("perl-DateLocale", 'yeardaywithtime' ), @$date);
        },
    },
);

sub format_date_ext {
    my ($days, $seconds, $date, $format) = @_;
    my $formated;
    for my $f (@$format) {
        my $formater = $ext_formaters{$f};
        die "Format $f not supported" unless $formater;
        if ($days > 1) {
            #more than 1 day ago
            if($days > 1 && $days < 5) {
                #less than 5 days and more than 1 day ago
                $formated->{$f} = $formater->{between_2_5days}->($date, $seconds);
            } elsif (strftime("%j", @$date) > $days) {
                #at this year
                $formated->{$f} = $formater->{this_year}->($date, $seconds);
            } else {
                #not at this year
                $formated->{$f} = $formater->{before_year}->($date, $seconds);
            }
        } elsif ($days == 1) {
            #yesterday
            $formated->{$f} = $formater->{yesterday}->($date, $seconds);
        } else {
            #today
            if($seconds < 60) {
                #less than 1 minute
                $formated->{$f} = $formater->{less_1min}->($date, $seconds);
            } elsif ($seconds < 60*60) {
                #less than 1 hour
                $formated->{$f} = $formater->{less_1hour}->($date, $seconds);
            } else {
                #more than 1 hour
                $formated->{$f} = $formater->{today}->($date, $seconds);
            }
        }
    }
    return $formated;
}

sub strftime {
	my ($fmt) = shift;
	my $fmt_redef = _fmt_redef($fmt, @_);
	return POSIX::strftime($fmt_redef, @_);
} 

sub occured_date {
	my ($date) = @_;
	return strftime( dgettext("perl-DateLocale", 'fmtdateoccured' ), @$date );
}

sub period_name_by_days {
	my( $days, $date ) = @_;
	my $gt_name = '';
	if ($days == 1) {
		$gt_name = 'yesterday';
	}
	elsif ($days == 0) {
		$gt_name = 'today';
	}
	elsif ($days == -1) {
		$gt_name = 'tommorow';
	}
	elsif ($days == -2) {
		$gt_name = 'datommorow';
	}
	my $fmt = '';
	if( $gt_name ){
		$fmt = dgettext("perl-DateLocale", $gt_name );
	}
	else {
		die( $days." not supported by period_name_by_days" );
	}
	return strftime($fmt, @$date);
}

sub period_name {
	my ($days, $date, $format) = @_;
	if( $days <= 1 and $days >= -2 ){
		return period_name_by_days( $days, $date );
	}
	else {
		my $fmt_name = strftime("%j", @$date) < $days ? 'yearday' : 'monthday';
		$fmt_name .= $format ne 'old_notime' ? 'withtime' : 'withouttime';
		return strftime(dgettext("perl-DateLocale", $fmt_name), @$date);
	}
}

1;
