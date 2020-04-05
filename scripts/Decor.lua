local Decor = {}
local pushplayer = false
local pushamount = 0.1
local frame = 0

function Decor.generateDecor()
    Decor.level1()
    Decor.level2()
    Runtime:addEventListener("enterFrame", Decor.enterFrame)
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
            pushamount = 0.1
            PlayerSpeed = 2
            Pushx = (event.target.x - select(1,Player.getPosition()))
            Pushy = (event.target.y - select(2,Player.getPosition()))
            pushplayer = true
        end
    end
end

 function Decor.enterFrame()
    if pushplayer and frame < 30 then
        BackgroundGroup.x = BackgroundGroup.x + (pushamount * Pushx)
        BackgroundGroup.y = BackgroundGroup.y + (pushamount * Pushy)
        pushamount = pushamount - 0.0034
        frame = frame + 1
    elseif frame >= 30 and pushplayer then
        frame = 0
        pushplayer = false
        PlayerSpeed = 10
    end
 end

return Decor