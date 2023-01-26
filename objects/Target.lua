require "globals"

local love = require "love"

function Target() -- takes in number of player lives
    local target = {}
    target.x = 150 
    target.y = 150 
    target.radius = 150 

    return {
        -- x = love.graphics.getWidth() / 2,
        -- y = love.graphics.getHeight() / 2,
        -- radius = SHIP_SIZE / 2,
        -- angle = VIEW_ANGLE,
        -- rotation = 0,

        -- set player lives
        -- lives = num_lives or 3, -- we now set player lives

        draw = function (self)
            love.graphics.circle("fill", self.target.x, self.target.y, self.target.radius)
            love.graphics.setColor(255/255, 135/255, 130/255, 0)
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
