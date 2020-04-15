local composer = require("composer")
local scene = composer.newScene()

Physics = require("physics")
Player = require("scripts.player")
local enemy = require("scripts.enemy")
Decor = require("scripts.Decor")
local UserInteface = require("scripts.UI")
local options = require("main-menu.options")
native.setProperty("windowMode", "fullscreen")
BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI
LevelObjects = {} -- Holds level objects (coops, ice lakes, etc.) in the form {x, y, size}

LevelBoundTop = display.contentCenterY - 1536
LevelBoundBottom = display.contentCenterY + 1536
LevelBoundLeft = display.contentCenterX - 1536
LevelBoundRight = display.contentCenterX + 1536
Level = 1
options.SetDifficulty("debug")
EnemyAmount = 0
EnemyLimit = 50
CoopInvincibilityTime = 1000

local newLevelSound = audio.loadSound("audio/newLevel.mp3")
local music = audio.loadSound("audio/music.mp3")

local muteSoundEffects = "m"
local mutedEffects = false
local muteMusic = "n"
local musicIsMuted = false

Physics.start()
Physics.setGravity(0, 0)

math.randomseed(os.time())

local L2BgImage = display.newImageRect(BackgroundGroup, "assets/sandBackground.png", 3072, 3072)
BackgroundGroup:insert(1,L2BgImage)
L2BgImage.x = display.contentCenterX + 3072
L2BgImage.y = display.contentCenterY

local L1BgImage = display.newImageRect(BackgroundGroup, "assets/farmBackground.png", 3072, 3072)
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

for i=1, 3 do
    local seaSideImageLeft = display.newImageRect(BackgroundGroup, "assets/seaCropped.png", 1536, 3072)
    BackgroundGroup:insert(5,seaSideImageLeft)
    seaSideImageLeft.x = -1344
    seaSideImageLeft.y = display.contentCenterY-3072+((i-1)*3072)
    local seaSideImageRight = display.newImageRect(BackgroundGroup, "assets/seaCropped.png", 1536, 3072)
    BackgroundGroup:insert(5,seaSideImageRight)
    seaSideImageRight.x = 6336
    seaSideImageRight.y = display.contentCenterY-3072+((i-1)*3072)
end

for i =1, 2 do
    local seaImageTop = display.newImageRect(BackgroundGroup, "assets/seaHorizontalCropped.png", 4608, 768)
    BackgroundGroup:insert(5,seaImageTop)
    seaImageTop.x = (i-1)*4608
    seaImageTop.y = display.contentCenterY - 4992
    local seaImageBottom = display.newImageRect(BackgroundGroup, "assets/seaHorizontalCropped.png", 4608, 768)
    BackgroundGroup:insert(5,seaImageBottom)
    seaImageBottom.x = (i-1)*4608
    seaImageBottom.y = display.contentCenterY + 4992
end

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
    coop.invincible = false
end

function CoopDamage(coop, damageAmount)
    if coop.invincible == true then
        return
    end
    coop.health = coop.health - damageAmount
    coop.healthImage.width = coop.health / 6.6666666667
    coop.invincible = true
    timer.performWithDelay(CoopInvincibilityTime, function() coop.invincible = false end, 1)
end

local function addCoop(x, y)
    local coop = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
    coop.ammo = 0
    BackgroundGroup:insert(15, coop)
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

SandwallTop = display.newImageRect(BackgroundGroup, "assets/sandwall.png", 102, 3072)
SandwallTop.x = display.contentCenterX + 1585
SandwallTop.y = display.contentCenterY - 1536
SandwallBottom = display.newImageRect(BackgroundGroup, "assets/sandwall.png", 102, 3072)
SandwallBottom.x = display.contentCenterX + 1585
SandwallBottom.y = display.contentCenterY + 1536
SandwallBottom.rotation = SandwallBottom.rotation+180
IceWallRight = display.newImageRect(BackgroundGroup, "assets/icewall.png", 6144, 102)
IceWallRight.x = display.contentCenterX +4608
IceWallRight.y = display.contentCenterY - 1587
IceWallLeft = display.newImageRect(BackgroundGroup, "assets/icewall.png", 6144, 102)
IceWallLeft.x = display.contentCenterX - 1534
IceWallLeft.y = display.contentCenterY - 1587
IceWallLeft.rotation = IceWallLeft.rotation+180
LavaWallRight = display.newImageRect(BackgroundGroup, "assets/lavawall.png", 6144, 102)
LavaWallRight.x = display.contentCenterX +4608
LavaWallRight.y = display.contentCenterY + 1587
LavaWallLeft = display.newImageRect(BackgroundGroup, "assets/lavawall.png", 6144, 102)
LavaWallLeft.x = display.contentCenterX - 1534
LavaWallLeft.y = display.contentCenterY + 1587
LavaWallLeft.rotation = LavaWallLeft.rotation+180
BackgroundGroup:insert(15, SandwallTop)
BackgroundGroup:insert(15, SandwallBottom)
BackgroundGroup:insert(15, IceWallRight)
BackgroundGroup:insert(15, IceWallLeft)
BackgroundGroup:insert(15, LavaWallRight)
BackgroundGroup:insert(15, LavaWallLeft)

Decor.generateDecor()
native.setProperty( "mouseCursorVisible", false )
audio.play(music, {channel = 1, loops = 0, duration = 660000})
Player.start()
UserInteface.InitialiseUI()

local function displayArrow()
    local arrow = display.newImageRect("assets/arrow.png", 500, 102)
    ForegroundGroup:insert(1, arrow)
    arrow.x = display.contentCenterX
    arrow.y = display.contentCenterY
    audio.play(newLevelSound,{channel = 6, loops = 0, duration = 800})
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
        transition.to(SandwallTop, {time = 2000, rotation = SandwallTop.rotation-90, alpha = 0.2, onComplete = function() SandwallTop:removeSelf() end})
        transition.to(SandwallBottom, {time = 2000, rotation = SandwallBottom.rotation+90, alpha = 0.2, onComplete = function() SandwallBottom:removeSelf() end})
        LevelBoundRight = display.contentCenterX + 1536 + 3072
        Level = 2
        TimeDifficulty = TimeDifficulty + TimeIncrease
        Coops = {coop1, coop2, coop3, coop4}
        EnemyLimit = EnemyLimit+25
        timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        timer.performWithDelay(TimeDifficulty, progressLevel, 1)
        EggCapacity = EggCapacity +10
        UserInteface.updateEggs()
        MinPlayerAccuracy = MinPlayerAccuracy+0.05
    elseif Level == 2 then
        transition.to(IceWallRight, {time = 3000, rotation = IceWallRight.rotation+90, alpha = 0.2, onComplete = function() IceWallRight:removeSelf() end})
        transition.to(IceWallLeft, {time = 3000, rotation = IceWallLeft.rotation-90, alpha = 0.2, onComplete = function() IceWallLeft:removeSelf() end})
        LevelBoundTop = display.contentCenterY - 1536 - 3072
        Level = 3
        TimeDifficulty = TimeDifficulty + TimeIncrease
        Coops = {coop1, coop2, coop3, coop4, coop5, coop6, coop7, coop8}
        EnemyLimit =  EnemyLimit+50
        timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        timer.performWithDelay(TimeDifficulty, progressLevel, 1)
        MaxEggsPerEnemy = 3
        EggCapacity = EggCapacity +10
        UserInteface.updateEggs()
        MinPlayerAccuracy = MinPlayerAccuracy+0.05
    elseif Level == 3 then
        transition.to(LavaWallRight, {time = 3000, rotation = LavaWallRight.rotation-90, alpha = 0.2, onComplete = function() LavaWallRight:removeSelf() end})
        transition.to(LavaWallLeft, {time = 3000, rotation = LavaWallLeft.rotation+90, alpha = 0.2, onComplete = function() LavaWallLeft:removeSelf() end})
        LevelBoundBottom = display.contentCenterY + 1536 + 3072
        Level = 4
        TimeDifficulty = TimeDifficulty + TimeIncrease
        EnemyLimit = EnemyLimit + 50
        timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        Coops = {coop1, coop2, coop3, coop4, coop5, coop6, coop7, coop8, coop9, coop10, coop11, coop12}
        EggCapacity = EggCapacity +10
        UserInteface.updateEggs()
        MinPlayerAccuracy = MinPlayerAccuracy+0.05
    end
end

timer.performWithDelay(math.random(MinTimeBetweenWaves, MaxTimeBetweenWaves), spawnEnemyWave, 0)
timer.performWithDelay(TimeDifficulty, progressLevel, 1)
timer.performWithDelay(100, UserInteface.updatetime, 0)

local function keyEvent(event)
    Player.handleMovement(event)
    MuteSound(event)
end

local function mouseEvent(event)
    Player.handleMouse(event)
end

function MuteSound(event)
    local phase = event.phase
    local name = event.keyName
    local keyState = false
    if phase == "down" then keyState = true end
    if name == muteSoundEffects and keyState then
        if(mutedEffects) then
            audio.setVolume(1.0,{})
        else
            audio.setVolume(0.0,{})
        end
        if(musicIsMuted) then
            audio.setVolume(0.0,{channel = 1})
        else
            audio.setVolume(1.0,{channel = 1})
        end
        mutedEffects = not(mutedEffects)
    elseif name == muteMusic and keyState then
        if(musicIsMuted) then
            audio.setVolume(1.0,{channel = 1})
        else
            audio.setVolume(0.0,{channel = 1})
        end
        musicIsMuted = not(musicIsMuted)
    end
end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)

function scene:show(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
    elseif (phase == "did") then

    end
end

function scene:hide(event)
    local sceneGroup = self.view
    local phase = event.phase

    if (phase == "will") then
       
    elseif (phase == "did") then
   
    end
end

function scene:destroy(event)
    local sceneGroup = self.view
   
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
