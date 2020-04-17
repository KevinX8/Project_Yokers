local userinterface = {}
--score = system.get(timer)--
Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)

local damageSound = audio.loadSound("audio/Damage Sound.wav")
local oneHeart = audio.loadSound("audio/OneHeart.mp3")

local livesText
local scoreText

local timemImage
local timesImage
local sImage
local currentLevel
local eggImage
local eggCounter
local fullHeart = false
local blinkTime = 300
local counter = 0
local blinkCoop = 3

local heart = {}
local coopicon = {}
Timeloaded = 0

function userinterface.InitialiseUI()
    i = 1
    repeat
        heart[i] = display.newImageRect(ForegroundGroup, "assets/fullheart.png", 96, 84)
        heart[i].y = display.contentCenterY - 440
        heart[i].x = display.contentCenterX - 1010 + (i * 120)
        heart[i].alpha = 0.7
        i = i + 1
    until i > MaxHearts
    local optionsm = {
        text = "0m",
        x = display.contentCenterX + 762,
        y = display.contentCenterY - 445,
        font = "assets/coolfont.fnt", -- vector font from: https://www.dafont.com/fipps.font converted to bitmap manually
        fontSize = 32,
        align = "centre"
    }
    local optionss = {
        text = "0",
        x = display.contentCenterX + 850,
        y = display.contentCenterY - 445,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
    }
    local optionssi = {
        text = "s",
        x = display.contentCenterX + 920,
        y = display.contentCenterY - 450,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
    }
    local optionse = {
        text = EgginInv.." / "..EggCapacity,
        x = display.contentCenterX - 790,
        y = display.contentCenterY + 390,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
    }
    local optionsl = {
        text = "Level 1",
        x = display.contentCenterX + 830,
        y = display.contentCenterY - 500,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
    }
    timemImage = Ponyfont.newText(optionsm)
    timesImage = Ponyfont.newText(optionss)
    currentLevel = Ponyfont.newText(optionsl)
    sImage = Ponyfont.newText(optionssi)
    eggImage = display.newImageRect(ForegroundGroup, "assets/egg.png", 37.5, 47.5)
    eggImage.x = display.contentCenterX - 920
    eggImage.y = display.contentCenterY + 400
    eggCounter = Ponyfont.newText(optionse)
    coopUImap = display.newImageRect(ForegroundGroup, "assets/map.png", 300, 350)
    coopUImap.alpha = 0.4
    coopUImap.x = display.contentCenterX + 800
    coopUImap.y = display.contentCenterY + 280
    local i = 1
    local startx = coopUImap.x - 120
    local starty = coopUImap.y - 130
    local offsety = 0
    local offsetx = 0
    repeat
    coopicon[i] = display.newImageRect(ForegroundGroup,"assets/coop icon.png", 40 , 40)
    coopicon[i].alpha = 0.9
    coopicon[i].x = startx + offsetx
    coopicon[i].y = starty + offsety
    coopicon[i].beingdamaged = false
    offsetx = offsetx + 80
    if i % 4 == 0 then
        offsetx = 0
        offsety = offsety + 130
    end
    i = i + 1
    until i > 12
end

function userinterface.updatehearts(added)
    if added and MaxHearts >= Health then
        if(Health == 2)then
            timer.cancel(Blink)
            heart[1]:removeSelf()
            heart[1] = display.newImageRect(ForegroundGroup, "assets/fullheart.png", 96, 84)
            heart[1].y = display.contentCenterY - 440
            heart[1].x = display.contentCenterX - 890
            heart[1].alpha = 0.7

        end
        heart[Health]:removeSelf()
        heart[Health] = display.newImageRect(ForegroundGroup, "assets/fullheart.png", 96, 84)
        heart[Health].y = display.contentCenterY - 440
        heart[Health].x = heart[Health - 1].x + 120
        heart[Health].alpha = 0.7
    elseif not added then
        audio.play(damageSound,{channel = 2, loops = 0, duration = 2000})
        local heartx = heart[Health + 1].x
        local hearty = heart[Health + 1].y
        local animationImage = heart[Health + 1]
        if Health == 0 then
            display.remove(animationImage)
            animationImage = display.newImageRect(ForegroundGroup, "assets/fullheart.png", 96, 84)
            animationImage.alpha = 0.7
            animationImage.y = display.contentCenterY - 440
            animationImage.x = display.contentCenterX - 890
            timer.cancel(Blink)
        end
        transition.to(animationImage,{time=2000, y = animationImage.y-200, alpha = 0.4, onComplete=function() animationImage:removeSelf() end})
        heart[Health + 1] = display.newImageRect(ForegroundGroup, "assets/emptyheart.png", 96, 84)
        heart[Health + 1].alpha = 0.7
        heart[Health + 1].x = heartx
        heart[Health + 1].y = hearty
        if(Health == 1) then
            fullHeart = true
            Blink = timer.performWithDelay(blinkTime, function() fullHeart = not(fullHeart) BlinkHealth() end, 0)
        end
   end
end 

function BlinkHealth()
    if PlayerActive then
        heart[1]:removeSelf()
        if(fullHeart) then
            heart[1] = display.newImageRect(ForegroundGroup, "assets/fullheart.png", 96, 84)
            audio.play(oneHeart,{loops = 0, channel = 7, duration = 550})
        else
            heart[1] = display.newImageRect(ForegroundGroup, "assets/emptyheart.png", 96, 84)
        end
        heart[1].alpha = 0.7
        heart[1].y = display.contentCenterY - 440
        heart[1].x = display.contentCenterX - 890
    end
end

function userinterface.updatetime()
    local timem = math.floor(((system.getTimer() - TimeLoaded) / 60000)) .. "m"
    local times = math.floor((((system.getTimer() - TimeLoaded) % 60000) /1000) *10) * 0.1
    timemImage.text = timem
    timesImage.text = times
end

function userinterface.updateEggs()
    if PlayerActive then
    eggCounter.text = EgginInv .. " / " .. EggCapacity
    end
end

function userinterface.updateLevelDisp()
    if PlayerActive then
    currentLevel.text = "Level " .. Level 
    end
end

function userinterface.deathscreen()
        local timeSurvived = system.getTimer() - TimeLoaded
        timer.cancel(TimeUI)
        timer.cancel(ProgessTimer)
        timer.cancel(EnemySpawner)
        display.remove(ForegroundGroup)
        local displayTime = timemImage.text .. " " .. timesImage.text .. "s"
        display.remove(timemImage)
        --timemImage.text = ""
        display.remove(timesImage)
        --timesImage.text = ""
        display.remove(currentLevel)
        --currentLevel.text = ""
        display.remove(sImage)
        display.remove(eggCounter)
        Score = (timeSurvived/100 + 100*Health + 80*CoopsAlive) * DifficultyScore
        local optionsD = {
            text = "Time Survived: " .. displayTime .. ". +" .. (timeSurvived/100)*DifficultyScore .. " points\nHealth Remaining: " .. Health .. ". +".. (100*Health)*DifficultyScore .. " points\nRemaining Coops: " .. CoopsAlive .. ". +" .. (80*CoopsAlive)*DifficultyScore .. " points\nDifficulty Multiplier : x"..DifficultyScore.."\nFinal Score: " .. Score .. " points",
            x = display.contentCenterX,
            y = display.contentCenterY,
            font = "assets/coolfont.fnt",
            fontSize = 32,
            align = "left"
        }
        Ponyfont.newText(optionsD)	
end

--[[ 
function goToPause(event)
	composer.gotoScene("menus.pause-menu", {effect = "crossFade", time = 500})
	end 

	 local pause = 
		 widget.newButton(
         {
         width = 40,
         height = 40,
         left = 25,
         top = 960,
         id = "pause",
         overFile = "main-menu/Images/pause.png",
         onEvent = goToPause
         }
       ) 
       --]]

function userinterface.updatecoopscreen(cooptoflash)
    counter = 2
    userinterface.coopfadeOut(coopicon[cooptoflash])
end

function userinterface.deletecoop(cooptodelete)
    display.remove(coopicon[cooptodelete])
end

function userinterface.coopfadeOut(flashme)
    counter = counter-1
    if(not(counter == 0) and flashme.beingdamaged == false) then
        flashme.beingdamaged = true
        transition.fadeOut(flashme, {time = (1000/(blinkCoop*2)), onComplete = function() transition.fadeIn(flashme, {time = 1000/(blinkCoop*2), onComplete = userinterface.coopfadeOut(flashme)}) end})
        timer.performWithDelay(1000, function() flashme.beingdamaged = false flashme.alpha = 0.7 end,1)
    end
end
--[[   
function userinterface.pauseButton()
	    local pause = {
	    display.newImageRect(ForegroundGroup, "main-menu/Images/pause.png", 70, 70)
        x = display.contentCenterX 
        y = 1000
        alpha = 1 
        onEvent = pauseGame
        }
     end
        
        pauseMenuBackground = display.newImageRect(uiPause, "main-menu/Images/Title_Screen.png", 1280, 720)
        pauseMenuBackground.x = display.contentCenterX
        pauseMenuBackground.y = display.contentCenterY
        pauseMenuBackground.alpha = 0 

        newGame = display.newImageRect(uiPause, "main-menu/Images/new_game.png", 289, 40)
        newGame.x = display.contentCenterX
        newGame.y = 630
        newGame.alpha = 0
 
        resume = display.newImageRect(uiPause, "main-menu/Images/resume_Game.png", 289, 40)
        resume.x = display.contentCenterX
        resume.y = 670
        resume.alpha = 0

        options = display.newImageRect(uiPause, "main-menu/Images/options.png", 289, 40)
        options.x = display.contentCenterX
        options.y = 710
        options.alpha = 0
       
        quit = display.newImageRect(uiPause, "main-menu/Images/quit.png", 289, 40)
        quit.x = display.contentCenterX
        quit.y = 750
        quit.alpha = 0
end

local function closeGame()
           native.requestExit()
        end

local function goToGame()
           composer.gotoScene("game")
        end
 
local function goToOptions()
           composer.gotoScene("main-menu.optionsMenu")
        end

local function resumeGame()
  physics.start()
  audio.start()
  transition.start()
  timer.start(TimeUI)
  timer.start(ProgressTimer)
  timer.start(EnemySpawner)
  display.remove(uiPause)
  display.add(ForegroundGroup
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

local function pauseGame(event)
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
  newGame:addEventListener("tap", gotoGame)
  newGame.alpha = 1
  resume:addEventListener("tap", resumeGame)
  resume.alpha = 1
  options:addEventListener("tap", gotoOptions)
  options.alpha = 1
  quit:addEventListener("tap", closeGame)
  quit.alpha = 1
  
end
--]]

--[[function userinterface.updatecoophealth()
    if gain then


    else
        local lifex = life[]

end --]]

return userinterface
