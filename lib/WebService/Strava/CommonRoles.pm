use strict;
use warnings;
use 5.014;

package WebService::Strava::CommonRoles;

use Moose::Role;

use JSON 'decode_json';
use URI;
use Data::Dumper;
use Digest::MD5 qw(md5_hex);
use Storable;

has 'ctx' => (is  => 'ro', isa => 'Object', required => 1);

sub lookup
{
	my $self = shift;
	my $param = shift;

	return ($self->ctx->can($param) ? $self->ctx->$param : $self->ctx->lookup($param));
}

sub _path
{
	my $self = shift;

	my @parts = ($self->ctx->_path, $self->path);
	push @parts, $self->id if $self->can('id') and defined $self->id;

	return join '/', @parts;
}

sub get
{
	my $self = shift;

	my $uri = URI->new($self->_path);

	my %params = ();
	my @keys = ();
	{
		my $class = ref $self;
		no strict 'refs';
		@keys = keys %{'main::'."$class".'::params'};
	}
	for my $k (@keys)
	{
		my $predicate = "has_$k";
		next unless $self->$predicate;
		$params{$k} = $self->$k;
	}
	$uri->query_form(%params) if %params;

	say "Getting: " . $uri;
	my $key = md5_hex $uri;
	my $store = 'cache/' . $key;

	my $decoded;

	if (-f $store)
	{
		$decoded = retrieve $store;
	}
	else
	{
		my $res = $self->lookup('ua')->get($uri);

		die "404" if $res->code eq "404";
		die "Unauthorized" if $res->code eq "401";

		unless ($res->is_success)
		{	
			print Dumper $res;
			die;
		}
		
		my ($limit_fifteen, $limit_twenty_four) = ($res->header('X-RateLimit-Limit') =~ /(\d+),(\d+)/);
		my ($usage_fifteen, $usage_twenty_four) = ($res->header('X-RateLimit-Usage') =~ /(\d+),(\d+)/);

		if (100 * $usage_fifteen / $limit_fifteen > 95)
		{
			warn "Approaching 15m limit ($usage_fifteen / $limit_fifteen)";
		}
		if ($limit_fifteen - $usage_fifteen < 15)
		{
			say "Using rate limiter";
			sleep 60;
		}

		if (100 * $usage_twenty_four / $limit_twenty_four > 99)
		{
			warn "Approaching 24h limit ($usage_twenty_four / $limit_twenty_four)";
		}

		$decoded = decode_json $res->content;
	}

	store $decoded, $store;

	$decoded = $self->_post_processing($decoded) if $self->can('_post_processing');

	return @$decoded if ref $decoded eq 'ARRAY';

	return $decoded;
}

around BUILDARGS => sub {
	my $orig  = shift;
	my $class = shift;

	if (@_ % 2 == 0) # or ref $_[0] or $_[1] ne 'ctx')
	{
		return $class->$orig(@_);
	}
	else
	{
		return $class->$orig(id => @_);
	}

};

1;
