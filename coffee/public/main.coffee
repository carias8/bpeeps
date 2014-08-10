$ ->
  game_canvas = $("#game_window")
  DIMENSIONS = [ 1200, 600 ]
  window.PADDING = (DIMENSIONS[0] / 4) # width / 4
  window.UNIT = (DIMENSIONS[1] / 9) # height / row size
  FPS = 30
  window.socket = io("http://localhost:8009")
  player_id = null
  player_ids = []
  socket.on "handshake", (new_player_id) ->
    player_id = new_player_id

  socket.on "game_start", (game_id, new_player_ids) ->
    player_ids = new_player_ids
    window.field = FieldBuilder.build_new_field("advanced")

    window.stage = new createjs.Stage("game_window")
    window.stage.canvas.width = DIMENSIONS[0]
    window.stage.canvas.height = DIMENSIONS[1]

    if player_id is player_ids[0]
      my_start = [ 1, 1 ]
      your_start = [ 7, 7 ]
    else
      my_start = [ 7, 7 ]
      your_start = [ 1, 1 ]


    my_player = new Player(my_start, player_id, true)
    that_player = new Player(your_start, false, false)

    window.FieldBuilder.draw_field field, window.stage
    
    
    # Tick Events are intended to be run once per tick for a certain amount of time
    # the tick event objects have three attributes: count, method, finish
    # count: number of ticks left
    # method: one iteration of the event
    # finish: end of event callback
    window.tick_events = []
    handleTick = ->
      new_tick_events = []
      for event, index in window.tick_events
        event.count--
        event.method()
        if event.count < 1
          event.finish()
          window.tick_events[index] = null
      window.tick_events = window.tick_events.filter (event) -> event

      my_player.draw window.stage
      that_player.draw window.stage
      #if tick_events.length > 0
      stage.update()

    createjs.Ticker.setFPS FPS
    createjs.Ticker.addEventListener "tick", handleTick
    stage.update()
