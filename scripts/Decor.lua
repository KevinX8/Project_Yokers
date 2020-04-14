local Decor = {}
local fireEggSpeed = 800
local fireEggLifeTime = 3
local fireEggAudio = audio.loadSound("audio/Ignition.wav")
local channelSelect = 0

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
        BackgroundGroup:insert(21,bush)
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
        BackgroundGroup:insert(21, cactus)
        Physics.addBody(cactus, "dynamic", {radius=120, density=999999999.0})
        cactus.x = math.random(LevelBoundLeft + 350,LevelBoundRight - 128)+2872
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
        BackgroundGroup:insert(21, iceLake)
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
        BackgroundGroup:insert(21, lavaLake)
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
                local pushX = -1 * (event.target.x - event.other.x)
                local pushY = -1 * (event.target.y - event.other.y)
                Player.slideOnIce(0.075, pushX, pushY, event.target.width)
            end
        elseif (event.other.myName == "player" or event.other.myName == "enemy") and (event.target.myName == "cactus" or event.target.myName == "lavaLake") then
            local pushAmount
            if(event.target.myName == "cactus") then
                pushAmount = 0.1
            else
                pushAmount = 0.05
            end
            local pushX = (event.target.x - event.other.x)
            local pushY = (event.target.y - event.other.y)
            if event.other.myName == "player" then
                Player.damage(1)
                Player.push(pushAmount, pushX, pushY)
            elseif event.other.myName == "enemy" then
                event.other.instance:push(pushAmount, pushX, pushY)
            end
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
        end
    end
end

 function Decor.enterFrame()
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
    audio.play(fireEggAudio,{channel = 10+channelSelect, loops = 0, duration = 900})
    BackgroundGroup:insert(21+iceLimit+lavaLimit,fireEggImage)
    fireEggImage.rotation = egg.rotation + 180
    egg.fireEggImage = fireEggImage
    egg.alpha = 0.0
    local vX, vY = egg:getLinearVelocity()
    fireEggImage.x = egg.x
    fireEggImage.y = egg.y
    if channelSelect == 2 then
        channelSelect = 0
    else
        channelSelect = channelSelect + 1
    end
    transition.to(fireEggImage,{time = fireEggLifeTime*(937),x = fireEggImage.x + vX*fireEggLifeTime, y = fireEggImage.y + vY*fireEggLifeTime})
end

function Decor.SparkExplosion(xValue, yValue)
    for i=1,200 do
        local size = math.random(3, 6)
        local sparkExplosion = display.newImageRect(BackgroundGroup, "assets/spark.png", size, size)
        local angle = math.random(0, 4*math.pi)
        local distance = math.random(-30,30)
        local offsetX = distance*math.cos(angle)
        local offsetY = distance*math.sin(angle)
        sparkExplosion.x = xValue + offsetX
        sparkExplosion.y = yValue + offsetY
        transition.to(sparkExplosion,{time = 400, x = xValue+11*(offsetX), y = yValue+11*(offsetY), onComplete = function() sparkExplosion:removeSelf() end}) --onComplete = sparkExplosion:removeSelf()})
    end
end

return Decor