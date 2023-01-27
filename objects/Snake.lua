require "globals"

local love = require "love"
local RealMedusa = require "objects/RealMedusa"

function Snake() -- takes in number of player lives
    snake = {}
    snake_one_x = 560 -- RealMedusa_x + 60 
    snake_one_y = 260 -- RealMedusa_y + 60 
    snake_one_radius = 150 -- RealMedusa_radius - 25 

    -- snake_one_y = 35 
    -- snake_one_radius = 35 
    -- snake_two_x = 35 
    -- snake_two_y = 35 
    -- snake_two_radius = 35 
    -- snake_three_x = 35 
    -- snake_three_y = 35 
    -- snake_three_radius = 35 

    return {
        -- x = love.graphics.getWidth() / 2,
        -- y = love.graphics.getHeight() / 2,
        -- radius = SHIP_SIZE / 2,
        -- angle = VIEW_ANGLE,
        -- rotation = 0,

        -- set player lives
        -- lives = num_lives or 3, -- we now set player lives

        draw = function (self)
            love.graphics.circle("fill", snake_one_x, snake_one_y, snake_one_radius)
            love.graphics.setColor(255/255, 100/255, 120/255)
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

return Snake 
