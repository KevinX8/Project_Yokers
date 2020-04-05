local userinterface = {}
--score = system.get(timer)--
local livesText
local scoreText

--livesText = display.newText(uiGroup, "Lives: ".. lives, 200, 80, native.systemFont,36)
--scoreText = display.newText(uiGroup, "Score: ".. score, 400, 80, native.systemFont,36)

function userinterface.InitialiseUI()
    i = 0
    repeat
        local heart = display.newImageRect(ForegroundGroup, "assets/heart.png", 100, 100)
        heart.y = display.contentCenterY - 480
        heart.x = display.contentCenterX - 900 + (i * 120)
        i = i + 1
    until i > 5
end

local function updateText()
    livesText.text = "Lives: ".. lives
    scoreText.text = "score: ".. score
end
local function onCollision(event)

    if ( damaged == false ) then 
        damaged = true
        
        lives = lives - 1
        livesText.text = "Lives; " .. lives

        if ( lives == 0) then 
            display.remove(player)
        else
            player.alpha = 0
        end
    end
end
return userinterface