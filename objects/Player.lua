local love = require "love"

function Player(debugging)
    local SHIP_SIZE = 30
    local VIEW_ANGLE = math.rad(90)

    debugging = debugging or false

    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_ANGLE, -- angle gets calculated as radian
        rotation = 0,
        walking = false,
        walk = {
            x = 0,
            y = 0,
            speed = 1,
        },

        -- below will draw the flame behind the ship whenever we move
        draw = function (self)
            local opacity = 1

            if debugging then
                love.graphics.setColor(1, 0, 0)

                love.graphics.rectangle( "fill", self.x - 1, self.y - 1, 2, 2 ) -- shows center of triangle
                
                love.graphics.circle("line", self.x, self.y, self.radius) -- the hitbox of the ship
            end

            love.graphics.setColor(1, 1, 1, opacity)
            love.graphics.circle("line", self.x, self.y, 20)

            love.graphics.setColor(100/255, 230/255, 5/255, 1)
            love.graphics.circle("line", self.x + 20, self.y - 20, 8)
            love.graphics.setColor(100/255, 230/255, 5/255, 1)
            love.graphics.circle("line", player.x - 20, player.y + 20, 8)
            love.graphics.setColor(100/255, 230/255, 5/255, 1)
            love.graphics.circle("line", player.x - 20, player.y - 20, 8)
        end,

        movePlayer = function (self)
            local FPS = love.timer.getFPS()
            local friction = 2 -- 0 = no friction

            -- basically turn 360 deg every second
            self.rotation = 360 / 180 * math.pi / FPS

            if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then -- rotate left
                self.angle = self.angle + self.rotation
            end
            
            if love.keyboard.isDown("d") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then -- rotate right
                self.angle = self.angle - self.rotation
            end

            if self.walking then
                self.walk.x = self.walk.speed * math.cos(self.angle) 
                self.walk.y = 0 - self.walk.speed * math.sin(self.angle)
            else
                -- applies friction to stop the ship
                if self.walk.x ~= 0 or self.walk.y ~= 0 then
                    self.walk.x = self.walk.x - friction * self.walk.x / FPS
                    self.walk.y = self.walk.y - friction * self.walk.y / FPS
                end
            end

            self.x = self.x + self.walk.x
            self.y = self.y + self.walk.y

            -- make sure the ship can't go off screen on x axis
            if self.x + self.radius < 0 then
                self.x = love.graphics.getWidth() + self.radius
            elseif self.x - self.radius > love.graphics.getWidth() then
                self.x = -self.radius
            end

            -- make sure the ship can't go off screen on y axis
            if self.y + self.radius < 0 then
                self.y = love.graphics.getHeight() + self.radius
            elseif self.y - self.radius > love.graphics.getHeight() then
                self.y = -self.radius
            end
        end
    }
end

return Player
