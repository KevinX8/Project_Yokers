local Decor = {}

function Decor.level1()
local i = 0
local bushlimit = math.random(5,10)
local cactusLimit = math.random(8,13)


repeat--level1--
    local bush = display.newImageRect(BackgroundGroup, "assets/bush.png", 256, 256)
    BackgroundGroup:insert(3,bush)
    bush.myName = "bush"
    Physics.addBody(bush, "static", {radius=60})
    bush.x = math.random(LevelBoundLeft + 128,LevelBoundRight + 128)-200
    bush.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
    i = i + 1
    bush.collision = Decor.collisionEvent
    bush:addEventListener("collision")
until i >= bushlimit
i = 0
repeat--level2--
    local cactus = display.newImageRect(BackgroundGroup, "assets/cactus.png", 256, 256)
    BackgroundGroup:insert(3, cactus)
    cactus.myName = "cactus"
    Physics.addBody(cactus, "static", {radius=120})
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
            if event.target.myName == "bush" then
                self.x = math.random(LevelBoundLeft + 128,LevelBoundRight + 128)-200
                self.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
                print("it works bush")
            end
            if event.target.myName == "cactus" then
                self.x = math.random(LevelBoundLeft + 128,LevelBoundRight + 128)+2872
                self.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
                print("it works cactus")
            end
        end
    end
end

return Decor