local composer = require("composer")
local options = composer.newScene()

local function goToMenu(event)
	composer.gotoScene("menu")
end
       
local function volumeUp(event)
	audio.setVolume(audio.getVolume() + 0.1)
end

local function volumeDown(event)
	audio.setVolume(audio.getVolume() - 0.1)
end     

function options:create(event)
    
	local sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "assets/Title Screen.png", 1920, 1080)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local muteSound = display.newImageRect(sceneGroup, "Assets/blank.png", 500, 75)
	muteSound.x = display.contentCenterX
	muteSound.y = 655
	local muteSoundText = Ponyfont.newText({
	text = "Mute Sound",
	x = muteSound.x,
	y = muteSound.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})

	local volUp = display.newImageRect(sceneGroup, "Assets/blank.png", 500, 75)
	volUp.x = display.contentCenterX
	volUp.y = 755
	local volUpText = Ponyfont.newText({
				text = "Volume Down",
	x = volUp.x,
	y = volUp.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
		align = "centre"
	})
				
	local volDown = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
	volDown.x = display.contentCenterX
	volDown.y = 855
	local volDownText = Ponyfont.newText({
	text = "Volume Down",
	x = volDown.x,
	y = volDown.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})

	local back = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
	back.x = display.contentCenterX
	back.y = 955
	local backText = Ponyfont.newText({
	text = "Back",
	x = back.x,
	y = back.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
		
	muteSound:addEventListener("tap", muteSound)
	volUp:addEventListener("tap", volumeUp)
	volDown:addEventListener("tap", volumeDown)
	back:addEventListener("tap", goToMenu)
end

function options:show(event)
    local sceneGroup = self.view
    local phase = event.phase

	if (phase == "will") then
	
	elseif (phase == "did") then
	
	end
 end


function options:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
      
    elseif (phase == "did") then
		composer.removeScene("optionsMenu")
    end
end

function options:destroy(event)
    local sceneGroup = self.view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
options:addEventListener("create", options)
options:addEventListener("show", options)
options:addEventListener("hide", options)
options:addEventListener("destroy", options)
-- -----------------------------------------------------------------------------------

return options
