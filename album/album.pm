package Album;
use debug::debug;
use sockets::interface;
use network::interface;
use db::albums;
use db::photos;

sub new
{

    my ($class, $target, $settings) = @_;

    my $self = {
		destination => @$settings{destination},

        debug   => new debug('album.log', @$settings{verbosity}),
        db      => new albums('album', 'album'),
		photo 	=> new photos('photo', 'photo'),
		socket  => new sockets::interface(@$settings{socket}),
        network => new network::interface(@$settings{network}, $settings),
    };
    
    foreach (@{ $self->{db}->{schema} })
    {
        $self->{$_} = 0;
    }

    $self->{url} = @$target{url};
    if ($self->{db}->info($self))
    {
        $self->{debug}->log("Local copy of album found.");
        
    }else{
        $self->{debug}->log("No local copy found.");
    }

	$self->{debug}->dump($settings);

    bless $self, $class;
    return $self;
}

sub info
{
    my ($self) = @_;
    foreach (@{ $self->{db}->{schema} } )
    {
        $self->{debug}->log("Album's $_: $self->{$_}") unless !defined $self->{$_};
    }
}

sub update
{
    my ($self, $url) = @_;
    $url = defined $url ? $url : $self->{url};
    if (my $html = $self->{network}->get("$url"))
    {
        $self->{debug}->log("Album information retrieved sucessfully.");
        $self->{socket}->info($self, $html);
    }else{
        $self->{debug}->log("Error retrieving album.");
        return 0;
    }

    $self->{debug}->log("Getting images list.");

	while (my $page = $self->{socket}->page())
	{
        if (my $strip = $self->{network}->get( $page ) )
        {
			my $files = $self->{socket}->files($strip);
			$self->{debug}->log("Found $files->{total} images on page $files->{current}");
            foreach my $i (0..$files->{total}-1)
            {
                $self->{photo}->{name} 	= $files->{files}->[$i];
                $self->{photo}->{url} 	= $files->{urls}->[$i];
                $self->{photo}->{album} = $self->{uid};
				# TODO:
				# --file-check : check if file locally exits and if so, its marked as downloaded
				# --force-download : no matter anything it download everything listed

				$self->{debug}->log("$self->{photo}->{name} - $self->{photo}->{url}");
                $self->{photo}->save();
            }
        }else{
            $self->{debug}->log("Error retrieving page '$self->{socket}->{current}'");
        }
    }
    return 1;
}

sub download
{
    my ($self) = @_;
    ## TODO Need to implement a parser class to handle html/regex. Where such thing belongs?

	# TODO:
	# 	while (my $file = $self->{photo}->get("url = $self->{album} AND state = '0'")) # returns a photo hash with values from the db
	#	{
	#		#
	#		if (!$file->{state} = $self->{network}->download($file->{download}, $self->{destination}$file->{name}))
	#		{
	#			$self->{debug}->log("Error downloading '$file->{download}'");
	#		}
	#		$self->{photo}->save(); # update it's state, checked etc.
	#	}

	# TODO Move this somewhere else
	`mkdir -p "$self->{destination}$self->{title}"` unless (-e "$self->{destination}$self->{title}");

	my $photos = $self->{photo}->get($self);
	my %work = (success => 0, skip => 0, fails => 0);
	foreach (@{$photos})
	{
		if (!-e "$self->{destination}$self->{title}/$_->[3]") # TODO should also check the database? NO. the photo->get(...) method should retrieve only state=0 files
		{
			#$_->[4] =~ s/http:\/\/./http:\/\/o/;
			$_->[2] = $self->{network}->download($_->[4], "$self->{destination}$self->{title}/$_->[3]");
			if (!$_->[2])
			{
				$self->{debug}->log("Error downloading: '$_->[4]'");
				$work{fails}++;
			}else{
				$work{success}++;
			}
		}else{
			$self->{debug}->log("Skiping: $_->[3] ($_->[4])");
			$work{skip}++;
		}
		#$self->{photo}->save();
        $self->{debug}->log("$work{success} images downloaded. $work{skip} skipped. $work{fails} failed.");
	}
}

sub save
{
    my ($self) = @_;
    $self->{db}->save($self);
}

1;