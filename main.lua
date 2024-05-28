require("GLOBAL")
require("states.MenuState") -- Make sure the MenuState is loaded so references to MenuState wont return a nil value

-- StateManager Variables

local switchState = stateManager.switchState

-- Love Functions

function love.load()
    -- Play GF's Jingle (TEMPORARY FOR NOW, JUST FITS THE SIMPLENESS OF THE BUILD)

    local GFJingle = love.audio.newSource("assets/audio/music/girlfriendsJingle.ogg", "stream")
    GFJingle:setLooping(true)
    GFJingle:setVolume(0.6)
    GFJingle:play()

    -- Switches to the MenuState cause the game just started.

    switchState(MenuState)
end

function love.update(dt)
    -- Calls the current state's "update" function when game updates

    if currentState and currentState.update then
        currentState:update(dt)
    end
end

function love.draw()
    -- Calls the current state's "draw" function when game draws
    if currentState and currentState.draw then
        currentState:draw()
    end

    -- Temporary debug printing

    love.graphics.print("notkaif", 1220, 700)

    love.graphics.setFont(fontList["vcr"])
    love.graphics.print(string.format("FPS: %d", love.timer.getFPS()), 10, 10)
    love.graphics.print(string.format("Memory Usage: %.2f MB", collectgarbage("count") / 1024), 10, 25)
    love.graphics.print("FlipFrenzy inDev v1.1.2", 10, 40)
end

function love.keypressed(key)
    -- Calls the current state's "keypressed" function when game updates
    if currentState and currentState.keypressed then
        currentState:keypressed(key)
    end
end
