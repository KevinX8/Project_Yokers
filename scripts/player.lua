local class = {}; -- this and the return statement at the end make this file behave somewhat like a class

local playerSpeed = 10
local playerProjectileSpeed = 800
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

function class.start()
    playerImage = display.newImageRect(BackgroundGroup, "assets/player.png", 128, 128)
    Physics.addBody(playerImage, "dynamic")
    playerImage.x = display.contentCenterX
    playerImage.y = display.contentCenterY
    Runtime:addEventListener("enterFrame", class.enterFrame)
end

function class.getPosition()
    return playerImage.x, playerImage.y
end

function class.throwProjectile()
    local newProjectile = display.newImageRect(BackgroundGroup, "assets/egg.png", 300 / 8, 380 / 8)
    Physics.addBody(newProjectile, "dynamic", {isSensor=true})
    newProjectile.isBullet = true -- makes collision detection "continuous" (more accurate)
    newProjectile.myName = "playerProjectile" -- also used for collision detection
    newProjectile.x = playerImage.x
    newProjectile.y = playerImage.y
    newProjectile.rotation = playerImage.rotation
    local angle = math.rad(newProjectile.rotation - 90) -- use the projectile's direction to see which way it should go
    newProjectile:setLinearVelocity(math.cos(angle) * playerProjectileSpeed, math.sin(angle) * playerProjectileSpeed)
end

function class.handleMovement(event)
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

function class.handleMouse(event)
    mouseX = event.x
    mouseY = event.y
    class.updateRotation()
    if (event.isPrimaryButtonDown) then
        if (clickReady) then
            class.throwProjectile()
            clickReady = false
        end
    else
        clickReady = true
    end
end

function class.updateRotation()
    local adjMouseX, adjMouseY = BackgroundGroup:contentToLocal(mouseX, mouseY)
    playerImage.rotation = math.deg(math.atan2(playerImage.y - adjMouseY, playerImage.x - adjMouseX)) - 90
end

local runtime = 0
local function getDeltaTime() -- Calculate the "Delta Time" (Time between frames)
    local time = system.getTimer() -- Time since the program started
    local deltaTime = (time - runtime) / (1000 / 60)
    runtime = time
    return deltaTime
end

function class.enterFrame()
    dt = getDeltaTime()
    if pressUp == true then
        BackgroundGroup.y = BackgroundGroup.y + (playerSpeed * dt)
    end
    if pressDown == true then
        BackgroundGroup.y = BackgroundGroup.y - (playerSpeed * dt)
    end
    if pressLeft == true then
        BackgroundGroup.x = BackgroundGroup.x + (playerSpeed * dt)
    end
    if pressRight == true then
        BackgroundGroup.x = BackgroundGroup.x - (playerSpeed * dt)
    end
    -- Force the player to be in the middle of the screen at all times
    playerImage.x, playerImage.y = BackgroundGroup:contentToLocal(display.contentCenterX, display.contentCenterY)
end

return class