

local enemy = require "enemy.enemy"
print(enemy.exposedVariable)

local playerTest = {}

playerTest.exposedVariable = "hello from player.lua, this is an exposed, non-global var"

return playerTest
