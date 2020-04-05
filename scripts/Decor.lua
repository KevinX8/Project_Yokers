local Decor = {}

function Decor.level1()
local i = 0
local bushlimit = math.random(5,10)
local cactusLimit = math.random(8,13)

repeat--level1--
    local bush = display.newImageRect(BackgroundGroup, "assets/bush.png", 256, 256)
    BackgroundGroup:insert(5,bush)
    Physics.addBody(bush, "dynamic", {radius=60, density=99999999.0})
    bush.myName = "bush"
    bush.x = math.random(LevelBoundLeft + 128,LevelBoundRight + 128)-200
    bush.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
    i = i + 1
    bush.collision = Decor.collisionEvent
    bush:addEventListener("collision")
until i >= bushlimit
i = 0
repeat--level2--
    local cactus = display.newImageRect(BackgroundGroup, "assets/cactus.png", 256, 256)
    BackgroundGroup:insert(5, cactus)
    Physics.addBody(cactus, "dynamic", {radius=120, density=999999999.0})
    cactus.x = math.random(LevelBoundLeft + 128,LevelBoundRight + 128)+2872
    cactus.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
    cactus.myName = "cactus"
    i = i + 1
    cactus.collision = Decor.collisionEvent
    cactus:addEventListener("collision")
until i >= cactusLimit
end

function Decor.collisionEvent(self, event)
    -- In this case, "self" refers to "enemyImage"
    if event.phase == "began" then
        if event.other.myName == "playerProjectile" then
            timer.cancel(event.other.despawnTimer)
            event.other:removeSelf()
        end
        if event.other.myName == "coop" then
            event.target:removeSelf()
            print("ouch coop hurts")
        end
        if event.other.myName == "player" and event.target.myName == "cactus" then
            print("ouch cactus")
            player.damage(1)
            BackgroundGroup.x = BackgroundGroup.x + 0.2* (event.target.x- select(1,player.getPosition()))
            BackgroundGroup.y = BackgroundGroup.y + 0.2*(event.target.y-select(2,player.getPosition()))
        end
    end
end

return Decor