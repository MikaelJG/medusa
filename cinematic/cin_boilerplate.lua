-- define the cinematic script
local cinematicScript = {
  -- define the camera movements
  { type = "move", duration = 3, x = 100, y = 100 },
  { type = "zoom", duration = 2, amount = 2 },
  { type = "move", duration = 2, x = 200, y = 200 },
  { type = "zoom", duration = 1, amount = 1.5 },
  { type = "move", duration = 2, x = 300, y = 300 },
  
  -- define the dialogue
  { type = "dialogue", duration = 5, speaker = "Hero", text = "I must find the ancient artifact!" },
  { type = "dialogue", duration = 4, speaker = "Villain", text = "You'll never find it!" },
  
  -- define the camera movements
  { type = "move", duration = 2, x = 400, y = 400 },
  { type = "zoom", duration = 2, amount = 2 },
  { type = "move", duration = 2, x = 500, y = 500 },
  
  -- define the final dialogue
  { type = "dialogue", duration = 3, speaker = "Hero", text = "I did it! I found the artifact!" }
}

-- define the current step of the cinematic
local currentStep = 1

function love.update(dt)
  -- check if the current step is a camera movement
  if cinematicScript[currentStep].type == "move" then
    -- move the camera
    camera.x = cinematicScript[currentStep].x
    camera.y = cinematicScript[currentStep].y
  elseif cinematicScript[currentStep].type == "zoom" then
    -- zoom the camera
    camera.zoom = cinematicScript[currentStep].amount
  elseif cinematicScript[currentStep].type == "dialogue" then
    -- display the dialogue box
    dialogueBox.display(cinematicScript[currentStep].speaker, cinematicScript[currentStep].text)
  end
  
  -- decrement the duration of the current step
  cinematicScript[currentStep].duration = cinematicScript[currentStep].duration - dt
  
  -- check if the current step has finished
  if cinematicScript[currentStep].duration <= 0 then
    -- move to the next step
    currentStep = currentStep + 1
    
    -- check if the cinematic has finished
    if currentStep > #cinematicScript then
      -- end the cinematic
      endCinematic()
    end
  end
end

function endCinematic()
  -- reset the camera
  camera.x = 0
  camera.y = 0
  camera.zoom = 1
  
  -- hide the dialogue box
  dialogueBox.hide()
  
  -- reset the current step
  currentStep = 1
end

