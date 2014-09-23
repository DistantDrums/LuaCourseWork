function math.round(num, idp)
      return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end
function love.load()
  love.physics.setMeter(50) --the height of a meter our worlds will be 50px
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with horizontal gravity of 0 and vertical gravity of 0 too
  objects = {} -- table to hold all our physical objects
 
  --let's create a balls
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 100, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball.fixture:setRestitution(1) --let the ball bounce
  objects.ball.body:setLinearDamping(1)
  objects.ball.body:setMass( 0.5 ) --kg

  objects.ball2 = {}
  objects.ball2.body = love.physics.newBody(world, 300, 650/3, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball2.shape = love.physics.newCircleShape(20) --the ball's shape has a radius of 20
  objects.ball2.fixture = love.physics.newFixture(objects.ball2.body, objects.ball2.shape, 1) -- Attach fixture to body and give it a density of 1.
  objects.ball2.fixture:setRestitution(1) --let the ball bounce
  objects.ball2.body:setLinearDamping(1)
  objects.ball2.body:setMass( 0.6 ) --kg

  mode = "HELP"
  --initial graphics setup
  love.graphics.setBackgroundColor(22, 22, 22) --set the background color to a dark gray
  love.window.setMode(650,650)
end
function showHelp()
    love.graphics.setColor(20, 20, 20) 
    love.graphics.rectangle( 'fill', 0, 0, 650, 650 )
    love.graphics.setColor(255, 255, 255) 
    love.graphics.printf("READ IT BEFORE USE PROGRAM!", 100, 100, 300, "center",0,1.5)
    love.graphics.printf("This program is designed to demonstrate the law of conservation of linear momentum and the law of conservation of  mass-energy", 100, 150, 300, "center",0,1.5)
    love.graphics.printf("Use arrows to move red ball", 100, 230, 300, "left",0,1.5)
    love.graphics.printf("Use mouse to apply a force to red ball", 100, 260, 300, "left",0,1.5)
    love.graphics.printf("Use a/z to inc/dec mass of red ball", 100, 290, 300, "left",0,1.5)
    love.graphics.printf("Use s/x to inc/dec mass of green ball", 100, 320, 300, "left",0,1.5)
    love.graphics.printf("Use 9/0 to inc/dec friction on the surface", 100, 350, 300, "left",0,1.5)
    love.graphics.printf("Use SPACE to reset balls", 100, 380, 300, "left",0,1.5)
    love.graphics.printf("Use ESC to exit", 100, 410, 300, "left",0,1.5)
    love.graphics.printf("Use h to close this manual or open it again", 100, 440, 300, "left",0,1.5)
end
function love.keypressed(key)
       if key == "a" then
            objects.ball.body:setMass( objects.ball.body:getMass() + 0.1 ) --kg
       elseif key == "z" then
            objects.ball.body:setMass( objects.ball.body:getMass() - 0.1 ) --kg
       elseif key == "s" then
            objects.ball2.body:setMass( objects.ball2.body:getMass() + 0.1 ) --kg
       elseif key == "x" then
            objects.ball2.body:setMass( objects.ball2.body:getMass() - 0.1 ) --kg
       elseif key == "h" then
           if mode=="HELP" then mode = "SHOW" else mode = "HELP" end
       elseif key == "9" then
            objects.ball.body:setLinearDamping( objects.ball.body:getLinearDamping()-0.1)
            objects.ball2.body:setLinearDamping( objects.ball2.body:getLinearDamping()-0.1)
       elseif key == "0" then
            objects.ball.body:setLinearDamping( objects.ball.body:getLinearDamping()+0.1)
            objects.ball2.body:setLinearDamping( objects.ball2.body:getLinearDamping()+0.1)
       elseif key == " " then
            objects.ball.body:setLinearVelocity( 0, 0 )
            objects.ball.body:setPosition( 650/2-200, 650/2 )
            objects.ball2.body:setLinearVelocity( 0, 0 )
            objects.ball2.body:setPosition( 650/2, 650/2 )
       elseif key == "escape" then
            love.event.quit()
        end

end
function love.update(dt)
  world:update(dt) --this puts the world into motion
 
  --here we are going to create some keyboard events
  if love.keyboard.isDown("right") then --press the right arrow key to push the ball to the right
    local dx,dy =  objects.ball.body:getPosition() 
    objects.ball.body:setPosition(dx +1,dy)
  elseif love.keyboard.isDown("left") then --press the left arrow key to push the ball to the left
    local dx,dy =  objects.ball.body:getPosition() 
    objects.ball.body:setPosition(dx - 1,dy)
  elseif love.keyboard.isDown("up") then --press the left arrow key to push the ball to the left
    local dx,dy =  objects.ball.body:getPosition() 
    objects.ball.body:setPosition(dx,dy-1)
  elseif love.keyboard.isDown("down") then --press the left arrow key to push the ball to the left
    local dx,dy =  objects.ball.body:getPosition() 
    objects.ball.body:setPosition(dx,dy+1)
  end
  distance, x1, y1, x2, y2 = love.physics.getDistance( objects.ball.fixture, objects.ball2.fixture )
end

function love.mousereleased(mx, my, button)
  if button == "l" then
    fx,fy = mx-objects.ball.body:getX(), my-objects.ball.body:getY()
    objects.ball.body:applyForce(50*fx,50*fy)
  end
end
function love.draw()
  if mode=="HELP" then
    showHelp()
  else
  love.graphics.setColor(100, 100, 100) --set the drawing color to red for the ball
  for i = 0,650,50 do
      love.graphics.line(0,i,650,i)
      love.graphics.line(i,0,i,650)
  end
  love.graphics.setColor(50, 50, 50) --set the drawing color to red for the ball
  for i = 0,650,10 do
      love.graphics.line(0,i,650,i)
      love.graphics.line(i,0,i,650)
  end
  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  x,y = objects.ball.body:getX(), objects.ball.body:getY()
  mass = math.round(objects.ball.body:getMass(),1)
  love.graphics.circle("fill", x, y, objects.ball.shape:getRadius())
  vx,vy = objects.ball.body:getLinearVelocity( )
  v = math.sqrt(vx*vx+vy*vy)


  if love.mouse.isDown("l") then
      love.graphics.setColor(255, 255, 255) --set the drawing color to red for the ball
      love.graphics.line(x1,y1,x2,y2)
      love.graphics.line(0,y,650,y)
      love.graphics.line(x,y,love.mouse.getX(),love.mouse.getY())
      mx,my = love.mouse.getPosition( )
  
  love.graphics.print(-(math.round(math.atan2(y1-y2,x1-x2)*180/math.pi)-180),600,10)
  love.graphics.print(-(math.round(math.atan2(y-my,x-mx)*180/math.pi)-180),600,25)
  love.graphics.print("Force/50: "..math.round(mx-x)..','..math.round(my-y),500,40)
  end
   
  love.graphics.setColor(255, 255, 255) --set the drawing color to red for the ball
  love.graphics.print("LD: "..math.round(objects.ball2.body:getLinearDamping(),1),600,50)
  love.graphics.setColor(193, 47, 14) --set the drawing color to red for the ball
  love.graphics.print("X: "..math.floor(x).."    Vx: "..math.floor(vx), 10,10)
  love.graphics.print("Y: "..math.floor(y).."    Vy: "..math.floor(vy), 10,25)
  love.graphics.print("T: "..math.round(mass*v*v/2,1),200,10)
  love.graphics.print("P: "..math.round(mass*v,1),200,40)
  love.graphics.setColor(255, 255, 255) 
  love.graphics.circle("fill", x, y, objects.ball.shape:getRadius()-5)
  love.graphics.setColor(0, 0, 0) 
  love.graphics.print(mass,x-10,y-10)

  love.graphics.setColor(47, 193, 14) --set the drawing color to red for the ball
  x,y = objects.ball2.body:getX(), objects.ball2.body:getY()
  mass = math.round(objects.ball2.body:getMass(),1)
  love.graphics.circle("fill", x, y, objects.ball2.shape:getRadius())
  vx,vy = objects.ball2.body:getLinearVelocity( )
  v = math.sqrt(vx*vx+vy*vy)
  love.graphics.print("X: "..math.floor(x).."    Vx: "..math.floor(vx), 10,40)
  love.graphics.print("Y: "..math.floor(x).."    Vy: "..math.floor(vy), 10,55)
  love.graphics.print("T: "..math.round(mass*v*v/2,1),200,25)
  love.graphics.print("T: "..math.round(mass*v,1),200,55)
  love.graphics.setColor(255, 255, 255) 
  love.graphics.circle("fill", x, y, objects.ball2.shape:getRadius()-5)
  love.graphics.setColor(0, 0, 0) 
  love.graphics.print(mass,x-10,y-10)

  end
end
