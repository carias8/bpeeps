class @Bomb 
  constructor: (@position, @power, field, stage) ->
    @blown = false
    field[@position[0]][@position[1]].bomb = this
    that = this
    window.tick_events.push
      count: @fuse_time
      method: ->
      finish: ->
        that.boom(stage, field)

  fuse_time: 60 # ticks
  color: "black"
  onFire: (stage, field) ->
    @boom stage, field

  draw: (stage) ->
    if not @gfx
      @gfx = new createjs.Shape()
      @gfx.graphics.beginFill(@color).drawCircle 0, 0, (UNIT / 2)
      @gfx.y = (@position[0] * UNIT) + (UNIT / 2)
      @gfx.x = (@position[1] * UNIT) + (UNIT / 2) + PADDING
      stage.addChild @gfx

  boom: (stage, field) ->  
    if not @blown
      bomb = this
      bomb.blown = true

      # Remove bomb from field/stage
      tile = field[ @position[0] ][ @position[1] ]
      tile.bomb = null
      stage.removeChild bomb.gfx

      extend_flame = (y_function, x_function) ->
        i = 1
        while i <= bomb.power
          tile = field[y_function(i)][x_function(i)]
          tile.onFire(stage, field) 
          break if tile.check_if_solid()
          i++
        return true

      #center
      tile.onFire stage, field    

      # up
      extend_flame(
        (i) -> bomb.position[0] - i
        (i) -> bomb.position[1]
      )
      
      # down
      extend_flame(
        (i) -> bomb.position[0] + i
        (i) -> bomb.position[1]
      )
      
      # left
      extend_flame(
        (i) -> bomb.position[0]
        (i) -> bomb.position[1] - i
      )
      
      # right
      extend_flame(
        (i) -> bomb.position[0] 
        (i) -> bomb.position[1] + i
      )
