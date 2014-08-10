var static = require('node-static');


var file = new static.Server('./public');

require('http').createServer(function (request, response) {

	console.log('[REQ]: ' + request.url);
	// console.log(request);
	// console.log(response);
  request.addListener('end', function () {
    file.serve(request, response, function(err, result){
      if (err) { 
        console.log("Error serving " + request.url + " - " + err.message);

        response.writeHead(err.status, err.headers);
        response.end();
      }
    });
  }).resume();
}).listen(8008);

var socket_server = require('http').Server();
var io = require('socket.io')(socket_server);

var player_id = 1;
var next_players_ids = [];
var next_game_id = 1;
var waiting_users = 0;
var GAME_SIZE = 2;
io.on('connection', function(socket){
  console.log('a user connected');
  socket.emit('handshake', player_id);
  next_players_ids.push(player_id);
  waiting_users++;
  player_id++;
  socket.join(next_game_id);

  if (waiting_users == GAME_SIZE){
    io.to(next_game_id).emit('game_start', next_game_id, next_players_ids);
    console.log(next_players_ids);
    next_players_ids = [];
    next_game_id++;
    waiting_users = 0;
  }

  socket.on('disconnect', function(){
    console.log('user disconnected');
  });
  socket.on('player_move', function(new_location, direction){
    socket.broadcast.emit('player_move', new_location, direction);
  });
  socket.on('player_win', function(){
    socket.broadcast.emit('player_win');
  });
});

socket_server.listen(8009, function(){
  console.log('listening on *:8009');
});