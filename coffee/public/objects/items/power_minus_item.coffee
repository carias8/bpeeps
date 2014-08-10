PowerMinusItemSpriteData =
  framerate: 15
  images: ['images/items/power_minus.png']
  frames:
    width: 30
    height: 30
  animations:    
    still:
      frames: [ 0 ]

PowerMinusItemSpriteSheet = new createjs.SpriteSheet(PowerMinusItemSpriteData)


class @PowerMinusItem extends @Item
  @weight: 1
  sprite_sheet: PowerMinusItemSpriteSheet
  onStep: (stage, field, player) ->
    super(stage, field, player)
    player.power--
