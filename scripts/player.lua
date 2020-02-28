local class = {}; -- this and the return statement at the end make this file behave somewhat like a class

local playerSpeed = 400
local playerProjectileSpeed = 300
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
    playerImage = display.newImageRect("assets/player.png", 128, 128)
    Physics.addBody(playerImage, "dynamic")
    playerImage.x = display.contentCenterX
    playerImage.y = display.contentCenterY
end

function class.getPosition()
    return playerImage.x, playerImage.y
end

function class.throwProjectile()
    local newProjectile = display.newImageRect("assets/egg.png", 64, 64)
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
    local newXVelocity, newYVelocity = 0, 0
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
    if pressUp == true then
        newYVelocity = newYVelocity - playerSpeed
    end
    if pressDown == true then
        newYVelocity = newYVelocity + playerSpeed
    end
    if pressLeft == true then
        newXVelocity = newXVelocity - playerSpeed
    end
    if pressRight == true then
        newXVelocity = newXVelocity + playerSpeed
    end
    playerImage:setLinearVelocity(newXVelocity, newYVelocity)
    class.updateRotation()
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
    playerImage.rotation = math.deg(math.atan2(playerImage.y - mouseY, playerImage.x - mouseX)) - 90
end

return class