#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);


my $minimum = 1000;
my $maximum = 9999;


get '/' => 'index';

websocket '/echo' => sub {
  my $c = shift;
  $c->app->log->debug('WebSocket opened');

  $c->inactivity_timeout(300);

  my $id = Mojo::IOLoop->recurring(1 => sub {

my $lat = $minimum + int(rand($maximum - $minimum));
my $lon = $minimum + int(rand($maximum - $minimum));
my $text = $minimum + int(rand($maximum - $minimum));

my $bytes = encode_json {lat => $lat, lon => $lon, text => $text};
$c->send($bytes);
 # $c->send($x);

 });

   $c->on(finish => sub {
    my ($c, $code, $reason) = @_;
    $c->on(finish => sub { Mojo::IOLoop->remove($id) });

    $c->app->log->debug("WebSocket closed with status $code");

  });
};
app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>Web Socket Mojolicious</title></head>
  <body>
    <script>
   //   var ws = new WebSocket('<%= url_for('echo')->to_abs %>');
   //   ws.onmessage = function(event) {
   //     document.getElementById("dateTime").innerHTML = event.data;
   //   };
  
 var ws = new WebSocket('<%= url_for('echo')->to_abs %>');
 ws.onmessage = function(event) {
	var res = JSON.parse(event.data);
	 document.getElementById("Lat").innerHTML = res.lat;
document.getElementById("Lon").innerHTML = res.lon;
document.getElementById("Text").innerHTML = res.text;

   //     document.getElementById("dateTime").innerHTML = event.data;
      };
  





  </script>

<h1 id="Lat"></h1>
<h1 id="Lon"></h1>
<h1 id="Text"></h1>

  </body>
</html>





