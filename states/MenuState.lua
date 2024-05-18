MenuState = {}

require("states.CookerState")  -- Ensure the MenuState module is required

local switchState = stateManager.switchState
local getCurrentState = stateManager.getCurrentState

function MenuState:load()
    -- Initialization code for the menu state
end

function MenuState:update(dt)
    -- Update code for the menu state
end

function MenuState:draw()
    love.graphics.draw(love.graphics.newImage("assets/images/logo.png"), 56, 40, 0, .8, .8)

    love.graphics.print("Press 'ENTER' to play.", 380, 600, 0, 4, 4)
    love.graphics.print("MenuState", 1200)
end

function MenuState:keypressed(key)
    -- Key pressed handling for the menu state

    if key == "return" then
        print("Init")
        switchState(CookerState)
    end
end

return MenuState  -- Make sure to return the state table
