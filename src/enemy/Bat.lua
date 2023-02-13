anim8 = require 'libraries/anim8'

-- BAT ENEMY
bats = {}

for i = 1, 10 do
  bat = {}
  bat.x = love.math.random(0, 800)
  bat.y = love.math.random(0, 800)
  bat.life = 10
  bat.speed = 20
  bat.alive = true
  -- bat.collider = world:newBSGRectangleCollider(bat.x, bat.y, 22, 33, 20) -- (x, y, width, height, mass)
  -- bat.collider:setFixedRotation(true)
  bat.spriteSheet = love.graphics.newImage("sprites/bat-spritesheet.png")
  bat.grid = anim8.newGrid(16, 16, bat.spriteSheet:getWidth(), bat.spriteSheet:getHeight())

  bat.animation = {}
  bat.animation.right = anim8.newAnimation(bat.grid('1-4', 1), 0.2)

  bat.anim = bat.animation.right

  table.insert(bats, i, bat)
end
