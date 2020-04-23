local composer = require("composer")
local game = composer.newScene()
Physics = require("physics")
Player = require("scripts.player")
local enemy = require("scripts.enemy")
Decor = require("scripts.Decor")
local UserInteface = require("scripts.UI")
local options = require("main-menu.options")
local newLevelSound
local music
local coop1
local coop2
local coop3
local coop4
local coop5
local coop6
local coop7
local coop8
local coop9
local coop10
local coop11
local coop12
local muteSoundEffects = "m"
local mutedEffects = false
local muteMusic = "n"
local musicIsMuted = false
local L2BgImage
local L1BgImage
local L3BgImage
local L4BgImage
local pauseKey
local arrowTimer
local arrowDespawnTimer
local mainMusic
local menuMusic
TimePauseD = 0
PlayerActive = false

local function keyEvent(event)
    Player.handleMovement(event)
    PauseGame(event)
    MuteSound(event)
end

local function mouseEvent(event)
    Player.handleMouse(event)
end
        
Runtime:addEventListener("key", keyEvent)
Runtime:addEventListener("mouse", mouseEvent)

function CalculateDistance(object1x, object1y, object2x, object2y) -- Calculates the distance between 2 positions
    return math.sqrt(((object1x - object2x) ^ 2) + ((object1y - object2y) ^ 2))
end

local function addCoopHealth(coop)
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
                Coops[i].isActive = false
                Coops[i]:removeSelf()
                Coops[i].healthBorder:removeSelf()
                Coops[i].healthGray:removeSelf()
                Coops[i].healthImage:removeSelf()
                if Coops[i].ammo > 0 then
                    display.remove(Coops[i].eggImage)
                end
                local brokenCoop = display.newImageRect(BackgroundGroup, "assets/brokenCoop.png", 512, 512)
                BackgroundGroup:insert(21+IceLimit+LavaLimit,brokenCoop)
                brokenCoop.x = coop.x
                brokenCoop.y = coop.y
                BrokenCoops = BrokenCoops + 1
                for i=i, (CoopsAlive-1) do
                    Coops[i] = Coops[i+1]
                end
                CoopsAlive = CoopsAlive - 1
                if(CoopsAlive <= 0) and PlayerActive then
                    enemy.nukeEnemies()
                    transition.pause()
                    timer.performWithDelay(100,function() Physics.pause() end,1) --stops crashing lol
                    PlayerActive = false
                    UserInteface.deathscreen(system.getTimer() - TimeLoaded - TimePauseD, true)
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

local function displayArrow()
    if PlayerActive then
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
        arrowDespawnTimer = timer.performWithDelay(500, function() arrow:removeSelf() end, 1)
    end
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

local function closeGame()
           native.requestExit()
        end
        
local function goToOptions()
           composer.showOverlay("main-menu.optionsMenu")
        end

local function goToMenu()
    ForegroundGroup:removeSelf()
    UserInteface.deathscreen(0, false)
    UserInteface.removeDeathScreen()
    enemy.nukeEnemies()
    display.remove(RetMenuImage)
    composer.removeScene("game")
    composer.gotoScene("menu")
end

function game:create()
    InGame = true
    mutedEffects = false
    musicIsMuted = false
    composer.removeScene("menu")
    menuMusic = audio.play(MenuMusic,{channel = 15, loops = -1, duration = 600000})
    audio.pause(menuMusic)
    options.SetDifficulty()
    native.setProperty("windowMode", "fullscreen")
    BackgroundGroup = display.newGroup() -- Holds all the objects that scroll (background, enemies, projectiles etc.) as well as the player
    ForegroundGroup = display.newGroup() -- Holds all UI
    LevelObjects = {} -- Holds level objects (coops, ice lakes, etc.) in the form {x, y, size}
    BrokenCoops = 0

    LevelBoundTop = display.contentCenterY - 1536
    LevelBoundBottom = display.contentCenterY + 1536
    LevelBoundLeft = display.contentCenterX - 1536
    LevelBoundRight = display.contentCenterX + 1536
    Score = 0
    Level = 1
    EnemyAmount = 0
    EnemyLimit = 50

    newLevelSound = audio.loadSound("audio/NewLevel.mp3")
    music = audio.loadSound("audio/Music.mp3")--Original music composed, performed, and recorded by Thomas Greaney for the purpose of the game

    pauseKey = "escape"

    Physics.start()
    Physics.setGravity(0, 0)

    math.randomseed(os.time())

    L2BgImage = display.newImageRect(BackgroundGroup, "assets/SandBackground.png", 3072, 3072)
    BackgroundGroup:insert(1,L2BgImage)
    L2BgImage.x = display.contentCenterX + 3072
    L2BgImage.y = display.contentCenterY

    L1BgImage = display.newImageRect(BackgroundGroup, "assets/farmBackground.png", 3072, 3072)
    BackgroundGroup:insert(1,L1BgImage)
    L1BgImage.x = display.contentCenterX
    L1BgImage.y = display.contentCenterY

    L3BgImage = display.newImageRect(BackgroundGroup, "assets/full snow background.png", 6144, 3072)
    BackgroundGroup:insert(3,L3BgImage)
    L3BgImage.x = display.contentCenterX + 1536
    L3BgImage.y = display.contentCenterY - 3072

    L4BgImage = display.newImageRect(BackgroundGroup, "assets/LavaBackground.png", 6144, 3072)
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

    coop1 = addCoop(0, 0, 5)
    coop2 = addCoop(1000, 1300, 6)
    coop3 = addCoop(3800, 300, 7)
    coop4 = addCoop(4850, 1400, 8)
    coop5 = addCoop(0, -3072, 1)
    coop6 = addCoop(1000, -1772, 2)
    coop7 = addCoop(3800, -2772, 3)
    coop8 = addCoop(4850, -1672, 4)
    coop9 = addCoop(0, 3072, 9)
    coop10 = addCoop(3072, 2772, 10)
    coop11 = addCoop(3072,4372, 11)
    coop12 = addCoop(5072, 3072, 12)

    Coops = {coop1, coop2}
    CoopsAlive = 2
    coop1.isActive = true
    coop2.isActive = true

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
    mainMusic = audio.play(music, {channel = 1, loops = -1, duration = 1320000})
    UserInteface.InitialiseUI()
    TimeLoaded = system.getTimer()

    EnemySpawner = timer.performWithDelay(math.random(MinTimeBetweenWaves, MaxTimeBetweenWaves), spawnEnemyWave, 0)
    ProgressTimer = timer.performWithDelay(TimeDifficulty, ProgressLevel, 1)
    TimeUI = timer.performWithDelay(100, UserInteface.updatetime, 0)
    BackgroundGroup.x = 0
    BackgroundGroup.y = 0
    Player.start()
end


function ProgressLevel()
    if Level == 1 then
        transition.to(SandwallTop, {time = 2000, rotation = SandwallTop.rotation-90, alpha = 0.2, onComplete = function() SandwallTop:removeSelf() end})
        transition.to(SandwallBottom, {time = 2000, rotation = SandwallBottom.rotation+90, alpha = 0.2, onComplete = function() SandwallBottom:removeSelf() end})
        LevelBoundRight = display.contentCenterX + 1536 + 3072
        Level = 2
        TimeDifficulty = TimeDifficulty + TimeIncrease
        addCoopToGame(coop3)
        addCoopToGame(coop4)
        EnemyLimit = EnemyLimit+25
        arrowTimer = timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        ProgressTimer = timer.performWithDelay(TimeDifficulty, ProgressLevel, 1)
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
        arrowTimer = timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        ProgressTimer = timer.performWithDelay(TimeDifficulty, ProgressLevel, 1)
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
        arrowTimer = timer.performWithDelay(1000, displayArrow, 4)
        UserInteface.updateLevelDisp()
        addCoopToGame(coop9)
        addCoopToGame(coop10)
        addCoopToGame(coop11)
        addCoopToGame(coop12)
        EggCapacity = EggCapacity+EggCapacity/4
        UserInteface.updateEggs()
        MinPlayerAccuracy = MinPlayerAccuracy+0.05
        ProgressTimer = timer.performWithDelay(TimeDifficulty, function() SpawnBoss = true end, 0)
    end
end

function PauseGame(event)
 local phase = event.phase
    local name = event.keyName
    local keyState = false
    if phase == "down" then keyState = true end
    if name == pauseKey and keyState and PlayerActive then
		Physics.pause()
        transition.pause()
        TimePauseD = TimePauseD - system.getTimer()
        native.setProperty( "mouseCursorVisible", true )
        timer.pause(TimeUI)
        timer.pause(ProgressTimer)
        timer.pause(EnemySpawner)
        PlayerActive = false
        UserInteface.pauseButtonMenuButtons()
        audio.resume(menuMusic)
        audio.pause(mainMusic)

		RetMenuImage:addEventListener("tap", goToMenu)
		ResumeGameImage:addEventListener("tap", ResumeGame)
		OptionsImage:addEventListener("tap", goToOptions)
		QuitImage:addEventListener("tap", closeGame)
   end
end

function ResumeGame(event)
    TimePauseD = TimePauseD + system.getTimer()
    ResumeGameImage.text = ""
    OptionsImage.text = ""
    QuitImage.text = ""
    RetMenuImage.text = ""
    audio.pause(menuMusic)
    composer.hideOverlay()
    RetMenuImage:removeEventListener("tap", goToMenu)
    ResumeGameImage:removeEventListener("tap", ResumeGame)
    OptionsImage:removeEventListener("tap", goToOptions)
    QuitImage:removeEventListener("tap", closeGame)
    Physics.start()
    audio.resume(mainMusic)
    transition.resume()
    native.setProperty( "mouseCursorVisible", false )
    PlayerActive = true

    timer.resume(TimeUI)
    timer.resume(ProgressTimer)
    timer.resume(EnemySpawner)
  --display.remove(NewGameImage)
end

function MuteSound(event)
    local phase = event.phase
    local name = event.keyName
    local keyState = false
    if phase == "down" then keyState = true end
    if name == muteSoundEffects and keyState then
        if(mutedEffects and (not(Muted))) then
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

function game:show(event)--function looks like it does nothing, but coronas composer doesnt work without it lol.
end

function game:destroy(event)
    if (not arrowDespawnTimer == nil) then
    timer.cancel(arrowDespawnTimer)
    end
    if (not arrowTimer == nil) then
    timer.cancel(arrowTimer)
    end
    timer.cancel(EnemySpawner)
    timer.cancel(ProgressTimer)
    timer.cancel(TimeUI)
    if not (Blink == nil) then
    timer.cancel(Blink)
    end
    Decor.removeEnterFrame()
    Player.removeEnterFrame()
    UserInteface.removeDeathScreen()
    timer.performWithDelay(100, function() display.remove(BackgroundGroup) end, 1)
    audio.stop(mainMusic)
    display.remove(ResumeGameImage)
    ResumeGameImage = nil
    display.remove(OptionsImage)
    display.remove(QuitImage)
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
game:addEventListener("create", game)
game:addEventListener("show", game)
game:addEventListener("hide", game)
game:addEventListener("destroy", game)
-- -----------------------------------------------------------------------------------

return game
