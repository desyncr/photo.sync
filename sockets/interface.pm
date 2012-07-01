package sockets::interface;
use Data::Dumper;
sub new
{
	my ($class, $socket) = @_;

	require $ENV{"PWD"} . "/sockets/site/$socket.pm";;

	my $self = {
		socket => $socket->new(),	# socket name
		version => VERSION,	# interface version to handle plugins / sockets
	};
	
	bless $self, $class;
	return $self;
}
sub page
{
	my ($self) = @_;
	return $self->{socket}->page();
}

sub files
{
	my ($self, $html) = @_;
	return $self->{socket}->files($html);
}

sub info
{
	my ($self, $album, $html) = @_;
	return $self->{socket}->info($album, $html);
}
1;

