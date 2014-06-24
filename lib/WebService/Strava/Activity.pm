package WebService::Strava::Activity;

use strict;
use warnings;

use Moose;
use Algorithm::GooglePolylineEncoding;

with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str',  default => 'activities');
has cache => (is => 'ro', isa => 'Bool', default => '1');
has id    => (is => 'ro', isa => 'Int');

our %params = (
	before              => {required => 0, isa => 'Int' }, # UNIX TIMESTAMP
	after               => {required => 0, isa => 'Int' }, # UNIX TIMESTAMP
	page                => {required => 0, isa => 'Int' },
	per_page            => {required => 0, isa => 'Int' },
	include_all_efforts => {required => 0, isa => 'Bool'}
);

has $_ => (
	is => 'rw',
	isa => $params{$_}{isa},
	required => $params{$_}{required},
	predicate => "has_$_"
) for keys %params;

sub zones {
	my $self = shift;
	return WebService::Strava::Zone->new(@_, ctx => $self);
}

sub laps {
	my $self = shift;
	return WebService::Strava::Lap->new(@_, ctx => $self);
}

sub following {
	my $self = shift;
	return WebService::Strava::Activity->new(@_, ctx => $self);
}

sub comments {
	my $self = shift;
	return WebService::Strava::Comment->new(@_, ctx => $self);
}

sub kudos {
	my $self = shift;
	return WebService::Strava::Athlete->new(@_, ctx => $self, path=> 'kudos');
}

sub photos {
	my $self = shift;
	return WebService::Strava::Photo->new(@_, ctx => $self);
}

sub streams {
	my $self = shift;
	return WebService::Strava::Stream->new(@_, ctx => $self);
}

sub _post_processing
{
	my $self = shift;
	my $data = shift;
	my $depth = shift // 4;

	$depth--;

	return $data if $depth <= 0;

	if (ref $data eq "HASH")
	{
		for my $key (keys %$data)
		{
			if (ref $data->{$key} eq "HASH")
			{
				$self->_post_processing($data->{$key}, $depth);
			}
			elsif ($key =~ /polyline$/)
			{
				$data->{"_$key"} = [Algorithm::GooglePolylineEncoding::decode_polyline $data->{$key}];
			}
		}
	}
	elsif (ref $data eq "ARRAY")
	{
		$self->_post_processing($_, $depth) for @$data;
	}

	return $data;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;
