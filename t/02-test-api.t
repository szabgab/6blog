use v6;
use Test;
use Bailador::Test;
use JSON::Fast;

use lib 'lib';
use Glosador::API;
use Glosador::Code;

plan 6;

setup();

subtest {
    plan 4;
    my %data = run-psgi-request('GET', '/');
    my $html = %data<response>[2];
    my %json = from-json $html;
    is %json<title>, 'Hello World';
    is-deeply %json, {
       "title" => "Hello World"
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route GET /';
    is %data<err>, '', 'stderr';
};

sub flatten(%h) {
    return %h.map({ (.key ~ '=' ~ .value) }).join('&');
}

subtest {
    plan 3;
    my %params = 
        username   => 'foobar',
        email      => 'foo@bar.com',
        password   => 'secret',
        full_name  => 'Foo Bar',
    ;

    my %data = run-psgi-request('POST', '/register', flatten(%params));

#    diag %data.perl;
    my $html = %data<response>[2];
    #diag $html;
    my %json = from-json $html;
    is-deeply %json, {
       "status" => "ok",
       "id" => 42
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route POST /register';
    is %data<err>, '', 'stderr';
}, 'register';

subtest {
    plan 3;
    my %params = 
        username   => 'foobar',
        password   => 'bad',
    ;

    my %data = run-psgi-request('POST', '/login', flatten(%params));
    my $html = %data<response>[2];
    my %json = from-json $html;
    is-deeply %json, {
       "status" => "failed",
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route POST /login';
    is %data<err>, '', 'stderr';
}, 'incorrect password';

subtest {
    plan 3;
    my %params = 
        username   => 'barfoo',
        password   => 'secret',
    ;

    my %data = run-psgi-request('POST', '/login', flatten(%params));
    my $html = %data<response>[2];
    my %json = from-json $html;
    is-deeply %json, {
       "status" => "failed",
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route POST /login';
    is %data<err>, '', 'stderr';
}, 'incorrect user';

subtest {
    plan 3;
    my %params = 
        username   => 'foobar',
        password   => 'secret',
    ;

    my %data = run-psgi-request('POST', '/login', flatten(%params));
    my $html = %data<response>[2];
    my %json = from-json $html;
    is-deeply %json, {
        :status('ok'),
        :email('foo@bar.com'),
        :full_name('Foo Bar'),
        :registered_date('now'),
        :username('foobar'),
        :verified('FALSE')
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route POST /login';
    is %data<err>, '', 'stderr';
}, 'incorrect user';


subtest {
    plan 3;

    my %data = run-psgi-request('GET', '/account');
    my $html = %data<response>[2];
    my %json = from-json $html;
    is-deeply %json, {
       "status" => "failed",
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route GET /account';
    is %data<err>, '', 'stderr';
}, 'incorrect user';


# vim: expandtab
# vim: tabstop=4
