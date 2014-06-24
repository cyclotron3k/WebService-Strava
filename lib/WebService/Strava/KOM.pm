package WebService::Strava::KOM;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';


has path => (is => 'ro', isa => 'Str', default => 'koms');


no Moose;
__PACKAGE__->meta->make_immutable;


1;
