# Initialize Phaser, and creates a 400x490px game
game = new Phaser.Game(1024, 768, Phaser.AUTO, "game_div")
game_state = {}
player_info = {}


circlePoint = (angle, radius) ->
  _x = radius * Math.cos(angle * (Math.PI / 180))
  _y = radius * Math.sin(angle * (Math.PI / 180))
  new Phaser.Point(_x, _y)

getcircle = (_x, _y) ->
  obj = game.add.graphics(_x, _y)
  obj.beginFill 0xFFFFFF
  obj.lineStyle 2, 0x000000
  obj.drawCircle -12, -12, 24
  obj


# Creates a new 'main' state that will contain the game
game_state.world = ->

game_state.world:: =
  preload: ->
    
    # Function called first to load all the assets
    @game.stage.backgroundColor = "#71c5cf"
    return

  create: ->

  
  # Fuction called after 'preload' to setup the game    
  update: ->


# Function called 60 times per second
game_state.fight = ->

game_state.fight:: =
  preload: ->
    @game.stage.backgroundColor = "#ff11ff"
    @game.load.image "hud_bg", "assets/ui/hud_bg.png"
    @game.load.image "hud_bar_green", "assets/ui/hud_bar_green.png"
    @game.load.image "hud_bar_orange", "assets/ui/hud_bar_orange.png"
    @game.load.image "world_bg_clouds", "assets/battle_world/bg_clouds.png"
    @game.load.image "world_bg_solid", "assets/battle_world/bg_solid.png"
    @game.load.image "world_bg_waves_1", "assets/battle_world/bg_waves_1.png"
    @game.load.image "world_bg_waves_2", "assets/battle_world/bg_waves_2.png"
    @game.load.image "world_bg_waves_3", "assets/battle_world/bg_waves_3.png"
    return

  create: ->
    @createworld()
    @createhud()
    return

  createworld: ->
    @game.add.sprite 0, 0, "world_bg_solid"
    
    #this.wave_group = this.game.createGroup(6);
    @world_bg_clouds_1 = @game.add.sprite(0, 0, "world_bg_clouds")
    @world_bg_clouds_2 = @game.add.sprite(1181, 0, "world_bg_clouds")
    @currenthealth = 100 
    @maxhealth = 100
    return

  showicons: ->

  generateicons: ->
    #this.icon_1 = this.getcircle(300, 300);
    @icon_2 = getcircle(300, 300)
    @icon_3 = getcircle(300, 300)
    @icon_4 = getcircle(300, 300)
    @icon_5 = getcircle(300, 300)
    @icon_6 = getcircle(300, 300)
    @icon_7 = getcircle(300, 300)
    @icon_8 = getcircle(300, 300)
    @icon_9 = getcircle(300, 300)
    @icon_2.x += circlePoint(0, 120).x
    @icon_2.y += circlePoint(0, 120).y
    @icon_3.x += circlePoint(90, 120).x
    @icon_3.y += circlePoint(90, 120).y
    @icon_4.x += circlePoint(180, 120).x
    @icon_4.y += circlePoint(180, 120).y
    @icon_5.x += circlePoint(270, 120).x
    @icon_5.y += circlePoint(270, 120).y
    @icon_6.x += circlePoint(45, 120).x
    @icon_6.y += circlePoint(45, 120).y
    @icon_7.x += circlePoint(135, 120).x
    @icon_7.y += circlePoint(135, 120).y
    @icon_8.x += circlePoint(225, 120).x
    @icon_8.y += circlePoint(225, 120).y
    @icon_9.x += circlePoint(315, 120).x
    @icon_9.y += circlePoint(315, 120).y
    return

  createhud: ->
    @game.add.sprite 10, 10, "hud_bg"
    @green_bar = @game.add.sprite(10, 10, "hud_bar_green")
    @orange_bar = @game.add.sprite(10, 10, "hud_bar_orange")
    @green_mask = @game.add.graphics(93, 93)
    @green_mask.beginFill 0xFFFFAA
    @green_mask.drawRect -82, -82, 164, 82
    @orange_mask = @game.add.graphics(93, 93)
    @orange_mask.beginFill 0xFFFFAA
    @orange_mask.drawRect -82, 0, 164, 82
    
    #this.green_mask.anchor.setTo(0.5, 1);
    @green_bar.mask = @green_mask
    @orange_bar.mask = @orange_mask
    @generateicons()
    return

  update: ->
    @currenthealth += -0.1
    @sethealth(@currenthealth, @maxhealth)
    @setarmour(@currenthealth, @maxhealth)
    @world_bg_clouds_1.x += -0.1
    @world_bg_clouds_2.x += -0.1
    @world_bg_clouds_1.x = 1181  if @world_bg_clouds_1.x < -1181
    @world_bg_clouds_2.x = 1181  if @world_bg_clouds_2.x < -1181
    return

  sethealth: (val, maxval) ->
    @green_mask.angle = 145 - ((val/maxval) * 145);

  setarmour: (val, maxval) ->
    @orange_mask.angle = -(145 - ((val/maxval) * 145));


# Add and start the 'main' state to start the game
game.state.add "world", game_state.world
game.state.add "fight", game_state.fight
game.state.start "fight"

class BattleButton
    constructor: () ->
