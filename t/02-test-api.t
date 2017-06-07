use v6;
use Test;
use Bailador::Test;
use JSON::Fast;

use lib 'lib';
use Glosador::API;
use Glosador::Code;

plan 2;

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


subtest {
    plan 3;
    my %params = 
        username   => 'foobar',
        email      => 'foo@bar.com',
        password   => 'secret',
        full_name  => 'Foo Bar',
    ;
    my $params = %params.map({ (.key ~ '=' ~ .value) }).join('&');

    my %data = run-psgi-request('POST', '/register', $params);

#    diag %data.perl;
    my $html = %data<response>[2];
    #diag $html;
    my %json = from-json $html;
    is-deeply %json, {
       "status" => "ok",
       "id" => 42
    };
    %data<response>[2] = '';
    is-deeply %data<response>, [200, ["Content-Type" => "application/json"], ''], 'route GET /';
    is %data<err>, '', 'stderr';
};


# vim: expandtab
# vim: tabstop=4
