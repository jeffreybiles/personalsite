@vengeance = ->
  acc = 0.6
  decel = 0.9
  asteroidSpeed = 1.5
  asteroidDecel = 0.97
  health = 100
  alive = true
  canvas = document.getElementById("myCanvas")
  canvasId = "myCanvas"
  ctx = canvas.getContext("2d")
  gameOver = false
  gameMode = 'normal'
  player = ""
  projectiles = []
  currentMousePos = {x: -1, y: -1}
  friendly = false
  dedicated = false

  currentAsteroids = 2
  maxAsteroids = 2

  level = 1
  myBulletSpeed = 3.5
  theirBulletSpeed = 1.5
  chanceShoot = 0.01
  seeking = 0.3

  first = true


  withinRadius = (object1, object2) ->
    if object1.radius
      dist1 = object1.radius
    else if object1.width
      dist1 = object1.width/2
    else
      return false
    if object2.radius
      dist2 = object2.radius
    else if object2.width
      dist2 = object2.width/2
    else
      return false
    if findDistance(object1, object2) < dist1 + dist2
      true
    else
      false

  findDistance = (object1, object2) ->
    if object1.x == object2.x && object1.y == object2.y
      return 2000
    else
      dx = object1.x - object2.x
      dy = object1.y - object2.y
      return Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2))

  vengeance = ->
    (1 - currentAsteroids/maxAsteroids)

  #bounding = (margin = 5) ->
  #  if this.loop
  #    if this.x < 0 then this.x += canvas.width
  #    if this.x > canvas.width then this.x -= canvas.width
  #    if this.y < 0 then this.y += canvas.height
  #    if this.y > canvas.height then this.y -= canvas.height
  #  else if this.stay || this.bounce
  #    if this.bounce
  #      if this.x < margin || this.x > canvas.width - margin
  #        this.dx *= -1
  #      if this.y < margin || this.y > canvas.height - margin
  #        this.dy *= -1
  #    if this.x < margin then this.x = margin
  #    if this.x > canvas.width - margin then this.x = canvas.width - margin
  #    if this.y < margin then this.y = margin
  #    if this.y > canvas.height - margin then this.y = canvas.height - margin
  #  return


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

    isDown: (keyCode) ->
      this._pressed[keyCode]
    onKeydown: (event) ->
      this._pressed[event.keyCode] = true
    onKeyup: (event) ->
      delete this._pressed[event.keyCode]


  rand = (max, min = 0) ->
    Math.floor(Math.random()*(max - min) + min)

  text = (text, x, y, color = '#000', size = 18, style = 'sans-serif')->
    ctx.fillStyle = color
    ctx.font = "bold #{size}px #{style}"
    ctx.textBaseline = 'bottom'
    ctx.fillText(text, x, y)
    return

  asteroidsLeft = ->
    num = 0
    (num += 1 if projectile.asteroid) for projectile in projectiles
    num

  drawBackground = ->
    if health <= 0 then startGame()
    color = 128
    ctx.fillStyle = "rgb(#{color},#{color},#{color})"
    ctx.fillRect(0,0,canvas.width,canvas.height)
    numAsteroids = asteroidsLeft()
    text(gameMode, 10, 30)
    if dedicated
      text("dedicated", 10, 50)
    else
      text("citizens", 10, 50)
    if numAsteroids == 0
      level += 1
      startGame(gameMode)
    else
      text(numAsteroids, 10, 590)
    return

  getMousePos = (event) ->
    shootBullet()
  #  tat()

  shootBullet = ->
    x = currentMousePos.x
    y = currentMousePos.y
    x -= canvas.offsetLeft;
    y -= canvas.offsetTop;
    thisBullet = new Bullet(x, y, player)
    thisBullet.mine = true
    projectiles.push(thisBullet)

  revengeBullet = (asteroid) ->
    if gameMode == 'normal'
      thisBullet = new Bullet(9*player.x/10 + rand(player.x/5), 9*player.y/10 + rand(player.y/5), asteroid, theirBulletSpeed)
    else if gameMode == 'feud'
      thisBullet = new Bullet(3*player.x/4 + rand(player.x/2), 3*player.y/4 + rand(player.y/2), asteroid, theirBulletSpeed)
    else if gameMode == 'occupation'
      thisBullet = new Bullet(player.x/2 + rand(player.x), player.y/2 + rand(player.y), asteroid, theirBulletSpeed)
    thisBullet.mine = false
    projectiles.push(thisBullet)

  tat = ->
    (revengeBullet(asteroid) if asteroid.asteroid && Math.random() < tatChance) for asteroid in projectiles

  collided = (thisObj, otherObj) ->
    if withinRadius(thisObj, otherObj) && otherObj.danger
      if thisObj.isPlayer && health > 0
        health -= 60
        if health < 0
          return true
        else return false
      else return true
    else return false

  detectCollisions = (index, allObjects, skip = []) ->
    i = index
    collisions = null
    thisObject = allObjects[i]
    i++
    while collisions == null && i < allObjects.length
      if (i not in skip) && collided(thisObject, allObjects[i])
        return i
      else
        i++
    null


  class Circle
    constructor: (@x, @y, @radius) ->
      this.dx = 0
      this.dy = 0
      this.bounce = true
      this.danger = true
      this.alive = true
      return

    move: ->
      this.x += this.dx;
      this.y += this.dy;
      margin = 5
      if this.loop
        if this.x < 0 then this.x += canvas.width
        if this.x > canvas.width then this.x -= canvas.width
        if this.y < 0 then this.y += canvas.height
        if this.y > canvas.height then this.y -= canvas.height
      else if this.stay || this.bounce
        if this.bounce
          if this.x < margin || this.x > canvas.width - margin
            this.dx *= -1
          if this.y < margin || this.y > canvas.height - margin
            this.dy *= -1
        if this.x < margin then this.x = margin
        if this.x > canvas.width - margin then this.x = canvas.width - margin
        if this.y < margin then this.y = margin
        if this.y > canvas.height - margin then this.y = canvas.height - margin
      return

    draw: (fillStyle = 'white', shadow = false) ->
      x = this.x
      y = this.y
      radius = this.radius
      ctx.fillStyle = fillStyle;
      ctx.beginPath()
      ctx.arc(x,y, radius, 0, Math.PI * 2, false);
      if shadow
        ctx.arc(x - shadowX*2, y - shadowY*2, radius, 0, Math.PI *2, false)
      ctx.fill() unless this.invisible
      return

    update: ->
      this.x += this.dx
      this.y += this.dy
      return

  class Asteroid extends Circle
    constructor: (@x, @y, @radius = 13) ->
      this.dx = Math.random() * asteroidSpeed
      this.dy = Math.random() * asteroidSpeed
      this.bounce = true
      this.danger = true
      this.asteroid = true

    draw: ->
      if Math.random() < chanceShoot*vengeance()
        revengeBullet(this)
      super "#614E3D"
      return

    move: ->
      if dedicated
        this.dx += (player.x - this.x)*0.001*seeking*vengeance()*Math.random()
        this.dy += (player.y - this.y)*0.001*seeking*vengeance()*Math.random()
        this.dx *= asteroidDecel
        this.dy *= asteroidDecel
      else
        this.x += (player.x - this.x)*seeking*vengeance()*(0.05 + Math.random()*0.05)
        this.y += (player.y - this.y)*seeking*vengeance()*(0.05 + Math.random()*0.05)
      super



  asteroidFactory = (num) ->
    for i in [1..Math.floor(num)]
      newAsteroid = new Asteroid(10, rand(canvas.height))
      projectiles.push(newAsteroid)
    return

  class Bullet extends Circle
    constructor: (xclick, yclick, origin = player, bulletSpeed = myBulletSpeed, radius = 3) ->
      xdistance = xclick - origin.x
      ydistance = yclick - origin.y
      angle = Math.atan(ydistance/xdistance)
      if xdistance > 0 then multiplier = 1 else multiplier = -1
      this.dx = bulletSpeed*Math.cos(angle)*multiplier
      this.dy = bulletSpeed*Math.sin(angle)*multiplier
      this.x = Math.floor(origin.x + (origin.radius + radius + 2)*Math.cos(angle)*multiplier)
      this.y = Math.floor(origin.y + (origin.radius + radius + 2)*Math.sin(angle)*multiplier)
      this.bounce = false
      this.radius = radius
      this.bullet = true

      this.danger = true

    draw: -> super '#2B241D'

  class Player extends Circle
    constructor: (@x = canvas.width/2, @y = canvas.height/2, @radius = 10, @health = 100) ->
      this.bounce = true
      this.danger = true
      this.dx = 0
      this.dy = 0
      this.isPlayer = true

    update: ->
      if (Key.isDown(Key.UP) || Key.isDown(Key.W)) then this.dy -= acc
      if (Key.isDown(Key.DOWN) || Key.isDown(Key.S)) then this.dy += acc
      if (Key.isDown(Key.LEFT) || Key.isDown(Key.A)) then this.dx -= acc
      if (Key.isDown(Key.RIGHT) || Key.isDown(Key.D)) then this.dx += acc
      this.dy *= decel
      this.dx *= decel
      return

    draw: -> super '#B5A18F'


  mainLoop = (canvas) ->
    if alive
      window.requestAnimationFrame(mainLoop, canvas)
    else
      startGame(gameMode)
    alive = true
    drawBackground()
    thing.draw() for thing in projectiles
    thingy.move() for thingy in projectiles
    thing2.update() for thing2 in projectiles
    i = 0
    skip = []
    while i < projectiles.length
      collidedWith = detectCollisions(i, projectiles, skip)
      skip.push(collidedWith)

      if collidedWith
        if !(projectiles[collidedWith].asteroid && projectiles[i].asteroid)
          if (projectiles[i].asteroid && projectiles[collidedWith].mine) ||
          (projectiles[collidedWith].asteroid && projectiles[i].mine)
            projectiles.splice(collidedWith, 1)
            projectiles.splice(i, 1)
            currentAsteroids = asteroidsLeft()
      else i++
    spliceBullets();
    return

  spliceBullets = ->
    i = 0
    while i < projectiles.length
      shot = projectiles[i]
      if shot.bullet && (shot.x < 0 || shot.x > canvas.width || shot.y < 0 || shot.y > canvas.height)
        projectiles.splice(i, 1)
      else
        i++
  window.addEventListener 'keyup', ((event) -> Key.onKeyup(event); event.preventDefault(); return false), false
  window.addEventListener 'keydown', ((event) -> Key.onKeydown(event); event.preventDefault(); return false), false

  startGame = (mode = gameMode) ->
    console.log("starting the game!")
    canvasId = Math.random().toString()
    oldCanvas = $('#holdsMyGame canvas').remove()
    $('#holdsMyGame').html("<canvas id='#{canvasId}' width=#{oldCanvas[0].width} height=#{oldCanvas[0].height}></canvas>")
    canvas = document.getElementById(canvasId)
    ctx = canvas.getContext("2d")
    canvas.tabIndex = 1
    gameMode = mode
    projectiles.length = 0
    player = new Player()
    projectiles.push(player)
    asteroidFactory(level + Math.pow(level, 1.8))
    health = 100 + 10*level
    currentAsteroids = asteroidsLeft()
    maxAsteroids = asteroidsLeft()
    console.log("About to call main loop")
    if first
      first = false
      mainLoop(canvas)
    return


  jQuery ($) ->
    $('#normal').click ->
      level = 1
      myBulletSpeed = 3.5
      theirBulletSpeed = 1.5
      chanceShoot = 0.01
      seeking = 0.3
      startGame('normal')
      return

    $('#feud').click ->
      level = 1
      myBulletSpeed = 4
      theirBulletSpeed = 3
      chanceShoot = 0.04
      seeking = 0.8
      startGame('feud')
      return

    $('#occupation').click ->
      level = 1
      myBulletSpeed = 4
      theirBulletSpeed = 1.2
      chanceShoot = 0.1
      seeking = 0.4
      startGame('occupation')
      return

    $(document).mousemove (event) ->
      currentMousePos = {
      x: event.pageX,
      y: event.pageY
      }

    $('#dedicated').click ->
      level = 1
      dedicated = true
      startGame()

    $('#citizen-soldier').click ->
      level = 1
      dedicated = false
      startGame()

  console.log("About to start the game!")
  $(document).mousedown(getMousePos)
  startGame(gameMode)

  window.api = {
  startGame: startGame
  }
