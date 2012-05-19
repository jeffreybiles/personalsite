var lightseeker = function() {
  var Asteroid, Circle, Goal, Key, Triangle, alive, asteroidAcc, asteroidDecel, asteroidFactory, asteroids, bounding, canvas, canvasId, ctx, drawBackground, findDistance, gameMode, gameOver, goalPost, health, level, mainLoop, rand, shipAcc, shipDecel, spin, startGame, text, withinRadius;

  shipAcc = 0.2;

  asteroidAcc = 0.4;

  shipDecel = 0.96;

  asteroidDecel = 0.9;

  spin = 0.1;

  level = 1;

  health = 5;

  alive = true;

  canvas = document.getElementById("myCanvas");

  canvasId = "myCanvas";

  ctx = canvas.getContext("2d");

  asteroids = [];

  gameOver = false;

  gameMode = 'normal';

  goalPost = "";

  withinRadius = function(object1, object2) {
    var dist1, dist2;
    if (object1.radius) {
      dist1 = object1.radius;
    } else if (object1.width) {
      dist1 = object1.width / 2;
    } else {
      return false;
    }
    if (object2.radius) {
      dist2 = object2.radius;
    } else if (object2.width) {
      dist2 = object2.width / 2;
    } else {
      return false;
    }
    if (findDistance(object1, object2) < dist1 + dist2) {
      return true;
    } else {
      return false;
    }
  };

  findDistance = function(object1, object2) {
    var distance, dx, dy;
    dx = object1.x - object2.x;
    dy = object1.y - object2.y;
    return distance = Math.sqrt(Math.pow(dx, 2) + Math.pow(dy, 2));
  };

  bounding = function(object) {
    var margin;
    if (object.wrap) {
      if (object.x < 0) object.x += canvas.width;
      if (object.x > canvas.width) object.x -= canvas.width;
      if (object.y < 0) object.y += canvas.height;
      if (object.y > canvas.height) object.y -= canvas.height;
    } else {
      margin = 10;
      if (object.x < margin) object.x = margin;
      if (object.x > canvas.width - margin) object.x = canvas.width - margin;
      if (object.y < margin) object.y = margin;
      if (object.y > canvas.height - margin) object.y = canvas.height - margin;
    }
  };

  Key = {
    _pressed: {},
    LEFT: 37,
    UP: 38,
    RIGHT: 39,
    DOWN: 40,
    isDown: function(keyCode) {
      return this._pressed[keyCode];
    },
    onKeydown: function(event) {
      return this._pressed[event.keyCode] = true;
    },
    onKeyup: function(event) {
      return delete this._pressed[event.keyCode];
    }
  };

  rand = function(max, min) {
    if (min == null) min = 0;
    return Math.floor(Math.random() * (max - min) + min);
  };

  text = function(text, x, y, color, size, style) {
    if (color == null) color = '#000';
    if (size == null) size = 18;
    if (style == null) style = 'sans-serif';
    ctx.fillStyle = color;
    ctx.font = "bold " + size + "px " + style;
    ctx.textBaseline = 'bottom';
    ctx.fillText(text, x, y);
  };

  drawBackground = function() {
    var color;
    if (health > 10) health = 10;
    if (health <= 0) gameOver = true;
    color = health * 25 + 5;
    if (color > 255) color = 255;
    if (color < 0) gameOver = true;
    ctx.fillStyle = "rgb(" + color + "," + color + "," + color + ")";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    text(gameMode, 10, 590);
  };

  Circle = function(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.dx = 0;
    this.dy = 0;
    this.wrap = true;
  };

  Circle.prototype.draw = function() {
    var radGrad, radius, shadowX, shadowY, x, y;
    x = this.x;
    y = this.y;
    radius = this.radius;
    if (this.danger) {
      shadowX = (goalPost.x - x) * radius / canvas.width;
      shadowY = (goalPost.y - y) * radius / canvas.height;
      radGrad = ctx.createRadialGradient(x + shadowX * 0.8, y + shadowY * 0.8, radius * 0.1, x, y, radius * 0.9);
      radGrad.addColorStop(0, "grey");
      radGrad.addColorStop(0.2, "grey");
      radGrad.addColorStop(1, "black");
    } else {
      radGrad = ctx.createRadialGradient(x, y, radius * 0.1, x, y, radius * 0.9);
      radGrad.addColorStop(0, "white");
      radGrad.addColorStop(0.2, "white");
      radGrad.addColorStop(1, "grey");
    }
    ctx.fillStyle = radGrad;
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, Math.PI * 2, false);
    if (this.danger) {
      ctx.arc(x - shadowX * 2, y - shadowY * 2, radius, 0, Math.PI * 2, false);
    }
    if ((gameMode !== 'spook' && gameMode !== 'hardSpook') || this.danger) {
      ctx.fill();
    }
  };

  Circle.prototype.update = function() {
    if (gameMode === 'normal' || gameMode === 'spook') {
      if (Key.isDown(Key.UP)) this.dy -= asteroidAcc;
      if (Key.isDown(Key.DOWN)) this.dy += asteroidAcc;
    } else {
      this.dy -= asteroidAcc;
    }
    if (Key.isDown(Key.LEFT)) this.dx -= asteroidAcc;
    if (Key.isDown(Key.RIGHT)) this.dx += asteroidAcc;
    this.dy *= asteroidDecel;
    this.dx *= asteroidDecel;
  };

  Circle.prototype.move = function() {
    if (this.x < 0) this.x += canvas.width;
    if (this.x > canvas.width) this.x -= canvas.width;
    if (this.y < 0) this.y += canvas.height;
    if (this.y > canvas.height) this.y -= canvas.height;
    this.x += this.dx;
    this.y += this.dy;
  };

  Circle.prototype.bounding = function() {
    return bounding(this);
  };

  Triangle = function(x, y, angle, height, width) {
    if (height == null) height = 30;
    if (width == null) width = 20;
    this.x = x;
    this.y = y;
    this.angle = angle;
    this.height = height;
    this.width = width;
    return this.speed = 0;
  };

  Triangle.prototype.draw = function() {
    var angle, height, leftPoint, rightPoint, toSide, toTop, topPoint, width, x, y;
    x = this.x;
    y = this.y;
    angle = this.angle;
    height = this.height;
    width = this.width;
    toTop = [Math.cos(angle) * height / 2, Math.sin(angle) * height / 2];
    toSide = [Math.cos(angle + Math.PI / 2) * width / 2, Math.sin(angle + Math.PI / 2) * width / 2];
    topPoint = [x + toTop[0], y + toTop[1]];
    leftPoint = [x + toSide[0] - toTop[0], y + toSide[1] - toTop[1]];
    rightPoint = [x - toSide[0] - toTop[0], y - toSide[1] - toTop[1]];
    ctx.fillStyle = "black";
    ctx.beginPath();
    ctx.moveTo(topPoint[0], topPoint[1]);
    ctx.lineTo(leftPoint[0], leftPoint[1]);
    ctx.lineTo(rightPoint[0], rightPoint[1]);
    ctx.moveTo(topPoint[0], topPoint[1]);
    ctx.fill();
  };

  Triangle.prototype.update = function() {
    if (gameMode === 'normal' || gameMode === 'spook') {
      if (Key.isDown(Key.UP)) this.speed += shipAcc;
      if (Key.isDown(Key.DOWN)) this.speed -= shipAcc / 2;
    } else {
      this.speed += shipAcc;
    }
    if (Key.isDown(Key.LEFT)) this.angle -= spin;
    if (Key.isDown(Key.RIGHT)) this.angle += spin;
    this.speed *= shipDecel;
  };

  Triangle.prototype.move = function() {
    var asteroid, _i, _len;
    this.bounding();
    for (_i = 0, _len = asteroids.length; _i < _len; _i++) {
      asteroid = asteroids[_i];
      this.detectCollision(asteroid);
    }
    this.x += this.speed * Math.cos(this.angle);
    this.y += this.speed * Math.sin(this.angle);
  };

  Triangle.prototype.detectCollision = function(object) {
    if (object.danger && withinRadius(this, object)) {
      health -= 1;
      alive = false;
    }
    if (object.goal && withinRadius(this, object)) {
      health += 1;
      level += 1;
      alive = false;
    }
  };

  Triangle.prototype.bounding = function() {
    return bounding(this);
  };

  Asteroid = function(x, y, radius) {
    this.x = x;
    this.y = y;
    return this.radius = radius;
  };

  Asteroid.prototype = new Circle();

  Asteroid.prototype.danger = true;

  asteroidFactory = function(num) {
    var i;
    for (i = 1; 1 <= num ? i <= num : i >= num; 1 <= num ? i++ : i--) {
      asteroids.push(new Asteroid(rand(canvas.width), rand(canvas.height), 10));
    }
  };

  Goal = function(x, y, radius) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    return this.goal = true;
  };

  Goal.prototype = new Circle();

  Goal.prototype.move = function() {};

  mainLoop = function(things, canvas) {
    var thing, thing2, thingy, _i, _j, _k, _len, _len2, _len3;
    alive = true;
    drawBackground();
    for (_i = 0, _len = things.length; _i < _len; _i++) {
      thing = things[_i];
      thing.draw();
    }
    for (_j = 0, _len2 = things.length; _j < _len2; _j++) {
      thingy = things[_j];
      thingy.move();
    }
    for (_k = 0, _len3 = things.length; _k < _len3; _k++) {
      thing2 = things[_k];
      thing2.update();
    }
    if (canvasId === canvas.id) {
      if (alive && gameOver === false) {
        setTimeout(mainLoop, 1000 / 60, things, canvas);
      } else if (gameOver === false) {
        startGame(gameMode);
      } else {
        level = 1;
        health = 5;
        gameOver = false;
        startGame(gameMode);
      }
    }
  };

  window.addEventListener('keyup', (function(event) {
    Key.onKeyup(event);
    event.preventDefault();
    return false;
  }), false);

  window.addEventListener('keydown', (function(event) {
    Key.onKeydown(event);
    event.preventDefault();
    return false;
  }), false);

  startGame = function(mode) {
    var oldCanvas, spaceship;
    if (mode == null) mode = 'normal';
    canvasId = Math.random().toString();
    oldCanvas = $('#holdsMyGame canvas').remove();
    $('#holdsMyGame').html("<canvas id='" + canvasId + "' width=" + oldCanvas[0].width + " height=" + oldCanvas[0].height + "></canvas>");
    canvas = document.getElementById(canvasId);
    ctx = canvas.getContext("2d");
    canvas.tabIndex = 1;
    gameMode = mode;
    asteroids = [];
    if (gameMode === 'spook' || gameMode === 'hardSpook') {
      goalPost = new Goal(canvas.width * Math.random(), canvas.height * Math.random(), 80);
    } else {
      goalPost = new Goal(canvas.width * 0.9, canvas.height * 0.9, 50);
    }
    asteroids.push(goalPost);
    if (gameMode === 'spook') {
      asteroidFactory((level + 2) * 3);
    } else {
      asteroidFactory(level * 3);
    }
    spaceship = new Triangle(20, 20, 0);
    mainLoop(Array.prototype.concat.apply([], [spaceship, asteroids]), canvas);
  };

  jQuery(function($) {
    $('#hardMode').click(function() {
      level = 1;
      startGame('hard');
      shipAcc = 0.2;
      asteroidDecel = 0.85;
    });
    $('#normalMode').click(function() {
      level = 1;
      shipAcc = 0.2;
      startGame('normal');
      asteroidDecel = 0.9;
    });
    $('#insaneMode').click(function() {
      level = 1;
      startGame('insane');
      shipAcc = 0.27;
      asteroidDecel = 0.94;
    });
    $('#spookMode').click(function() {
      level = 1;
      startGame('spook');
      shipAcc = 0.2;
      asteroidDecel = 0.9;
    });
    return $('#hardSpookMode').click(function() {
      level = 1;
      startGame('hardSpook');
      shipAcc = 0.2;
      return asteroidDecel = 0.8;
    });
  });

  startGame();

  window.api = {
    startGame: startGame
  };

}
