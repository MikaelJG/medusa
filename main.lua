-- use variables set in globals
require "globals"

local love = require "love"
-- Medusa is simple the Player Object
-- Todo, change back all medusa work to player
local Medusa = require "objects/Medusa" -- importing Player object

-- RealMedusa is the character object
local RealMedusa = require "objects/RealMedusa"
local Snake = require "objects/Snake"
local Target = require "objects/Target" -- importing Target object
local Game = require "states/Game" -- importing game object
local Menu = require "states/Menu" -- importing menu object

math.randomseed(os.time())

function love.load()
    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0

    game = Game()
    medusa = Medusa()
    RealMedusa = RealMedusa()
    snake = Snake()
    target = Target()
    menu = Menu(game) -- Create a menu object
end

-- KEYBINDINGS [ START ]--
function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" then -- for number pad keys (then keys keyboards)  or key == "kp8" then
            -- medusa action on up key
            -- medusa.thrusting = true
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
        -- player.thrusting = false
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

    elseif game.state.menu then -- check if in menu state
        menu:run(clickedMouse) -- run the menu
        clickedMouse = false -- set mouse clicked
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        -- draw player lives
        -- player:drawLives(game.state.paused)
        -- draw player in center of screen
        target:draw(target)
        RealMedusa:draw(RealMedusa)
        medusa:draw(medusa)
        snake:draw(snake)

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
