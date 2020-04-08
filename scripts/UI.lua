local userinterface = {}
--score = system.get(timer)--
local livesText
local scoreText
local heart = {}
Timeloaded = 0

--livesText = display.newText(uiGroup, "Lives: ".. lives, 200, 80, native.systemFont,36)
--scoreText = display.newText(uiGroup, "Score: ".. score, 400, 80, native.systemFont,36)

function userinterface.InitialiseUI()
    i = 1
    repeat
        heart[i] = display.newImageRect(ForegroundGroup, "assets/heart.png", 100, 150)
        heart[i].y = display.contentCenterY - 480
        heart[i].x = display.contentCenterX - 900 + (i * 120)
        i = i + 1
    until i > 5
    Timeloaded = system.getTimer()
    TimemImage = display.newText("0m", display.contentCenterX + 800, display.contentCenterY - 480, "assets/time.otf", 32 )
    TimesImage = display.newText("0s", display.contentCenterX + 900, display.contentCenterY - 480, "assets/time.otf", 32 )
    TimemImage:setFillColor(0,0,0)
    TimesImage:setFillColor(0,0,0)
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
    print(Timeloaded)
    local timem = math.floor(((system.getTimer() - Timeloaded) / 60000)) .. "m"
    local times = math.floor((((system.getTimer() - Timeloaded) % 60000) /1000) * 10) * 0.1 .. "s"
    TimemImage.text = timem
    TimesImage.text = times
end

return userinterface