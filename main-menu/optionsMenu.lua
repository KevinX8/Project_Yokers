local composer = require("composer")
local scene = composer.newScene()

local function goToMenu(event)
          composer.gotoScene("menu")
       end
       
local function volumeUp(event)
            audio.setVolume(audio.getVolume() + 0.1)
        end

local function volumeDown(event)
            audio.setVolume(audio.getVolume() - 0.1)
        end     

function scene:create(event)
    
    local sceneGroup = self.view

		local background = display.newImageRect(sceneGroup, "Images/Title_Screen.png", 1920, 1080)
			  background.x = display.contentCenterX
			  background.y = display.contentCenterY

	    local muteSound = display.newImageRect(sceneGroup, "Images/mute.png", 500, 75)
			  muteSound.x = display.contentCenterX
			  muteSound.y = 705

	    local volUp = display.newImageRect(sceneGroup, "Images/volup.png", 500, 75)
			  volUp.x = display.contentCenterX
			  volUp.y = 780
			
	    local volDown = display.newImageRect(sceneGroup, "Images/voldown.png",  500, 75)
			  volDown.x = display.contentCenterX
			  volDown.y = 855

	    local back = display.newImageRect(sceneGroup, "Images/back.png",  500, 75)
			  back.x = display.contentCenterX
			  back.y = 930
			
			  muteSound:addEventListener("tap", MuteSound)
			  volUp:addEventListener("tap", volumeUp)
			  volDown:addEventListener("tap", volumeDown)
			  back:addEventListener("tap", goToMenu)
		  end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

	if (phase == "will") then
	
	elseif (phase == "did") then
	
	end
 end


function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
      
    elseif (phase == "did") then
	composer.removeScene("optionsMenu")
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
