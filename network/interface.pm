package network::interface;
use Data::Dumper;
sub new
{
	my ($class, $network, $params) = @_;
	require $ENV{"PWD"} . "/network/interface/$network.pm";;

	my $self = {
		socket => $network->new($params),	# socket name
		version => VERSION,	# interface version to handle plugins / sockets
	};
	
	bless $self, $class;
	return $self;
}

sub get
{
	my ($self, $url) = @_;
	return $self->{socket}->get($url);
}

sub download
{
	my ($self, $url, $dest) = @_;
	return $self->{socket}->download($url, $dest);
}
1;
