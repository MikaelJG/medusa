function tween(target, duration, properties, easing)
  easing = easing or "linear"
  return flux.to(target, duration, properties):ease(easing)
end


function love.load()
  x = 100
  y = 100
  w = 50
  h = 50
end

function love.update(dt)
  -- Move the rectangle to the right
  tween({x = 400}, 2, {x = 400 + w - x})
end

function love.draw()
  love.graphics.rectangle("fill", x, y, w, h)
end

-- This code will move the rectangle from its initial position to the right side of the screen over a duration of 2 seconds. You can adjust the target properties, duration, and easing function to create different types of tweens.


