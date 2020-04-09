local userinterface = {}
--score = system.get(timer)--
local livesText
local scoreText
local CoopLifetext
local PlayerLifetext
local CoopLife = {}
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
    Timeloaded = system.getTimer()
    TimemImage = display.newText("0m", display.contentCenterX + 750, display.contentCenterY - 440, "assets/time.otf", 32 )
    TimesImage = display.newText("0", display.contentCenterX + 850, display.contentCenterY - 440, "assets/time.otf", 32 )
    SImage = display.newText("s", display.contentCenterX + 920, display.contentCenterY - 440, "assets/time.otf", 32 )
    TimemImage:setFillColor(0,0,0)
    TimesImage:setFillColor(0,0,0)
    SImage:setFillColor(0,0,0)

    j = 1
    repeat
        CoopLife[j] = display.newImageRect(ForegroundGroup, "assets/heart.png", 100, 150)
        CoopLife[j].y = display.contentCenterY + 480
        CoopLife[j].x = display.contentCenterX - 1010 + (j * 120)
        j = j + 1
    until j > 5

    PlayerLifetext = display.newText("PlayerLife", display.contentCenterX -850, display.contentCenterY -500, native.systemFontBold, 36)
    CoopLifetext = display.newText("CoopLife", display.contentCenterX -850, display.contentCenterY +420, native.systemFontBold, 36)
    PlayerLifetext :setFillColor( 0, 0, 0 )
    CoopLifetext :setFillColor( 0, 0, 0 )
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
    TimemImage.text = timem
    TimesImage.text = times
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