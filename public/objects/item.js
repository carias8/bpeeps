// Generated by CoffeeScript 1.4.0
(function() {
  var ITEM_GFX_SCALE, ITEM_PADDING;

  ITEM_PADDING = 10;

  ITEM_GFX_SCALE = 1.5;

  this.Item = (function() {
    var remove_item;

    remove_item = function(item, stage, field) {
      field[item.position[0]][item.position[1]].item = null;
      return stage.removeChild(item.gfx);
    };

    Item.weight = 1;

    function Item(position) {
      this.position = position;
      true;
    }

    Item.prototype.gfx = null;

    Item.prototype.onStep = function(stage, field, player) {
      if (this.gfx) {
        return remove_item(this, stage, field);
      }
    };

    Item.prototype.onFire = function(stage, field) {
      if (this.gfx) {
        return remove_item(this, stage, field);
      }
    };

    Item.prototype.draw = function(stage) {
      if (this.gfx) {
        return false;
      }
      this.gfx = new createjs.Sprite(this.sprite_sheet, "still");
      this.gfx.scaleY = ITEM_GFX_SCALE;
      this.gfx.scaleX = ITEM_GFX_SCALE;
      this.gfx.y = (this.position[0] * window.UNIT) + ITEM_PADDING;
      this.gfx.x = (this.position[1] * window.UNIT) + window.PADDING + ITEM_PADDING;
      this.gfx.gotoAndPlay("still");
      return stage.addChild(this.gfx);
    };

    return Item;

  })();

}).call(this);