_G.love = require("love") -- The engine

_G.stateManager = require("libraries.stateManager") -- State Manager for different gamestates
_G.spriteHandler = require("libraries.spritehandler") -- Sprite Manager for sprites with Sparrow/Starling spritesheets
_G.timerHandler = require("libraries.timer") -- Timer Manager for timing and stuff

_G.currentState = nil -- Current gamestate (default to menu state)