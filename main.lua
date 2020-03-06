Physics = require("physics")
local player = require("scripts.player")
local enemy = require("scripts.enemy")

BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI

Physics.start()
Physics.setGravity(0, 0)

math.randomseed(os.time())

bgImage = display.newImageRect(BackgroundGroup, "assets/background.png", 3072, 3072)
bgImage.x = display.contentCenterX
bgImage.y = display.contentCenterY

player.start()
enemy.start(player)

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

--https://forums.coronalabs.com/topic/70000-dragging-a-sprite-between-display-groups/?p=364727
function MoveObjectTo( targetGroup, dispObject )
    local x, y = dispObject:localToContent( 0, 0 ) -- get location in world coords
    x, y = targetGroup:contentToLocal( x, y ) -- get world coords as local to target group
    targetGroup:insert( dispObject ) -- move display object to the target display group
    dispObject.x, dispObject.y = x, y -- reposition the display object to the position relative to it's original position
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)
