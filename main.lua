Physics = require("physics")
Player = require("scripts.player")
local enemy = require("scripts.enemy")
local Decor = require("scripts.Decor")

native.setProperty("windowMode", "fullscreen")
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

local L3BgImage = display.newImageRect(BackgroundGroup, "assets/full snow background.png", 6144, 3072)
BackgroundGroup:insert(3,L3BgImage)
L3BgImage.x = display.contentCenterX + 1536
L3BgImage.y = display.contentCenterY - 3072

local coop1 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop1)
coop1.x = 0
coop1.y = 0
Physics.addBody(coop1, "static")
coop1.myName = "coop"
local coop2 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop2)
coop2.x = 1000
coop2.y = 1300
Physics.addBody(coop2, "static")
coop2.myName = "coop"
local coop3 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop3)
coop3.x = 3800
coop3.y = 300
Physics.addBody(coop3, "static")
coop3.myName = "coop"
local coop4 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop4)
coop4.x = 4850
coop4.y = 1400
Physics.addBody(coop4, "static")
coop4.myName = "coop"
local coop5 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop5)
coop5.x = 0
coop5.y = -3072
Physics.addBody(coop5, "static")
coop5.myName = "coop"
local coop6 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop6)
coop6.x = 1000
coop6.y = -1772
Physics.addBody(coop6, "static")
coop6.myName = "coop"
local coop7 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop7)
coop7.x = 3800
coop7.y = -2772
Physics.addBody(coop7, "static")
coop7.myName = "coop"
local coop8 = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
BackgroundGroup:insert(5,coop8)
coop8.x = 4850
coop8.y = -1672
Physics.addBody(coop8, "static")
coop8.myName = "coop"
Coops = {coop1, coop2}

Decor.generateDecor()
native.setProperty( "mouseCursorVisible", false )
Player.start()

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

local function spawnEnemyWave()
    if EnemyAmount < EnemyLimit then
        local pickrandomedge = math.random(0,3)
        local enemyX
        local enemyY
        if pickrandomedge == 0 then
            enemyX = math.random(LevelBoundLeft, LevelBoundRight)
            enemyY = LevelBoundBottom + 540
        elseif pickrandomedge == 1 then
            enemyX = math.random(LevelBoundLeft, LevelBoundRight)
            enemyY = LevelBoundTop - 540
        elseif pickrandomedge == 2 then
            enemyX = LevelBoundRight + 960
            enemyY = math.random(LevelBoundTop, LevelBoundBottom)
        elseif pickrandomedge == 3 then
            enemyX = LevelBoundLeft - 960
            enemyY = math.random(LevelBoundTop, LevelBoundBottom)
        end
        local i = 0
        repeat
            enemy.new(enemyX, enemyY)
            EnemyAmount = EnemyAmount + 1
            i = i + 1
        until i >= EnemiesPerWave
    end
end

local function progressLevel()
    if Level == 1 then
        LevelBoundRight = display.contentCenterX + 1536 + 3072
        Level = 2
        Coops = {coop1, coop2, coop3, coop4}
        timer.performWithDelay(1000, displayArrow, 5)
    elseif Level == 2 then
        LevelBoundTop = display.contentCenterY - 1536 - 3072
        Level = 3
        Coops = {coop1, coop2, coop3, coop4, coop5, coop6, coop7, coop8}
        timer.performWithDelay(1000, displayArrow, 5)
    elseif Level == 3 then
        LevelBoundBottom = display.contentCenterY + 1536 + 3072
        Level = 4
        timer.performWithDelay(1000, displayArrow, 5)
    end
end

timer.performWithDelay(math.random(MinTimeBetweenWaves, MaxTimeBetweenWaves), spawnEnemyWave, 0)
timer.performWithDelay(TimeDifficulty, progressLevel, 3)

local function keyEvent(event)
    Player.handleMovement(event)
end

local function mouseEvent(event)
    Player.handleMouse(event)
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)
