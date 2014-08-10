$(function(){
    var game_canvas = $('#game_window');
    DIMENSIONS = [1200, 600];
    PADDING = (DIMENSIONS[0] / 4); // width / 4
    UNIT = (DIMENSIONS[1] / 9); // height / row size
    FPS = 30;
    socket = io('http://localhost:8009');
    var player_id = null;
    var player_ids = [];

    socket.on('handshake', function(new_player_id){
      player_id = new_player_id;
    });

    socket.on('game_start', function(game_id, new_player_ids){
      player_ids = new_player_ids;
      field = FieldBuilder.build_new_field('advanced');
      var bombs = [];

      stage = new createjs.Stage('game_window');
      stage.canvas.width = DIMENSIONS[0];
      stage.canvas.height = DIMENSIONS[1];

      console.debug(player_id);
      console.debug(player_ids[0]);
      if (player_id == player_ids[0]){
        var my_start = [1, 1];
        var your_start = [7, 7];
      } else {
        var my_start = [7, 7];
        var your_start = [1, 1];
      }

      console.debug(my_start);
      var my_player = new Player(my_start, player_id, true);
      var that_player = new Player(your_start, false, false);

      FieldBuilder.draw_field(field, stage);   

      //Update stage will render next frame
      createjs.Ticker.setFPS(FPS);  
      createjs.Ticker.addEventListener("tick", handleTick);


      // Tick Events are intended to be run once per tick for a certain amount of time
      // the following event objects have three attributes: count, method, finish
      // count: number of ticks left
      // method: one iteration of the event
      // finish: end of event callback
      tick_events = []; // IS DAT A MOFOKIN GLOBAL UP IN HEERE?
      function handleTick() {
        $.each(tick_events, function(index, event){
          event.count = event.count - 1;
          event.method();
          if (event.count < 1) {
            tick_events.splice(index, 1);
            event.finish();
          }
        });
        my_player.draw(stage);
        that_player.draw(stage);
        stage.update();
      }

    });



  });