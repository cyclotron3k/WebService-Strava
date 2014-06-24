package WebService::Strava::Segment;

use strict;
use warnings;

use Moose;

with 'WebService::Strava::CommonRoles';

has path  => (is => 'rw', isa => 'Str',  default => 'segments');
has cache => (is => 'ro', isa => 'Bool', default => '1');
has id    => (is => 'ro', isa => 'Int');

our %params = (
	bounds        => {required => 0, isa => 'Str' },
	activity_type => {required => 0, isa => 'Str' },
	min_cat       => {required => 0, isa => 'Int' },
	max_cat       => {required => 0, isa => 'Int' }
);

has $_ => (
	is => 'rw',
	isa => $params{$_}{isa},
	required => $params{$_}{required},
	predicate => "has_$_"
) for keys %params;


sub starred
{
	my $self = shift;
	return WebService::Strava::Segment->new(ctx => $self);
}

sub all_efforts
{
	my $self = shift;
	return WebService::Strava::Effort->new(@_, ctx => $self, path => 'all_efforts');
}

sub leaderboard
{
	my $self = shift;
	return WebService::Strava::Athlete->new(ctx => $self);
}

sub explore
{
	my $self = shift;
	return WebService::Strava::Segment->new(@_, ctx => $self, path => 'explore');
}

sub _post_processing
{
	my $self = shift;
	my $data = shift;

	if (ref $data eq "HASH" and keys %$data == 1 and defined $data->{'segments'})
	{
		return $data->{'segments'};
	}

	return $data;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
