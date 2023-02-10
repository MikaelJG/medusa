local love = require "love"

math.randomseed(os.time())

local enemies = {}

function love.load()

    -- COMMAND INFOS
    text = " f = fullscreen, q = quit, space = attack, arrow keys = move "

    -- SOUNDS
    sounds = {}
    sounds.blip = love.audio.newSource("sounds/blip.wav", "static")
    sounds.music = love.audio.newSource("sounds/music.mp3", "stream")
    sounds.music:setLooping(true)

    --CAMERA
    camera = require ("libraries/camera")
    -- in link, cam = Camera(0, 0, scale)
    cam = camera()

    -- at gameStart, call a requireAll fun, in gameStart.lua
    require ("src/startup/gameStart")
    gameStart()

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
        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
      clickedMouse = true -- set if mouse is clicked
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

    -- PLAYER MOVE

     -- velocity
    local velocityX = 0
    local velocityY = 0

  if love.keyboard.isDown("right") then
    velocityX = player.speed
    player.anim = player.animation.right
    isMoving = true
    player.dir = "right"
  end

  if love.keyboard.isDown("left") then
    velocityX = -player.speed
    player.anim = player.animation.left
    isMoving = true
    player.dir = "left"
  end

  if love.keyboard.isDown("down") then
    velocityY = player.speed
    player.anim = player.animation.down
    isMoving = true
    player.dir = "down"
  end

  if love.keyboard.isDown("up") then
    velocityY = -player.speed
    player.anim = player.animation.up
    isMoving = true
    player.dir = "up"
  end

  player.collider:setLinearVelocity(velocityX, velocityY)

  -- Attack

  if love.keyboard.isDown("space") then
    -- getRadianRotation(player.dir)
    -- attack.anim:gotoFrame(1)
    attack.anim:update(dt)
    isAttack = true
  end

  if isAttack == false then
    attack.anim:gotoFrame(4)
  end

  if isMoving == false then
    player.anim:gotoFrame(2)
  end

 -- bat move
 for i = #bats, 1, -1 do
  if bats[i].life <= 0 then
    table.remove(bats, i)
  else
    if bats[i].x < player.x then
      bats[i].x = bats[i].x + 0.3
    end

    if bats[i].y < player.y then
      bats[i].y = bats[i].y + 0.3
    end

    if bats[i].x > player.x then
      bats[i].x = bats[i].x - 0.3
    end

    if bats[i].y > player.y then
      bats[i].y = bats[i].y - 0.3
    end
  end
end

-- knock back
for i = 1, #bats do
    if bats[i].x < player.x + 35 and bats[i].x > player.x - 35 and bats[i].y < player.y + 35 and bats[i].y > player.y - 35 then
      if love.keyboard.isDown("space") then
        if player.dir == "left" then
          bats[i].x = bats[i].x - 100
          bats[i].life = bats[i].life - 1
        elseif player.dir == "down" then
          bats[i].y = player.y + 100
          bats[i].life = bats[i].life - 1
        elseif player.dir == "up" then
          bats[i].y = player.y - 100
          bats[i].life = bats[i].life - 1
        elseif player.dir == "right" then
          bats[i].x = bats[i].x + 100
          bats[i].life = bats[i].life - 1
        end
        attack.anim:draw(attack.spriteSheet, player.x + 30, player.y, getRadianRotation(player.dir), 2, 2)
      end
    else
      bats[i].spriteSheet = love.graphics.newImage("sprites/bat-spritesheet.png")
    end
end


-- UPDATE
  gameMap:update(dt)
  player.anim:update(dt)
  attack.anim:update(dt)
  world:update(dt)
  for i = 1, #bats do
    bats[i].anim:update(dt)
  end

  -- COLLIDER POSITION
  player.x = (player.collider:getX()) - 12
  player.y = (player.collider:getY()) - 18

  -- updates cam everyframe to follow player
  cam:lookAt(player.x, player.y)

end

function love.draw()

            if game.state.running or game.state.paused then
                sounds.music:play()

            cam:attach()
                -- MAP
                -- Map:draw(tx, ty, sx, sy)
                -- gameMap:draw(80, 8, 2, 2)
                gameMap:drawLayer(gameMap.layers["Ground"])
                gameMap:drawLayer(gameMap.layers["Trees"])

                -- BAT
                for i = 1, #bats do
                  bats[i].anim:draw(bats[i].spriteSheet, bats[i].x, bats[i].y, nil, 2, 2)
                end

                for i = 1, #bats do
                  love.graphics.rectangle("fill", bats[i].x, bats[i].y - 20, bats[i].life, 2)
                  -- love.graphics.print(bats[i].life, bats[i].x, bats[i].y - 20)
                end

                -- PLAYER
                -- EX:  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, 9)
                player.anim:draw(player.spriteSheet, player.x, player.y, nil, 2, 2)

                -- for cam update offset variables (ox, oy)
                -- love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky)
                -- ox = half sprite width
                -- oy = half sprite height


                -- ATTACK
                -- attack.anim:draw(attack.spriteSheet, player.x, player.y, rotation,scaling?, scaling?)
                if player.dir == "left" then
                    attack.anim:draw(attack.spriteSheet, player.x - 5, player.y + 30, getRadianRotation(player.dir), 2, 2)
                elseif player.dir == "down" then
                    attack.anim:draw(attack.spriteSheet, player.x + 30, player.y + 30, getRadianRotation(player.dir), 2, 2)
                elseif player.dir == "up" then
                    attack.anim:draw(attack.spriteSheet, player.x - 5, player.y, getRadianRotation(player.dir), 2, 2)
                elseif player.dir == "right" then
                    attack.anim:draw(attack.spriteSheet, player.x + 30, player.y, getRadianRotation(player.dir), 2, 2)
                end

                -- COLLIDER
                -- world:draw()

                -- end
                game:draw(game.state.paused)
            cam:detach() -- for HUD, print under detach()

            elseif game.state.menu then -- draw menu if in menu state
                menu:draw()
            end

            love.graphics.setColor(1, 1, 1, 1)

            if not game.state.running then -- draw cursor if not in running state
                love.graphics.circle("fill", mouse_x, mouse_y, 10)
            end

            if game.state.running then
                -- COMMAND INFOS
                love.graphics.setColor(0, 0, 0, 0.5)
                love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), 35) -- x, y, width, height
                love.graphics.setColor(255, 255, 255)
                love.graphics.printf(text, 0, 10, love.graphics.getWidth(), "center")
                love.graphics.print("Life: " .. player.life, 10, 10)
                love.graphics.print("Bat: " .. #bats, love.graphics.getWidth() - 100, 10)
            end

end
