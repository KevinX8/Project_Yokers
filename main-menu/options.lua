local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    local sceneGroup = self.view

    local phase = event.phase

    local widget = require("widget")

    local background = display.newImageRect("Images/Title_Screen.png", 1280, 720)
    background.x = display.contentCenterX
    background.y = display.contentCenterY


    local function goToMenu(event)
        if ("ended" == event.phase) then
            composer.gotoScene("menu", {effect = "crossFade", time = 500})
        end
    end

    local function volumeUp(event)
        if ("ended" == event.phase) then
            audio.setVolume(audio.getVolume() + 0.1)
        end
    end

    local function volumeDown(event)
        if ("ended" == event.phase) then
            audio.setVolume(audio.getVolume() - 0.1)
        end
    end

    local volUp =
        widget.newButton(
        {
            onEvent = volumeUp
        }
    )

    local volDown =
        widget.newButton(
        {
            onEvent = volumeDown
        }
    )

    local returnMain =
        widget.newButton(
        {
	    id = "back"
            onEvent = goToMenu
        }
    )
    sceneGroup:insert(background)
    sceneGroup:insert(returnMain)
    sceneGroup:insert(volDown)
    sceneGroup:insert(volUp)
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
