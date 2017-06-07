use v6;
use DBIish;


sub main() is export {
    return {
        title => 'Hello World',
    };
}

sub add_user($username, $full_name, $email, $password) {
    my $dbh = connect();
    my $sth = $dbh.prepare(q:to/STATEMENT/);
        INSERT INTO user (username, full_name, email, password, registered_date)
        VALUES ( ?, ?, ?, ?, ?)
    STATEMENT
    $sth.execute($username, $full_name, $email, $password, 'now');
}

sub register(%params) is export {
    # TODO verify fields
    # hash password
    # check if database store was successfule
    my $username  = %params<username>;
    my $full_name = %params<full_name>;
    my $email     = %params<email>;
    my $password  = %params<password>;
    add_user($username, $full_name, $email, $password);

    return {
        status => 'ok',
        id => 42,
    };
}

sub connect() {
    my $dbfile = 'blog.db';
    return DBIish.connect("SQLite", :database($dbfile));
}

sub setup() is export {
    my $schema = "schema.sql".IO.slurp: :close;
    my $dbh = connect();

    #say $schema;

    for $schema.split(/\;/) -> $sql {
        next if $sql ~~ /^\s*$/;
        $dbh.do($sql);
    }

    $dbh.dispose;
}


# vim: expandtab
# vim: tabstop=4


# vim: expandtab
# vim: tabstop=4
