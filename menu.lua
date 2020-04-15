local composer = require("composer")
local scene = composer.newScene()

function scene:create(event)
    
    local sceneGroup = self.view
    
end

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

	if (phase == "will") then

		local widget = require("widget")

		local background = display.newImage("main-menu/Images/Title_Screen.png", 1920, 1080)
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

		local newGame =
				widget.newButton(
			{
			width = 289,
			height = 40,
			left = 825,
			top = 630,
			id = "new",
			defaultFile = "main-menu/Images/new_game.png",
			onEvent = goToGame
			}
		)

		local loadGame =
				widget.newButton(
			{
			width = 289,
			height = 40,
			left = 825,
			top = 670,
			id = "load",
			defaultFile = "main-menu/Images/load_game.png",
			onEvent = goToGame
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
			defaultFile = "main-menu/Images/options.png",
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
			defaultFile = "main-menu/Images/quit_game.png",
			onEvent = closeGame
			}	
		)

 elseif (phase == "did") then
 
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

