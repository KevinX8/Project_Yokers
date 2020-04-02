local enemy = {
    player = nil,
    enemyImage = nil,
    aiState = "roaming",
    targetX = 0,
    targetY = 0,
    aiLoopTimer = nil,
    coopList = {}
}
enemy.__index = enemy
local movementSpeed = 250
local playerDamage = 20
local playerAttackDistance = 400 -- If the player comes closer than this distance, the enemy attacks
local playerForgetDistance = 800 -- If the player gets this far away, the enemy will forget about them and go back to the coops

--      AI States: 
-- roaming - Randomly wandering around.
-- attackCoop - Going after the closest chicken coop
-- attackPlayer - Going after the player
--      AI Transitions between States:
-- Roaming will become attackCoop after waiting a random amount of time
-- roaming/attackCoop will become attackPlayer if the player comes really close or if the player attacks
-- attackPlayer will become roaming if the player gets far away

local function calculateDistance(object1x, object1y, object2x, object2y) -- Calculates the distance between 2 positions
    return math.sqrt(((object1x - object2x) ^ 2) + ((object1y - object2y) ^ 2))
end

function enemy.new(playerReference, coops, startX, startY)
    local self = setmetatable({}, enemy) -- OOP in Lua is weird...

    self.enemyImage = display.newImageRect(BackgroundGroup, "assets/enemy.png", 93, 120)
    self.enemyImage.instance = self -- give the image a reference to this script instance for collisionEvent
    Physics.addBody(self.enemyImage, "dynamic")
    self.enemyImage.x = startX
    self.enemyImage.y = startY
    self.player = playerReference
    self.coopList = coops
    self.aiLoopTimer = timer.performWithDelay(33.333333, function() enemy.aiUpdate(self) end, 0) -- 33.3333 ms delay = 30 times a second, 0 means it will repeat forever
    self.enemyImage.collision = self.collisionEvent
    self.enemyImage:addEventListener("collision")

    self.targetX = math.random(LevelBoundLeft, LevelBoundRight) -- Generate an initial random target (enemy starts in "roaming" mode)
    self.targetY = math.random(LevelBoundTop, LevelBoundBottom)

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
    local playerX, playerY = self.player.getPosition()
    local playerDistance = calculateDistance(self.enemyImage.x, self.enemyImage.y, playerX, playerY)
    if self.aiState == "roaming" then
        if math.random(0, 200) == 0 then -- 1 in 200 chance, 30 times a second - on average will roam for 6 seconds
            self.aiState = "attackCoop"
        end
        if playerDistance < playerAttackDistance then
            self.aiState = "attackPlayer"
        end
        if calculateDistance(self.enemyImage.x, self.enemyImage.y, self.targetX, self.targetY) < 100 then
            -- When the enemy arrives at the target position, generate a new target position
            self.targetX = math.random(LevelBoundLeft, LevelBoundRight)
            self.targetY = math.random(LevelBoundTop, LevelBoundBottom)
        end
    elseif self.aiState == "attackCoop" then
        -- Find the closest coop to this enemy
        local lowestDistance = 100000
        local closestCoop = nil
        for i, coop in ipairs(self.coopList) do
            local distance = calculateDistance(self.enemyImage.x, self.enemyImage.y, coop.x, coop.y)
            if distance < lowestDistance or closestCoop == nil then
                lowestDistance = distance
                closestCoop = coop
            end
        end
        if playerDistance < playerAttackDistance then
            self.aiState = "attackPlayer"
        end
        self.targetX = closestCoop.x
        self.targetY = closestCoop.y
    elseif self.aiState == "attackPlayer" then
        if playerDistance > playerForgetDistance then
            self.aiState = "attackCoop"
        end
        self.targetX = playerX
        self.targetY = playerY
    end

    if playerDistance < 150 then
        self.player.damage(playerDamage)
    end

    -- Point towards the target position
    self.enemyImage.rotation = math.deg(math.atan2(self.enemyImage.y - self.targetY, self.enemyImage.x - self.targetX)) - 90
    -- Move towards the target position
    local angle = math.rad(self.enemyImage.rotation - 90)
    self.enemyImage:setLinearVelocity(math.cos(angle) * movementSpeed, math.sin(angle) * movementSpeed)
end

return enemy