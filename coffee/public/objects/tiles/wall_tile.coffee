class @WallTile extends @Tile
  constructor: (@position) ->
 
  color: "blue"
  check_if_solid: -> true
  onFire: (stage, field) -> true
