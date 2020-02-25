Physics = require("physics")
local player = require("scripts.player")

Physics.start()
Physics.setGravity(0, 0)

math.randomseed(os.time())

player.start()

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

local function MouseEvent(event)
    player.handleMouse(event)
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", MouseEvent)
