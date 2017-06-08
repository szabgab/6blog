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
    my %res = login(request.params);
    if %res<status> eq 'ok' {
        my $session = session();
        $session<id> = %res<id>;
        # TODO add time
    }
    %res<id>:delete;
    content_type 'application/json';
    return to-json %res;
}

get '/account' => sub {
    my %headers = request.headers;
    content_type 'application/json';
    my $session;
    if %headers<COOKIE> {
        $session = session();
        #return to-json { x => $session.perl };
    }

    return to-json account(request.params, $session)
}


# vim: expandtab
# vim: tabstop=4
