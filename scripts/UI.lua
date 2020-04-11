local userinterface = {}
--score = system.get(timer)--
local livesText
local scoreText

local timeLoaded
local timemImage
local timesImage
local sImage
local eggImage
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
    until i > 5
    timeLoaded = system.getTimer()
    timemImage = display.newText("0m", display.contentCenterX + 750, display.contentCenterY - 440, "assets/time.otf", 32 )
    timesImage = display.newText("0", display.contentCenterX + 850, display.contentCenterY - 440, "assets/time.otf", 32 )
    sImage = display.newText("s", display.contentCenterX + 920, display.contentCenterY - 440, "assets/time.otf", 32 )
    eggImage = display.newImageRect(ForegroundGroup, "assets/egg.png", 37.5, 47.5)
    eggImage.x = display.contentCenterX - 920
    eggImage.y = display.contentCenterY + 500
    timemImage:setFillColor(0,0,0)
    timesImage:setFillColor(0,0,0)
    sImage:setFillColor(0,0,0)
end

function userinterface.updatehearts(added)
   if added then
    if(Health == 1)then
        timer.cancel(Blink)
        heart[1] = display.newImageRect(ForegroundGroup, "assets/heart.png", 96, 84)
    end
    heart[Health] = display.newImageRect(ForegroundGroup, "assets/heart.png", 96, 84)
    heart[Health].alpha = 0.7
    heart[Health].y = display.contentCenterY - 440
    heart[Health + 1].x = heart[Health].x + 120
   else
    local heartx = heart[Health + 1].x
    local hearty = heart[Health + 1].y
    local animationImage = heart[Health + 1]
    transition.to(animationImage,{time=2000, y = animationImage.y-200, alpha = 0.4, onComplete=function() animationImage:removeSelf() end})
    heart[Health + 1] = display.newImageRect(ForegroundGroup, "assets/emptyheart.png", 96, 84)
    heart[Health+1].alpha = 0.7
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
    else
        heart[1] = display.newImageRect(ForegroundGroup, "assets/emptyheart.png", 96, 84)
    end
    heart[1].alpha = 0.7
    heart[1].y = display.contentCenterY - 440
    heart[1].x = display.contentCenterX - 890
end


function userinterface.updatetime()
    local timem = math.floor(((system.getTimer() - Timeloaded) / 60000)) .. "m"
    local times = math.floor((((system.getTimer() - Timeloaded) % 60000) /1000) *10) * 0.1
    timemImage.text = timem
    timesImage.text = times
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