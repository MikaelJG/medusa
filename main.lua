local love = require "love"

-- local Player = require "objects/Player"
local Enemy = require "src/enemy/Enemy"
local Game = require "src/startup/Game" -- importing game object
local Menu = require "src/startup/Menu" -- importing menu object

math.randomseed(os.time())

local enemies = {}

function love.load()

    -- a require stategy
    -- at gameStart, call a requireAll function in gameStart.lua
    require ("src/startup")
    gameStart() 
        
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- PLAYER
    player = {}
    player.x = 400
    player.y = 200
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

    -- ATTACK
    attack = {}
    attack.spriteSheet = love.graphics.newImage("sprites/slash-effect-right.png")

    attack.grid = anim8.newGrid(16, 16, attack.spriteSheet:getWidth(), attack.spriteSheet:getHeight())

    attack.animation = {}

    attack.animation.right = anim8.newAnimation(attack.grid('1-3', 1), 0.2)

    attack.anim = attack.animation.right


    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0

    game = Game()
    -- player = Player()
    menu = Menu(game) -- Create a menu object
    -- when the game starts insert an enemy in empty table ennemies
    table.insert(enemies, 1, Enemy())
end


-- KEYBINDINGS [ START ]--
function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" then -- for number pad keys (then keys keyboards)  or key == "kp8" then
            -- medusa action on up key
            player.walking = true
        end

        if key == "space" or key == "down" then -- for numero pad keys (ten keys keyboards) or key == "kp5" then
            -- medusa action on space key
            -- medusa:shootLazer()
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end

function love.keyreleased(key)
    if key == "w" or key == "up" then -- or key == "kp8"
        -- player no action when key released
        player.walking = false
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            -- player action when game is running
            -- player:shootLazer()
        else
            clickedMouse = true -- set if mouse is clicked
        end
    end
end
-- KEYBINDINGS [ END ] --


function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.running then
        -- player:movePlayer()
        for i = 1, #enemies do
            enemies[i]:move(player.x, player.y)
        end

    elseif game.state.menu then -- check if in menu state
        menu:run(clickedMouse) -- run the menu
        clickedMouse = false -- set mouse clicked
    end

    -- Moving player and animation
    local isMoving = false
    local isAttack = false

  if love.keyboard.isDown("right") then
      player.x = player.x + player.speed
      player.anim = player.animation.right
      isMoving = true
  end

  if love.keyboard.isDown("left") then
      player.x = player.x - player.speed
      player.anim = player.animation.left
      isMoving = true
  end

  if love.keyboard.isDown("down") then
      player.y = player.y + player.speed
      player.anim = player.animation.down
      isMoving = true
  end

  if love.keyboard.isDown("up") then
      player.y = player.y - player.speed
      player.anim = player.animation.up
      isMoving = true
  end

  -- Attack

  if love.keyboard.isDown("space") then
    attack.anim = attack.animation.right
    isAttack = true
  end

  if isAttack == false then
    attack.anim:gotoFrame(3)
  end

  --through window

  --  make sure the ship can't go off screen on x axis
  if player.x + player.radius < 0 then
      player.x = love.graphics.getWidth() + player.radius
  elseif player.x - player.radius > love.graphics.getWidth() then
      player.x = -player.radius
  end

  -- make sure the ship can't go off screen on y axis
  if player.y + player.radius < 0 then
      player.y = love.graphics.getHeight() + player.radius
  elseif player.y - player.radius > love.graphics.getHeight() then
      player.y = -player.radius
  end

  if isMoving == false then
    player.anim:gotoFrame(2)
  end

  player.anim:update(dt)
  attack.anim:update(dt)
end

function love.draw()
    if game.state.running or game.state.paused then
        -- draw player lives
        -- player:drawLives(game.state.paused)
        -- draw player in center of screen
        for i = 1, #enemies do
            enemies[i]:draw()
        end
        player.anim:draw(player.spriteSheet, player.x, player.y, nil, 2, 2)
        attack.anim:draw(attack.spriteSheet, player.x, player.y, nil, 2, 2)

        -- end
        game:draw(game.state.paused)

    elseif game.state.menu then -- draw menu if in menu state
        menu:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)

    if not game.state.running then -- draw cursor if not in running state
        love.graphics.circle("fill", mouse_x, mouse_y, 10)
    end

    love.graphics.print(love.timer.getFPS(), 10, 10)
end
