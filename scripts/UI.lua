local userinterface = {}
--score = system.get(timer)--
Ponyfont = require "com.ponywolf.ponyfont" -- https://github.com/ponywolf/ponyfont used to load bitmap fonts (white bg)

local damageSound = audio.loadSound("audio/Damage Sound.wav")
local oneHeart = audio.loadSound("audio/OneHeart.mp3")

local livesText
local scoreText

local timeLoaded
local timemImage
local timesImage
local sImage
local currentLevel
local eggImage
local eggCounter
local fullHeart = false
local blinkTime = 300

local heart = {}
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
    timeLoaded = system.getTimer()
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

function userinterface.updatetime()
    local timem = math.floor(((system.getTimer() - timeLoaded) / 60000)) .. "m"
    local times = math.floor((((system.getTimer() - timeLoaded) % 60000) /1000) *10) * 0.1
    timemImage.text = timem
    timesImage.text = times
end

function userinterface.updateEggs()
    eggCounter.text = EgginInv .. " / " .. EggCapacity
end

function userinterface.updateLevelDisp()
    currentLevel.text = "Level " .. Level 
end

function userinterface.deathscreen()
    local deathmessage = display.newText
end

--[[function userinterface.updatecoophealth()
    if gain then


    else
        local lifex = life[]

end --]]

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

return userinterface
