local composer = require("composer")
local menu = composer.newScene()
Difficulty = "Normal"
local sceneGroup
local optionsText
local quitText
local newGameText
local difficultyText
local hidden = false
local background
local newGame
local options
local optionsMenu
local quit
MenuMusic = audio.loadSound("audio/MenuMusic-1.mp3")

Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)

local function closeGame(event)
	if(not hidden) then
		native.requestExit()
	end
end

local function goToGame(event)
	if(not hidden) then
		audio.setVolume(0,{channel = 16})
		composer.gotoScene("game")
	end
end

local function goToOptions(event)
	if(not hidden) then
		composer.gotoScene("main-menu.optionsMenu")
	end
end

local function changeDifficulty(event)
	if (not hidden) then
		if(Difficulty == "Hard") then
			difficultyText.text = "Difficulty: Easy"
			Difficulty = "Easy"
		elseif (Difficulty == "Easy") then
			difficultyText.text = "Difficulty: Normal"
			Difficulty = "Normal"
		else
			difficultyText.text = "Difficulty: Hard"
			Difficulty = "Hard"
		end
	end
end

function menu:create(event)
    sceneGroup = self.view

	background = display.newImageRect(sceneGroup, "assets/Title Screen.png", 1920, 1080)
	background.x = display.contentCenterX
	background.y = display.contentCenterY

	newGame = display.newImageRect(sceneGroup, "assets/blank.png", 500, 75)
	newGame.x = display.contentCenterX
	newGame.y = 605
	newGameText = Ponyfont.newText({
	text = "New Game",
	x = newGame.x,
	y = newGame.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
		
	options = display.newImageRect(sceneGroup, "assets/blank.png",  500, 75)
	options.x = display.contentCenterX
	options.y = 705
	difficultyText = Ponyfont.newText({
	text = "Difficulty: Normal",
	x = options.x,
	y = options.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
	
	optionsMenu = display.newImageRect(sceneGroup, "assets/blank.png",  500, 75)
	optionsMenu.x = display.contentCenterX
	optionsMenu.y = 805
	optionsText = Ponyfont.newText({
	text = "Options",
	x = optionsMenu.x,
	y = optionsMenu.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})

	quit = display.newImageRect(sceneGroup, "assets/blank.png",  500, 75)
	quit.x = display.contentCenterX
	quit.y = 905
	quitText = Ponyfont.newText({
	text = "Quit Game",
	x = quit.x,
	y = quit.y,
	font = "assets/coolfont.fnt",
	fontSize = 32,
	align = "centre"
	})
end

function menu:show(event)
	audio.play(MenuMusic,{channel = 15, loops = 10, duration = 600000})
	audio.resume(MenuMusic)
	if event.phase == "will" then
	newGameText.text = "New Game"
	difficultyText.text = "Difficulty: "..Difficulty
	optionsText.text = "Options"
	quitText.text = "Quit Game"
	hidden = false
	newGame:addEventListener("tap", function() if(not hidden) then newGameText.text = "Loading..." timer.performWithDelay(50,goToGame,1) end end)
	options:addEventListener("tap", changeDifficulty)
	optionsMenu:addEventListener("tap", goToOptions)
	quit:addEventListener("tap", closeGame)
	end
 end


function menu:hide(event)
	newGameText.text = ""
	difficultyText.text = ""
	optionsText.text = ""
	quitText.text = ""
	hidden = true
	newGame:removeEventListener("tap", function() if(not hidden) then newGameText.text = "Loading..." timer.performWithDelay(50,goToGame,1) end end)
	options:removeEventListener("tap", changeDifficulty)
	optionsMenu:removeEventListener("tap", goToOptions)
	quit:removeEventListener("tap", closeGame)
end

function menu:destroy(event)
	sceneGroup:removeSelf()
	newGameText.text = ""
	difficultyText.text = ""
	optionsText.text = ""
	quitText.text = ""
	newGame:removeEventListener("tap", function() if(not hidden) then newGameText.text = "Loading..." timer.performWithDelay(50,goToGame,1) end end)
	options:removeEventListener("tap", changeDifficulty)
	optionsMenu:removeEventListener("tap", goToOptions)
	quit:removeEventListener("tap", closeGame)
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
menu:addEventListener("create", menu)
menu:addEventListener("show", menu)
menu:addEventListener("hide", menu)
menu:addEventListener("destroy",menu)
-- -----------------------------------------------------------------------------------

return menu
