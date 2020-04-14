local enemy = {
    enemyImage = nil,
    aiState = "roaming",
    targetX = 0,
    targetY = 0,
    aiLoopTimer = nil,
    type = 0, -- 0 is normal, red is 1, blue is 2
    health = 1,
    pushActive = false,
    pushAmount = 0,
    pushX = 0,
    pushY = 0,
    pushFrame = 0,
    currentMovementSpeed = 0
}
enemy.__index = enemy
local movementSpeed = 250
local iceChickenAcceleratedSpeed = 600
local playerAttackDistance = 600 -- If the player comes closer than this distance, the enemy attacks
local playerForgetDistance = 900 -- If the player gets this far away, the enemy will forget about them and go back to the coops
local Decor = require("scripts.Decor")

--      AI States: 
-- roaming - Randomly wandering around.
-- attackCoop - Going after the closest chicken coop
-- attackPlayer - Going after the player
--      AI Transitions between States:
-- Roaming will become attackCoop after waiting a random amount of time
-- roaming/attackCoop will become attackPlayer if the player comes really close or if the player attacks
-- attackPlayer will become roaming if the player gets far away

function enemy.new(startX, startY)
    local self = setmetatable({}, enemy) -- OOP in Lua is weird...
    local pickred = math.random(9) + Level - 1
    local pickblue = math.random(19) + Level - 2
    if pickred > 9 then
        self.enemyImage = display.newImageRect(BackgroundGroup, "assets/redenemy.png", 93, 120)
        self.type = 1
        self.health = 1
    elseif pickblue > 19 then
        self.enemyImage = display.newImageRect(BackgroundGroup, "assets/blueenemy.png", 93, 120)
        self.type = 2
        self.health = 3
    else
        self.enemyImage = display.newImageRect(BackgroundGroup, "assets/enemy.png", 93, 120)
        self.type = 0
        self.health = 1
    end
    BackgroundGroup:insert(21+iceLimit+lavaLimit,self.enemyImage)
    self.enemyImage.instance = self -- give the image a reference to this script instance for collisionEvent
    Physics.addBody(self.enemyImage, "dynamic")
    self.enemyImage.myName = "enemy"
    self.enemyImage.x = startX
    self.enemyImage.y = startY
    self.currentMovementSpeed = movementSpeed
    self.aiLoopTimer = timer.performWithDelay(33.333333, function() enemy.aiUpdate(self) end, 0) -- 33.3333 ms delay = 30 times a second, 0 means it will repeat forever
    self.enemyImage.collision = self.collisionEvent
    self.enemyImage:addEventListener("collision")

    Runtime:addEventListener("enterFrame", function() enemy.enterFrame(self) end)

    self.targetX = math.random(LevelBoundLeft, LevelBoundRight) -- Generate an initial random target (enemy starts in "roaming" mode)
    self.targetY = math.random(LevelBoundTop, LevelBoundBottom)

    return self
end

function enemy.collisionEvent(self, event)
    -- In this case, "self" refers to "enemyImage"
    if event.phase == "began" then
        if event.other.myName == "playerProjectile" then
            if(event.other.isFireEgg) then
                event.other.fireEggImage:removeSelf()
                self.instance.health = 0
                Decor.SparkExplosion(event.other.x,event.other.y)
                Explosion = true
                ExplosionX = event.other.x
                ExplosionY = event.other.y
            else
                self.instance.health = self.instance.health - 1
            end
            timer.cancel(event.other.despawnTimer)
            event.other:removeSelf()
            local pushX = (event.other.x - event.target.x)
            local pushY = (event.other.y - event.target.y)
            self.instance:push(0.1, pushX, pushY)
        elseif event.other.myName == "cactus" or event.other.myName == "lavaLake" or event.other.myName == "explosion"then
            self.instance.health = self.instance.health - 1
            if event.other.myName == "explosion" then
                timer.cancel(event.other.timer)
                event.other:removeSelf()
            else
                if self.instance.type == 2 and event.other.myName == "lavaLake" then
                    self.instance.health = 0 -- blue chickens die instantly in lava
                end
                if self.instance.type == 1 and event.other.myName == "cactus" then
                    self.instance.health = self.instance.health + 1 -- red chickens are immune to cacti
                end
            end
        elseif event.other.myName == "iceLake" and self.instance.type == 2 then
            self.instance.currentMovementSpeed = iceChickenAcceleratedSpeed -- ice chickens move faster on ice lakes
        end
        if self.instance.health <= 0 then
            timer.cancel(self.instance.aiLoopTimer)
            EnemyAmount = EnemyAmount - 1
            self:removeSelf()
        end
    elseif event.phase == "ended" then
        if event.other.myName == "iceLake" and self.instance.type == 2 then
            self.instance.currentMovementSpeed = movementSpeed
        end
    end
end

function enemy:push(_pushAmount, _pushX, _pushY)
    self.pushAmount = _pushAmount
    self.pushX = _pushX
    self.pushY = _pushY
    self.pushActive = true
end

function enemy:enterFrame()
    if self.enemyImage.y == nil then -- chicken has already died
        return
    end

    -- Point towards the target position
    self.enemyImage.rotation = math.deg(math.atan2(self.enemyImage.y - self.targetY, self.enemyImage.x - self.targetX)) - 90
    -- Move towards the target position
    if not self.pushActive then
        local angle = math.rad(self.enemyImage.rotation - 90)
        self.enemyImage:setLinearVelocity(math.cos(angle) * self.currentMovementSpeed, math.sin(angle) * self.currentMovementSpeed)
    end

    if self.pushActive and self.pushFrame < 30 then
        if self.enemyImage.x <= LevelBoundLeft or self.enemyImage.x >= LevelBoundRight or self.enemyImage.y <= LevelBoundTop or self.enemyImage.y >= LevelBoundBottom then
            self.pushFrame = 29
        end
        self.enemyImage:setLinearVelocity(self.pushAmount * self.pushX * -40, self.pushAmount * self.pushY * -40)
        self.pushAmount = self.pushAmount - (self.pushAmount / 30)
        self.pushFrame = self.pushFrame + 1
    elseif self.pushFrame >= 30 and self.pushActive then
        self.pushFrame = 0
        self.pushActive = false
    end
end

function enemy:aiUpdate() -- Called 30 times a second
    local playerX, playerY = Player.getPosition()
    local playerDistance = CalculateDistance(self.enemyImage.x, self.enemyImage.y, playerX, playerY)
    if self.aiState == "roaming" then
        if math.random(0, 200) == 0 then -- 1 in 200 chance, 30 times a second - on average will roam for 6 seconds
            self.aiState = "attackCoop"
        end
        if playerDistance < playerAttackDistance then
            self.aiState = "attackPlayer"
        end
        if CalculateDistance(self.enemyImage.x, self.enemyImage.y, self.targetX, self.targetY) < 100 then
            -- When the enemy arrives at the target position, generate a new target position
            self.targetX = math.random(LevelBoundLeft, LevelBoundRight)
            self.targetY = math.random(LevelBoundTop, LevelBoundBottom)
        end
    elseif self.aiState == "attackCoop" then
        -- Find the closest coop to this enemy
        local lowestDistance = 100000
        local closestCoop = nil
        for i, coop in ipairs(Coops) do
            local distance = CalculateDistance(self.enemyImage.x, self.enemyImage.y, coop.x, coop.y)
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
        local playerDamage = 1
        if self.type == 1 then
            playerDamage = 2
        end
        Player.damage(playerDamage)
    end
end

return enemy