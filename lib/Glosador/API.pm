use v6;
use Bailador;
use JSON::Fast;

use Glosador::Code;

unit module Glosador::API;

get '/' => sub {
    content_type 'application/json';
    return to-json main();
}

post '/register' => sub {
    content_type 'application/json';
    return to-json register(request.params)
}

post '/login' => sub {
    content_type 'application/json';
    return to-json login(request.params)
}

get '/account' => sub {
    content_type 'application/json';
    return to-json account(request.params)
}


# vim: expandtab
# vim: tabstop=4
