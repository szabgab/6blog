use v6;
use Bailador;
use JSON::Fast;

use Glosador::Code;

unit module Glosador::API;

get '/' => sub {
    content_type 'application/json';
    return to-json main();
}

# vim: expandtab
# vim: tabstop=4
