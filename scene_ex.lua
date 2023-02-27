function love.load()
    -- Set up your scenes here
    currentScene = "menu"
end

function love.update(dt)
    -- Update your scenes here
end

function love.draw()
    -- Draw your scenes here
    if currentScene == "menu" then
        -- Draw your menu scene
    elseif currentScene == "game" then
        -- Draw your game scene
    end
    -- Draw the transition effect if needed
    if transition then
        love.graphics.setColor(0, 0, 0, transitionAlpha)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
    end
end

function goToScene(scene)
    transitionAlpha = 0
    transition = true
    transitionDuration = 1 -- Change this to adjust the duration of the transition
    currentScene = scene
end

function love.keypressed(key)
    if key == "space" then
        goToScene("game") -- Change this to the scene you want to transition to
    end
end

function love.update(dt)
    -- Update the transition effect if needed
    if transition then
        transitionAlpha = transitionAlpha + dt / transitionDuration
        if transitionAlpha >= 1 then
            transitionAlpha = 1
            transition = false
        end
    end
end

 -- In this example, we use a variable transition to indicate whether a transition effect is currently happening. When we want to transition to a new scene, we call the goToScene function with the name of the scene we want to transition to. This sets up the variables needed for the transition effect, including transitionAlpha, which represents the opacity of the transition effect.
 -- 
 -- In the love.update function, we update the transitionAlpha variable to gradually increase the opacity of the transition effect over time. Once the transitionAlpha reaches 1, we set transition to false to indicate that the transition effect is complete.
 -- 
 -- In the love.draw function, we draw the current scene as normal, and if a transition effect is happening, we draw a black rectangle with an opacity determined by transitionAlpha over the entire screen to create a fade effect.
