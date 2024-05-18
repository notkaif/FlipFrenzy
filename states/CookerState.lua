CookerState = {}
_G.stateManager = require("libraries.stateManager")
local switchState = stateManager.switchState
local getCurrentState = stateManager.getCurrentState

function CookerState:load()
    -- Initialization code for the menu state
end

function CookerState:update(dt)
    -- Update code for the menu state
end

function CookerState:draw()

    love.graphics.draw(love.graphics.newImage("assets/images/grill.png"), 61.2, 25, 0, 1.3, 1.3)
    love.graphics.print("Press 'ESCAPE' to return back to the menu.")
    love.graphics.print("CookerState", 1200)
end

function CookerState:keypressed(key)
    -- Key pressed handling for the menu state

    if key == "escape" then
        print("Deinit")
        switchState(MenuState)
    end
end

return CookerState  -- Make sure to return the state table
