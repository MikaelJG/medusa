require "globals"

local love = require "love"

function Medusa()
    medusa = {}
    medusa_x = 200 
    medusa_y = 200 
    medusa_radius = 25 
    -- size of player and angle for example
    -- local SHIP_SIZE = 30
    -- local VIEW_ANGLE = math.rad(90)

    return {
        -- x = love.graphics.getWidth() / 2,
        -- y = love.graphics.getHeight() / 2,
        -- radius = SHIP_SIZE / 2,
        -- angle = VIEW_ANGLE,
        -- rotation = 0,

        -- set player lives
        -- lives = num_lives or 3, -- we now set player lives

        draw = function (self)
            love.graphics.circle("fill", medusa_x, medusa_y, medusa_radius)
            love.graphics.setColor(115/255, 170/255, 15/255)
        end,

        -- we draw player lives on screen
        drawLives = function (self, faded)
        end,

        movePlayer = function (self)
        end,

        expload = function (self) -- player can now expload
        end
    }
end

return Medusa 
