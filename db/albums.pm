package albums;
use db::database;
use Data::Dumper;

our @ISA = qw(database);

sub new
{
    my ($class, $database, $table) = @_;

    # convert to a hash: {'id' => 'int primary key auto_increment', 'uid' => 'char(10)'} etc
    my @schema = ('id', 'uid', 'url', 'state', 'checked', 'owner', 'title', 'created', 'updated', 'pages', 'images');
    my $self = $class->SUPER::new($database, $table, @schema);

    bless $self, $class;
    return $self;
}

sub info
{
    my ($self, $album) = @_;
    if ($self->count("`url` = '$album->{url}'"))
    {
        my $result = $self->select($self->{schema}, "`url` = '$album->{url}'");

        foreach (@{ $self->{schema} })
        {
            $album->{$_} = $values->{$_};
        }
        return 1;
    }
    return 0;
}

sub save
{
    my ($self, $album) = @_;
    if ($self->count("`url` = '$album->{url}'"))
    {
        $self->update({
                    state     => $album->{state},
                    checked   => scalar localtime(time()),
                    updated   => scalar localtime(time()),
                    pages     => $album->{pages},
                    images    => $album->{images}
                    },
                    "`url` = '$album->{url}'"
                    );
    }else{
        my %insert;
        foreach (@{$self->{schema}})
        {
            $insert->{$_} = $album->{$_};
        }
        $self->insert($insert);
    }
}

1;