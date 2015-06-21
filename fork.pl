#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;

get '/' => 'index';

websocket '/echo' => sub {
  my $c = shift;
  $c->app->log->debug('WebSocket opened');

  $c->inactivity_timeout(300);

my $pid = fork;

if (!defined $pid) 
	{
   		die $c->app->log->debug("Can not fork:  $!");
	}

elsif ($pid == 0) 
	{
    # client process
    $c->app->log->debug("Child is born !");
	print "Child is born\n\n";
	while (1)	{print "Hello \n";sleep(1);}
	}
else 
	{
    # parent process
    $c->app->log->debug("Parent is fine ");

        # do something useful here!
    waitpid $pid, 0;

}



  my $msg1 = `date`;
  $c->send($msg1);

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
