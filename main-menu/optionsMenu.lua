local composer = require("composer")
local optionsMenu = composer.newScene()
local sceneGroup
local muteSoundText
local volUpText
local volDownText
local backText
local hidden = true

Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)


local function goToMenu(event)
	if(not hidden) then
          composer.gotoScene("menu")
       end
end
       
local function volumeUp(event)
	if(not hidden) then
          audio.setVolume(audio.getVolume() + 0.1)
       end
end

local function volumeDown(event)
	if(not hidden) then
          audio.setVolume(audio.getVolume() - 0.1)
       end 
end

function optionsMenu:create(event)
     
	sceneGroup = self.view

        local background = display.newImageRect(sceneGroup, "assets/Title Screen.png", 1920, 1080)
			  background.x = display.contentCenterX
			  background.y = display.contentCenterY

	    local muteSound = display.newImageRect(sceneGroup, "Assets/blank.png", 500, 75)
			  muteSound.x = display.contentCenterX
			  muteSound.y = 655
			  muteSoundText = Ponyfont.newText({
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
			  volUpText = Ponyfont.newText({
              text = "Volume Up",
			  x = volUp.x,
			  y = volUp.y,
			  font = "assets/coolfont.fnt",
			  fontSize = 32,
		      align = "centre"
		      })
			
	    local volDown = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
			  volDown.x = display.contentCenterX
			  volDown.y = 855
			  volDownText = Ponyfont.newText({
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
			  backText = Ponyfont.newText({
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

function optionsMenu:show(event)
    muteSoundText.text = "Mute Sound"
    volUpText.text = "Volume Up"
    volDownText.text = "Volume Down"
    backText.text = "Back"
    hidden = false
end


function optionsMenu:hide(event)
    muteSoundText.text = ""
    volUpText.text = ""
    volDownText.text = ""
    backText.text = ""
    hidden = true
end

function optionsMenu:destroy(event)
	sceneGroup:removeSelf()
	muteSoundText.text = ""
	volUpText.text = ""
	volDownText.text = ""
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
