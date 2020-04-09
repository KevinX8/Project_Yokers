local composer = require("composer")
local scene = composer.newScene()

local widget = require("widget")

local function goToLevelSelect(event)
            if ("ended" == event.phase) then
                composer.gotoScene("levelSelect", {effect = "crossFade", time = 500})
            end
        end

local background = display.newImage("Images/Title_Screen.png", 1280, 720)
        background.x = display.contentCenterX
        background.y = display.contentCenterY

local function closeGame()
            native.requestExit()
        end

local function goToLevelSelect(event)
            if ("ended" == event.phase) then
                composer.gotoScene("levelSelect", {effect = "crossFade", time = 500})
            end
        end

local function goToOptions(event)
            if ("ended" == event.phase) then
                composer.gotoScene("options", {effect = "crossFade", time = 500})
            end
        end

local newGame =
        widget.newButton{
   {
    width = 289,
    height = 40,
    left = 240,
    top = 630,
    defaultFile = "Images/new_game.png",
    onEvent = goToLevelSelection
}

local loadGame =
        widget.newButton{
   {
    width = 289,
    height = 40,
    left = 240,
    top = 670,
    defaultFile = "Images/load_game.png",
}

local options =
                widget.newButton{
    {
    width = 289,
    height = 40,
    left = 240,
    top = 710,
    defaultFile = "Images/options.png",
    onEvent = goToOptions                           
}

local quit =
              widget.newButton{
    {
    width = 289,
    height = 40,
    left = 240,
    top = 750,
    defaultFile = "Images/quit_game.png",
    onEvent = closeGame
}







