package photos;
use db::database;

our @ISA = qw(database);

sub new
{
    my ($class, $database, $table) = @_;
    my @schema = ('id', 'album', 'state', 'name', 'url', 'created', 'size', 'large');
    
    my $self = $class->SUPER::new($database, $table, @schema);
    foreach (@schema)
    {
        $self->{$_} = 0;
    }
    bless $self, $class;
    return $self;
}

sub save
{
    my ($self) = @_;

    if ($self->count("`url` = '$self->{url}'"))
    {
        $self->update({
                    state     => $self->{state},
                    size      => $self->{size},
                    },
                    "`url` = '$self->{url}'"
                    );
    }else{
        my %insert;
        foreach (@{$self->{schema}})
        {
            $insert->{$_} = $self->{$_};
        }
        $self->insert($insert);
    }
}

sub get
{
	my ($self) = @_;
	my $result = $self->select($self->{schema}, "`album` = '$self->{album}' AND `state` = '0'");
	$self->{debug}->dump($result);	
	return $result;
}
