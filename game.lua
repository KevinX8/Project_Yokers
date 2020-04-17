local composer = require("composer")
local scene = composer.newScene()
local timer = 0

local options = require("main-menu.options")
options.SetDifficulty()
Physics = require("physics")
Player = require("scripts.player")
local enemy = require("scripts.enemy")
Decor = require("scripts.Decor")
local UserInteface = require("scripts.UI")
native.setProperty("windowMode", "fullscreen")
BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
ForegroundGroup = display.newGroup() -- Holds all UI
LevelObjects = {} -- Holds level objects (coops, ice lakes, etc.) in the form {x, y, size}

LevelBoundTop = display.contentCenterY - 1536
LevelBoundBottom = display.contentCenterY + 1536
LevelBoundLeft = display.contentCenterX - 1536
LevelBoundRight = display.contentCenterX + 1536
Score = 0
Level = 1
EnemyAmount = 0
EnemyLimit = 50

local newLevelSound = audio.loadSound("audio/newLevel.mp3")
local music = audio.loadSound("audio/music.mp3")--Original music composed, performed, and recorded by Thomas Greaney for the purpose of the game

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
    coop.health = InitialCoopHealth
    coop.healthBorder = display.newRoundedRect(BackgroundGroup, coop.x, coop.y-40, 158 ,58, 10)
    coop.healthGray = display.newRoundedRect(BackgroundGroup, coop.x, coop.y-40, 150 ,50, 10)
    coop.healthImage = display.newRoundedRect(BackgroundGroup, coop.x, coop.y-40, 150 ,50, 10)
    coop.healthImage:setFillColor( 232/255, 14/255, 14/255)
    coop.healthGray:setFillColor(116/255,7/255,7/255)
    coop.healthBorder:setFillColor(0)
    coop.invincible = false
    coop.isActive = false
end

local function addCoop(x, y, number)
    local coop = display.newImageRect(BackgroundGroup, "assets/coop.png", 512, 512)
    coop.ammo = 0
    coop.number = number --refrence points for the minimap
    BackgroundGroup:insert(15, coop)
    coop.x = x
    coop.y = y
    Physics.addBody(coop, "static")
    coop.myName = "coop"
    addCoopHealth(coop)
    table.insert(LevelObjects, {x, y, 512})
    return coop
end

local coop1 = addCoop(0, 0, 5)
local coop2 = addCoop(1000, 1300, 6)
local coop3 = addCoop(3800, 300, 7)
local coop4 = addCoop(4850, 1400, 8)
local coop5 = addCoop(0, -3072, 1)
local coop6 = addCoop(1000, -1772, 2)
local coop7 = addCoop(3800, -2772, 3)
local coop8 = addCoop(4850, -1672, 4)
local coop9 = addCoop(0, 3072, 9)
local coop10 = addCoop(3072, 2772, 10)
local coop11 = addCoop(5072,3072, 11)
local coop12 = addCoop(3072, 4372, 12)

Coops = {coop1, coop2}
CoopsAlive = 2
coop1.isActive = true
coop2.isActive = true

local function addCoopToGame(coop)
    CoopsAlive = CoopsAlive + 1
    Coops[CoopsAlive] = coop
    coop.isActive = true
end

local function removeCoopFromGame(coop)
    UserInteface.deletecoop(coop.number)
    if CoopsAlive > 0 then
        for i =1, CoopsAlive do
            if coop.x == Coops[i].x and coop.y == Coops[i].y then
                Coops[i]:removeSelf()
                Coops[i].healthBorder:removeSelf()
                Coops[i].healthGray:removeSelf()
                Coops[i].healthImage:removeSelf()
                if Coops[i].ammo > 0 then
                    Coops[i].eggImage:removeSelf()
                end
                for i=i, (CoopsAlive-1) do
                    Coops[i] = Coops[i+1]
                end
                CoopsAlive = CoopsAlive - 1
                if(CoopsAlive <= 0) and PlayerActive then
                    transition.pause()
                    Physics.pause() --stops crashing lol
                    PlayerActive = false
                    UserInteface.deathscreen()
                end
            end
        end
    end
end

function CoopDamage(coop, damageAmount)
    UserInteface.updatecoopscreen(coop.number)
    coop.health = coop.health - damageAmount
    coop.healthImage.width = coop.health / InitialCoopHealth * 150
    if coop.health < 1 then
        removeCoopFromGame(coop)
    end
end

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
audio.play(music, {channel = 1, loops = -1, duration = 660000})
Player.start()
UserInteface.InitialiseUI()
TimeLoaded = system.getTimer()

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
        if(Level == 3 and pickrandomedge == 0 and math.random() <  0.8) then
            pickrandomedge = math.random(1,3)
        elseif(Level == 4 and pickrandomedge == 1 and math.random() < 0.8)then
            pickrandomedge = math.random(0,2)
            if not pickrandomedge == 0 then
                pickrandomedge = pickrandomedge+1
            end
        end
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
        addCoopToGame(coop3)
        addCoopToGame(coop4)
        EnemyLimit = EnemyLimit+25
        timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        timer.performWithDelay(TimeDifficulty, progressLevel, 1)
        EggCapacity = EggCapacity*1.5
        UserInteface.updateEggs()
        MinPlayerAccuracy = MinPlayerAccuracy+0.05
    elseif Level == 2 then
        transition.to(IceWallRight, {time = 3000, rotation = IceWallRight.rotation+90, alpha = 0.2, onComplete = function() IceWallRight:removeSelf() end})
        transition.to(IceWallLeft, {time = 3000, rotation = IceWallLeft.rotation-90, alpha = 0.2, onComplete = function() IceWallLeft:removeSelf() end})
        LevelBoundTop = display.contentCenterY - 1536 - 3072
        Level = 3
        TimeDifficulty = TimeDifficulty + TimeIncrease
        addCoopToGame(coop5)
        addCoopToGame(coop6)
        addCoopToGame(coop7)
        addCoopToGame(coop8)
        EnemyLimit =  EnemyLimit+50
        timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        timer.performWithDelay(TimeDifficulty, progressLevel, 1)
        MaxEggsPerEnemy = 3
        EggCapacity = EggCapacity+EggCapacity/3
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
        addCoopToGame(coop9)
        addCoopToGame(coop10)
        addCoopToGame(coop11)
        addCoopToGame(coop12)
        EggCapacity = EggCapacity+EggCapacity/4
        UserInteface.updateEggs()
        MinPlayerAccuracy = MinPlayerAccuracy+0.05
        timer.performWithDelay(TimeDifficulty, enemy.boss, 0)
    end
end

EnemySpawner = timer.performWithDelay(math.random(MinTimeBetweenWaves, MaxTimeBetweenWaves), spawnEnemyWave, 0)
ProgessTimer = timer.performWithDelay(TimeDifficulty, progressLevel, 1)
TimeUI = timer.performWithDelay(100, UserInteface.updatetime, 0)

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

local function closeGame()
           native.requestExit()
        end

local function goToGame()
           composer.gotoScene("game")
        end
 
local function goToOptions()
           composer.gotoScene("main-menu.optionsMenu")
        end

function pauseGame(event)

 local phase = event.phase
    local name = event.keyName
    local keyState = false
    if phase == "down" then keyState = true end
    if name == pauseKey and keyState then
		physics.pause()
		audio.pause()
		transition.pause()
		timer.cancel(TimeUI)
		timer.cancel(ProgressTimer)
		timer.cancel(EnemySpawner)
		display.add(uiPause)
		display.remove(ForegroundGroup)
		display.remove(timemImage)
		display.remove(timesImage)
		display.remove(currentLevel)
		display.remove(sImage)
		display.remove(eggCounter)
  
		pauseMenuBackground.alpha = 1
		pause.alpha = 0
		newGame:addEventListener("tap", goToGame)
		newGame.alpha = 1
		resume:addEventListener("tap", resumeGame)
		resume.alpha = 1
		options:addEventListener("tap", goToOptions)
		options.alpha = 1
		quit:addEventListener("tap", closeGame)
		quit.alpha = 1
     end
  end

Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)

function resumeGame(event)
  physics.start()
  audio.start()
  transition.start()
  timer.start(TimeUI)
  timer.start(ProgressTimer)
  timer.start(EnemySpawner)
  display.remove(uiPause)
  display.add(ForegroundGroup)
  display.add(timemImage)
  display.add(timesImage)
  display.add(currentLevel)
  display.add(sImage)
  display.add(eggCounter)
  
  pauseMenuBackground.alpha = 0
  pause.alpha = 1
  newGame:removeEventListener("tap", gotoGame)
  newGame.alpha = 0
  resume:removeEventListener("tap", resumeGame)
  resume.alpha = 0
  options:removeEventListener("tap", gotoOptions)
  options.alpha = 0
  quit:removeEventListener("tap", closeGame)
  quit.alpha = 0
  
end

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
