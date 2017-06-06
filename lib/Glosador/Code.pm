use v6;


sub main() is export {
    return {
        title => 'Hello World',
    };
}

sub add_user() {
    my $dbh = 0;
    my $sth = $dbh.prepare(q:to/STATEMENT/);
        INSERT INTO user (username, full_name, email, password, registered_date)
        VALUES ( ?, ?, ?, ?, ?)
    STATEMENT
}

# vim: expandtab
# vim: tabstop=4
