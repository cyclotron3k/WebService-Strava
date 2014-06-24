package WebService::Strava::Lap;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str',  default => 'uploads');
has cache => (is => 'ro', isa => 'Bool', default => '1');

# segment_efforts
# segment/:id/all_efforts

no Moose;
__PACKAGE__->meta->make_immutable;

1;
