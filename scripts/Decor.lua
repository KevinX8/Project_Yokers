local Decor = {}

function Decor.generateDecor()
    Decor.level1()
    Decor.level2()
end

function Decor.level1()
    local i = 0
    local bushlimit = math.random(5,10)
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
end

function Decor.level2()
    local i = 0
    local cactusLimit = math.random(8,13)
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
    -- In this case, "self" refers to the decor image
    if event.phase == "began" then
        if event.other.myName == "playerProjectile" then
            timer.cancel(event.other.despawnTimer)
            event.other:removeSelf()
        elseif event.other.myName == "coop" then -- Don't allow decor to spawn on top of coops
            event.target:removeSelf()
            print("ouch coop hurts")
        elseif event.other.myName == "player" and event.target.myName == "cactus" then
            print("ouch cactus")
            Player.damage(1)
            BackgroundGroup.x = BackgroundGroup.x + 0.2* (event.target.x- select(1,Player.getPosition()))
            BackgroundGroup.y = BackgroundGroup.y + 0.2*(event.target.y-select(2,Player.getPosition()))
        end
    end
end

return Decor