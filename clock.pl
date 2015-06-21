#!/usr/bin/env perl
use warnings;
use strict;
use Mojolicious::Lite;

any '/' => 'index';

websocket '/data' => sub {
  	my $self = shift;
	# Websocked opens
 	$self->app->log->debug('WebSocket opened');




  my $timer = Mojo::IOLoop->recurring( 1 => sub {
    state $i = 0;
    $self->send({ json => gen_data($i++) });
#	sleep(1);
  });

  	$self->on( finish => sub {
    	Mojo::IOLoop->remove($timer);
	my ($self, $code, $reason) = @_;
	$self->app->log->debug("WebSocket closed with status $code");
  	});
};


sub gen_data 
	{
		my $time = `date`;
		return $time;
	}
app->start;


__DATA__

@@ index.html.ep

% layout 'basic';

%= javascript 'https://code.jquery.com/jquery-2.1.4.min.js';



<h1 id="TempIn">Testing the script</h1>


%= javascript begin
  var data = [];

  var url = '<%= url_for('data')->to_abs %>';
  var ws = new WebSocket( url );
  ws.onmessage = function(e){

var element = document.getElementById("TempIn");
element.innerHTML =  JSON.parse(e.data);;

   
  };
% end