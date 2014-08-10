node_static = require 'node-static'


file = new node_static.Server './public'

require('http').createServer( (request, response) ->
  console.log('[REQ]: ' + request.url)
  # console.log(request)
  # console.log(response)
  request.addListener('end',  () ->
    file.serve(request, response, (err, result) ->
      if err
        console.log("Error serving " + request.url + " - " + err.message)

        response.writeHead(err.status, err.headers)
        response.end()
    )
  ).resume()
).listen(8008)

socket_server = require('http').Server()
io = require('socket.io')(socket_server)

player_id = 1
next_players_ids = []
next_game_id = 1
waiting_users = 0
GAME_SIZE = 2
io.on 'connection', (socket) ->
  console.log('a user connected')
  socket.emit('handshake', player_id)
  next_players_ids.push(player_id)
  waiting_users++
  player_id++
  socket.join(next_game_id)

  if waiting_users is GAME_SIZE
    io.to(next_game_id).emit('game_start', next_game_id, next_players_ids)
    console.log(next_players_ids)
    next_players_ids = []
    next_game_id++
    waiting_users = 0
  

  socket.on 'disconnect', () ->
    console.log('user disconnected')

  socket.on 'player_bomb', (location) ->
    socket.broadcast.emit 'player_bomb', location
  
  socket.on 'player_move', (new_location, direction) ->
    socket.broadcast.emit 'player_move', new_location, direction
  
  socket.on 'player_win', () ->
    socket.broadcast.emit 'player_win'  

socket_server.listen 8009, () ->
  console.log('listening on *:8009')
