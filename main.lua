Physics = require("physics")
local player = require("scripts.player")
local enemy = require("scripts.enemy")
local Decor = require("scripts.Decor")

BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI

LevelBoundTop = display.contentCenterY - 1536
LevelBoundBottom = display.contentCenterY + 1536
LevelBoundLeft = display.contentCenterX - 1536
LevelBoundRight = display.contentCenterX + 1536
Level = 1
TimeDifficulty = 6000
EnemiesPerWave = 5
MinTimeBetweenWaves = 5000
MaxTimeBetweenWaves = 10000
EnemyAmount = 0
EnemyLimit = 50

Physics.start()
Physics.setGravity(0, 0)

math.randomseed(os.time())

local L1BgImage = display.newImageRect(BackgroundGroup, "assets/background.png", 3072, 3072)
BackgroundGroup:insert(1,L1BgImage)
L1BgImage.x = display.contentCenterX
L1BgImage.y = display.contentCenterY

local L2BgImage = display.newImageRect(BackgroundGroup, "assets/SandBackground.png", 3072, 3072)
BackgroundGroup:insert(2,L2BgImage)
L2BgImage.x = display.contentCenterX + 3072
L2BgImage.y = display.contentCenterY

local coop1 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(4,coop1)
coop1.x = 0
coop1.y = 0
Physics.addBody(coop1, "static")
coop1.myName = "coop"
local coop2 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(4,coop2)
coop2.x = 1000
coop2.y = 1300
Physics.addBody(coop2, "static")
coop2.myName = "coop"
local coop3 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(4,coop3)
coop3.x = 3800
coop3.y = 300
Physics.addBody(coop3, "static")
coop3.myName = "coop"
local coop4 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(4,coop4)
coop4.x = 4850
coop4.y = 1400
Physics.addBody(coop4, "static")
coop4.myName = "coop"
coops = {coop1, coop2}

Decor.level1()
player.start()

local function displayArrow()
    local arrow = display.newImageRect("assets/arrow.png", 500, 102)
    ForegroundGroup:insert(1, arrow)
    arrow.x = display.contentCenterX
    arrow.y = display.contentCenterY
    if Level == 3 then
        arrow.rotation = arrow.rotation - 90
    elseif Level == 4 then
        arrow.rotation = arrow.rotation + 90
    end
    arrow.despawnTimer = timer.performWithDelay(500, function() arrow:removeSelf() end, 1)
end

local function spawnNewEnemy()
    if EnemyAmount < EnemyLimit then
    local pickrandomedge = math.random(0,3)    
        if pickrandomedge == 0 then 
            local EnemyX = math.random(LevelBoundLeft, LevelBoundRight)
            local i = 0
            repeat
                enemy.new(player, coops, EnemyX, LevelBoundBottom + 540) 
                EnemyAmount = EnemyAmount + 1
                i = i + 1
            until i >= EnemiesPerWave
        end
        if pickrandomedge == 1 then 
            local EnemyX = math.random(LevelBoundLeft, LevelBoundRight)
            local i = 0
            repeat
                enemy.new(player, coops, EnemyX, LevelBoundTop - 540) 
                EnemyAmount = EnemyAmount + 1
                i = i + 1
            until i >= EnemiesPerWave
        end
        if pickrandomedge == 2 then 
            local EnemyY = math.random(LevelBoundTop, LevelBoundBottom)
            local i = 0
            repeat
                enemy.new(player, coops, LevelBoundRight + 960, EnemyY)
                EnemyAmount = EnemyAmount + 1
                i = i + 1
            until i >= EnemiesPerWave   
        end
        if pickrandomedge == 3 then 
            local EnemyY = math.random(LevelBoundTop, LevelBoundBottom)
            local i = 0
            repeat
                enemy.new(player, coops, LevelBoundLeft - 960, EnemyY) 
                EnemyAmount = EnemyAmount + 1
                i = i + 1
            until i >= EnemiesPerWave 
        end
    end    
end

local function progressLevel()
    if Level == 1 then
        LevelBoundRight = display.contentCenterX + 1536 + 3072
        Level = 2
        coops = {coop1, coop2, coop3, coop4}
        timer.performWithDelay(1000, displayArrow, 5)
    elseif Level == 2 then
        LevelBoundTop = display.contentCenterY - 1536 - 3072
        Level = 3
        timer.performWithDelay(1000, displayArrow, 5)
    elseif Level == 3 then
        LevelBoundBottom = display.contentCenterY + 1536 + 3072
        Level = 4
        timer.performWithDelay(1000, displayArrow, 5)
    end
end

timer.performWithDelay(math.random(MinTimeBetweenWaves,MaxTimeBetweenWaves), spawnNewEnemy, 0) -- Spawn new enemy every 2 seconds
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
