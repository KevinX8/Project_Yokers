local class = {};

local movementSpeed = 250

local player
local enemyImage
local aiState = "roaming"
local targetX = 0
local targetY = 0
local aiLoopTimer

--      AI States: 
-- roaming - Randomly wandering around.
-- attackCoop - Going after the closest chicken coop
-- attackPlayer - Going after the player
--      AI Transitions between States:
-- Roaming will become attackCoop after waiting a random amount of time
-- roaming/attackCoop will become attackPlayer if the player comes really close or if the player attacks
-- attackPlayer will become roaming if the player gets far away

function class.start(playerReference)
    enemyImage = display.newImageRect("assets/enemy.png", 128, 128)
    Physics.addBody(enemyImage, "dynamic")
    enemyImage.x = 200
    enemyImage.y = 200
    player = playerReference
    aiLoopTimer = timer.performWithDelay(33.333333, class.aiUpdate, 0) -- 33.3333 ms delay = 30 times a second, 0 means it will repeat forever
end

function class.aiUpdate() -- Called 30 times a second
    if aiState == "roaming" then
        if math.random(0, 200) == 0 then -- 1 in 200 chance, 30 times a second - on average will roam for 6 seconds
            aiState = "attackCoop"
            return
        end
        -- Generate random target position (todo)
    elseif aiState == "attackCoop" then
        -- add this when coops exist
        aiState = "attackPlayer" -- temporary
    elseif aiState == "attackPlayer" then
        targetX, targetY = player.getPosition()
    end
    -- Point towards the target position
    enemyImage.rotation = math.deg(math.atan2(enemyImage.y - targetY, enemyImage.x - targetX)) - 90
    -- Move towards the target position
    local angle = math.rad(enemyImage.rotation - 90)
    enemyImage:setLinearVelocity(math.cos(angle) * movementSpeed, math.sin(angle) * movementSpeed)
end

return class