package WebService::Strava::Gear;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str',  default => 'gear');
has cache => (is => 'ro', isa => 'Bool', default => '0');

no Moose;
__PACKAGE__->meta->make_immutable;

1;
