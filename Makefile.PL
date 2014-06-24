#!/usr/bin/perl

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
	NAME          => 'WebService::Strava',
	VERSION_FROM  => 'lib/WebService/Strava.pm',
	PREREQ_PM     => {
		'Algorithm::GooglePolylineEncoding' => 0,
		'Digest::MD5' => 0,
		'JSON' => 0,
		'LWP::UserAgent' => 0,
		'Moose' => 0,
		'Storable' => 0,
		'URI' => 0
	},
	ABSTRACT_FROM => 'lib/WebService/Strava.pm',
	AUTHOR        => [
		'Aidan Samuel <aidan.samuel@gmail.com>',
		'Fred Moyer <fred@redhotpenguin.com>'
	]
);
