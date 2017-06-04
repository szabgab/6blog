use v6;
use Test;
use Bailador::Test;
use JSON::Fast;

use lib 'lib';
use Glosador::API;

plan 1;

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


