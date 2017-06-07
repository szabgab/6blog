use v6;
use DBIish;
use Crypt::Bcrypt;


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

sub login(%params) is export {
    my $dbh = connect();
    my $sth = $dbh.prepare('SELECT username, password FROM user WHERE username = ?');
    $sth.execute(%params<username>);
    
    my @rows = $sth.allrows();
    $sth.finish;
    $dbh.dispose;

    if @rows.elems > 1 {
        die "we have a real problem here. (duplicate username)";
    }
    if @rows.elems == 0 {
        # user not found
        return {
            status => 'failed',
        }
    }
    if bcrypt-match(%params<password>, @rows[0][1]) {
        return {
            status => 'ok',
        }
    } else {
        return {
            status => 'failed',
        }
    }
}


sub register(%params) is export {
    # TODO verify fields
    # hash password
    # check if database store was successfule
    my $username  = %params<username>;
    my $full_name = %params<full_name>;
    my $email     = %params<email>;
    my $password  = %params<password>;
    my $hashed_pw = bcrypt-hash($password);
    add_user($username, $full_name, $email, $hashed_pw);

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
