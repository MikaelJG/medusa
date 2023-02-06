local love = require "love"
-- anim8 = require 'libraries/anim8'

-- flyEnemy = {}
-- flyEnemy.x = 400
-- flyEnemy.y = 200
-- flyEnemy.radius = 2
-- flyEnemy.speed = 1

-- flyEnemy.spriteSheet = love.graphics.newImage("sprites/fly-enemy.png")
-- flyEnemy.grid = anim8.newGrid(16, 1, flyEnemy.spriteSheet:getWidth(), flyEnemy.spriteSheet:getHeight())

-- flyEnemy.animation = {}
-- flyEnemy.animation.down = anim8.newAnimation(flyEnemy.grid('1-4', 1), 0.2)
-- flyEnemy.animation.left = anim8.newAnimation(flyEnemy.grid('1-4', 2), 0.2)
-- flyEnemy.animation.right = anim8.newAnimation(flyEnemy.grid('1-4', 3), 0.2)
-- flyEnemy.animation.up = anim8.newAnimation(flyEnemy.grid('1-4', 4), 0.2)

-- flyEnemy.anim = flyEnemy.animation.up

function Enemy()
  local dice = math.random(1, 4)
  local enemy_x, enemy_y
  local _radius = 10

  if dice == 1 then -- come from above --
    enemy_x = math.random(_radius, love.graphics.getWidth())
    enemy_y = -_radius * 4
  elseif dice == 2 then -- come from the left --
    enemy_x = -_radius * 4
    enemy_y = math.random(_radius, love.graphics.getHeight())
  elseif dice == 3 then -- come from the bottom --
    enemy_x = math.random(_radius, love.graphics.getWidth())
    enemy_y = love.graphics.getHeight() + (_radius * 4)
  else -- come from the right --
    enemy_x = love.graphics.getWidth() + (_radius * 4)
    enemy_y = math.random(_radius, love.graphics.getHeight())
  end

  -- table.insert(flyEnemy, 1, flyEnemy)

  return {
        level = 0.5,
        radius = _radius,
        x = enemy_x,
        y = enemy_y,

        move = function (self, player_x, player_y)
            if player_x - self.x > 0 then
                self.x = self.x + self.level
            elseif player_x - self.x < 0 then
                self.x = self.x - self.level
            end

            if player_y - self.y > 0 then
                self.y = self.y + self.level
            elseif player_y - self.y < 0 then
                self.y = self.y - self.level
            end
        end,

        draw = function (self)
            love.graphics.setColor(1, 0.5, 0.7)
            love.graphics.circle("fill", self.x, self.y, self.radius)
            -- for i = 1, #flyEnemy do
            --   flyEnemy[i]:draw()
            -- end

            love.graphics.setColor(1, 1, 1)
        end,
    }
end

return Enemy
