local Decor = {}
local iceCollision = false
local pushplayer = false
local iceslide = false
local enemyslide = false
local icewidth = 0
local pushamount = 0.1
local frame = 0
local pushscale = pushamount / 30
local fireEggSpeed = 800
local fireEggLifeTime = 3

function Decor.generateDecor()
    Decor.level1()
    Decor.level2()
    Decor.level3()
    Decor.level4()
    Runtime:addEventListener("enterFrame", Decor.enterFrame)
end

function Decor.level1()
    local i = 0
    local bushlimit = math.random(5,10)
    repeat--level1--
        local bush = display.newImageRect(BackgroundGroup, "assets/bush.png", 256, 256)
        BackgroundGroup:insert(15,bush)
        Physics.addBody(bush, "dynamic", {radius=60, density=99999999.0})
        bush.myName = "bush"
        bush.x = math.random(LevelBoundLeft + 128,LevelBoundRight - 128)
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
        BackgroundGroup:insert(15, cactus)
        Physics.addBody(cactus, "dynamic", {radius=120, density=999999999.0})
        cactus.x = math.random(LevelBoundLeft + 128,LevelBoundRight - 128)+2872
        cactus.y = math.random(LevelBoundTop + 128,LevelBoundBottom - 128)
        cactus.myName = "cactus"
        i = i + 1
        cactus.collision = Decor.collisionEvent
        cactus:addEventListener("collision")
    until i >= cactusLimit
end

function Decor.level3()
    local i = 0
    iceLimit = math.random(4,7)
    repeat
        local size = math.random(512, 768)
        local iceLake = display.newImageRect(BackgroundGroup, "assets/ice lake.png", size, size)
        BackgroundGroup:insert(15, iceLake)
        Physics.addBody(iceLake, "static", {radius=size/2, density=999999999.0, isSensor=true})
        local positionValid = false
        local x = 0
        local y = 0
        local positionAttempts = 0
        repeat
            x = math.random(LevelBoundLeft + size, (LevelBoundRight + 3072) - size)
            y = math.random((LevelBoundTop - 3072) + size, LevelBoundTop - size)
            positionValid = true
            for o, object in ipairs(LevelObjects) do
                if CalculateDistance(x, y, object[1], object[2]) < ((object[3] / 2) + (size / 2)) then
                    positionValid = false
                end
            end
            positionAttempts = positionAttempts + 1
            if (positionAttempts > 100) then
                print("lake overflow")
                break -- failsafe incase there's no space for lakes to prevent corona crashing
            end
        until positionValid == true
        iceLake.x = x
        iceLake.y = y
        table.insert(LevelObjects, {x, y, size})
        iceLake.myName = "iceLake"
        i = i + 1
        iceLake.collision = Decor.collisionEvent
        iceLake:addEventListener("collision")
    until i >= iceLimit
end

function Decor.level4()
    local i = 0
    lavaLimit = math.random(4,7)
    repeat
        local size = math.random(512, 768)
        local lavaLake = display.newImageRect(BackgroundGroup, "assets/lava.png", size, size)
        BackgroundGroup:insert(15, lavaLake)
        Physics.addBody(lavaLake, "static", {radius=(size-30)/2, density=999999999.0, isSensor=true})
        local positionValid = false
        local x = 0
        local y = 0
        local positionAttempts = 0
        repeat
            x = math.random(LevelBoundLeft + size, (LevelBoundRight + 3072) - size)
            y = math.random((LevelBoundBottom) + size, LevelBoundBottom - size + 3072)
            positionValid = true
            for o, object in ipairs(LevelObjects) do
                if CalculateDistance(x, y, object[1], object[2]) < ((object[3] / 2) + (size / 2)) then
                    positionValid = false
                end
            end
            positionAttempts = positionAttempts + 1
            if (positionAttempts > 100) then
                print("lake overflow")
                break -- failsafe incase there's no space for lakes to prevent corona crashing
            end
        until positionValid == true
        lavaLake.x = x
        lavaLake.y = y
        lavaLake.rotation = (math.floor(math.random(4))*90)
        table.insert(LevelObjects, {x, y, size})
        lavaLake.myName = "lavaLake"
        i = i + 1
        lavaLake.collision = Decor.collisionEvent
        lavaLake:addEventListener("collision")
    until i >= lavaLimit
end

function Decor.collisionEvent(self, event)
    -- In this case, "self" refers to the decor image
    if event.phase == "began" then
        if(event.target.myName == "iceLake") then
            if event.other.myName == "player" then
                pushamount = 0.075
                Initialx = event.other.x
                Initialy = event.other.y
                Pushx = -1 * (event.target.x - Initialx)
                Pushy = -1 * (event.target.y - Initialy)
                iceslide = true
                icewidth = event.target.width
            end
        elseif event.other.myName == "player" and (event.target.myName == "cactus" or event.target.myName == "lavaLake") then
            print("ouch cactus")
            Player.damage(1)
            if(event.target.myName == "cactus") then
            pushamount = 0.1
            else
                pushamount = 0.05
            end
            pushscale = pushamount / 30
            PlayerSpeed = 2
            Pushx = (event.target.x - select(1,Player.getPosition()))
            Pushy = (event.target.y - select(2,Player.getPosition()))
            pushplayer = true
        elseif event.other.myName == "playerProjectile" then
            if not(event.target.myName == "lavaLake") then 
                if(event.other.isFireEgg) then
                    event.other.fireEggImage:removeSelf()
                end
                timer.cancel(event.other.despawnTimer)
                event.other:removeSelf()
            elseif event.other.isFireEgg == false then
                event.other.isFireEgg = true
                SpawnFireEggImage(event.other)
            end
        elseif event.other.myName == "coop" then -- Don't allow decor to spawn on top of coops
            event.target:removeSelf()
            print("ouch coop hurts")
        end
    end
end

 function Decor.enterFrame()
    if iceslide then
        PlayerSpeed = 2
        BackgroundGroup.x = BackgroundGroup.x + (pushamount * Pushx)
        BackgroundGroup.y = BackgroundGroup.y + (pushamount * Pushy)
        if math.sqrt(math.pow(Initialx - select(1,Player.getPosition()),2) + math.pow(Initialy - select(2,Player.getPosition()),2)) - 150 > icewidth or select(1,Player.getPosition()) <= LevelBoundLeft or select(1,Player.getPosition()) >= LevelBoundRight or select(2,Player.getPosition()) <= LevelBoundTop or select(2,Player.getPosition()) >= LevelBoundBottom then
            iceslide = false
            PlayerSpeed = 10
        end
    end
    if pushplayer and frame < 30 then
        if select(1,Player.getPosition()) <= LevelBoundLeft or select(1,Player.getPosition()) >= LevelBoundRight or select(2,Player.getPosition()) <= LevelBoundTop or select(2,Player.getPosition()) >= LevelBoundBottom then
            frame = 29
        end
        BackgroundGroup.x = BackgroundGroup.x + (pushamount * Pushx)
        BackgroundGroup.y = BackgroundGroup.y + (pushamount * Pushy)
        pushamount = pushamount - pushscale
        frame = frame + 1
    elseif frame >= 30 and pushplayer then
        frame = 0
        pushplayer = false
        PlayerSpeed = 10
    end
    if (select(2,Player.getPosition()) < -1*(display.contentHeight/2+500)) then
        SpawnSnowFlake()
    elseif(select(2,Player.getPosition()) > (display.contentHeight/2+1500)) then
        if(math.random() < .5) then
            SpawnSpark()
        end
    end
end

function SpawnSnowFlake()
    local size = math.random(5, 10)
    local flake = display.newImageRect(BackgroundGroup, "assets/snowflake.png", size, size)
    flake.x = math.random(6144)-500
    flake.y = -3470-display.contentHeight/2
    local wind = -100
    transition.to(flake,{time=(15-size)*300 + 3000, y = -1000, x = flake.x + wind, onComplete=function() flake:removeSelf() end})
end

function SpawnSpark()
    local size = math.random(5, 10)
    local spark = display.newImageRect(BackgroundGroup, "assets/spark.png", size, size)
    spark.x = math.random(6144)-600
    spark.y = 4600+display.contentHeight/2
    transition.to(spark,{time=1200*(15-size) + 6000, y = 2100, onComplete=function() spark:removeSelf() SpawnAsh(spark.x, spark.y, size) end})
end

function SpawnAsh(x, y, size)
    local ash = display.newImageRect(BackgroundGroup, "assets/ash.png", size, size)
    ash.x = x
    ash.y = y
    transition.to(ash,{time=1200*(15-size) + 6000, y = 4600+display.contentHeight/2, onComplete=function() ash:removeSelf() end})
end

function SpawnFireEggImage(egg)
    local fireEggImage = display.newImageRect(BackgroundGroup, "assets/fireegg.png", 380 / 8, 380 / 4)
    BackgroundGroup:insert(15+iceLimit+lavaLimit,fireEggImage)
    fireEggImage.rotation = egg.rotation + 180
    egg.fireEggImage = fireEggImage
    egg.alpha = 0.0
    local vX, vY = egg:getLinearVelocity()
    fireEggImage.x = egg.x
    fireEggImage.y = egg.y
    transition.to(fireEggImage,{time = fireEggLifeTime*(937),x = fireEggImage.x + vX*fireEggLifeTime, y = fireEggImage.y + vY*fireEggLifeTime})
end

return Decor