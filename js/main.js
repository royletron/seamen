(function() {
  var BattleButton, circlePoint, game, game_state, getcircle, player_info;

  game = new Phaser.Game(1024, 768, Phaser.AUTO, "game_div");

  game_state = {};

  player_info = {};

  circlePoint = function(angle, radius) {
    var _x, _y;
    _x = radius * Math.cos(angle * (Math.PI / 180));
    _y = radius * Math.sin(angle * (Math.PI / 180));
    return new Phaser.Point(_x, _y);
  };

  getcircle = function(_x, _y) {
    var obj;
    obj = game.add.graphics(_x, _y);
    obj.beginFill(0xFFFFFF);
    obj.lineStyle(2, 0x000000);
    obj.drawCircle(-12, -12, 24);
    return obj;
  };

  game_state.world = function() {};

  game_state.world.prototype = {
    preload: function() {
      this.game.stage.backgroundColor = "#71c5cf";
    },
    create: function() {},
    update: function() {}
  };

  game_state.fight = function() {};

  game_state.fight.prototype = {
    preload: function() {
      this.game.stage.backgroundColor = "#ff11ff";
      this.game.load.image("hud_bg", "assets/ui/hud_bg.png");
      this.game.load.image("hud_bar_green", "assets/ui/hud_bar_green.png");
      this.game.load.image("hud_bar_orange", "assets/ui/hud_bar_orange.png");
      this.game.load.image("world_bg_clouds", "assets/battle_world/bg_clouds.png");
      this.game.load.image("world_bg_solid", "assets/battle_world/bg_solid.png");
      this.game.load.image("world_bg_waves_1", "assets/battle_world/bg_waves_1.png");
      this.game.load.image("world_bg_waves_2", "assets/battle_world/bg_waves_2.png");
      this.game.load.image("world_bg_waves_3", "assets/battle_world/bg_waves_3.png");
    },
    create: function() {
      this.createworld();
      this.createhud();
    },
    createworld: function() {
      this.game.add.sprite(0, 0, "world_bg_solid");
      this.world_bg_clouds_1 = this.game.add.sprite(0, 0, "world_bg_clouds");
      this.world_bg_clouds_2 = this.game.add.sprite(1181, 0, "world_bg_clouds");
      this.currenthealth = 100;
      this.maxhealth = 100;
    },
    showicons: function() {},
    generateicons: function() {
      this.icon_2 = getcircle(300, 300);
      this.icon_3 = getcircle(300, 300);
      this.icon_4 = getcircle(300, 300);
      this.icon_5 = getcircle(300, 300);
      this.icon_6 = getcircle(300, 300);
      this.icon_7 = getcircle(300, 300);
      this.icon_8 = getcircle(300, 300);
      this.icon_9 = getcircle(300, 300);
      this.icon_2.x += circlePoint(0, 120).x;
      this.icon_2.y += circlePoint(0, 120).y;
      this.icon_3.x += circlePoint(90, 120).x;
      this.icon_3.y += circlePoint(90, 120).y;
      this.icon_4.x += circlePoint(180, 120).x;
      this.icon_4.y += circlePoint(180, 120).y;
      this.icon_5.x += circlePoint(270, 120).x;
      this.icon_5.y += circlePoint(270, 120).y;
      this.icon_6.x += circlePoint(45, 120).x;
      this.icon_6.y += circlePoint(45, 120).y;
      this.icon_7.x += circlePoint(135, 120).x;
      this.icon_7.y += circlePoint(135, 120).y;
      this.icon_8.x += circlePoint(225, 120).x;
      this.icon_8.y += circlePoint(225, 120).y;
      this.icon_9.x += circlePoint(315, 120).x;
      this.icon_9.y += circlePoint(315, 120).y;
    },
    createhud: function() {
      this.game.add.sprite(10, 10, "hud_bg");
      this.green_bar = this.game.add.sprite(10, 10, "hud_bar_green");
      this.orange_bar = this.game.add.sprite(10, 10, "hud_bar_orange");
      this.green_mask = this.game.add.graphics(93, 93);
      this.green_mask.beginFill(0xFFFFAA);
      this.green_mask.drawRect(-82, -82, 164, 82);
      this.orange_mask = this.game.add.graphics(93, 93);
      this.orange_mask.beginFill(0xFFFFAA);
      this.orange_mask.drawRect(-82, 0, 164, 82);
      this.green_bar.mask = this.green_mask;
      this.orange_bar.mask = this.orange_mask;
      this.generateicons();
    },
    update: function() {
      this.currenthealth += -0.1;
      this.sethealth(this.currenthealth, this.maxhealth);
      this.setarmour(this.currenthealth, this.maxhealth);
      this.world_bg_clouds_1.x += -0.1;
      this.world_bg_clouds_2.x += -0.1;
      if (this.world_bg_clouds_1.x < -1181) {
        this.world_bg_clouds_1.x = 1181;
      }
      if (this.world_bg_clouds_2.x < -1181) {
        this.world_bg_clouds_2.x = 1181;
      }
    },
    sethealth: function(val, maxval) {
      return this.green_mask.angle = 145 - ((val / maxval) * 145);
    },
    setarmour: function(val, maxval) {
      return this.orange_mask.angle = -(145 - ((val / maxval) * 145));
    }
  };

  game.state.add("world", game_state.world);

  game.state.add("fight", game_state.fight);

  game.state.start("fight");

  BattleButton = (function() {
    function BattleButton() {}

    return BattleButton;

  })();

}).call(this);
