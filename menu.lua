local composer = require("composer")
local scene = composer.newScene()

Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)

local function closeGame(event)
		  native.requestExit()
       end

local function goToGame(event)
              composer.gotoScene("game")
          end

local function goToOptions(event)
              composer.gotoScene("options")
          end

function scene:create(event)
    
    local sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "assets/Title Screen.png", 1920, 1080)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local newGame = display.newImageRect(sceneGroup, "Assets/blank.png", 500, 75)
	newGame.x = display.contentCenterX
	newGame.y = 705
	local newGameText = Ponyfont.newText({
	text = "New Game",x = newGame.x,
	y = newGame.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
		
	local options = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
	options.x = display.contentCenterX
	options.y = 780
	local optionsText = Ponyfont.newText({
	text = "Options",x = options.x,
	y = options.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})

	local quit = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
	quit.x = display.contentCenterX
	quit.y = 855
	local optionsText = Ponyfont.newText({
	text = "Quit Game",x = quit.x,
	y = quit.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
		
	newGame:addEventListener("tap", goToGame)
	options:addEventListener("tap", goToOptions)
	quit:addEventListener("tap", closeGame)
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
	composer.removeScene("menu")
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
