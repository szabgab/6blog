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
    my $sth = $dbh.prepare('SELECT * FROM user WHERE username = ?');
    $sth.execute(%params<username>);
    
    my @rows = $sth.allrows(:array-of-hash);
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
    if bcrypt-match(%params<password>, @rows[0]<password>) {
        @rows[0]<password>:delete;
        return {
            status => 'ok',
            |@rows[0],
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

sub account(%params, $session) is export {
    # if logged in return the information about the user
    # if not logged in return false
    if $session<id> {
        my $dbh = connect();
        my $sth = $dbh.prepare('SELECT * FROM user WHERE id=?');
        $sth.execute($session<id>);
        my %user = $sth.row(:hash);
        $sth.finish;
        $dbh.dispose;

        return {
            status    => "ok",
            full_name => %user<full_name>,
            email     => %user<email>,
            username  => %user<username>,
        }
    } else {
        return {
            status => "failed",
        }
    }
}


# vim: expandtab
# vim: tabstop=4
