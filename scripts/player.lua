local player = {} -- this and the return statement at the end make this file behave somewhat like a class

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
local clickReady = true

Health = 5
local isInvincible = false
EggCapacity = 50
EgginInv = 50

function player.start()
    Cursor = display.newImageRect(ForegroundGroup, "assets/cursor.png", 50, 50)
    playerImage = display.newImageRect(BackgroundGroup, "assets/player.png", 150, 150)
    BackgroundGroup:insert(5+lavaLimit+iceLimit,playerImage)
    print(BackgroundGroup.numChildren-12-iceLimit-lavaLimit)
    Physics.addBody(playerImage, "dynamic", {radius = 85})
    playerImage.myName = "player"
    playerImage.x = display.contentCenterX
    playerImage.y = display.contentCenterY
    Runtime:addEventListener("enterFrame", player.enterFrame)
end

function player.getPosition()
    return playerImage.x, playerImage.y
end

function player.throwProjectile()
    local newProjectile = display.newImageRect(BackgroundGroup, "assets/egg.png", 300 / 8, 380 / 8)
    BackgroundGroup:insert(5+iceLimit+lavaLimit,newProjectile)
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
    Cursor.x = mouseX
    Cursor.y = mouseY
    if (event.isPrimaryButtonDown) then
        if (clickReady) and EgginInv > 0 then
            player.throwProjectile()
            clickReady = false
        end
    else
        clickReady = true
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
    -- Force the player to be in the middle of the screen at all times
    playerImage.x, playerImage.y = BackgroundGroup:contentToLocal(display.contentCenterX, display.contentCenterY)
    -- Update player rotation
    local adjMouseX, adjMouseY = BackgroundGroup:contentToLocal(mouseX, mouseY)
    playerImage.rotation = math.deg(math.atan2(playerImage.y - adjMouseY, playerImage.x - adjMouseX)) - 90
end

function player.damage(damageAmount)
    if not isInvincible then
        Health = Health - damageAmount
        if Health <= 0 then
            print("you are dead") -- need to add death
            return
        end
        UserInteface.updatehearts(false)
        isInvincible = true
        PlayerFadeOut(counter)
        isInvincible = true
        counter = invincibilityTime * blinkSpeed
    end
end

function PlayerFadeOut()
    counter = counter-1
    if(not(counter == 0)) then
        transition.fadeOut(playerImage, {time = (1000/(blinkSpeed*2)), onComplete = function() transition.fadeIn(playerImage, {time = 1000/(blinkSpeed*2), onComplete = PlayerFadeOut}) end})
    else
        isInvincible = false
    end
end

return player