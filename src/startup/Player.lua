
    anim8 = require 'libraries/anim8'

    -- PLAYER
    player = {}
    player.x = 400
    player.y = 200
    player.dir = "down"
    player.radius = 2
    player.speed = 1

    player.spriteSheet = love.graphics.newImage("sprites/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animation.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animation.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animation.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animation.up
