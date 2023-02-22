local love = require "love"

math.randomseed(os.time())

local enemies = {}

function love.load()

    -- COMMAND INFOS
    text = " f = fullscreen, q = quit, space = attack, arrow keys = move "

    -- SOUNDS
    sounds = {}
    sounds.blip = love.audio.newSource("sounds/blip.wav", "static")
    sounds.music = love.audio.newSource("sounds/medusa.mp3", "stream")
    sounds.music:setLooping(true)

    --DIALOG
    local Dialove = require('libraries/dialove')

    dialogManager = Dialove.init({
      font = love.graphics.newFont('fonts/vt323/VT323-Regular.ttf', 30)
    })

    -- dialogManager:push('first dialogue content') -- stores a dialog into memory
    -- dialogManager:push('second Dialog content') -- stores a dialog into memory
    -- dialogManager:pop() -- requests the first pushed dialog to be shown on screen

    -- -- use this approach instead:
    -- dialogManager:push('Julien!!! Ca va? ')

    -- dialogManager:show({
    --   text = "C'est vraiment aberrant c't'histoire. J'en peux plus moi les gars.",
    --   title = 'Julien',
    --   image = love.graphics.newImage('assets/julien.png')
    -- })

    -- dialogManager:show({
    --   text = "Dit, tu connais Hollow Knight??",
    --   title = 'Julien',
    --   image = love.graphics.newImage('assets/julien.png')
    -- })

    --CAMERA
    camera = require ("libraries/camera")
    cam = camera(400, 300, 3, 0)

    -- at gameStart, call a requireAll fun, in gameStart.lua
    require ("src/startup/gameStart")
    gameStart()

    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0

    game = Game()
    menu = Menu(game) -- Create a menu object

    -- On start, insert an enemy in empty table ennemies
    table.insert(enemies, 1, Enemy())


    -- QUERY

    local panels = gameMap.layers["panels"].objects
    -- world:addCollisionClass('Panel')

    buttons = {}

    for i = 1, #panels do
        local panel = panels[i]
        print(panel.x, panel.y)
        -- panel = world:newRectangleCollider(panel.x, panel.y, panel.width, panel.height)
        button = world:newRectangleCollider(panel.x, panel.y, 20, 20)
        table.insert(buttons, button)
        -- panel:setType("static")
        -- panel:setCollisionClass("Panel")
    end

      world:addCollisionClass('Player')
      player.collider:setCollisionClass("Player")

      world:addCollisionClass('Button')

     for i = 1, #buttons do
        buttons[i]:setCollisionClass("Button")
        buttons[i]:setType("static")
     end

      -- world:addCollisionClass('Panel')
      -- panel:setCollisionClass("Panel")
      -- panel:setType('static')
end



-- KEYBINDINGS [ START ]--
function love.keypressed(key)

    -- QUERY
    if key == 'a' then
      local px, py = player.collider:getPosition()
      local colliders = world:queryCircleArea(px, py, 8, {'Button'})
    if #colliders > 0 then
      player.life = player.life + 1
      end
    end

    -- DIALOGUE
    if key == 'd' then
        dialogManager:pop()
    elseif key == 'c' then
        dialogManager:complete()
    elseif key == 'f' then
        dialogManager:faster()
    end

    -- MENU
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
            dialogManager:pop()
    end
end

-- KEYBINDINGS [ END ] --

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    if game.state.running then
        -- for i = 1, #enemies do
        --     enemies[i]:move(player.x, player.y)
        -- end

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
            bats[i].x = bats[i].x + bat.speed
          end

          if bats[i].y < player.y then
            bats[i].y = bats[i].y + bat.speed
          end

          if bats[i].x > player.x then
            bats[i].x = bats[i].x - bat.speed
          end

          if bats[i].y > player.y then
            bats[i].y = bats[i].y - bat.speed
          end
        end
      end

      -- knock back
      for i = 1, #bats do
          if bats[i].x < player.x + 20 and bats[i].x > player.x - 20 and bats[i].y < player.y + 20 and bats[i].y > player.y - 20 then
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
      dialogManager:update(dt)
      for i = 1, #bats do
        bats[i].anim:update(dt)
      end

      -- COLLIDER POSITION
      player.x = (player.collider:getX()) - 6
      player.y = (player.collider:getY()) - 9

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
          gameMap:drawLayer(gameMap.layers["ground"])
          gameMap:drawLayer(gameMap.layers["stone"])
          gameMap:drawLayer(gameMap.layers["house"])
          gameMap:drawLayer(gameMap.layers["object"])
          -- gameMap:drawLayer(gameMap.layers["plants"])
          -- gameMap:drawLayer(gameMap.layers["panels"])

          -- BAT
          for i = 1, #bats do
            bats[i].anim:draw(bats[i].spriteSheet, bats[i].x, bats[i].y, nil, 1, 1)
          end

          for i = 1, #bats do
            love.graphics.rectangle("fill", bats[i].x + 3, bats[i].y - 3, bats[i].life, 0.5)
            -- love.graphics.print(bats[i].life, bats[i].x, bats[i].y - 20)
          end

          -- PLAYER
          -- EX:  player.anim:draw(player.spriteSheet, player.x, player.y, nil, 6, 9)
          player.anim:draw(player.spriteSheet, player.x, player.y, nil, 1, 1)

          -- for cam update offset variables (ox, oy)
          -- love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky)
          -- ox = half sprite width
          -- oy = half sprite height


          -- ATTACK
          -- attack.anim:draw(attack.spriteSheet, player.x, player.y, rotation,scaling?, scaling?)
          if player.dir == "left" then
              attack.anim:draw(attack.spriteSheet, player.x - 2, player.y + 15, getRadianRotation(player.dir), 1, 1)
          elseif player.dir == "down" then
              attack.anim:draw(attack.spriteSheet, player.x + 15, player.y + 15, getRadianRotation(player.dir), 1, 1)
          elseif player.dir == "up" then
              attack.anim:draw(attack.spriteSheet, player.x - 2, player.y, getRadianRotation(player.dir), 1, 1)
          elseif player.dir == "right" then
              attack.anim:draw(attack.spriteSheet, player.x + 15, player.y, getRadianRotation(player.dir), 1, 1)
          end

          -- COLLIDER
          world:draw()

          -- end
          game:draw(game.state.paused)
      cam:detach() -- for HUD, print under detach()

      -- DIALOG
      dialogManager:draw()

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
          love.graphics.print("Ennemies: " .. #bats, love.graphics.getWidth() - 120, 10)
      end

end
