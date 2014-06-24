package WebService::Strava::Comment;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str',  default => 'comments');
has cache => (is => 'ro', isa => 'Bool', default => '0');

our %params = (
	markdown => {required => 0, isa => 'Bool'},
	page     => {required => 0, isa => 'Int' },
	per_page => {required => 0, isa => 'Int' },
);

has $_ => (
	is => 'rw',
	isa => $params{$_}{isa},
	required => $params{$_}{required},
	predicate => "has_$_"
) for keys %params;

no Moose;
__PACKAGE__->meta->make_immutable;

1;
