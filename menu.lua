local composer = require("composer")
local scene = composer.newScene()


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

	local background = display.newImageRect(sceneGroup, "main-menu/Images/Title_Screen.png", 1920, 1080)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

		local newGame = display.newImageRect(sceneGroup, "main-menu/Images/new_game.png", 500, 75)
			newGame.x = display.contentCenterX
			newGame.y = 705

		local loadGame = display.newImageRect(sceneGroup, "main-menu/Images/load_game.png", 500, 75)
			loadGame.x = display.contentCenterX
			loadGame.y = 780
			
		local options = display.newImageRect(sceneGroup, "main-menu/Images/options.png",  500, 75)
			options.x = display.contentCenterX
			options.y = 855

		local quit = display.newImageRect(sceneGroup, "main-menu/Images/quit_game.png",  500, 75)
			quit.x = display.contentCenterX
			quit.y = 930
			
			newGame:addEventListener("tap", goToGame)
			loadGame:addEventListener("tap", goToGame)
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
