#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);


my $minimum = 1000;
my $maximum = 9999;

my $minimumSpd = 0;
my $maximumSpd = 15;



get '/' => 'index';

websocket '/echo' => sub {
  my $ws = shift;
  $ws->app->log->debug('WebSocket opened');

  $ws->inactivity_timeout(300);

  my $id = Mojo::IOLoop->recurring(1 => sub {

my $lat = $minimum + int(rand($maximum - $minimum));
my $lon = $minimum + int(rand($maximum - $minimum));
my $speed = $minimumSpd + int(rand($maximumSpd - $minimumSpd));

my $bytes = encode_json {lat => $lat, lon => $lon, speed => $speed};
$ws->send($bytes);
 
 });

   $ws->on(finish => sub {
    my ($ws, $code, $reason) = @_;
    $ws->on(finish => sub { Mojo::IOLoop->remove($id) });

    $ws->app->log->debug("WebSocket closed with status $code");

  });
};
app->start;

__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
  <head><title>Web Socket Mojolicious</title>

<style>
table, th, td {
    border: 1px solid black;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    padding-top:1px;
    padding-bottum: 2px;
}


.lable{
 background-color: #E5C9A4;
}

.pos{
  background-color: #EDDDC8;
}



table {
 float:left;
 width:200px;
 border-width:5px;   
 border-style:ridge;
}



</style>

</head>
  <body>
    <script>
  
 	var ws = new WebSocket('<%= url_for('echo')->to_abs %>');
 	ws.onmessage = function(event) {
		var res = JSON.parse(event.data);
		document.getElementById("Lat").innerHTML = res.lat;
		document.getElementById("Lon").innerHTML = res.lon;
		document.getElementById("Spd").innerHTML = res.speed;
		

      };

  </script>

<div id=tableBorder>
<table border="1" >
<tr>
        <td id="latLable" class="lable"><h1>Lattitude</h1></td><td class="pos"><h1 id="Lat"></h1></td>
</tr>
<tr>
          <td id="lonLable" class="lable" ><h1>Longitude</h1></td><td class="pos"><h1 id="Lon"></h1></td>
</tr>
<tr>
        <td id="speedLable" class="lable"><h1>SOG</h1></td><td class="pos"><h1 id="Spd"></h1></td>
</tr>

</tr>

</table>
</div>



  </body>
</html>





