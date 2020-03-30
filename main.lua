Physics = require("physics")
local player = require("scripts.player")
local enemy = require("scripts.enemy")

BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI

Physics.start()
Physics.setGravity(0, 0)

math.randomseed(os.time())

bgImage = display.newImageRect(BackgroundGroup, "assets/full background.png", 3072, 3072)
bgImage.x = display.contentCenterX
bgImage.y = display.contentCenterY

local coop1 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
coop1.x = 0
coop1.y = 0
Physics.addBody(coop1, "static")
local coop2 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
coop2.x = 1000
coop2.y = 1300
Physics.addBody(coop2, "static")
local coops = {coop1, coop2}

player.start()

local function spawnNewEnemy()
    enemy.new(player, coops, math.random(-1000, 1000), math.random(-1000, 1000))
end
timer.performWithDelay(2000, spawnNewEnemy, 0) -- Spawn new enemy every 2 seconds


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

local function keyEvent(event)
    player.handleMovement(event)
end

local function mouseEvent(event)
    player.handleMouse(event)
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)
