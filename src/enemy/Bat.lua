anim8 = require 'libraries/anim8'

-- BAT
bat = {}
bat.x = 200
bat.y = 100
bat.spriteSheet = love.graphics.newImage("sprites/bat-spritesheet.png")
bat.grid = anim8.newGrid(16, 16, bat.spriteSheet:getWidth(), bat.spriteSheet:getHeight())

bat.animation = {}
bat.animation.right = anim8.newAnimation(bat.grid('1-4', 1), 0.2)

bat.anim = bat.animation.right
