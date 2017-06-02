use v6;
use Test;
use Bailador::Test;

use lib 'lib';
use Glosador;

plan 1;

subtest {
    plan 2;
    my %data = run-psgi-request('GET', '/');
    is-deeply %data<response>, [200, ["Content-Type" => "text/html"], 'Hello World'], 'route GET /';
    is %data<err>, '', 'stderr';
};

