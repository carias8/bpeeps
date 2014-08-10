class @BrickTile extends @Tile
  constructor: (@position) -> true
  players: []
  color: "red"
  check_if_solid: -> true
  onFire: (stage, field) ->
    super(stage, field)

    this_tile = this
    window.tick_events.push
      count: window.Tile.EXPLODE_FRAMES
      method: -> true
      finish: ->
        new_tile = new Tile this_tile.position, window.ItemFactory.roll_for_item(this_tile.position)
        stage.removeChild this_tile.gfx if this_tile.gfx
        field[this_tile.position[0]][this_tile.position[1]] = new_tile
        new_tile.draw stage
    

