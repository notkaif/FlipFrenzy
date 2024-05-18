local currentState = nil

local function switchState(state)
    if state then
        currentState = state
        if currentState.load then
            currentState:load()
        end
    else
        print("Error: Attempted to switch to a nil state :/")
    end
end

local function getCurrentState()
    return currentState
end

return {
    switchState = switchState,
    getCurrentState = getCurrentState
}
