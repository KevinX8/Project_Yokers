lives = 5
score = 0
damaged = false
local livesText
local scoreText


livesText = display.newText(uiGroup, "Lives: ".. lives, 200, 80, native.systemFont,36)
scoreText = display.newText(uiGroup, "Score: ".. score, 400, 80, native.systemFont,36)

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
            timer.performWithDelay( 1000, restoreShip)
        end
    end
end
