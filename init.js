// Generated by CoffeeScript 1.4.0
(function() {
  var GAME_SIZE, file, io, next_game_id, next_players_ids, node_static, player_id, socket_server, waiting_users;

  node_static = require('node-static');

  file = new node_static.Server('./public');

  require('http').createServer(function(request, response) {
    console.log('[REQ]: ' + request.url);
    return request.addListener('end', function() {
      return file.serve(request, response, function(err, result) {
        if (err) {
          console.log("Error serving " + request.url + " - " + err.message);
          response.writeHead(err.status, err.headers);
          return response.end();
        }
      });
    }).resume();
  }).listen(8008);

  socket_server = require('http').Server();

  io = require('socket.io')(socket_server);

  player_id = 1;

  next_players_ids = [];

  next_game_id = 1;

  waiting_users = 0;

  GAME_SIZE = 2;

  io.on('connection', function(socket) {
    console.log('a user connected');
    socket.emit('handshake', player_id);
    next_players_ids.push(player_id);
    waiting_users++;
    player_id++;
    socket.join(next_game_id);
    if (waiting_users === GAME_SIZE) {
      io.to(next_game_id).emit('game_start', next_game_id, next_players_ids);
      console.log(next_players_ids);
      next_players_ids = [];
      next_game_id++;
      waiting_users = 0;
    }
    socket.on('disconnect', function() {
      return console.log('user disconnected');
    });
    socket.on('player_bomb', function(location) {
      return socket.broadcast.emit('player_bomb', location);
    });
    socket.on('player_move', function(new_location, direction) {
      return socket.broadcast.emit('player_move', new_location, direction);
    });
    return socket.on('player_win', function() {
      return socket.broadcast.emit('player_win');
    });
  });

  socket_server.listen(8009, function() {
    return console.log('listening on *:8009');
  });

}).call(this);
