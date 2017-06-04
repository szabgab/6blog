use v6;
use Bailador;
use JSON::Fast;

unit module Glosador::API;

get '/' => sub {
    content_type 'application/json';
    return to-json {
		title => 'Hello World',
	};
}

# vim: expandtab
# vim: tabstop=4


