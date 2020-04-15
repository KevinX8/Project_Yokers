local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
   
    local sceneGroup = self.view
        
        local widget = require("widget")

        local background = display.newImageRect("Images/Title_Screen.png", 1280, 720)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

        local function closeGame(event)
            native.requestExit()
        end

        local function goToGame(event)
            if ("ended" == event.phase) then
                composer.gotoScene("game", {effect = "crossFade", time = 500})
            end
        end
 
        local function goToOptions(event)
            if ("ended" == event.phase) then
                composer.gotoScene("options", {effect = "crossFade", time = 500})
            end
        end

	--[[local function pause(event)
    if event.phase == "began" then 
        if paused == false then
            physics.pause()
            paused = true
        elseif paused == true then
            physics.start()
            paused = false
        end
    end
end

paused = false
Runtime:addEventListener("touch", pause) --]]

        local newGame =
            widget.newButton(
            {
                width = 289,
                height = 40,
                left = 825,
                top = 630,
                id = "newGame",
                defaultFile = "Images/new_game.png",
                onEvent = goToGame
            }
        )

        local resume =
            widget.newButton(
            {
                width = 289,
                height = 40,
                left = 825,
                top = 670,
                id = "resume",
                defaultFile = "Images/resume_Game.png",
                onEvent = pause
            }
        )

        local options =
            widget.newButton(
            {
                width = 289,
                height = 40,
                left = 825,
                top = 710,
                id = "options",
                defaultFile = "Images/options.png",
                onEvent = goToOptions  
            }
        )
            
        local quit =
            widget.newButton(
            {
                width = 289,
                height = 40,
                left = 825,
                top = 750,
                id = "quit",
                defaultFile = "Images/quit_game.png",
                onEvent = closeGame
                
            }
        )
        
		sceneGroup:insert(background)
		sceneGroup:insert(newGame)
		sceneGroup:insert(resume)
		sceneGroup:insert(options)
		sceneGroup:insert(quit)

    end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then

        audio.play(menuMusic, {channel = 1, loops = -1})
        
    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
       
    elseif (phase == "did") then
    
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
  
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
