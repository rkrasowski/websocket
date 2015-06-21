#!/usr/bin/env perl
use warnings;
use strict;

use Mojolicious::Lite;

# Template with browser-side code
get '/' => 'index';

# WebSocket echo service
websocket '/echo' => sub {
  my $c = shift;

  # Opened
  $c->app->log->debug('WebSocket opened');

  # Increase inactivity timeout for connection a bit
  $c->inactivity_timeout(300);

  # Message

 # $c->on(message => sub {
#	my $msg1;
 #      ($c, $msg1) = @_;
#	$msg1 = `date`;

	my $msg1 = `date`;
    	$c->send($msg1);

#  });

  # Closed
  $c->on(finish => sub {
    my ($c, $code, $reason) = @_;
    $c->app->log->debug("WebSocket closed with status $code");
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
