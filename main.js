// Initialize Phaser, and creates a 400x490px game
var game = new Phaser.Game(1024, 768, Phaser.AUTO, 'game_div');  
var game_state = {};
var player_info = {};

// Creates a new 'main' state that will contain the game
game_state.world = function() { };  
game_state.world.prototype = {

  preload: function() { 
    // Function called first to load all the assets
    this.game.stage.backgroundColor = '#71c5cf';
  },

  create: function() { 
    // Fuction called after 'preload' to setup the game    
  },

  update: function() {
    // Function called 60 times per second
  },
};

game_state.fight = function() { };
game_state.fight.prototype = {
  preload: function() {
    this.game.stage.backgroundColor = '#ff11ff';
    this.game.load.image('hud_bg', 'assets/ui/hud_bg.png'); 
    this.game.load.image('hud_bar_green', 'assets/ui/hud_bar_green.png'); 
    this.game.load.image('hud_bar_orange', 'assets/ui/hud_bar_orange.png'); 

  },

  create: function() {
    this.game.add.sprite(10, 10, 'hud_bg');
    this.green_bar = this.game.add.sprite(10, 10, 'hud_bar_green');
    this.orange_bar = this.game.add.sprite(10, 10, 'hud_bar_orange');
    this.green_mask = this.game.add.graphics(93, 93);
    this.green_mask.beginFill(0xFFFFAA);
    this.green_mask.drawRect(-82, -82, 164, 82);
    this.orange_mask = this.game.add.graphics(93, 93);
    this.orange_mask.beginFill(0xFFFFAA);
    this.orange_mask.drawRect(-82, 0, 164, 82);
    //this.green_mask.anchor.setTo(0.5, 1);
    this.green_bar.mask = this.green_mask;
    this.orange_bar.mask = this.orange_mask;
  },

  update: function() {
    this.green_mask.angle += -1;
    this.orange_mask.angle += -1;
  },

  sethealth: function(val) {

  },

  setarmour: function(val) {

  },
};

// Add and start the 'main' state to start the game
game.state.add('world', game_state.world);  
game.state.add('fight', game_state.fight);  
game.state.start('fight');  