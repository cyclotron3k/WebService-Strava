package WebService::Strava::Athlete;

use strict;
use warnings;

use Data::Dumper;

use Moose;
with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str');
has cache => (is => 'ro', isa => 'Bool', default => '0');
has id    => (is => 'ro', isa => 'Int');

sub koms
{
	my $self = shift;
	return WebService::Strava::Effort->new(ctx => $self, path => 'koms');
}

sub activities
{
	my $self = shift;
	return WebService::Strava::Activity->new(ctx => $self);
}

sub clubs
{
	my $self = shift;
	return WebService::Strava::Club->new(ctx => $self);
}

sub friends
{
	my $self = shift;
	return WebService::Strava::Athlete->new(ctx => $self, path => 'friends');
}

sub followers
{
	my $self = shift;
	return WebService::Strava::Athlete->new(ctx => $self, path => 'followers');
}

sub both_following
{
	my $self = shift;
	return WebService::Strava::Athlete->new(ctx => $self, path => 'both-following');
}


# override the default defined in WebService::Strava::CommonRoles
sub _path
{
	my $self = shift;

	my $path = defined $self->path ? $self->path : defined $self->id ? 'athletes' : 'athlete';
	my @parts = ($self->ctx->_path, $path);
	push @parts, $self->id if defined $self->id;

	return join '/', @parts;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
