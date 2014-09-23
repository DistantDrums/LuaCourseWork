function love.load()
  width = 300
  height = 600

  --initial graphics setup
  love.window.setMode(width, height)
  love.graphics.setBackgroundColor(34, 34, 34) --set the background color to a nice blue


  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 9.81*64, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 9.81

  objects = {} -- table to hold all our physical objects
 
  --let's create the ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(world, width/2, height-20/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(width, 20) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape); --attach shape to body

  --let's create the ceil
  objects.ceil = {}
  objects.ceil.body = love.physics.newBody(world, width/2, 20/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ceil.shape = love.physics.newRectangleShape(width, 20) --make a rectangle with a width of 650 and a height of 50
  objects.ceil.fixture = love.physics.newFixture(objects.ceil.body, objects.ceil.shape); --attach shape to body

  --let's create the walls
  objects.left_wall = {}
  objects.left_wall.body = love.physics.newBody(world, 20/2, height/2) 
  objects.left_wall.shape = love.physics.newRectangleShape(20, height) --make a rectangle with a width of 650 and a height of 50
  objects.left_wall.fixture = love.physics.newFixture(objects.left_wall.body, objects.left_wall.shape); --attach shape to body

  objects.right_wall = {}
  objects.right_wall.body = love.physics.newBody(world, width-20/2, height/2) 
  objects.right_wall.shape = love.physics.newRectangleShape(20, height) --make a rectangle with a width of 650 and a height of 50
  objects.right_wall.fixture = love.physics.newFixture(objects.right_wall.body, objects.right_wall.shape); --attach shape to body
  --Lets create cells
  --
  objects.cells = {}
  objects.cells.N = 13-1
  for i=1, objects.cells.N do
          objects.cells[i] = {}
          objects.cells[i].body = love.physics.newBody(world, 20+(i)*20 , height-50) 
          objects.cells[i].shape = love.physics.newRectangleShape(1,60) 
          objects.cells[i].fixture = love.physics.newFixture(objects.cells[i].body, objects.cells[i].shape); --attach shape to body
  end

  --Lets create a barriers
  objects.barriers = {}

  --TODO:Написать распределение барьеров 
  objects.barriers.N = 1 -- the number of the barriers in line
  objects.barriers.M = 5 -- the number of the barriers-lines
  objects.barriers.R = 3 -- the radius of the barriers
  function make_line(h,s) -- высота h смещение s
  for i=objects.barriers.N, objects.barriers.N+13 do
          objects.barriers[i] = {}
          objects.barriers[i].body = love.physics.newBody(world, 25+s +(i-objects.barriers.N)*20 , h) 
          objects.barriers[i].shape = love.physics.newCircleShape(objects.barriers.R) 
          objects.barriers[i].fixture = love.physics.newFixture(objects.barriers[i].body, objects.barriers[i].shape); --attach shape to body
  end
  objects.barriers.N=objects.barriers.N+13
  end
  for i=0,100,30 do
      make_line(height/2+i,0)
      make_line(height/2+i+15,10)
  end

  --let's create a balls
  objects.balls = {}
  objects.balls.N = 100 -- the number of the balls
  for i=1,objects.balls.N do
      objects.balls[i] = {}
      objects.balls[i].body = love.physics.newBody(world, width/2+math.random(i), height/2+math.random(i), "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
      objects.balls[i].shape = love.physics.newCircleShape(3) --the ball's shape has a radius of 20
      objects.balls[i].fixture = love.physics.newFixture(objects.balls[i].body, objects.balls[i].shape, 1) -- Attach fixture to body and give it a density of 1.
      objects.balls[i].fixture:setRestitution(0.5) --let the ball bounce
  end
end

function createBall(x,y)
    objects.balls.N = objects.balls.N + 1
      objects.balls[objects.balls.N] = {}
      objects.balls[objects.balls.N].body = love.physics.newBody(world, x, y, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
      objects.balls[objects.balls.N].shape = love.physics.newCircleShape(3) --the ball's shape has a radius of 20
      objects.balls[objects.balls.N].fixture = love.physics.newFixture(objects.balls[objects.balls.N].body, objects.balls[objects.balls.N].shape, 1) -- Attach fixture to body and give it a density of 1.
      objects.balls[objects.balls.N].fixture:setRestitution(0.5) --let the ball bounce
end

function love.mousepressed(x, y, button)
   if button == "l" then
     createBall(x,y) 
   end
end

function love.update(dt)
  world:update(dt) --this puts the world into motion
if love.mouse.isDown("r") then
     createBall(love.mouse.getX(),love.mouse.getY())
    end 
end

function love.draw()

  --Lets draw a barriers 
  love.graphics.setColor(72, 160, 14) 
    for i=1,objects.barriers.N do
        love.graphics.circle("line", objects.barriers[i].body:getX(), objects.barriers[i].body:getY(), objects.barriers[i].shape:getRadius())
    end
    for i=1,objects.cells.N do
      love.graphics.polygon("line", objects.cells[i].body:getWorldPoints(objects.cells[i].shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
    end


 love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
    for i=1,objects.balls.N do
        love.graphics.circle("fill", objects.balls[i].body:getX(), objects.balls[i].body:getY(), objects.balls[i].shape:getRadius())
    end
  love.graphics.setColor(72, 160, 14) 
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.ceil.body:getWorldPoints(objects.ceil.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.left_wall.body:getWorldPoints(objects.left_wall.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates
  love.graphics.polygon("fill", objects.right_wall.body:getWorldPoints(objects.right_wall.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(200, 200, 200) 
   love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 10, 10)
   love.graphics.print("Balls: "..tostring(objects.balls.N), 10, 20)
end
