package WebService::Strava::Zone;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path => (is => 'ro', isa=> 'Str', default => 'zones');

# segment_efforts
# segment/:id/all_efforts

no Moose;
__PACKAGE__->meta->make_immutable;

1;
