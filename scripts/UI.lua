local userinterface = {}
--score = system.get(timer)--
Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)

local damageSound = audio.loadSound("audio/Damage Sound.wav")
local oneHeart = audio.loadSound("audio/OneHeart.mp3")

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

local function gameClose(event)
		native.requestExit()
	end 

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
    local coopUImap = display.newImageRect(ForegroundGroup, "assets/map.png", 300, 350)
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
    local timem = math.floor(((system.getTimer() - TimeLoaded - TimePauseD) / 60000)) .. "m"
    local times = math.floor((((system.getTimer() - TimeLoaded - TimePauseD) % 60000) /1000) *10) * 0.1
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

function userinterface.deathscreen(timeSurvived, coopsAllDead)
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
    native.setProperty( "mouseCursorVisible", true )
    local originalScore = (math.floor(timeSurvived/100) + 80*CoopsAlive)
    local symbol = "+"
    Score = math.ceil(originalScore*DifficultyScore)
    if(Score<originalScore) then
        symbol = "-"
    end
    local deathText = {
        text = "You Died!",
        x = display.contentCenterX,
        y = display.contentCenterY-200,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "center"
    }
    local optionsD = {
        text = "Time Survived: \nRemaining Coops: \nDifficulty Multiplier : \nFinal Score:",
        x = display.contentCenterX-500,
        y = display.contentCenterY,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "left"
    }
    local optionsE = {
        text = math.floor(timeSurvived/60000) .. "m"..(math.floor((timeSurvived/100)%600)/10).."s\n".. CoopsAlive .. "\n"..DifficultyScore.."\n" .. Score,
        x = display.contentCenterX,
        y = display.contentCenterY,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "center"
    }
    local optionsF = {
        text = "+" .. math.floor(timeSurvived/100) .. " points\n+" .. (80*CoopsAlive) .. " points\n"..symbol..math.abs(Score-originalScore).." points\n".. Score .. " points",
        x = display.contentCenterX+500,
        y = display.contentCenterY,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "right"
    }
    local quit2 = {
        text = "Quit",
        x = display.contentCenterX-60,
        y = display.contentCenterY + 240,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "center"
    }
       
    if(coopsAllDead) then
        deathText.text = "All Of Your Coops Were Destroyed!"
    end
    
    Ponyfont.newText(deathText)
    Ponyfont.newText(optionsD)
    Ponyfont.newText(optionsE)
    Ponyfont.newText(optionsF)
    local quit2Text = Ponyfont.newText(quit2)
    quit2Text:addEventListener("tap", gameClose)
end



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

function userinterface.pauseButtonMenuButtons()
        
       --[[ local newGame1 = {
        text = "New Game",
        x = display.contentCenterX,
        y = display.contentCenterY - 150,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
        } ]]--
        
        local resume1 = {
        text = "Resume",
        x = display.contentCenterX,
        y = display.contentCenterY - 225,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
        }
        
        local options1 = {
        text = "Options",
        x = display.contentCenterX,
        y = display.contentCenterY - 300,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
        }
        
        local quit1 = {
        text = "Quit",
        x = display.contentCenterX,
        y = display.contentCenterY - 375,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
        }
        
        --NewGameImage = Ponyfont.newText(newGame1)
        if ResumeGameImage == nil then
        ResumeGameImage = Ponyfont.newText(resume1)
        OptionsImage = Ponyfont.newText(options1)
        QuitImage = Ponyfont.newText(quit1)
        else
            ResumeGameImage.text = "Resume"
            OptionsImage.text = "Options"
            QuitImage.text = "Quit"
        end
    end

return userinterface
