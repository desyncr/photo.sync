package debug;
use Data::Dumper;

sub new
{
    my ($class, $logfile, $verbosity) = @_;
	`mkdir "log"` unless (-e "log");
    open(DEBUG, ">>log/$logfile") or die $!;
    my $self = {
        logfile         => $logfile || '',
        verbosity       => $verbosity || 0,
        handle          => $logfile
    };

    bless $self, $class;
    return $self;
}

sub dump
{
	my ($self, $dump, $var) = @_;
	my $name = (defined $var) ? $var : 'variable';
    my $message = '[ ' . scalar localtime(time()) . " ][ $self->{logfile} ] Contents of $name\n";
	if ($self->{verbosity} >= 1)
    {
		print $message;
        print Dumper $dump;
    }
    
}
sub log
{
    my ($self, $message) = @_;
    #[ Fri Nov 4 04:10:47 2011 ] Connecting through 127.0.0.1:80
    $message = '[ ' . scalar localtime(time()) . " ][ $self->{logfile} ] $message\n";

    if ($self->{verbosity} >= 1)
    {
        print $message;
    }
    
    print DEBUG $message;

}

1;
