PowerPlusItemSpriteData =
  framerate: 15
  images: ['images/items/power_plus.png']
  frames:
    width: 32
    height: 32
  animations:    
    still:
      frames: [ 0 ]

PowerPlusItemSpriteSheet = new createjs.SpriteSheet(PowerPlusItemSpriteData)


class @PowerPlusItem extends @Item
  @weight: 1
  sprite_sheet: PowerPlusItemSpriteSheet
  onStep: (stage, field, player) ->
    super(stage, field, player)
    player.power++
