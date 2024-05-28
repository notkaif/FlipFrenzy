_G.love = require("love")                             -- The engine

_G.stateManager = require("libraries.stateManager")   -- State Manager for different gamestates
_G.spriteHandler = require("libraries.spritehandler") -- Sprite Manager for sprites with Sparrow/Starling spritesheets
_G.coolStuff = require("libraries.kaifscoolstuff")    -- Cool functions and utilities

_G.currentState = nil                                 -- Current gamestate (default to menu state)

-- FONTS

_G.fontList = {

    ["doublefeature"] = love.graphics.newFont("assets/fonts/DoubleFeature20.ttf"),
    ["vcr"] = love.graphics.newFont("assets/fonts/vcr.ttf")
}
