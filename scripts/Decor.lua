local Decor = {}

function Decor.level1()
local i = 0
repeat
    local bush = display.newImageRect(BackgroundGroup, "assets/bush.png", 256, 256)
    BackgroundGroup:insert(2,bush)
    Physics.addBody(bush, "static")
    bush.x = math.random(LevelBoundLeft + 128,LevelBoundRight + 128)
    bush.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
    i = i + 1
    bush.collision = Decor.collisionEvent
    bush:addEventListener("collision")
until i >= 7
end
function Decor.collisionEvent(self, event)
    -- In this case, "self" refers to "enemyImage"
    if event.phase == "began" then
        if event.other.myName == "playerProjectile" then
            timer.cancel(event.other.despawnTimer)
            event.other:removeSelf()
        end
    end
end

return Decor