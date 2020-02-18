local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

math.randomseed(os.time())

local player = display.newImageRect("assets/player.png", 256, 256)
physics.addBody(player, "dynamic")
local playerSpeed = 250
player.x = display.contentCenterX
player.y = display.contentCenterY

local function key(event)
    local phase = event.phase
    local name = event.keyName
    local px, py = player:getLinearVelocity()
    if phase == "down" then
        if name == "w" then
            player:setLinearVelocity(px, -playerSpeed)
        elseif name == "s" then
            player:setLinearVelocity(px, playerSpeed)
        elseif name == "a" then
            player:setLinearVelocity(-playerSpeed, py)
        elseif name == "d" then
            player:setLinearVelocity(playerSpeed, py)
        end
    elseif phase == "up" then
        if name == "w" then
            player:setLinearVelocity(px, 0)
        elseif name == "s" then
            player:setLinearVelocity(px, 0)
        elseif name == "a" then
            player:setLinearVelocity(0, py)
        elseif name == "d" then
            player:setLinearVelocity(0, py)
        end
    end
end
Runtime:addEventListener("key", key)