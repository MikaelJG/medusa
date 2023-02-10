local love = require "love"
local Text = require "../components/Text"

function Game()
    return {
        level = 1,
        state = {
            -- start with the menu by default
            menu = true,
            paused = false,
            running = false,
            ended = false
        },

        changeGameState = function (self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
        end,

        draw = function (self, faded)
            if faded then
                Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
                Text(
                    "QUIT",
                    0,
                    love.graphics.getHeight() * 0.65,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center",
                    1
                ):draw()
            end
        end,

        startNewGame = function (self, medusa)
            self:changeGameState("running")
        end
    }
end

return Game
