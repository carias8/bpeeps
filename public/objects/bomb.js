// Generated by CoffeeScript 1.4.0
(function() {

  this.Bomb = (function() {

    function Bomb(position, power, field, stage) {
      var that;
      this.position = position;
      this.power = power;
      this.blown = false;
      field[this.position[0]][this.position[1]].bomb = this;
      that = this;
      window.tick_events.push({
        count: this.fuse_time,
        method: function() {},
        finish: function() {
          return that.boom(stage, field);
        }
      });
    }

    Bomb.prototype.fuse_time = 60;

    Bomb.prototype.color = "black";

    Bomb.prototype.onFire = function(stage, field) {
      return this.boom(stage, field);
    };

    Bomb.prototype.draw = function(stage) {
      if (!this.gfx) {
        this.gfx = new createjs.Shape();
        this.gfx.graphics.beginFill(this.color).drawCircle(0, 0, UNIT / 2);
        this.gfx.y = (this.position[0] * UNIT) + (UNIT / 2);
        this.gfx.x = (this.position[1] * UNIT) + (UNIT / 2) + PADDING;
        return stage.addChild(this.gfx);
      }
    };

    Bomb.prototype.boom = function(stage, field) {
      var bomb, extend_flame, tile;
      if (!this.blown) {
        bomb = this;
        bomb.blown = true;
        tile = field[this.position[0]][this.position[1]];
        tile.bomb = null;
        stage.removeChild(bomb.gfx);
        extend_flame = function(y_function, x_function) {
          var i;
          i = 1;
          while (i <= bomb.power) {
            tile = field[y_function(i)][x_function(i)];
            tile.onFire(stage, field);
            if (tile.check_if_solid()) {
              break;
            }
            i++;
          }
          return true;
        };
        tile.onFire(stage, field);
        extend_flame(function(i) {
          return bomb.position[0] - i;
        }, function(i) {
          return bomb.position[1];
        });
        extend_flame(function(i) {
          return bomb.position[0] + i;
        }, function(i) {
          return bomb.position[1];
        });
        extend_flame(function(i) {
          return bomb.position[0];
        }, function(i) {
          return bomb.position[1] - i;
        });
        return extend_flame(function(i) {
          return bomb.position[0];
        }, function(i) {
          return bomb.position[1] + i;
        });
      }
    };

    return Bomb;

  })();

}).call(this);
