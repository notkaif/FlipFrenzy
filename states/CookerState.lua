CookerState = {}
CookerState.initialized = false

local switchState = stateManager.switchState
local timer = 0

-- DEVELOPMENT STUFF REMOVE LATER

local spriteList = {}

local COOK_TIMINGS = {
    ["raw"] = 10,
    ["cooked"] = 10,
    ["overcooked"] = 5
}
local grillImage

local cookingSound
local leaveSound



local function addSprite(sprite, imagePath, xmlPath)
    sprite:setImage(imagePath)
    sprite:setXML(xmlPath)
    table.insert(spriteList, sprite)
end

function CookerState:load()
    
    if CookerState.initialized == false then
        local testPatty = spriteHandler.new()

    addSprite(testPatty, "assets/images/sheets/patty_Grill.png", "assets/images/sheets/patty_Grill.xml")

    testPatty:Play("raw")

    testPatty.x = 952
    testPatty.y = 142
    testPatty.rotation = 0
    testPatty.size = 0.7


    testPatty.cookingData = {
        state = "raw",
        cookingPercentage = 0,
    }
    testPatty.spriteType = "patty"
    testPatty.popped = false

    grillImage = love.graphics.newImage("assets/images/grill.png")
    cookingSound = love.audio.newSource("assets/audio/sounds/sizzling.ogg", "static")
    leaveSound = love.audio.newSource("assets/audio/sounds/menu_leave.ogg", "static")

    end

    CookerState.initialized = true
end

function CookerState:update(dt)

    for i, sprite in pairs(spriteList) do
        sprite:update(dt)

        if sprite.spriteType == "patty" then
            local cookingData = sprite.cookingData

            if love.mouse.isDown(1) and sprite:MouseTouching() then
                if not sprite.popped then
                    love.audio.newSource("assets/audio/sounds/pop.mp3", "static"):play()
                    sprite.popped = true
                end

                sprite.size = 0.75
                sprite.x = love.mouse.getX() - 72
                sprite.y = love.mouse.getY() - 72
                cookingSound:stop()
            else
                if sprite.popped then
                    love.audio.newSource("assets/audio/sounds/pop2.mp3", "static"):play()
                    sprite.popped = false
                end

                timer = timer + dt
                sprite.size = 0.7
                if sprite.x >= 120 and sprite.x <= 880 and sprite.y >= 150 and sprite.y <= 610 then
                    cookingSound:setLooping(true)
                    cookingSound:play()
                    if timer >= 1 then
                        timer = timer - 1
                        cookingData.cookingPercentage = cookingData.cookingPercentage + (100 / COOK_TIMINGS[cookingData.state])
                        print(cookingData.cookingPercentage)
                    end

                else
                    cookingSound:stop()
                end

                if cookingData.cookingPercentage >= 100 then
                    if cookingData.state == "raw" then
                        cookingData.state = "cooked"
                    elseif cookingData.state == "cooked" then
                        cookingData.state = "overcooked"
                    else
                        table.remove(spriteList, i)
                        sprite:Destroy()
                        cookingSound:stop()
                    end
                    timer = 0
                    cookingData.cookingPercentage = 0
                end
            end

            sprite:Play(cookingData.state)
        end
    end
end

function CookerState:draw()
    love.graphics.draw(grillImage, 61.2, 25, 0, 1.3, 1.3)
    love.graphics.print("Press 'ESCAPE' to return back to the menu.")
    love.graphics.print("CookerState", 1200)

    for _, sprite in pairs(spriteList) do
        sprite:draw(sprite.x, sprite.y, sprite.rotation, sprite.size)
    end
end

function CookerState:keypressed(key)
    if key == "escape" then
        print("Deinit CookerState")
        switchState(MenuState)
        leaveSound:play()
    end
end

return CookerState