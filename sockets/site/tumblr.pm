package tumblr;
use Data::Dumper;

sub new
{
    my ($class) = @_;
    my $self = {
        name    => $class,
        current => 0,
        pages   => 0,
        url     => '',
        download => '',
        arrPages => [],
    };
    bless $self, $class;
    return $self;
}

sub page
{
    my ($self) = @_;
    
    if ($self->{current} >= $self->{pages})
    {
        return 0;
    }

    $self->{current} += 1;
    return $self->{url};
}

sub files
{
    my ($self, $html) = @_;
    my $info = {
        total   => 0,
        current => 0,
    };
    @{$info->{urls}}    = $html =~ m/src="(\S+)".alt=/g;
    @{$info->{files}}   = $html =~ m/src=".*\/(\w*\.\w+)".alt=/g;
    $info->{total}      = eval($#{$info->{urls}}+1);
    $info->{current}    = $self->{current};
    return $info;
}

sub info
{
    my ($self, $album, $html) = @_;

    $album->{url} =~ m/^.*$/;
    $album->{uid} = $album->{url};

    $html =~ m/<title>(.*)<\/title>/g;
    $album->{title} = $1;
    $album->{title} =~ tr/\//_/; ## sanitize 
    $album->{owner} = "";
    $album->{created} = "";
    $self->{pages} = $album->{pages} = 1;
    $album->{images} = eval($album->{pages} * 45);

    $album->{pages} = 1;
    $self->{pages} = 1;

    $self->{download} = $album->{url};
    $self->{url} = $album->{url};
    return $self->{download};
}



1;