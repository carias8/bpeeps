// Generated by CoffeeScript 1.4.0
(function() {
  var BASE_WALK_FRAMES, KeyMap, PLAYER_GFX_SCALE, PLAYER_PADDING_X, PlayerColor, PlayerSpriteData, PlayerSpriteSheet;

  KeyMap = {
    37: "left",
    38: "up",
    39: "right",
    40: "down",
    88: "x",
    90: "z"
  };

  PLAYER_GFX_SCALE = 2;

  PlayerColor = {};

  PlayerSpriteData = {
    framerate: 15,
    images: ["/images/clear_playersheet (walking).png"],
    frames: {
      width: 17,
      height: 35
    },
    animations: {
      up: {
        frames: [0, 2, 1, 2]
      },
      left: {
        frames: [3, 5, 4, 5]
      },
      down: {
        frames: [6, 8, 7, 8]
      },
      right: {
        frames: [9, 11, 10, 11]
      },
      stand: {
        frames: [8]
      }
    }
  };

  PlayerSpriteSheet = new createjs.SpriteSheet(PlayerSpriteData);

  PLAYER_PADDING_X = 14;

  BASE_WALK_FRAMES = 10;

  this.Player = (function() {

    function Player(position, player_id, is_local) {
      var this_player;
      this.position = position;
      this.player_id = player_id;
      this.is_local = is_local;
      this_player = this;
      if (this.is_local) {
        $(document).keydown(function(event) {
          return this_player.key_input(event.which, window.field, window.stage);
        });
        this.super_move = this.move;
        this.move = function(new_location, stage, field, direction) {
          this.super_move(new_location, stage, field, direction);
          return window.socket.emit("player_move", new_location, direction);
        };
      } else {
        window.socket.on('player_bomb', function(location) {
          return this_player.lay_bomb(window.stage, window.field);
        });
        window.socket.on('player_move', function(new_location, direction) {
          return this_player.move(new_location, window.stage, window.field, direction);
        });
      }
    }

    Player.prototype.is_moving = false;

    Player.prototype.power = 2;

    Player.prototype.speed = 2;

    Player.prototype.gfx = null;

    Player.prototype.color = "white";

    Player.prototype.lay_bomb = function(stage, field) {
      var bomb;
      bomb = new Bomb(this.position, this.power, field, stage);
      return bomb.draw(stage);
    };

    Player.prototype.onFire = function(stage, field) {
      if (this.is_local) {

      } else {

      }
    };

    Player.prototype.can_move = function(location, field) {
      var tile;
      tile = field[location[0]][location[1]];
      return tile && !(tile.check_if_solid()) && !this.is_moving;
    };

    Player.prototype.key_input = function(key, field, stage) {
      var direction, keyname, new_location;
      keyname = KeyMap[key];
      if (keyname === "z") {
        this.lay_bomb(stage, field);
        return window.socket.emit('player_bomb', this.position);
      } else {
        direction = keyname;
        new_location = [];
        new_location[0] = this.position[0];
        new_location[1] = this.position[1];
        switch (direction) {
          case "up":
            new_location[0] -= 1;
            break;
          case "down":
            new_location[0] += 1;
            break;
          case "left":
            new_location[1] -= 1;
            break;
          case "right":
            new_location[1] += 1;
        }
        if (this.can_move(new_location, field)) {
          return this.move(new_location, stage, field, direction);
        }
      }
    };

    Player.prototype.move = function(new_location, stage, field, direction) {
      var new_tile, old_tile, player, tick_step_x, tick_step_y, walk_frames;
      player = this;
      player.is_moving = true;
      player.gfx.gotoAndPlay(direction);
      walk_frames = BASE_WALK_FRAMES - this.speed;
      old_tile = field[this.position[0]][this.position[1]];
      new_tile = field[new_location[0]][new_location[1]];
      old_tile.players.splice(old_tile.players.indexOf(player), 1);
      new_tile.players.push(this);
      tick_step_y = (new_location[0] - player.position[0]) / walk_frames;
      tick_step_x = (new_location[1] - player.position[1]) / walk_frames;
      return tick_events.push({
        count: walk_frames,
        method: function() {
          return player.position = [player.position[0] + tick_step_y, player.position[1] + tick_step_x];
        },
        finish: function() {
          player.gfx.gotoAndStop(direction);
          player.position = new_location;
          player.is_moving = false;
          return new_tile.onStep(stage, field, player);
        }
      });
    };

    Player.prototype.draw = function(stage) {
      if (!this.gfx) {
        this.gfx = new createjs.Sprite(PlayerSpriteSheet, "stand");
        this.gfx.scaleX = PLAYER_GFX_SCALE;
        this.gfx.scaleY = PLAYER_GFX_SCALE;
        this.gfx.gotoAndPlay("stand");
      }
      this.gfx.y = this.position[0] * UNIT;
      this.gfx.x = (this.position[1] * UNIT) + PADDING + PLAYER_PADDING_X;
      return stage.addChild(this.gfx);
    };

    return Player;

  })();

}).call(this);
