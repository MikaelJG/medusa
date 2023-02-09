local love = require "love"

math.randomseed(os.time())

local enemies = {}

function love.load()
    -- SOUNDS
    sounds = {}
    sounds.blip = love.audio.newSource("sounds/blip.wav", "static")
    sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
    sounds.music:setLooping(true)

    sounds.music:play()

    camera = require ("libraries/camera")
    -- in link, cam = Camera(0, 0, scale)
    cam = camera(0, 0, 2)

    -- at gameStart, call a requireAll fun, in gameStart.lua
    require ("src/startup/gameStart")
    gameStart()

    love.graphics.setDefaultFilter("nearest", "nearest")

    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0

    game = Game()
    menu = Menu(game) -- Create a menu object

    -- On start, insert an enemy in empty table ennemies
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
      player.dir = "right"
      player.x = player.x + player.speed
      player.anim = player.animation.right
      isMoving = true
  end

  if love.keyboard.isDown("left") then
      player.dir = "left"
      player.x = player.x - player.speed
      player.anim = player.animation.left
      isMoving = true
  end

  if love.keyboard.isDown("down") then
      player.dir = "down"
      player.y = player.y + player.speed
      player.anim = player.animation.down
      isMoving = true
  end

  if love.keyboard.isDown("up") then
      player.dir = "up"
      player.y = player.y - player.speed
      player.anim = player.animation.up
      isMoving = true
  end

  -- Attack

  if love.keyboard.isDown("space") then
    -- getRadianRotation(player.dir)
    attack.anim:gotoFrame(1)
    attack.anim:update(dt)
    isAttack = true
  end

  if isAttack == false then
    attack.anim:gotoFrame(3)
  end

  --through window

  --  Player can't go off screen on x axis
  if player.x + player.radius < 0 then
      player.x = love.graphics.getWidth() + player.radius
  elseif player.x - player.radius > love.graphics.getWidth() then
      player.x = -player.radius
  end

  -- The player can't go off screen on y axis
  if player.y + player.radius < 0 then
      player.y = love.graphics.getHeight() + player.radius
  elseif player.y - player.radius > love.graphics.getHeight() then
      player.y = -player.radius
  end

  if isMoving == false then
    player.anim:gotoFrame(2)
  end

  -- bat move
if bat.x < player.x then
  bat.x = bat.x + 0.3
end

if bat.y < player.y then
  bat.y = bat.y + 0.3
end

if bat.x > player.x then
  bat.x = bat.x - 0.3
end

if bat.y > player.y then
  bat.y = bat.y - 0.3
end

-- knock back
if bat.x < player.x + 10 and bat.x > player.x - 10 and bat.y < player.y + 10 and bat.y > player.y - 10 then
  if love.keyboard.isDown("space") then
    bat.x = player.x - 25
    bat.y = player.y - 25
    bat.spriteSheet = love.graphics.newImage("sprites/bat-spritesheet2.png")
  end
else
  bat.spriteSheet = love.graphics.newImage("sprites/bat-spritesheet.png")
end

  player.anim:update(dt)
  attack.anim:update(dt)
  bat.anim:update(dt)
  gameMap:update(dt)

  -- updates cam everyframe to follow player
  cam:lookAt(player.x, player.y)

  -- check width of the screen
  -- local width = love.graphics.getWidth()
  -- local height = love.graphics.getHeight()

  -- if cam.x < width/2 then
  --   cam.x = width/2
  -- end
  -- if cam.y < height/2 then
  --   cam.y = height/2
  -- end

  -- -- to find how many tiles in map
  -- -- for tiled maps, not a simple background
  -- local mapWidth = gameMap.width * gameMap.tilewidth
  -- local mapHeight = gameMap.height * gameMap.tileheight

  -- -- -- for simple background
  -- -- -- I THINK : local mapWidth = gameMap.width?

  -- -- -- Right border
  -- if cam.x > (mapWidth - width/2) then
  --        cam.x = (mapWidth - width/2)
  -- end

  -- -- -- Bottom border
  -- if cam.y > (mapHeight - height/2) then
  --        cam.y = (mapHeight - height/2)
  -- end
  rotation = getRotationFromDir(direction)
end

function love.draw()

        -- attach the camera to everything on screen
        cam:attach()

        -- we need map layers for the camera to work
            if game.state.running or game.state.paused then

                -- MAP
                -- Map:draw(tx, ty, sx, sy)
                -- gameMap:draw(80, 8, 2, 2)
        gameMap:drawLayer(gameMap.layers["Ground"])
        gameMap:drawLayer(gameMap.layers["Trees"])

                -- BAT
                bat.anim:draw(bat.spriteSheet, bat.x, bat.y, nil, 2, 2)

                -- ENEMIES
                -- for i = 1, #enemies do
                --     enemies[i]:draw()
                -- end

                -- PLAYER
                -- for cam update offset variables (ox, oy)
                -- love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky)
                -- ox = half sprite width
                -- oy = half sprite height

                -- EX:  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, 9)
                player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1.3, 1.3)

                -- ATTACK
                -- attack.anim:draw(attack.spriteSheet, player.x, player.y, rotation,scaling?, scaling?)
                attack.anim:draw(attack.spriteSheet, player.x, player.y, getRadianRotation(player.dir) , 2, 2)
                --love.graphics.print(getRadianRotation(player.dir), 10, 60)

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
            love.graphics.print(player.dir, 10, 30)
            love.graphics.print(getRadianRotation(player.dir), 10, 60)

        cam:detach()

        -- draw something outside of cam:detach() to have it HUD
        -- HUD (heads-up display)
end
