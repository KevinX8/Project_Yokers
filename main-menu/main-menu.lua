-----------------------------------------------------------------------------------------

-- main.lua


-----------------------------------------------------------------------------------------

local widget = require("widget")


local background = display.newImage("Images/Title_Screen.png", 1280, 720)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

local btn =widget.newButton {
    width = 500,
    height = 250,
    left = 175,
    top = 655,
    defaultFile = "Images/new_game.png",
}

local btn =widget.newButton {
    width = 500,
    height = 250,
    left = 175,
    top = 765,
    defaultFile = "Images/load_game.png",
}

local btn =widget.newButton {
    width = 500,
    height = 250,
    left = 175,
    top = 875,
    defaultFile = "Images/options.png",
}

local btn =widget.newButton {
    width = 500,
    height = 250,
    left = 175,
    top = 985,
    defaultFile = "Images/quit_game.png",
}





