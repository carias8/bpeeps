KeyMap =
  37: "left"
  38: "up"
  39: "right"
  40: "down"
  88: "x"
  90: "z"

PLAYER_GFX_SCALE = 2
PlayerColor = {}
PlayerSpriteData =
  framerate: 15
  images: ["/images/clear_playersheet (walking).png"]
  frames:
    width: 17
    height: 35

  animations:    
    up:
      frames: [ 0, 2, 1, 2 ]
    left:
      frames: [ 3, 5, 4, 5 ]
    down:
      frames: [ 6, 8, 7, 8 ]
    right:
      frames: [ 9, 11, 10, 11 ]
    stand:
      frames: [ 8 ]

PlayerSpriteSheet = new createjs.SpriteSheet(PlayerSpriteData)
PLAYER_PADDING_X = 14
BASE_WALK_FRAMES = 10 # inverse speed of walk in # of frames/unit

# TODO: replace conditional (@is_local) with polymorphism (MyPlayer + YourPlayer)
class @Player
  constructor: (@position, @player_id, @is_local) ->
    this_player = this
    if @is_local
      $(document).keydown (event) ->
        this_player.key_input event.which, window.field, window.stage
        # FieldBuilder.draw_field window.field, window.stage

      @super_move = @move
      @move = (new_location, stage, field, direction) ->
        @super_move new_location, stage, field, direction
        window.socket.emit "player_move", new_location, direction

    else
      window.socket.on 'player_bomb', (location) ->
        this_player.lay_bomb window.stage, window.field
      window.socket.on 'player_move', (new_location, direction) ->
        this_player.move new_location, window.stage, window.field, direction
  is_moving: false
  power: 2
  speed: 2
  gfx: null
  color: "white"
  lay_bomb: (stage, field) ->
    bomb = new Bomb(@position, @power, field, stage)
    bomb.draw stage
  onFire: (stage, field) ->
    if @is_local
      # console.debug "you lost! hit f5"
    else
      # window.socket.emit "game_over", @is_local
  can_move: (location, field) ->
    tile = field[location[0]][location[1]]
    tile and not (tile.check_if_solid()) and not (@is_moving)
  key_input: (key, field, stage) ->
    keyname = KeyMap[key]
    if keyname is "z"
      @lay_bomb stage, field
      window.socket.emit 'player_bomb', @position
    else
      direction = keyname
      new_location = []
      new_location[0] = @position[0]
      new_location[1] = @position[1]
      switch direction
        when "up"
          new_location[0] -= 1
        when "down"
          new_location[0] += 1
        when "left"
          new_location[1] -= 1
        when "right"
          new_location[1] += 1
      @move new_location, stage, field, direction  if @can_move(new_location, field)

  move: (new_location, stage, field, direction) ->
    player = this
    player.is_moving = true
    player.gfx.gotoAndPlay direction
    walk_frames = BASE_WALK_FRAMES - @speed

    old_tile = field[@position[0]][@position[1]]
    new_tile = field[new_location[0]][new_location[1]]
    old_tile.players.splice(old_tile.players.indexOf(player), 1) # remove from old
    new_tile.players.push this # add to new

    tick_step_y = (new_location[0] - player.position[0]) / walk_frames
    tick_step_x = (new_location[1] - player.position[1]) / walk_frames
    tick_events.push
      count: walk_frames
      method: ->
        player.position = [
          player.position[0] + tick_step_y
          player.position[1] + tick_step_x
        ]

      finish: ->
        player.gfx.gotoAndStop direction
        player.position = new_location
        player.is_moving = false
        new_tile.onStep(stage, field, player)

  draw: (stage) ->
    unless @gfx
      @gfx = new createjs.Sprite(PlayerSpriteSheet, "stand")
      @gfx.scaleX = PLAYER_GFX_SCALE
      @gfx.scaleY = PLAYER_GFX_SCALE
      @gfx.gotoAndPlay "stand"
    
    # //Create a Shape DisplayObject.
    # this.gfx = new createjs.Shape();
    # this.gfx.graphics.beginFill(this.color).drawCircle( 0, 0, (UNIT/4) );
    
    #Set position of Shape instance. 
    @gfx.y = (@position[0] * UNIT)
    @gfx.x = (@position[1] * UNIT) + PADDING + PLAYER_PADDING_X
    
    #Add Shape instance to stage display list.
    stage.addChild @gfx


