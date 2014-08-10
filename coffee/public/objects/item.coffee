
ITEM_PADDING = 10
ITEM_GFX_SCALE = 1.5

class @Item

  remove_item = (item, stage, field) ->
    field[ item.position[0] ][ item.position[1] ].item = null
    stage.removeChild item.gfx

  @weight: 1
  constructor: (@position) -> true
  gfx: null
  onStep: (stage, field, player) ->
    remove_item(this, stage, field) if @gfx
  onFire: (stage, field) ->
    remove_item(this, stage, field) if @gfx
  draw: (stage) ->
    return false if @gfx
    @gfx = new createjs.Sprite(@sprite_sheet, "still")
    @gfx.scaleY = ITEM_GFX_SCALE
    @gfx.scaleX = ITEM_GFX_SCALE
  
    #Set position of Shape instance. 
    @gfx.y = (@position[0] * window.UNIT) + ITEM_PADDING
    @gfx.x = (@position[1] * window.UNIT) + window.PADDING + ITEM_PADDING
    @gfx.gotoAndPlay "still"
  
    #Add Shape instance to stage display list.
    stage.addChild @gfx
