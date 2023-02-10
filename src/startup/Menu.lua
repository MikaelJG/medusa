local love = require "love"

local Button = require "components/Button"

function Menu(game)
    local funcs = {
        newGame = function ()
            game:startNewGame()
        end,
        quitGame = function ()
            love.event.quit()
        end,
    }

    local buttons = {
        Button(funcs.newGame, nil, nil, love.graphics.getWidth() / 3, 50, "New Game", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.25),
        Button(nil, nil, nil, love.graphics.getWidth() / 3, 50, "Settings", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.4),
        Button(funcs.quitGame, nil, nil, love.graphics.getWidth() / 3, 50, "Quit", "center", "h3", love.graphics.getWidth() / 3, love.graphics.getHeight() * 0.55),
    }

    return {
        focused = "",
        run = function (self, clicked)
            local mouse_x, mouse_y = love.mouse.getPosition()
            for name, button in pairs(buttons) do
                if button:checkHover(mouse_x, mouse_y, 10) then
                    if clicked then
                        button:click()
                    end

                    self.focused = name

                    button:setTextColor(0.8, 0.2, 0.2)
                else
                    button:setTextColor(1, 1, 1)
                end
            end
            if love.keyboard.isDown("down") then
                button = buttons[1]
                button:setTextColor(0.8, 0.2, 0.2)
                -- if count < 3 then
                --    count = count + 1
                -- end
            end
            if love.keyboard.isDown("return") then
                     button = buttons[1]
                     button:click()
            end
        end,

        draw = function (self)
            for _, button in pairs(buttons) do
                button:draw()
            end
        end
    }
end

return Menu
