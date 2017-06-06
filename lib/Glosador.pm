use v6;
use Bailador;
use Glosador::Code;

unit module Glosador;

get '/' => sub {
    my $res = main();
    return $res<title>;
}

# vim: expandtab
# vim: tabstop=4

