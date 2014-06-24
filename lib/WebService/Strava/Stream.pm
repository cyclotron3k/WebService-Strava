package WebService::Strava::Stream;

use strict;
use warnings;

use Moose;

with 'WebService::Strava::CommonRoles';
has path  => (is => 'ro', isa => 'Str',  default => 'streams');
has cache => (is => 'ro', isa => 'Bool', default => '1');
has types => (is => 'ro', required => 1, isa => 'Str');

our %params = (
	resolution  => {required => 0, isa => 'Int' },
	series_type => {required => 0, isa => 'Int' }
);

has $_ => (
	is => 'rw',
	isa => $params{$_}{isa},
	required => $params{$_}{required},
	predicate => "has_$_"
) for keys %params;



sub validate_types
{
	my $self = shift;
	my $types = shift;
	my @valid_types = qw(time latlng distance altitude velocity_smooth heartrate cadence watts temp moving grade_smooth);
	return 0;
}

sub validate_resolution_type
{
	my $self = shift;
	my $types = shift;
	my @valid_types = qw(low medium high);
	return 0;
}

sub validate_series_type
{
	# relevant only if using resolution
	my $self = shift;
	my $types = shift;
	my @valid_types = qw(time distance);
	return 0;
}

sub _path
{
	my $self = shift;

	my @parts = ($self->ctx->_path, 'streams');
	push @parts, $self->types if defined $self->types;

	return join '/', @parts;
}


no Moose;
__PACKAGE__->meta->make_immutable;

1;
