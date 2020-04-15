local player = {} -- this and the return statement at the end make this file behave somewhat like a class

local iceSlideSound = audio.loadSound("audio/IceSlide.mp3")
local eggThrowSound = audio.loadSound("audio/EggThrowSound.wav")
local audioChannelSelect = 1

local UserInteface = require("scripts.UI")
PlayerSpeed = 10
local playerProjectileSpeed = 800--change fireEggSpeed in Decor.lua, global variable won't work so two variable needed
local invincibilityTime = 3 -- Time in seconds the player should be invincible after being hit
local blinkSpeed = 2 --Speed at which player blinks when taken damage
local counter = invincibilityTime * blinkSpeed -- used in invincibility animation
local projectileLifetime = 3 -- Time in seconds before a projectile goes disappears after being shot
local upButton = "w"
local downButton = "s"
local leftButton = "a"
local rightButton = "d"

local playerImage

local pressUp = false
local pressDown = false
local pressLeft = false
local pressRight = false
local mouseX = 0
local mouseY = 0
local mouseRotation = 0
local clickReady = true

local pushActive = false
local pushAmount = 0
local pushX = 0
local pushY = 0
local pushFrame = 0

local slideActive = false
local slideSpeed = 0
local lakeWidth = 0
local slideInitialX = 0
local slideInitialY = 0

Health = 5
local isInvincible = false
EggCapacity = 50
EgginInv = 20
Explosion = false
ExplosionX = 0
ExplosionY = 0

function player.start()
    local self = setmetatable({}, player)
    Cursor = display.newImageRect(ForegroundGroup, "assets/cursor.png", 100, 100)
    Cursor.alpha = 0.65
    playerImage = display.newImageRect(BackgroundGroup, "assets/player.png", 150, 150)
    BackgroundGroup:insert(21+lavaLimit+iceLimit,playerImage)
    print(BackgroundGroup.numChildren-12-iceLimit-lavaLimit)
    Physics.addBody(playerImage, "dynamic", {radius = 85})
    playerImage.myName = "player"
    playerImage.x = display.contentCenterX
    playerImage.y = display.contentCenterY
    Runtime:addEventListener("enterFrame", player.enterFrame)
    playerImage.collision = player.collisionEvent
    playerImage:addEventListener("collision")
end

function player.collisionEvent(self, event)
    if event.phase == "began" then
        if event.other.myName == "coop" then
            if(event.other.ammo > 0)then
                if EggCapacity-EgginInv < event.other.ammo then
                    event.other.ammo = event.other.ammo - EggCapacity+EgginInv
                    EgginInv = EggCapacity
                    UserInteface.updateEggs()
                else
                    EgginInv = EgginInv + event.other.ammo
                    UserInteface.updateEggs()
                    event.other.ammo = 0
                    event.other.eggImage:removeSelf()
                end
            end
        end
    end
end

function player.getPosition()
    return playerImage.x, playerImage.y
end

function player.throwProjectile()
    audio.play(eggThrowSound,{channel = 2+audioChannelSelect, loops = 0, duration = 400, fadeIn = 10})
    if audioChannelSelect == 3 then
        audioChannelSelect = 1
    else
        audioChannelSelect = audioChannelSelect + 1
    end
    local newProjectile = display.newImageRect(BackgroundGroup, "assets/egg.png", 300 / 8, 380 / 8)
    BackgroundGroup:insert(21+iceLimit+lavaLimit,newProjectile)
    Physics.addBody(newProjectile, "dynamic", {isSensor=true})
    newProjectile.isBullet = true -- makes collision detection "continuous" (more accurate)
    newProjectile.myName = "playerProjectile" -- also used for collision detection
    newProjectile.x = playerImage.x
    newProjectile.y = playerImage.y
    newProjectile.isFireEgg = false
    newProjectile.rotation = playerImage.rotation
    local angle = math.rad(newProjectile.rotation - 90) -- use the projectile's direction to see which way it should go
    newProjectile:setLinearVelocity(math.cos(angle) * playerProjectileSpeed, math.sin(angle) * playerProjectileSpeed)
    EgginInv = EgginInv - 1
    UserInteface.updateEggs()
    newProjectile.despawnTimer = timer.performWithDelay(projectileLifetime * 1000, function() newProjectile:removeSelf() if(newProjectile.isFireEgg == true) then newProjectile.fireEggImage:removeSelf() end end, 1)
end

function player.handleMovement(event)
    local phase = event.phase
    local name = event.keyName
    local keyState = false
    if phase == "down" then keyState = true end
    if name == upButton then
        pressUp = keyState
    elseif name == downButton then
        pressDown = keyState
    elseif name == leftButton then
        pressLeft = keyState
    elseif name == rightButton then
        pressRight = keyState
    end
end

function player.handleMouse(event)
    mouseX = event.x
    mouseY = event.y
    if not(mouseX == display.contentCenterX and mouseY == display.contentCenterY) then
        mouseRotation = math.atan((mouseY-display.contentCenterY)/ (mouseX-display.contentCenterX))
        Cursor.x = mouseX
        Cursor.y = mouseY
        if (mouseX < display.contentCenterX) then
            Cursor.rotation = math.deg(mouseRotation)+180
            Cursor.yScale = -1
        else
            Cursor.rotation = math.deg(mouseRotation)
            Cursor.yScale = 1
        end
        if (event.isPrimaryButtonDown) then
            if (clickReady) and EgginInv > 0 then
                player.throwProjectile()
                clickReady = false
            end
        else
            clickReady = true
        end
    end
end

local runtime = 0
local function getDeltaTime() -- Calculate the "Delta Time" (Time between frames)
    local time = system.getTimer() -- Time since the program started
    local deltaTime = (time - runtime) / (1000 / 60)
    runtime = time
    return deltaTime
end

function player.enterFrame()
    local dt = getDeltaTime() -- Incorporating the Delta Time into the player speed makes the player go the same speed regardless of the framerate
    if pressUp == true and (playerImage.y - 64) > LevelBoundTop then
        BackgroundGroup.y = BackgroundGroup.y + (PlayerSpeed * dt)
    end
    if pressDown == true and (playerImage.y + 64) < LevelBoundBottom then
        BackgroundGroup.y = BackgroundGroup.y - (PlayerSpeed * dt)
    end
    if pressLeft == true and (playerImage.x - 64) > LevelBoundLeft then
        BackgroundGroup.x = BackgroundGroup.x + (PlayerSpeed * dt)
    end
    if pressRight == true and (playerImage.x + 64) < LevelBoundRight then
        BackgroundGroup.x = BackgroundGroup.x - (PlayerSpeed * dt)
    end
    -- Update player rotation
    local adjMouseX, adjMouseY = BackgroundGroup:contentToLocal(mouseX, mouseY)
    playerImage.rotation = math.deg(math.atan2(playerImage.y - adjMouseY, playerImage.x - adjMouseX)) - 90
    -- Apply push / ice slide if one is active
    if slideActive then
        BackgroundGroup.x = BackgroundGroup.x + (slideSpeed * pushX)
        BackgroundGroup.y = BackgroundGroup.y + (slideSpeed * pushY)
        if math.sqrt(math.pow(slideInitialX - playerImage.x,2) + math.pow(slideInitialY - playerImage.y,2)) - 150 > lakeWidth or playerImage.x <= LevelBoundLeft or playerImage.x >= LevelBoundRight or playerImage.y <= LevelBoundTop or playerImage.y >= LevelBoundBottom then
            slideActive = false
            PlayerSpeed = 10
        end
    end
    if pushActive and pushFrame < 30 then
        if playerImage.x <= LevelBoundLeft or playerImage.x >= LevelBoundRight or playerImage.y <= LevelBoundTop or playerImage.y >= LevelBoundBottom then
            pushFrame = 29
        end
        BackgroundGroup.x = BackgroundGroup.x + (pushAmount * pushX)
        BackgroundGroup.y = BackgroundGroup.y + (pushAmount * pushY)
        pushAmount = pushAmount - (pushAmount / 30)
        pushFrame = pushFrame + 1
    elseif pushFrame >= 30 and pushActive then
        pushFrame = 0
        pushActive = false
        PlayerSpeed = 10
    end
    -- Force the player to be in the middle of the screen at all times
    playerImage.x, playerImage.y = BackgroundGroup:contentToLocal(display.contentCenterX, display.contentCenterY)

    if(Explosion) then
        Explosion = false
        for i=1,18 do
            local explosion = display.newImageRect(BackgroundGroup, "assets/blank.png", 120, 120)
            explosion.x = ExplosionX
            explosion.y = ExplosionY
            Physics.addBody(explosion, "dynamic", {radius=10, isSensor=true})
            local angle = math.pi/9 * (i-1)
            explosion:setLinearVelocity(math.cos(angle)*675, math.sin(angle)*675)
            explosion.myName = "explosion"
            explosion.timer = timer.performWithDelay(400, function() explosion:removeSelf() end, 1)
        end
    end
end

function player.damage(damageAmount)
    if not isInvincible then
        local hurt = Health - damageAmount
        while not (Health == 0) and not (hurt == Health) do
        Health = Health - 1
        UserInteface.updatehearts(false)
        end
        if Health <= 0 then
            print("you are dead") -- need to add death
            return
        end
        isInvincible = true
        player.fadeOut()
        counter = invincibilityTime * blinkSpeed
    end
end

function player.fadeOut()
    counter = counter-1
    if(not(counter == 0)) then
        transition.fadeOut(playerImage, {time = (1000/(blinkSpeed*2)), onComplete = function() transition.fadeIn(playerImage, {time = 1000/(blinkSpeed*2), onComplete = player.fadeOut}) end})
    else
        isInvincible = false
    end
end

function player.push(_pushAmount, _pushX, _pushY)
    pushAmount = _pushAmount
    pushX = _pushX
    pushY = _pushY
    pushActive = true
    PlayerSpeed = 2
end

function player.slideOnIce(_slideSpeed, _pushX, _pushY, _lakeWidth)
    audio.play(iceSlideSound,{channel = 8, loops = 0, duration = 1100})
    slideSpeed = _slideSpeed
    pushX = _pushX
    pushY = _pushY
    lakeWidth = _lakeWidth
    slideActive = true
    slideInitialX = playerImage.x
    slideInitialY = playerImage.y
    PlayerSpeed = 2
end

return player