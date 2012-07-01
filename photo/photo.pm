package Photo;
use debug::debug;

sub new
{
    my ($class) = @_;
    my $self = {
        id      => 0,
        state   => 0,
        name    => '',
        url     => '',
        created => 0,
        size    => 0,
        large   => 0,
    
        debug   => new Debug('photo', 1),
    };
    bless $self, $class;
    return $self;
}

sub info
{
    
}

sub download
{
    
}

sub save
{
    
}

1;