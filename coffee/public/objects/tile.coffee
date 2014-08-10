ExplosionSpriteData =
  framerate: 15
  images: ["/images/explosion.png"]
  frames:
    width: 128
    height: 128

  animations:    
    explode: 
      frames: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15]

ExplosionSpriteSheet = new createjs.SpriteSheet ExplosionSpriteData


class @Tile
  @EXPLODE_FRAMES: 11
  constructor: (@position, @item = null) -> true
  bomb: null
  players: []
  color: "yellow"
  check_if_solid: -> @bomb
  onStep: (stage, field, player) ->
    @item.onStep(stage, field, player) if @item
    @bomb.onStep(stage, field, player) if @bomb
  onFire: (stage, field) ->
    @item.onFire(stage, field) if @item
    @bomb.onFire(stage, field) if @bomb
    if @players.length > 0
      for player in @players
        player.onFire(stage, field)
    if not @fire_gfx
      @fire_gfx = new createjs.Sprite(ExplosionSpriteSheet, "explode")
      @fire_gfx.scaleX = 0.5
      @fire_gfx.scaleY = 0.5
      @fire_gfx.y = (@position[0] * window.UNIT)
      @fire_gfx.x = (@position[1] * window.UNIT) + PADDING
      stage.addChild @fire_gfx 
    @draw(stage)
    @fire_gfx.gotoAndPlay "explode"
    stage.update()

    tile = this
    window.tick_events.push
      count: window.Tile.EXPLODE_FRAMES
      method: -> true
      finish: ->
        stage.removeChild(tile.fire_gfx)
        tile.fire_gfx = null

  draw: (stage, ignore_cache = false) ->
    if not @gfx or ignore_cache      
      #Create a Shape DisplayObject.
      @gfx = new createjs.Shape()
      @gfx.graphics.beginFill(@color).drawRect 0, 0, UNIT, UNIT
      
      #Set position of Shape instance.
      @gfx.y = (@position[0] * UNIT)
      @gfx.x = (@position[1] * UNIT) + PADDING
    
      # Add Shape instance to stage display list.
      stage.addChild @gfx

    @item.draw(stage) if @item
    @bomb.draw(stage) if @bomb
    if @players.length > 0
      for player in @players
        player.draw stage