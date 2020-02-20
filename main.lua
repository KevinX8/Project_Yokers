local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

math.randomseed(os.time())

local player = display.newImageRect("assets/player.png", 256, 256)
physics.addBody(player, "dynamic")
local playerSpeed = 250
player.x = display.contentCenterX
player.y = display.contentCenterY
local pressUp = false
local pressDown = false
local pressLeft = false
local pressRight = false

local function key(event)
    local phase = event.phase
    local name = event.keyName
    local keyState = false
    local newXVelocity, newYVelocity = 0, 0
    if phase == "down" then keyState = true end
    if name == "w" then
        pressUp = keyState
    elseif name == "s" then
        pressDown = keyState
    elseif name == "a" then
        pressLeft = keyState
    elseif name == "d" then
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
    player:setLinearVelocity(newXVelocity, newYVelocity)
end
Runtime:addEventListener("key", key)