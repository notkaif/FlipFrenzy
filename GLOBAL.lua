_G.love = require("love")                             -- The engine

-- LIBRARIES

_G.stateManager = require("libraries.stateManager")   -- State Manager for different gamestates
_G.spriteHandler = require("libraries.spritehandler") -- Sprite Manager for sprites with Sparrow/Starling spritesheets
_G.coolStuff = require("libraries.kaifscoolstuff")    -- Cool functions and utilities
_G.discordRPC = require("libraries.discordRPC")

-- GLOBAL STUFF

_G.currentState = nil                                 -- Current gamestate (default to menu state)
_G.lastMouseState = false
_G.currentMouseState = love.mouse.isDown(1)

-- FONTS

_G.fontList = {

    ["doublefeature"] = love.graphics.newFont("assets/fonts/DoubleFeature20.ttf"),
    ["vcr"] = love.graphics.newFont("assets/fonts/vcr.ttf")
}

-- AUDIO

_G.audioTable = {
    menu_activate = nil,
    menu_ding = nil,
    menu_leave = nil,
    pop = nil,
    pop2 = nil,
    sizzling = nil,
    splat = nil,
}

-- STATE STUFF