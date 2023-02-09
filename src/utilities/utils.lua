-- attack animation rotates based on player position
-- rotation is defined in anim8 library
function getRadianRotation(direction)

    if direction == "right" then
        -- do not rotate
        return 0
    elseif direction == "left" then
        return math.pi
    elseif direction == "up" then
        return (math.pi/2)*3
    elseif direction == "down" then
        return math.pi/2
    else
        return 0
    end
end
