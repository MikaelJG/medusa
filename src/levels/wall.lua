-- WALL
walls = {}
if gameMap.layers["walls"] then
  for i, obj in pairs(gameMap.layers["walls"].objects) do
    local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height) -- (x, y, width, height, mass)
    wall:setType("static")
    table.insert(walls, wall)
  end
end

-- PANELS
panels = {}
if gameMap.layers["panels"] then
  for i, obj in pairs(gameMap.layers["panels"].objects) do
    local panel = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height) -- (x, y, width, height, mass)
    panel:setType("static")
    table.insert(panels, panel)
  end
end

-- PLANTS
plants = {}
if gameMap.layers["plants"] then
  for i, obj in pairs(gameMap.layers["plants"].objects) do
    local plant = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height) -- (x, y, width, height, mass)
    plant:setType("static")
    table.insert(plants, plant)
  end
end
