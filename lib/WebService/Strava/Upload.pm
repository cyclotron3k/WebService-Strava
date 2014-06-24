package WebService::Strava::Upload;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path => (is => 'ro', isa=> 'Str', default => 'uploads');


no Moose;
__PACKAGE__->meta->make_immutable;

1;
