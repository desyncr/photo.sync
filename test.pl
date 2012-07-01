#!/usr/bin/perl -w
use strict;
use warnings;
use Data::Dumper;
my $url = 'http://localhost/';
print "$url\n\n";
my $orig=$url =~ s/http:\/\/./http:\/\/o/;

print "$url\n\n";

die;

my $path = "/downloads/asd/";


print $path;
print "\n";
die;

__END__

for my $try (1..10)
{
	print "try #$try\n";
	`curl - hht://google.com`;
	last if !$?;
}

__END__
use network::interface;

my $net = new network::interface('curl', ['127.0.0.1:37604', 'socks5-hostname']);

print $net->get('https://check.torproject.org/?lang=en-US&small=1&uptodate=1');

die;

__END__
my $hash = {
    vector      => ["hello", "there", "i'mma", "vector"]
};

print Dumper $hash;
foreach (@{$hash->{vector}})
{
    print $_ . "\n";
}
 
