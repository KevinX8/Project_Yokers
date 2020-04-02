local player = {} -- this and the return statement at the end make this file behave somewhat like a class

local playerSpeed = 10
local playerProjectileSpeed = 800
local invincibilityTime = 1 -- Time in seconds the player should be invincible after being hit
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

local health = 100
local isInvincible = false

function player.start()
    playerImage = display.newImageRect(BackgroundGroup, "assets/player.png", 150, 150)
    BackgroundGroup:insert(2,playerImage)
    Physics.addBody(playerImage, "dynamic")
    playerImage.x = display.contentCenterX
    playerImage.y = display.contentCenterY
    Runtime:addEventListener("enterFrame", player.enterFrame)
end

function player.getPosition()
    return playerImage.x, playerImage.y
end

function player.throwProjectile()
    local newProjectile = display.newImageRect(BackgroundGroup, "assets/egg.png", 300 / 8, 380 / 8)
    BackgroundGroup:insert(2,newProjectile)
    Physics.addBody(newProjectile, "dynamic", {isSensor=true})
    newProjectile.isBullet = true -- makes collision detection "continuous" (more accurate)
    newProjectile.myName = "playerProjectile" -- also used for collision detection
    newProjectile.x = playerImage.x
    newProjectile.y = playerImage.y
    newProjectile.rotation = playerImage.rotation
    local angle = math.rad(newProjectile.rotation - 90) -- use the projectile's direction to see which way it should go
    newProjectile:setLinearVelocity(math.cos(angle) * playerProjectileSpeed, math.sin(angle) * playerProjectileSpeed)

    newProjectile.despawnTimer = timer.performWithDelay(projectileLifetime * 1000, function() newProjectile:removeSelf() end, 1)
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
    if (event.isPrimaryButtonDown) then
        if (clickReady) then
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
    local dt = getDeltaTime()
    if pressUp == true and (playerImage.y - 64) > LevelBoundTop then
        BackgroundGroup.y = BackgroundGroup.y + (playerSpeed * dt)
    end
    if pressDown == true and (playerImage.y + 64) < LevelBoundBottom then
        BackgroundGroup.y = BackgroundGroup.y - (playerSpeed * dt)
    end
    if pressLeft == true and (playerImage.x - 64) > LevelBoundLeft then
        BackgroundGroup.x = BackgroundGroup.x + (playerSpeed * dt)
    end
    if pressRight == true and (playerImage.x + 64) < LevelBoundRight then
        BackgroundGroup.x = BackgroundGroup.x - (playerSpeed * dt)
    end
    -- Force the player to be in the middle of the screen at all times
    playerImage.x, playerImage.y = BackgroundGroup:contentToLocal(display.contentCenterX, display.contentCenterY)
    -- Update player rotation
    local adjMouseX, adjMouseY = BackgroundGroup:contentToLocal(mouseX, mouseY)
    playerImage.rotation = math.deg(math.atan2(playerImage.y - adjMouseY, playerImage.x - adjMouseX)) - 90
end

function player.damage(damageAmount)
    if not isInvincible then
        health = health - damageAmount
        if health <= 0 then
            print("u r ded") -- need to add death
        end
        isInvincible = true
        timer.performWithDelay(invincibilityTime * 1000, function() isInvincible = false end, 1)
    end
end

return player