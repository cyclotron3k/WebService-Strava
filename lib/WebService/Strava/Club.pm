package WebService::Strava::Club;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str',  default => 'club');
has cache => (is => 'ro', isa => 'Bool', default => '0');

sub activity {
	my $self = shift;
	return WebService::Strava::Activity->new(club_id => $self->id, ctx => $self);
}

sub member {
	my $self = shift;
	return WebService::Strava::Athlete->new(club_id => $self->id, ctx => $self);
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
