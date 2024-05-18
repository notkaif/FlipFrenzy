require("states.MenuState")  -- Ensure the MenuState module is required

local switchState = stateManager.switchState
local getCurrentState = stateManager.getCurrentState

function love.load()
    local GFJingle = love.audio.newSource("assets/audio/girlfriendsJingle.ogg", "stream")
    GFJingle:play()

    switchState(MenuState)
end

function love.update(dt)
    local currentState = getCurrentState()
    if currentState and currentState.update then
        currentState:update(dt)
    end
end

function love.draw()
   love.graphics.print("notkaif", 1230, 700)
   local currentState = getCurrentState()
    if currentState and currentState.draw then
        currentState:draw()
    end
end

function love.keypressed(key)
    local currentState = getCurrentState()
    if currentState and currentState.keypressed then
        currentState:keypressed(key)
    end
end