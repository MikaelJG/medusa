    -- ANIMATION LIBRARY
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- COLLIDER LIBRARY
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0)

    -- PLAYER
    player = {}
    player.x = 20
    player.y = 400
    player.collider = world:newBSGRectangleCollider(20, 400, 10, 15, 10) -- (x, y, width, height, mass)
    player.collider:setFixedRotation(true)
    player.dir = "down"
    player.radius = 10
    player.life = 10
    player.speed = 70

    player.spriteSheet = love.graphics.newImage("sprites/player-sheet.png")
    player.grid = anim8.newGrid(12, 18, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())

    player.animation = {}
    player.animation.down = anim8.newAnimation(player.grid('1-4', 1), 0.2)
    player.animation.left = anim8.newAnimation(player.grid('1-4', 2), 0.2)
    player.animation.right = anim8.newAnimation(player.grid('1-4', 3), 0.2)
    player.animation.up = anim8.newAnimation(player.grid('1-4', 4), 0.2)

    player.anim = player.animation.down
