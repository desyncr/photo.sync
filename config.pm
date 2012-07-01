package config;
use strict;
use warnings;

use Getopt::Long;

    our %config = (
        target => {
            url         => 'http://',
            update      => 0,                   # download added files
        },
        
        settings => {
            destination => '~/downloads/',
            agent       => 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1',
            timeout		=> 30,
			tries		=> 10,
			
			proxy		=> '',
			proto		=> '',

			socket		=> 'flickr',
			network		=> 'www',
			verbosity	=> 1,
			test		=> 0,
        }
    );

    my $result = GetOptions(
        'url=s'		    => \$config{target}{url},
        'update'        => \$config{target}{update},
        'destination=s' => \$config{settings}{destination},
		'agent=s'		=> \$config{settings}{agent},
        'timeout=i' 	=> \$config{settings}{timeout},
        'tries=i'   	=> \$config{settings}{tries},

		'proxy=s'   	=> \$config{settings}{proxy},
		'proto=s'   	=> \$config{settings}{proto},

		'socket=s'		=> \$config{settings}{socket},
		'network=s'		=> \$config{settings}{network},
        'verbosity=i'   => \$config{settings}{verbosity},
		'test'			=> \$config{settings}{test},
    );
	$config{settings}{destination} .= "/" unless ($config{settings}{destination} =~ m/\/$/);
    `mkdir -p $config{settings}{destination}` unless (-e $config{settings}{destination});

1;