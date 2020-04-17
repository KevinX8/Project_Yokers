local composer = require("composer")
local scene = composer.newScene()
Difficulty = 2

Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)

local function closeGame(event)
	native.requestExit()
end

local function goToGame(event)
	composer.gotoScene("game")
end

local function changeDifficulty(event)
	Difficulty = Difficulty+1
	if(Difficulty == 4) then
		Difficulty = 1
	end
	if(Difficulty == 1) then
		DifficultyText.text = "Difficulty: Easy"
	elseif (Difficulty == 2) then
		DifficultyText.text = "Difficulty: Normal"
	else
		DifficultyText.text = "Difficulty: Hard"
	end
end

function scene:create(event)
    
    local sceneGroup = self.view

	local background = display.newImageRect(sceneGroup, "assets/Title Screen.png", 1920, 1080)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	local newGame = display.newImageRect(sceneGroup, "Assets/blank.png", 500, 75)
	newGame.x = display.contentCenterX
	newGame.y = 655
	NewGameText = Ponyfont.newText({
	text = "New Game",
	x = newGame.x,
	y = newGame.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
		
	local options = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
	options.x = display.contentCenterX
	options.y = 755
	DifficultyText = Ponyfont.newText({
	text = "Difficulty: Normal",
	x = options.x,
	y = options.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})

	local quit = display.newImageRect(sceneGroup, "Assets/blank.png",  500, 75)
	quit.x = display.contentCenterX
	quit.y = 855
	local quitText = Ponyfont.newText({
	text = "Quit Game",
	x = quit.x,
	y = quit.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
		
	newGame:addEventListener("tap", function() NewGameText.text = "Loading..." timer.performWithDelay(10,goToGame,1) end)
	options:addEventListener("tap", changeDifficulty)
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
