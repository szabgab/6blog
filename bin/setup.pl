use v6;
use DBIish;


my $schema = "schema.sql".IO.slurp: :close;

my $dbfile = 'blog.db';
my $dbh = DBIish.connect("SQLite", :database($dbfile));

say $schema;

for $schema.split(/\;/) -> $sql {
    next if $sql ~~ /^\s*$/;
    $dbh.do($sql);
}

$dbh.dispose;

# vim: expandtab
# vim: tabstop=4

