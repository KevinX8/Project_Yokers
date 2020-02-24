local playerSpeed = 250
local playerProjectileSpeed = 300

local physics = require("physics")
physics.start()
physics.setGravity(0, 0)

math.randomseed(os.time())

local player = display.newImageRect("assets/player.png", 128, 128)
physics.addBody(player, "dynamic")
player.x = display.contentCenterX
player.y = display.contentCenterY
local pressUp = false
local pressDown = false
local pressLeft = false
local pressRight = false

--[[
local fill = script.Parent.Filler
local text = script.Parent.TextLabel
while wait() do
    local character = player.Character
    if character ~= nil then
        local chicken = character:FindFirstChild("living")
        if chicken ~= nil then
            character.living.MaxHealth = 100
            character.living.Health = MaxHealth - damage()
            fill:HealthSize(UDim2.new((chicken.Health/chicken.MaxHealth),0,1,0))
            text.Text = "HP: "..math.floor(chicken.Health).." / "..chicken.MaxHealth.." ["..math.floor((chicken.Health/chicken.MaxHealth)*100).."%]"
        end
    else
        text.Text = "NIL"
        fill:HealthSize(UDim2.new(0,0,1,0))
    end
end
--]]
--[[curHealth() 
  character.living.health

local enemy = 
local fill = script.Parent.Filler
local text = script.Parent.TextLabel
while wait() do
    local character = enemy.Character
    if character ~= nil then
        local zombie = character:FindFirstChild("undead")
        if zombie ~= nil then
            character.undead.MaxHealth = 50
            character.undead.Health = MaxHealth - damage()
            fill:HealthSize(UDim2.new((zombie.Health/zombie.MaxHealth),0,1,0))
            text.Text = "HP: "..math.floor(zombie.Health).." / "..zombie.MaxHealth.." ["..math.floor((zombie.Health/zombie.MaxHealth)*100).."%]"
        end
    else
        text.Text = "NIL"
        fill:HealthSize(UDim2.new(0,0,1,0))
    end
end
--]]

--[[damage() Have to make function so damage can 
//       actually be applied --]] 
    
local function throwProjectile()
    local newProjectile = display.newImageRect("assets/egg.png", 64, 64)
    physics.addBody(newProjectile, "dynamic", {isSensor=true})
    newProjectile.isBullet = true -- makes collision detection "continuous" (more accurate)
    newProjectile.myName = "playerProjectile" -- also used for collision detection
    newProjectile.x = player.x
    newProjectile.y = player.y
    newProjectile.rotation = player.rotation
    local angle = math.rad(newProjectile.rotation - 90) -- use the projectile's direction to see which way it should go
    newProjectile:setLinearVelocity(math.cos(angle) * playerProjectileSpeed, math.sin(angle) * playerProjectileSpeed)
end

local function keyEvent(event)
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

local function MouseEvent(event)
    player.rotation = math.deg(math.atan2(player.y - event.y, player.x - event.x)) - 90
    if (event.isPrimaryButtonDown) then
        throwProjectile()
    end
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", MouseEvent)
