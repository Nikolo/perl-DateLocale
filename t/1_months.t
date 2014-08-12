#!/usr/bin/env perl

use strict;
use Test::More tests => 2;
use POSIX qw/setlocale/;
use DateLocale;

setlocale(POSIX::LC_TIME, 'ru_RU.UTF-8');
is(DateLocale::strftime('%OB %B', 0,0,0,11,2,14), 'март марта', 'Month');

setlocale(POSIX::LC_MESSAGES, 'kk_KZ.UTF-8');
is(DateLocale::strftime('%OB %B', 0,0,0,11,2,14), 'наурыз наурызы', 'Month');


