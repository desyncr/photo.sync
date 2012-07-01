use db::database_test;
use Data::Dumper;
$db = new database('data', 'clients');
$db->{dbi}->do("create table if not exists clients ( name, surname, uid, count );");
if (!$db->count("`uid` = '230'"))
{
    $db->insert({name => Pedro, surname => Lopez, uid => 230});
}else {
    $db->update({name => Pedro, uid => 1}, "`name` = 'Pedro'");
}
my $clients = $db->select([uid, name, surname], "`uid` != '30'");
while ( ($key, $client) = each(%$clients) )
{
    print "key : $key : $client->{name}\n";
}

$db->delete("`uid` = '123123'");
