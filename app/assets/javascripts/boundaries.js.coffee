@boundaries = ->
#  soundManager.onready ->
#
#    soundManager.createSound
#      id:'hit'
#      url:'boundaries_sounds/hit.mp3'
#
#    soundManager.createSound
#      id:'defeat'
#      url:'boundaries_sounds/defeat.mp3'

  canvas = document.getElementById("myCanvas")
  canvasId = "myCanvas"
  ctx = canvas.getContext("2d")

  decel = 0.96
  spikeSize = 10
  nucleusRad = 15
  electronRad = 7
  radChangeRate = 2
  radMax = 100
  angleChangeRate = 15
  hitSpeed = 15

  otherSpeed = 1
  level = 1
  accelerationConstant = 0.0001
  playerAcceleration = 0.20
  maxVelocity = 1

  player = ''
  enemies = []

  firstTime = true

  rand = (max) ->
    Math.ceil(Math.random()*max)

  numEnemies = ->
    return Math.floor(Math.pow(level, 1.8))

  drawBackground = ->
    ctx.fillStyle = '#CCA981'
    ctx.fillRect(0, 0, canvas.width, canvas.height)

#  loadAndPlaySound = (fileName) ->
#    sound = document.createElement('audio')
#    sound.setAttribute('src', "#{fileName}")
#    sound.load()
#    sound.play()

  Key =
    _pressed: {},

    LEFT: 37 || 65,
    A: 65,
    UP: 38,
    W: 87,
    RIGHT: 39,
    D: 68,
    DOWN: 40,
    S: 83,
    SPACE: 32,

    isDown: (keyCode) ->
      this._pressed[keyCode]
    onKeydown: (event) ->
      this._pressed[event.keyCode] = true
    onKeyup: (event) ->
      delete this._pressed[event.keyCode]


  class Circle

    move: ->
      @dx *= decel
      @dy *= decel
      if 0 < @y < canvas.height && 0 < @x < canvas.width
        @draw()
      else
        @stillAlive = false
#        soundManager.play('defeat')

    draw: ->
      ctx.fillStyle = @color
      ctx.beginPath()
      ctx.arc(@x,@y, nucleusRad, 0, Math.PI * 2, false);
      ctx.fill()

  class Nucleus extends Circle
    constructor: (@x, @y, @radius, @isPlayer, @color = 'black', @nucleusColor = '#A8652D') ->
      @angle = 0
      @dx = 0
      @dy = 0
      @stillAlive = true

    move: ->
      @angle += angleChangeRate/(30 + @radius)
      @x += @dx
      @y += @dy
      @electronX = @x + Math.cos(@angle)*@radius
      @electronY = @y + Math.sin(@angle)*@radius
      super

    draw: ->
      ctx.fillStyle = @nucleusColor
      ctx.beginPath()
      ctx.arc(@electronX, @electronY, electronRad, 0, Math.PI *2, false)
      ctx.fill()
      super



  class Player extends Nucleus
    constructor: (x, y, radius) ->
      super(x, y, radius, true)

    update: ->
      if (Key.isDown(Key.UP) || Key.isDown(Key.W)) then @dy -= playerAcceleration
      if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) then @dy += playerAcceleration
      if (Key.isDown(Key.LEFT) || Key.isDown(Key.A)) then @dx -= playerAcceleration
      if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) then @dx += playerAcceleration
      if (Key.isDown(Key.SPACE))
        @radius += radChangeRate if @radius < radMax
      else if @radius > nucleusRad + electronRad + 1
        @radius -= radChangeRate

  class Enemy extends Nucleus
    constructor: (x, y, radius) ->
      @outward = true
      super(x, y, radius, false, '#777777', '#333333')

    update: ->
      @dx += (player.x - @x) * 0.00035 * ((1.2 + level/10) - enemies.length/numEnemies())
      @dy += (player.y - @y) * 0.00035 * ((1.2 + level/10) - enemies.length/numEnemies())
      if Math.random() < 0.05
        @outward = !@outward
      if @outward
        @radius += radChangeRate if @radius < radMax
      else
        @radius -= radChangeRate if @radius > nucleusRad + electronRad + 1

  enemyFactory = (number) ->
    enemies = []
    for i in [1..number]
      enemies.push(new Enemy(rand(canvas.width), rand(canvas.height), 20))


  collision = (hitter, hittee, modifiers = 1) ->
    hittee.dx = Math.cos(hitter.angle + Math.PI/2)*hitSpeed*modifiers
    hittee.dy = Math.sin(hitter.angle + Math.PI/2)*hitSpeed*modifiers
#    soundManager.play('hit')

  electronCollision = (atom1, atom2) ->
    collision(atom1, atom2, 0.3)
    collision(atom2, atom1, 0.3)

  checkOneCollision = (x1, y1, x2, y2, radius) ->
    distance = Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2)
    if distance < Math.pow(radius, 2)
      return true
    else
      return false

  checkAtomsCollision = (atom1, atom2) ->
    if checkOneCollision(atom1.x, atom1.y, atom2.electronX, atom2.electronY, nucleusRad + electronRad)
      collision(atom2, atom1)
    if checkOneCollision(atom1.electronX, atom1.electronY, atom2.x, atom2.y, nucleusRad + electronRad)
      collision(atom1, atom2)
    if checkOneCollision(atom1.electronX, atom1.electronY, atom2.electronX, atom2.electronY, electronRad + electronRad)
      electronCollision(atom1, atom2)

  checkAllCollisions = ->
    i = 0
    while i < enemies.length
      enemy = enemies[i]
      checkAtomsCollision(enemy, player)
      j = i + 1
      while j < enemies.length
        checkAtomsCollision(enemy, enemies[j])
        j++
      i++

    filterEnemies()

  filterEnemies = ->
    i = 0
    while i < enemies.length
      if enemies[i].stillAlive
        i++
      else
        enemies.splice(i, 1)

  mainLoop = (canvas) ->
    window.requestAnimationFrame(mainLoop, canvas)
    if enemies.length == 0
      level++
      startGame()
    else if !player.stillAlive
      startGame()

    drawBackground()
    player.update()
    player.move()
    player.draw()
    enemy.update() for enemy in enemies
    enemy.move() for enemy in enemies
    enemy.draw() for enemy in enemies
    checkAllCollisions()

  window.addEventListener 'keyup', ((event) -> Key.onKeyup(event); event.preventDefault(); return false), false
  window.addEventListener 'keydown', ((event) -> Key.onKeydown(event); event.preventDefault(); return false), false

  startGame = ->
    canvasId = Math.random().toString()
    oldCanvas = $('#holdsMyGame canvas').remove()
    $('#holdsMyGame').html("<canvas id='#{canvasId}' width=#{oldCanvas[0].width} height=#{oldCanvas[0].height}></canvas>")
    canvas = document.getElementById(canvasId)
    ctx = canvas.getContext("2d")
    canvas.tabIndex = 1

    player = new Player(canvas.width/2, canvas.height/2, 20, true)
    enemyFactory(numEnemies())
    if firstTime
      firstTime = false
      mainLoop(canvas)


  level = 1
  startGame()