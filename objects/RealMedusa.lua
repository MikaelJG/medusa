require "globals"

local love = require "love"

function RealMedusa() -- takes in number of player lives
    RealMedusa = {}
    RealMedusa_x = 50 
    RealMedusa_y = 50 
    RealMedusa_radius = 35 

    return {
        -- x = love.graphics.getWidth() / 2,
        -- y = love.graphics.getHeight() / 2,
        -- radius = SHIP_SIZE / 2,
        -- angle = VIEW_ANGLE,
        -- rotation = 0,

        -- set player lives
        -- lives = num_lives or 3, -- we now set player lives

        draw = function (self)
            love.graphics.circle("fill", RealMedusa_x, RealMedusa_y, RealMedusa_radius)
            love.graphics.setColor(255/255, 135/255, 130/255)
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

return RealMedusa 