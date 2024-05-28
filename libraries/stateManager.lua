local function switchState(state)
    if state then
        currentState = state
        if currentState.load then
            currentState:load()
        else
            print("Warning: Attempted to switch to state but it does not have a load function")     -- Should avoid this for drawing
        end
    else
        print("Error: Attempted to switch to a nil state") -- Should not happen, error handling
    end
end

return {
    switchState = switchState -- Returns the switchState variable to switch states.
}
