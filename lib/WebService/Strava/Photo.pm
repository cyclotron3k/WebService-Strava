package WebService::Strava::Photo;

use strict;
use warnings;

use Moose;
with 'WebService::Strava::CommonRoles';

has path  => (is => 'ro', isa => 'Str',  default => 'photos');
has cache => (is => 'ro', isa => 'Bool', default => '1');

no Moose;
__PACKAGE__->meta->make_immutable;

1;