#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;

get '/' => 'index';

websocket '/echo' => sub {
  my $c = shift;
  $c->app->log->debug('WebSocket opened');

  $c->inactivity_timeout(300);

  my $id = Mojo::IOLoop->recurring(1 => sub {

  my $msg1 = `date`;
  $c->send($msg1);

 });



   $c->on(finish => sub {
    my ($c, $code, $reason) = @_;

    $c->app->log->debug("WebSocket closed with status $code");
	 $c->on(finish => sub { Mojo::IOLoop->remove($id) });

  });
};
app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>Test</title></head>
  <body>
    <script>
      var ws = new WebSocket('<%= url_for('echo')->to_abs %>');
      ws.onmessage = function(event) {
        document.getElementById("dateTime").innerHTML = event.data;
      };
    </script>

<h1 id="dateTime"></h1>
  </body>
</html>
