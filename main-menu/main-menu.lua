-----------------------------------------------------------------------------------------

-- main.lua


-----------------------------------------------------------------------------------------

local widget = require("widget")


local background = display.newImage("Images/Title_Screen.png", 1280, 720)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

local btn =widget.newButton {
    width = 289,
    height = 30,
    left = 15,
    top = 250,
    defaultFile = "Images/new_game.png",
}

local btn =widget.newButton {
    width = 289,
    height = 30,
    left = 15,
    top = 280,
    defaultFile = "Images/load_game.png",
}

local btn =widget.newButton {
    width = 289,
    height = 30,
    left = 15,
    top = 310,
    defaultFile = "Images/options.png",
}

local btn =widget.newButton {
    width = 289,
    height = 30,
    left = 15,
    top = 340,
    defaultFile = "Images/quit_game.png",
}







