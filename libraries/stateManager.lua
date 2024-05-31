local function switchState(state)
    if not state then
        print("Error: Attempted to switch to a nil state")
        return
    end

    currentState = state
    if currentState.load then
        currentState:load()
    else
        print("Warning: State does not have a load function")
    end
end

return {
    switchState = switchState
}
