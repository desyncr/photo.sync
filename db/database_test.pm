package database;
use debug::debug;
use DBI;

########################################################################
# Opens up a given SQLite database and set table name from where to read
#
# $db = Database::new('database','tablename');
#
sub new
{
    my ($class, $db, $table) = @_;

    my $self = {
        db      => $db,
        table   => $table,
        dbi     => DBI->connect("dbi:SQLite:./db/" . $db . ".db"),
        debug   => new debug('database.log', 1)
    };

    bless $self, $class;
    return $self;
}

########################################################################
# Sets table name from where to read
#
# $db->using('testtable');
sub using
{
    my ($self, $table) = @_;
    $self->{table} = $table;
}

########################################################################
# Out put debug info
sub debugStr
{
    my ($self) = @_;
    $self->{debug}->log($_[1]);
    return $_[1];
}

########################################################################
# Perform a select from the db.
#
# First param is a list of fields to retrieve.
# Second param is the where clause.
#
# $db->select([id, name, surname], 'name!="pedro"')
sub select
{
    my ($self, $values, $where, $order, $limit) = @_;
    $values = join("`, `", @{$values});
    
    $where = "WHERE $where" unless $where eq '';
    $order = "ORDER BY `$order`" unless $order eq '';
    $limit = "LIMIT $limit" unless $limit eq '';
    
    return $self->{dbi}->selectall_hashref(
        $self->debugStr("SELECT `$values` FROM `$self->{table}` $where $order $limit"), 1
    );
    
}

########################################################################
# Count a rows
# 
#
#
sub count
{
    my ($self, $where) = @_;
    $where = "WHERE $where" unless %{$where} eq '';
    my $count = $self->{dbi}->selectall_arrayref(
        $self->debugStr("SELECT COUNT(*) FROM `$self->{table}` $where")
    );
    return @$count[0]->[0];
}
########################################################################
# Insert a row into the database
# 
# first param is the list of values to insert
#
# $db->insert({'name' => 'pedro', 'surname' => 'lopez'})
sub insert
{
    my ($self, $values) = @_;
    $self->{dbi}->do(
        $self->debugStr("INSERT INTO `$self->{table}` (`" . _kstr(%{$values}) . "`) VALUES ('" . _vstr(%{$values}) . "')")
    );
}

########################################################################
# Delete rows from the database given certain params
#
# $db->delete('name="pedro"');
#
sub delete
{
    my ($self, $where) = @_;
    $self->{dbi}->do(
        $self->debugStr("DELETE FROM `$self->{table}` WHERE $where")
    );
}

########################################################################
# Update rows from the database given certain params
#
# $db->update(('name' => 'Pedro'), "`name` = 'pedro'"));
#
sub update
{
    my ($self, $values, $where) = @_;
    my $val, @values;
    while ( ($key, $val) = each(%{$values}) )
    {
        push(@values, "`$key` = '$val'");
    }
    $values = join(", ", @values);
    $self->{dbi}->do(
        $self->debugStr("UPDATE `$self->{table}` SET $values WHERE $where")
    );
}

########################################################################
# Helper functions
sub _kstr
{
    my %k = @_;
    return join("`,`",keys(%k))
}

sub _vstr
{
    my %v = @_;
    return join("','",values(%v))
}

1;