local userinterface = {}
--score = system.get(timer)--
Ponyfont = require "com.ponywolf.ponyfont"

local livesText
local scoreText

local timeLoaded
local timemImage
local timesImage
local sImage
local eggImage
local eggCounter

local heart = {}
Timeloaded = 0

function userinterface.InitialiseUI()
    i = 1
    repeat
        heart[i] = display.newImageRect(ForegroundGroup, "assets/heart.png", 100, 150)
        heart[i].y = display.contentCenterY - 440
        heart[i].x = display.contentCenterX - 1010 + (i * 120)
        i = i + 1
    until i > 5
    timeLoaded = system.getTimer()
    local optionsm = {
        text = "0m",
        x = display.contentCenterX + 762,
        y = display.contentCenterY - 445,
        font = "assets/coolfont.fnt",
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
        text = "50 / 50",
        x = display.contentCenterX - 790,
        y = display.contentCenterY + 390,
        font = "assets/coolfont.fnt",
        fontSize = 32,
        align = "centre"
    }
    timemImage = Ponyfont.newText(optionsm)
    timesImage = Ponyfont.newText(optionss)
    sImage = Ponyfont.newText(optionssi)
    eggImage = display.newImageRect(ForegroundGroup, "assets/egg.png", 37.5, 47.5)
    eggImage.x = display.contentCenterX - 920
    eggImage.y = display.contentCenterY + 400
    eggCounter = Ponyfont.newText(optionse)
end

function userinterface.updatehearts(added)
   if added then
    heart[Health] = display.newImageRect(ForegroundGroup, "assets/heart.png", 100, 150)
    heart[Health].y = display.contentCenterY - 480
    heart[Health + 1].x = heart[Health].x + 120
   else
    local heartx = heart[Health + 1].x
    local hearty = heart[Health + 1].y
    heart[Health + 1]:removeSelf()
    heart[Health + 1] = display.newImageRect(ForegroundGroup, "assets/emptyheart.png", 100, 150)
    heart[Health + 1].x = heartx
    heart[Health + 1].y = hearty
   end
end 

function userinterface.updatetime()
    local timem = math.floor(((system.getTimer() - Timeloaded) / 60000)) .. "m"
    local times = math.floor((((system.getTimer() - Timeloaded) % 60000) /1000) *10) * 0.1
    timemImage.text = timem
    timesImage.text = times
end

function userinterface.updateEggs()
    eggCounter.text = EgginInv .. " / " .. EggCapacity
end

function userinterface.deathscreen()
    local deathmessage = display.newText
end

--[[function userinterface.updatecoophealth()
    if gain then


    else
        local lifex = life[]

end --]]

return userinterface