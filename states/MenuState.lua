MenuState = {}

require("states.CookerState") -- -- Make sure the CookerState is loaded so references to CookerState wont return a nil value

local switchState = stateManager.switchState

local activateSound

function MenuState:load()
    activateSound = love.audio.newSource("assets/audio/sounds/menu_activate.ogg", "static")
end

function MenuState:update(dt)
end

function MenuState:draw()
    love.graphics.draw(love.graphics.newImage("assets/images/logo.png"), 56, 40, 0, .8, .8)

    love.graphics.print("Press 'ENTER' to play.", 380, 600, 0, 4, 4)
    love.graphics.print("MenuState", 1200)
end

function MenuState:keypressed(key)
    if key == "return" then
        print("Init CookerState")
        switchState(CookerState)
        activateSound:setVolume(0.3)
        activateSound:play()
    end
end

return MenuState
