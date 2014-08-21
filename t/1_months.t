#!/usr/bin/env perl

use strict;
use utf8;
#use open ':std', ':encoding(utf8)';
use Test::More tests => 116;
use POSIX qw/setlocale/;
use DateLocale;

my $count_test = 0;
my @time = qw/33 22 11 11 2 114/;
if(setlocale(POSIX::LC_TIME, 'ru_RU.UTF-8')){
	is(DateLocale::strftime('%OB %B', @time), 'март марта', 'Month name');
	is(DateLocale::strftime( '%Y-%m-%d', @time), '2014-03-11', 'Numeric date');
	is(DateLocale::strftime("%d %B %Y", @time), '11 марта 2014', 'Full date');
	is(DateLocale::strftime("%d %B", @time), '11 марта', 'Date without year');
	is(DateLocale::strftime("%d %B %Y %H:%M", @time), '11 марта 2014 11:22', 'Full date with time');
	is(DateLocale::strftime("%d %B %H:%M", @time), '11 марта 11:22', 'Date with time without year');
	is(DateLocale::period_name( -2, \@time, ''), 'послезавтра в 11:22', 'period_name -2');
	is(DateLocale::period_name( -2, \@time, 'old_notime'), 'послезавтра в 11:22', 'period_name -2 old_notime');
	is(DateLocale::period_name( -1, \@time, ''), 'завтра в 11:22', 'period_name -1');
	is(DateLocale::period_name( -1, \@time, 'old_notime'), 'завтра в 11:22', 'period_name -1 old_notime');
	is(DateLocale::period_name( 0, \@time, ''), 'сегодня в 11:22', 'period_name 0');
	is(DateLocale::period_name( 0, \@time, 'old_notime'), 'сегодня в 11:22', 'period_name 0 old_notime');
	is(DateLocale::period_name( 1, \@time, ''), 'вчера в 11:22', 'period_name 1');
	is(DateLocale::period_name( 1, \@time, 'old_notime'), 'вчера в 11:22', 'period_name 1 old_notime');
	is(DateLocale::period_name( 2, \@time, ''), '11 марта в 11:22', 'period_name 2');
	is(DateLocale::period_name( 2, \@time, 'old_notime'), '11 марта', 'period_name 2 old_notime');
	is(DateLocale::period_name( 200, \@time, ''), '11 марта 2014 в 11:22', 'period_name 2');
	is(DateLocale::period_name( 200, \@time, 'old_notime'), '11 марта 2014', 'period_name 2 old_notime');
	is_deeply(DateLocale::format_date_ext(0, 5, \@time, ['long', 'long_tooltip']), {long => 'только что', long_tooltip => 'только что'}, 'date_ext 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 65, \@time, ['long', 'long_tooltip']), {long => '1 мин', long_tooltip => '1 минута'}, 'date_ext 1 min and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605, \@time, ['long', 'long_tooltip']), {long => '1 час', long_tooltip => '1 час'}, 'date_ext 1 hour and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*2, \@time, ['long', 'long_tooltip']), {long => '2 часа', long_tooltip => '2 часа'}, 'date_ext 2 hours and 10 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*5, \@time, ['long', 'long_tooltip']), {long => '5 часов', long_tooltip => '5 часов'}, 'date_ext 5 hours and 25 sec');
	is_deeply(DateLocale::format_date_ext(1, 5, \@time, ['long', 'long_tooltip']), {long => 'вчера в 11:22', long_tooltip => 'вчера в 11:22'}, 'date_ext 1 day and 5 sec');
	is_deeply(DateLocale::format_date_ext($_, 5, \@time, ['long', 'long_tooltip']), {long => 'вторник', long_tooltip => 'вторник в 11:22'}, 'date_ext '.$_.' days and 5 sec') for qw /2 3 4/;
	is_deeply(DateLocale::format_date_ext(5, 5, \@time, ['long', 'long_tooltip']), {long => '11 марта', long_tooltip => '11 марта в 11:22'}, 'date_ext 5 days and 5 sec');
	is_deeply(DateLocale::format_date_ext(200, 5, \@time, ['long', 'long_tooltip']), {long => '11 мар 14', long_tooltip => '11 марта 2014 в 11:22'}, 'date_ext 200 days and 5 sec');
	$count_test += 27;
}
else {
	warn "ru_RU.UTF-8 not found: skip";
}


if(setlocale(POSIX::LC_TIME, 'uk_UA.UTF-8')){
	is(DateLocale::strftime('%OB %B', @time), 'березень березня', 'Month name');
	is(DateLocale::strftime( '%Y-%m-%d', @time), '2014-03-11', 'Numeric date');
	is(DateLocale::strftime("%d %B %Y", @time), '11 березня 2014', 'Full date');
	is(DateLocale::strftime("%d %B", @time), '11 березня', 'Date without year');
	is(DateLocale::strftime("%d %B %Y %H:%M", @time), '11 березня 2014 11:22', 'Full date with time');
	is(DateLocale::strftime("%d %B %H:%M", @time), '11 березня 11:22', 'Date with time without year');
	is(DateLocale::period_name( -2, \@time, ''), 'пiслязавтра о 11:22', 'period_name -2');
	is(DateLocale::period_name( -2, \@time, 'old_notime'), 'пiслязавтра о 11:22', 'period_name -2 old_notime');
	is(DateLocale::period_name( -1, \@time, ''), 'завтра о 11:22', 'period_name -1');
	is(DateLocale::period_name( -1, \@time, 'old_notime'), 'завтра о 11:22', 'period_name -1 old_notime');
	is(DateLocale::period_name( 0, \@time, ''), 'сьогоднi о 11:22', 'period_name 0');
	is(DateLocale::period_name( 0, \@time, 'old_notime'), 'сьогоднi о 11:22', 'period_name 0 old_notime');
	is(DateLocale::period_name( 1, \@time, ''), 'вчора о 11:22', 'period_name 1');
	is(DateLocale::period_name( 1, \@time, 'old_notime'), 'вчора о 11:22', 'period_name 1 old_notime');
	is(DateLocale::period_name( 2, \@time, ''), '11 березня о 11:22', 'period_name 2');
	is(DateLocale::period_name( 2, \@time, 'old_notime'), '11 березня', 'period_name 2 old_notime');
	is(DateLocale::period_name( 200, \@time, ''), '11 березня 2014 о 11:22', 'period_name 2');
	is(DateLocale::period_name( 200, \@time, 'old_notime'), '11 березня 2014', 'period_name 2 old_notime');
	is_deeply(DateLocale::format_date_ext(0, 5, \@time, ['long', 'long_tooltip']), {long => 'тільки що', long_tooltip => 'тільки що'}, 'date_ext 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 65, \@time, ['long', 'long_tooltip']), {long => '1 хв', long_tooltip => '1 хвилина'}, 'date_ext 1 min and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605, \@time, ['long', 'long_tooltip']), {long => '1 година', long_tooltip => '1 година'}, 'date_ext 1 hour and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*2, \@time, ['long', 'long_tooltip']), {long => '2 години', long_tooltip => '2 години'}, 'date_ext 2 hours and 10 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*5, \@time, ['long', 'long_tooltip']), {long => '5 годин', long_tooltip => '5 годин'}, 'date_ext 5 hours and 25 sec');
	is_deeply(DateLocale::format_date_ext(1, 5, \@time, ['long', 'long_tooltip']), {long => 'вчора о 11:22', long_tooltip => 'вчора о 11:22'}, 'date_ext 1 day and 5 sec');
	is_deeply(DateLocale::format_date_ext($_, 5, \@time, ['long', 'long_tooltip']), {long => 'вівторок', long_tooltip => 'вівторок о 11:22'}, 'date_ext '.$_.' days and 5 sec') for qw /2 3 4/;
	is_deeply(DateLocale::format_date_ext(5, 5, \@time, ['long', 'long_tooltip']), {long => '11 березня', long_tooltip => '11 березня о 11:22'}, 'date_ext 5 days and 5 sec');
	is_deeply(DateLocale::format_date_ext(200, 5, \@time, ['long', 'long_tooltip']), {long => '11 бер 14', long_tooltip => '11 березня 2014 о 11:22'}, 'date_ext 200 days and 5 sec');
	$count_test += 27;
}
else {
	warn "uk_UA.UTF-8 not found: skip";
}


if(setlocale(POSIX::LC_TIME, 'kk_KZ.UTF-8')){
	is(DateLocale::strftime('%OB %B', @time), 'наурыз наурызы', 'Month name');
	is(DateLocale::strftime( '%Y-%m-%d', @time), '2014-03-11', 'Numeric date');
	is(DateLocale::strftime("%d %B %Y", @time), '11 наурызы 2014', 'Full date');
	is(DateLocale::strftime("%d %B", @time), '11 наурызы', 'Date without year');
	is(DateLocale::strftime("%d %B %Y %H:%M", @time), '11 наурызы 2014 11:22', 'Full date with time');
	is(DateLocale::strftime("%d %B %H:%M", @time), '11 наурызы 11:22', 'Date with time without year');
	is(DateLocale::period_name( -2, \@time, ''), 'бүрсігүні, 11:22', 'period_name -2');
	is(DateLocale::period_name( -2, \@time, 'old_notime'), 'бүрсігүні, 11:22', 'period_name -2 old_notime');
	is(DateLocale::period_name( -1, \@time, ''), 'ертең, 11:22', 'period_name -1');
	is(DateLocale::period_name( -1, \@time, 'old_notime'), 'ертең, 11:22', 'period_name -1 old_notime');
	is(DateLocale::period_name( 0, \@time, ''), 'бүгін, 11:22', 'period_name 0');
	is(DateLocale::period_name( 0, \@time, 'old_notime'), 'бүгін, 11:22', 'period_name 0 old_notime');
	is(DateLocale::period_name( 1, \@time, ''), 'кеше, 11:22', 'period_name 1');
	is(DateLocale::period_name( 1, \@time, 'old_notime'), 'кеше, 11:22', 'period_name 1 old_notime');
	is(DateLocale::period_name( 2, \@time, ''), '11 наурызы, 11:22', 'period_name 2');
	is(DateLocale::period_name( 2, \@time, 'old_notime'), '11 наурызы', 'period_name 2 old_notime');
	is(DateLocale::period_name( 200, \@time, ''), '11 наурызы 2014, 11:22', 'period_name 2');
	is(DateLocale::period_name( 200, \@time, 'old_notime'), '11 наурызы 2014', 'period_name 2 old_notime');
	is_deeply(DateLocale::format_date_ext(0, 5, \@time, ['long', 'long_tooltip']), {long => 'жаңа ғана', long_tooltip => 'жаңа ғана'}, 'date_ext 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 65, \@time, ['long', 'long_tooltip']), {long => '1 мин', long_tooltip => '1 минут'}, 'date_ext 1 min and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605, \@time, ['long', 'long_tooltip']), {long => '1 сағат', long_tooltip => '1 сағат'}, 'date_ext 1 hour and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*2, \@time, ['long', 'long_tooltip']), {long => '2 сағат', long_tooltip => '2 сағат'}, 'date_ext 2 hours and 10 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*5, \@time, ['long', 'long_tooltip']), {long => '5 сағат', long_tooltip => '5 сағат'}, 'date_ext 5 hours and 25 sec');
	is_deeply(DateLocale::format_date_ext(1, 5, \@time, ['long', 'long_tooltip']), {long => 'кеше, 11:22', long_tooltip => 'кеше, 11:22'}, 'date_ext 1 day and 5 sec');
	is_deeply(DateLocale::format_date_ext($_, 5, \@time, ['long', 'long_tooltip']), {long => 'сейсенбі', long_tooltip => 'сейсенбі, 11:22'}, 'date_ext '.$_.' days and 5 sec') for qw /2 3 4/;
	is_deeply(DateLocale::format_date_ext(5, 5, \@time, ['long', 'long_tooltip']), {long => '11 наурызы', long_tooltip => '11 наурызы, 11:22'}, 'date_ext 5 days and 5 sec');
	is_deeply(DateLocale::format_date_ext(200, 5, \@time, ['long', 'long_tooltip']), {long => '11 нау 14', long_tooltip => '11 наурызы 2014, 11:22'}, 'date_ext 200 days and 5 sec');
	$count_test += 27;
}
else {
	warn "kk_KZ.UTF-8 not found: skip";
}


if(setlocale(POSIX::LC_TIME, 'en_US.UTF-8')){
	is(DateLocale::strftime('%OB %B', @time), 'March March', 'Month name');
	is(DateLocale::strftime( '%Y-%m-%d', @time), '2014-03-11', 'Numeric date');
	is(DateLocale::strftime("%d %B %Y", @time), '11 March 2014', 'Full date');
	is(DateLocale::strftime("%d %B", @time), '11 March', 'Date without year');
	is(DateLocale::strftime("%d %B %Y %H:%M", @time), '11 March 2014 11:22', 'Full date with time');
	is(DateLocale::strftime("%d %B %H:%M", @time), '11 March 11:22', 'Date with time without year');
	is(DateLocale::period_name( -2, \@time, ''), 'day after tommorow at 11:22', 'period_name -2');
	is(DateLocale::period_name( -2, \@time, 'old_notime'), 'day after tommorow at 11:22', 'period_name -2 old_notime');
	is(DateLocale::period_name( -1, \@time, ''), 'tommorow at 11:22', 'period_name -1');
	is(DateLocale::period_name( -1, \@time, 'old_notime'), 'tommorow at 11:22', 'period_name -1 old_notime');
	is(DateLocale::period_name( 0, \@time, ''), 'today at 11:22', 'period_name 0');
	is(DateLocale::period_name( 0, \@time, 'old_notime'), 'today at 11:22', 'period_name 0 old_notime');
	is(DateLocale::period_name( 1, \@time, ''), 'yesterday at 11:22', 'period_name 1');
	is(DateLocale::period_name( 1, \@time, 'old_notime'), 'yesterday at 11:22', 'period_name 1 old_notime');
	is(DateLocale::period_name( 2, \@time, ''), '11 March at 11:22', 'period_name 2');
	is(DateLocale::period_name( 2, \@time, 'old_notime'), '11 March', 'period_name 2 old_notime');
	is(DateLocale::period_name( 200, \@time, ''), '11 March 2014 at 11:22', 'period_name 2');
	is(DateLocale::period_name( 200, \@time, 'old_notime'), '11 March 2014', 'period_name 2 old_notime');
	is_deeply(DateLocale::format_date_ext(0, 5, \@time, ['long', 'long_tooltip']), {long => 'recently', long_tooltip => 'recently'}, 'date_ext 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 65, \@time, ['long', 'long_tooltip']), {long => '1 min', long_tooltip => '1 minute'}, 'date_ext 1 min and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605, \@time, ['long', 'long_tooltip']), {long => '1 hour', long_tooltip => '1 hour'}, 'date_ext 1 hour and 5 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*2, \@time, ['long', 'long_tooltip']), {long => '2 hours', long_tooltip => '2 hours'}, 'date_ext 2 hours and 10 sec');
	is_deeply(DateLocale::format_date_ext(0, 3605*5, \@time, ['long', 'long_tooltip']), {long => '5 hours', long_tooltip => '5 hours'}, 'date_ext 5 hours and 25 sec');
	is_deeply(DateLocale::format_date_ext(1, 5, \@time, ['long', 'long_tooltip']), {long => 'yesterday at 11:22', long_tooltip => 'yesterday at 11:22'}, 'date_ext 1 day and 5 sec');
	is_deeply(DateLocale::format_date_ext($_, 5, \@time, ['long', 'long_tooltip']), {long => 'tuesday', long_tooltip => 'tuesday at 11:22'}, 'date_ext '.$_.' days and 5 sec') for qw /2 3 4/;
	is_deeply(DateLocale::format_date_ext(5, 5, \@time, ['long', 'long_tooltip']), {long => '11 March', long_tooltip => '11 March at 11:22'}, 'date_ext 5 days and 5 sec');
	is_deeply(DateLocale::format_date_ext(200, 5, \@time, ['long', 'long_tooltip']), {long => '11 mar 14', long_tooltip => '11 March 2014 at 11:22'}, 'date_ext 200 days and 5 sec');
	$count_test += 27;
}
else {
	warn "en_US.UTF-8 not found: skip";
}
done_testing($count_test);

