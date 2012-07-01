package www;
use HTTP::Request::Common;
use HTTP::Response;
use LWP::UserAgent;

use debug::debug;
use Data::Dumper;

sub new
{
	my ($class, $settings) = @_;

	my $self = {
		# TODO: Handle proxy usage
		proxy 	=> @$settings{proxy}	|| '',
		proto 	=> @$settings{proto}	|| '',

		timeout	=> @$settings{timeout}	|| 60,
		tries  	=> @$settings{tries}	|| 10,
		agent  	=> @$settings{agent}	|| 'Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20100101 Firefox/7.0.1',

        debug	=> new debug('www.log', @$settings{verbosity}),
        ua 		=> LWP::UserAgent->new,

		test 	=> @$settings{test},
	};
    
    if (!$self->{test})
    {
        $self->{ua}->timeout($self->{timeout});
        $self->{ua}->agent($self->{agent});
    }

    bless $self, $class;
    return $self;
}


sub get
{
    my ($self, $url) = @_;
    $self->{debug}->log("Getting: $url");
    if (!$self->{test})
    {
        my $response = $self->{ua}->get($url);
        if ($response->is_success)
        {
            return $response->decoded_content;
        }else{
            return 0;
        }
    }else{
        open (HTML, "<$url");
        my @html = <HTML>;
        return join('', @html);
    }
}

sub download
{
    my ($self, $url, $dest) = @_;
    $self->{debug}->log("Downloading '$url' to '$dest'");
    if (!$self->{test})
    {
        my $response = 0;
        eval { $response = $self->{ua}->mirror($url, $dest) };
        if ($response && $response->is_success)
        {
            return 1;
        }else{
            return 0;
        }
    }else{
        return 1;
    }
}
1;