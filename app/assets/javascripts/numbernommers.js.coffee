@numbernommers = ->
  boardWidth = 5
  boardHeight = 5
  score = 3
  startingHealth = 3
  health = startingHealth
  canvas = document.getElementById("myCanvas")
  canvasId = "myCanvas"
  ctx = canvas.getContext("2d")
  gameMode = 'normal'
  player = ""
  enemies = []
  level = 1
  difficulty = 5
  frequency = 1000 #milliseconds it takes for an enemy to move
  cooldown = false
  gameOver = false
  numbers = [[],[]]
  answer = 5



  text = (text, x, y, color = '#000', size = 18, style = 'sans-serif')->
    ctx.fillStyle = color
    ctx.font = "bold #{size}px #{style}"
    ctx.textAlign = 'center'
    ctx.textBaseline = 'middle'
    ctx.fillText(text, x, y)
    return

  newEquation = ->
    "#{rand(difficulty)} + #{rand(difficulty)}"

  makeNumberGrid = ->
    numbers.length = 0
    for i in [1..boardWidth]
      numberColumn = []
      for j in [1..boardHeight]
        equation = newEquation()
        numberColumn[j] = equation
      numbers[i] = numberColumn

  drawBackground = ->
    color = 200
    ctx.fillStyle = "rgb(#{color},#{color},#{color})"
    ctx.fillRect(0,0,canvas.width,canvas.height)

  drawGrid = ->
    height = canvas.height/(boardHeight + 2)
    width = canvas.width/(boardWidth + 2)
    ctx.strokeStyle = "black"
    for i in [1..boardWidth]
      for j in [1..boardHeight]
        ctx.strokeRect(i*width, j*height, width, height)

        text(numbers[i][j], (i+0.5)*width, (j+0.5)*height)
    text("health: #{health}", 100, 40)
    text("score: #{score}", canvas.width - 100, 40)
    text("target: #{answer}", canvas.width/2, 40)
    return

  cooldownTimer = ->
    cooldown = false


  Key =
    _pressed: {},

    LEFT: 37,
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
      if event.keyCode == 32
        player.nom()
      else
        unless cooldown
          cooldown = true
          setTimeout( cooldownTimer, 70)
          player.move(event.keyCode)
    onKeyup: (event) ->
      delete this._pressed[event.keyCode]

  rand = (max, min = 0) ->
    Math.floor(Math.random()*(max - min) + min)

  newAnswer = ->
    i = rand(boardWidth, 1)
    j = rand(boardHeight, 1)
    answer = eval(numbers[i][j])

  class Square
    constructor: (@x, @y) ->
      @height = canvas.height/(boardHeight + 2)
      @width = canvas.width/(boardWidth + 2)
      @color = '#938493'

    draw: (fillStyle = @color) ->
      x = @x * @width
      y = @y * @height
      ctx.fillStyle = fillStyle
      ctx.fillRect(x, y, @width, @height)
      return

  class Enemy extends Square
    constructor: ->
      if Math.random() > 0.5
        @direction = 'horizontal'
        @x = 0
        @y = Math.ceil(Math.random()*boardHeight)
      else
        @direction = 'vertical'
        @y = 0
        @x = Math.ceil(Math.random()*boardWidth)
      @height = canvas.height/(boardHeight + 2)
      @width = canvas.width/(boardWidth + 2)
      @color = '#A07676'
      @stillAround = true

    move: ->
      if @direction == 'horizontal'
        @x += 1
        if @x > boardWidth + 1
          @stillAround = false
      else
        @y += 1
        if @y > boardHeight + 1
          @stillAround = false

  moveAllEnemies = (canvas) ->
    enemy.move() for enemy in enemies
    checkEnemies()
    if canvas.id == canvasId
      setTimeout(moveAllEnemies, frequency, canvas)

  drawEnemies = ->
    for enemy in enemies
      enemy.draw()


  enemyFactory = (num) ->
    if num <= 0
      return
    for i in [1..Math.floor(num)]
      newEnemy = new Enemy()
      enemies.push(newEnemy)
    return

  checkEnemies = ->
    player.checkCollisions()
    i = 0
    while i < enemies.length
      if enemies[i].stillAround
        i++
      else
        enemies.splice(i, 1)
    enemyFactory(score/3 - enemies.length)
    if health <= 0
      startGame()

  class Player extends Square

    move: ->
      if (Key.isDown(Key.UP) || Key.isDown(Key.W)) then @y -= 1
      else if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) then @y += 1
      else if (Key.isDown(Key.LEFT) || Key.isDown(Key.A)) then @x -= 1
      else if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) then @x += 1

      if @y < 1 then @y = 1
      if @y > boardHeight then @y = boardHeight
      if @x < 1 then @x = 1
      if @x > boardWidth then @x = boardWidth
      checkEnemies()


    checkCollisions: ->
      if @isHit()
        health -= 1

    isHit: ->
      for enemy in enemies
        if @y == enemy.y && @x == enemy.x
          enemy.stillAround = false
          return true
      return false

    nom: ->
      equation = numbers[@x][@y]
      oldColor = @color
      if eval(equation) == answer
        @color = 'green'
        setTimeout(revertColor, 300, oldColor)
        score += 1
        health += 0.25
        numbers[@x][@y] = newEquation()
        newAnswer()
      else
        @color = 'red'
        setTimeout(revertColor, 300, oldColor)
        health -= 1

  revertColor = (color) ->
    player.color = color

  mainLoop = (canvas) ->
    alive = true
    drawBackground()
    player.draw()
    drawEnemies()
    drawGrid()
    if canvasId == canvas.id
      setTimeout(mainLoop, 1000/60, canvas)
    return


  window.addEventListener 'keyup', ((event) -> Key.onKeyup(event); event.preventDefault(); return false), false
  window.addEventListener 'keydown', ((event) -> Key.onKeydown(event); event.preventDefault(); return false), false

  startGame = ->
    makeNumberGrid()
    canvasId = Math.random().toString()
    oldCanvas = $('#holdsMyGame canvas').remove()
    $('#holdsMyGame').html("<canvas id='#{canvasId}' width=#{oldCanvas[0].width} height=#{oldCanvas[0].height}></canvas>")
    canvas = document.getElementById(canvasId)
    ctx = canvas.getContext("2d")
    canvas.tabIndex = 1
    cooldown = false
    score = 0
    level = 1
    health = 3
    enemies = []
    player = new Player(3,3)
    newAnswer()
    enemyFactory(score)

    setTimeout(moveAllEnemies, frequency, canvas) #is this what's causing the blowup?
    mainLoop(canvas)

  startGame()