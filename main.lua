Physics = require("physics")
Player = require("scripts.player")
local enemy = require("scripts.enemy")
local Decor = require("scripts.Decor")
local UserInteface = require("scripts.UI")

native.setProperty("windowMode", "fullscreen")
BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI
LevelObjects = {} -- Holds level objects (coops, ice lakes, etc.) in the form {x, y, size}

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

local L2BgImage = display.newImageRect(BackgroundGroup, "assets/SandBackground.png", 3072, 3072)
BackgroundGroup:insert(1,L2BgImage)
L2BgImage.x = display.contentCenterX + 3072
L2BgImage.y = display.contentCenterY

local L1BgImage = display.newImageRect(BackgroundGroup, "assets/background.png", 3072, 3072)
BackgroundGroup:insert(1,L1BgImage)
L1BgImage.x = display.contentCenterX
L1BgImage.y = display.contentCenterY

local L3BgImage = display.newImageRect(BackgroundGroup, "assets/full snow background.png", 6144, 3072)
BackgroundGroup:insert(3,L3BgImage)
L3BgImage.x = display.contentCenterX + 1536
L3BgImage.y = display.contentCenterY - 3072

local L4BgImage = display.newImageRect(BackgroundGroup, "assets/LavaBackground.png", 6144, 3072)
BackgroundGroup:insert(4,L4BgImage)
L4BgImage.x = display.contentCenterX + 1536
L4BgImage.y = display.contentCenterY + 3072

function CalculateDistance(object1x, object1y, object2x, object2y) -- Calculates the distance between 2 positions
    return math.sqrt(((object1x - object2x) ^ 2) + ((object1y - object2y) ^ 2))
end

function addCoopHealth(coop)
    coop.health = 1000
    coop.healthBorder = display.newRoundedRect(BackgroundGroup, coop.x, coop.y-40, 158 ,58, 10)
    coop.healthGray = display.newRoundedRect(BackgroundGroup, coop.x, coop.y-40, 150 ,50, 10)
    coop.healthImage = display.newRoundedRect(BackgroundGroup, coop.x, coop.y-40, 150 ,50, 10)
    coop.healthImage:setFillColor( 232/255, 14/255, 14/255)
    coop.healthGray:setFillColor(82/255,8/255,82/255)
    coop.healthBorder:setFillColor(0)
end    

local function addCoop(x, y)
    local coop = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
    BackgroundGroup:insert(5, coop)
    coop.x = x
    coop.y = y
    Physics.addBody(coop, "static")
    coop.myName = "coop"
    addCoopHealth(coop)
    table.insert(LevelObjects, {x, y, 512})
    return coop
end

local coop1 = addCoop(0, 0)
local coop2 = addCoop(1000, 1300)
local coop3 = addCoop(3800, 300)
local coop4 = addCoop(4850, 1400)
local coop5 = addCoop(0, -3072)
local coop6 = addCoop(1000, -1772)
local coop7 = addCoop(3800, -2772)
local coop8 = addCoop(4850, -1672)
local coop9 = addCoop(0, 3072)
local coop10 = addCoop(1000, 4372)
local coop11 = addCoop(3800, 3372)
local coop12 = addCoop(4850, 4472)
Coops = {coop1, coop2}

Decor.generateDecor()
native.setProperty( "mouseCursorVisible", false )
Player.start()
UserInteface.InitialiseUI()

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
        Coops = {coop1, coop2, coop3, coop4, coop5, coop6, coop7, coop8, coop9, coop10, coop11, coop12}
    end
end

timer.performWithDelay(math.random(MinTimeBetweenWaves, MaxTimeBetweenWaves), spawnEnemyWave, 0)
timer.performWithDelay(TimeDifficulty, progressLevel, 3)
timer.performWithDelay(100, UserInteface.updatetime, 0)

local function keyEvent(event)
    Player.handleMovement(event)
end

local function mouseEvent(event)
    Player.handleMouse(event)
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)
