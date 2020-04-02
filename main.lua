Physics = require("physics")
local player = require("scripts.player")
local enemy = require("scripts.enemy")

BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI

LevelBoundTop = display.contentCenterY - 1536
LevelBoundBottom = display.contentCenterY + 1536
LevelBoundLeft = display.contentCenterX - 1536
LevelBoundRight = display.contentCenterX + 1536
Level = 1
TimeDifficulty = 120000
EnemyAmount = 5
TimeBetweenWaves = 5000

Physics.start()
Physics.setGravity(0, 0)

math.randomseed(os.time())

local bgImage = display.newImageRect(BackgroundGroup, "assets/full background.png", 3072, 3072)
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
    local pickrandomedge = math.random(0,3)    
        if pickrandomedge == 0 then 
            local EnemyX = math.random(LevelBoundLeft, LevelBoundRight)
            local i = 0
            repeat
                enemy.new(player, coops, EnemyX, LevelBoundBottom - 540) 
                i = i + 1
            until i >= EnemyAmount
        end
        if pickrandomedge == 1 then 
            local EnemyX = math.random(LevelBoundLeft, LevelBoundRight)
            local i = 0
            repeat
                enemy.new(player, coops, EnemyX, LevelBoundTop + 540) 
                i = i + 1
            until i >= EnemyAmount
        end
        if pickrandomedge == 2 then 
            local EnemyY = math.random(LevelBoundTop, LevelBoundBottom)
            local i = 0
            repeat
                enemy.new(player, coops, LevelBoundRight + 960, EnemyY)
                i = i + 1
            until i >= EnemyAmount    
        end
        if pickrandomedge == 3 then 
            local EnemyY = math.random(LevelBoundTop, LevelBoundBottom)
            local i = 0
            repeat
                enemy.new(player, coops, LevelBoundLeft - 960, EnemyY) 
                i = i + 1
            until i >= EnemyAmount    
        end
end

local function progressLevel()
    if Level == 1 then
        LevelBoundRight = display.contentCenterX + 1536 + 3072
        Level = 2
    elseif Level == 2 then
        LevelBoundTop = display.contentCenterY - 1536 - 3072
        Level = 3
    elseif Level == 3 then
        LevelBoundBottom = display.contentCenterY + 1536 + 3072
    end
end

timer.performWithDelay(TimeBetweenWaves, spawnNewEnemy, 0) -- Spawn new enemy every 2 seconds
timer.performWithDelay(TimeDifficulty, progressLevel, 3)

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
