 local composer = require ("composer")
 local scene = composer.newScene()

 local function goToLevel1(event)
            if ("ended" == event.phase) then
                composer.gotoScene("level1", {effect = "crossFade", time = 500})
            end
        end
  
 local function goToLevel2(event)
            if ("ended" == event.phase) then
                composer.gotoScene("level2", {effect = "crossFade", time = 500})
            end
        end
        
 local function goToLevel3(event)
            if ("ended" == event.phase) then
                composer.gotoScene("level3", {effect = "crossFade", time = 500})
            end
        end      
 
 local function goToLevel4(event)
        if ("ended" == event.phase) then
            composer.gotoScene("level4", {effect = "crossFade", time = 500})
        end
    end
 
    
 local level1 =
            widget.newButton(
            {	
            
                onEvent = goToLevel1
            }
        )
           
 local level2 =
            widget.newButton(
            {	
            
                onEvent = goToLevel2
            }
        )
           
 local level3 =
            widget.newButton(
            {	
            
                onEvent = goToLevel3
            }
        )
		   
 local level4 =
            widget.newButton(
            {	
            
                onEvent = goToLevel4
            }
        )
 
 
 local returnMain =
        widget.newButton(
        {	
			id = "back"
            onEvent = goToMenu
        }
    )

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
