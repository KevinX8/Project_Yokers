local enemy = {
    player = nil,
    enemyImage = nil,
    aiState = "roaming",
    targetX = 0,
    targetY = 0,
    aiLoopTimer = nil
}
enemy.__index = enemy
local movementSpeed = 250

--      AI States: 
-- roaming - Randomly wandering around.
-- attackCoop - Going after the closest chicken coop
-- attackPlayer - Going after the player
--      AI Transitions between States:
-- Roaming will become attackCoop after waiting a random amount of time
-- roaming/attackCoop will become attackPlayer if the player comes really close or if the player attacks
-- attackPlayer will become roaming if the player gets far away

function enemy.new(playerReference, startX, startY)
    local self = setmetatable({}, enemy) -- OOP in Lua is weird...

    self.enemyImage = display.newImageRect(BackgroundGroup, "assets/enemy.png", 128, 128)
    self.enemyImage.instance = self -- give the image a reference to this script instance for collisionEvent
    Physics.addBody(self.enemyImage, "dynamic")
    self.enemyImage.x = startX
    self.enemyImage.y = startY
    self.player = playerReference
    self.aiLoopTimer = timer.performWithDelay(33.333333, function() enemy.aiUpdate(self) end, 0) -- 33.3333 ms delay = 30 times a second, 0 means it will repeat forever
    self.enemyImage.collision = self.collisionEvent
    self.enemyImage:addEventListener("collision")

    return self
end

function enemy.collisionEvent(self, event)
    -- In this case, "self" refers to "enemyImage"
    if event.phase == "began" then
        if event.other.myName == "playerProjectile" then
            timer.cancel(self.instance.aiLoopTimer)
            timer.cancel(event.other.despawnTimer)
            event.other:removeSelf()
            self:removeSelf()
        end
    end
end

function enemy:aiUpdate() -- Called 30 times a second
    if self.aiState == "roaming" then
        if math.random(0, 200) == 0 then -- 1 in 200 chance, 30 times a second - on average will roam for 6 seconds
            self.aiState = "attackCoop"
            return
        end
        -- Generate random target position (todo)
    elseif self.aiState == "attackCoop" then
        -- add this when coops exist
        self.aiState = "attackPlayer" -- temporary
    elseif self.aiState == "attackPlayer" then
        self.targetX, self.targetY = self.player.getPosition()
    end
    -- Point towards the target position
    self.enemyImage.rotation = math.deg(math.atan2(self.enemyImage.y - self.targetY, self.enemyImage.x - self.targetX)) - 90
    -- Move towards the target position
    local angle = math.rad(self.enemyImage.rotation - 90)
    self.enemyImage:setLinearVelocity(math.cos(angle) * movementSpeed, math.sin(angle) * movementSpeed)
end

return enemy