local player = require "player.player"

local enemy = {}
enemy.exposedVariable = "hello from enemy.lua. this is enemy.exposedVariable"

print(player.exposedVariable)

return enemy
