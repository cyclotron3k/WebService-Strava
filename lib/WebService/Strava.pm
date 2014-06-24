package WebService::Strava;

use strict;
use warnings;

=head1 NAME

WebService::Strava - Interface to the Strava API version 3

=cut

use Moose;
use LWP::UserAgent;
use Data::Dumper;

use WebService::Strava::Activity;
use WebService::Strava::Athlete;
use WebService::Strava::Club;
use WebService::Strava::Comment;
use WebService::Strava::Effort;
use WebService::Strava::Gear;
use WebService::Strava::Lap;
use WebService::Strava::Photo;
use WebService::Strava::Segment;
use WebService::Strava::Stream;

our $VERSION = 0.03;

has 'token'  => (is => 'rw', isa => 'Str', required => 1);
has 'client' => (is => 'rw', isa => 'Str', required => 1);
has '_path'  => (is => 'ro', isa => 'Str', default => 'https://www.strava.com/api/v3');
has 'ua'     => (is => 'ro', isa => 'LWP::UserAgent', lazy_build => 1);

sub _build_ua {
	my $self = shift;
	my $ua = LWP::UserAgent->new(agent => join('_', __PACKAGE__, $VERSION), timeout => 300);
	$ua->default_header(':Authorization' => 'Bearer ' . $self->token);
	return $ua;
}

sub athletes
{
	my $self = shift;
	return WebService::Strava::Athlete->new(@_, ctx => $self);
}

sub activities
{
	my $self = shift;
	return WebService::Strava::Activity->new(@_, ctx => $self);
}

sub clubs
{
	my $self = shift;
	return WebService::Strava::Club->new(@_, ctx => $self);
}

sub gear
{
	my $self = shift;
	return WebService::Strava::Gear->new(@_, ctx => $self);
}

sub segments
{
	my $self = shift;
	return WebService::Strava::Segment->new(@_, ctx => $self);
}

__PACKAGE__->meta->make_immutable;
no Moose;

1;
