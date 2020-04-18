local composer = require("composer")
local optionsMenu = composer.newScene()
local sceneGroup
local muteSoundText
local volUpText
local volDownText
local backText
local hidden = false
local muted = false
local volumeText
local muteSoundButton
local lastVolume = 1

Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)
audio.setVolume(1)

local function goToMenu(event)
	if(not hidden) then
		composer.gotoScene("menu")
    end
end
       
local function volumeUp(event)
	if(not hidden and not muted) then
		lastVolume = (math.ceil(lastVolume *10) + 1)/10
		audio.setVolume(lastVolume)
		if (audio.getVolume() < 0.91) then
			volumeText.text = "Volume: "..(lastVolume*100)
		else
			volumeText.text = "Volume: "..(100)
			audio.setVolume(1)
			lastVolume = 1
		end
    end
end

local function volumeDown(event)
	if(not hidden and not muted) then
		lastVolume = (math.ceil(lastVolume *10) - 1)/10
		audio.setVolume(lastVolume)
		if(lastVolume > 0.09) then
			volumeText.text = "Volume: "..(lastVolume*100)
		else			
			volumeText.text = "Volume: "..(0)
			audio.setVolume(0)
			lastVolume = 0
		end		
    end 
end

local function muteSound(event)
	if(muted) then
		audio.setVolume(math.ceil(lastVolume*10)/10)
		muteSoundText.text = "Mute Sound: Unmuted"
	else
		audio.setVolume(0.0)
		muteSoundText.text = "Mute Sound: Muted"
	end
	muted = not muted
end

function optionsMenu:create(event)
     
	sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "assets/Title Screen.png", 1920, 1080)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	muteSoundButton = display.newImageRect(sceneGroup, "assets/blank.png", 500, 50)
	muteSoundButton.x = display.contentCenterX
	muteSoundButton.y = 605
	muteSoundText = Ponyfont.newText({
	text = "Mute Sound: Unmuted",
	x = muteSoundButton.x,
	y = muteSoundButton.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})

	local volUp = display.newImageRect(sceneGroup, "assets/blank.png", 500, 50)
	volUp.x = display.contentCenterX
	volUp.y = 685
	volUpText = Ponyfont.newText({
	text = "Volume Up",
	x = volUp.x,
	y = volUp.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
			
	local volDown = display.newImageRect(sceneGroup, "assets/blank.png",  500, 50)
	volDown.x = display.contentCenterX
	volDown.y = 755
	volDownText = Ponyfont.newText({
	text = "Volume Down",
	x = volDown.x,
	y = volDown.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
	
	volumeText = Ponyfont.newText({
	text = "Volume: "..(100),
	x = display.contentCenterX,
	y = 825,
	font = "assets/coolfont.fnt",
	fontSize = 32,
		align = "centre"
	})

	local back = display.newImageRect(sceneGroup, "assets/blank.png",  500, 50)
	back.x = display.contentCenterX
	back.y = 905
	backText = Ponyfont.newText({
	text = "Back",
	x = back.x,
	y = back.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
			
	muteSoundButton:addEventListener("tap", muteSound)
	volUp:addEventListener("tap", volumeUp)
	volDown:addEventListener("tap", volumeDown)
	back:addEventListener("tap", goToMenu)
end

function optionsMenu:show(event)
    muteSoundText.text = "Mute Sound"
    volUpText.text = "Volume Up"
	volDownText.text = "Volume Down"
	volumeText.text = "Volume: "..(lastVolume*100)
    backText.text = "Back"
    hidden = false
end


function optionsMenu:hide(event)
    muteSoundText.text = ""
    volUpText.text = ""
	volDownText.text = ""
	volumeText.text = ""
    backText.text = ""
    hidden = true
end

function optionsMenu:destroy(event)
	sceneGroup:removeSelf()
	muteSoundText.text = ""
	volUpText.text = ""
	volDownText.text = ""
	volumeText.text = ""
	backText.text = ""
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
optionsMenu:addEventListener("create", optionsMenu)
optionsMenu:addEventListener("show", optionsMenu)
optionsMenu:addEventListener("hide", optionsMenu)
optionsMenu:addEventListener("destroy", optionsMenu)
-- -----------------------------------------------------------------------------------

return optionsMenu
