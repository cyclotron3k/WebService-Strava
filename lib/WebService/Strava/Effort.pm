package WebService::Strava::Effort;

use strict;
use warnings;

use Moose;

with 'WebService::Strava::CommonRoles';
has path  => (is => 'ro', isa => 'Str',  default => 'effort');
has cache => (is => 'ro', isa => 'Bool', default => '0');

our %params = (
	athlete_id       => {required => 0, isa => 'Int' },
	start_date_local => {required => 0, isa => 'Date'},
	end_date_local   => {required => 0, isa => 'Date'},
	page             => {required => 0, isa => 'Int' },
	per_page         => {required => 0, isa => 'Int' }
);

has $_ => (
	is => 'rw',
	isa => $params{$_}{isa},
	required => $params{$_}{required},
	predicate => "has_$_"
) for keys %params;

# segment_efforts
# segment/:id/all_efforts

sub streams {
	my $self = shift;
	return WebService::Strava::Stream->new(@_, ctx => $self);
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
