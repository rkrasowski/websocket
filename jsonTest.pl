#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);

my $bytes = encode_json {lat => 1.23, lon => 4.56, text => 'hello'};



my $hash  = decode_json $bytes;


my $lat = $hash->{lat};
my $lon = $hash->{lon};
my $text = $hash->{text};



say "Lat is: $lat";
say "Lon is: $lon";
say "Text is: $text";








