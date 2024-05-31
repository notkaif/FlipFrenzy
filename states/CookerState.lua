CookerState = {}
CookerState.initialized = false

local switchState = stateManager.switchState

CookerState.spriteList = {}

local COOK_TIMINGS = {
    ["raw"] = 10,
    ["cooked"] = 10,
    ["overcooked"] = 5
}

local grillImage
local isHoldingPatty = false
local heldPatty = nil
local spritesToRemove = {}

local function loadAudio()
    audioTable.pop = love.audio.newSource("assets/audio/sounds/pop.mp3", "static")
    audioTable.pop2 = love.audio.newSource("assets/audio/sounds/pop2.mp3", "static")
    audioTable.sizzling = love.audio.newSource("assets/audio/sounds/sizzling.ogg", "static")
    audioTable.splat = love.audio.newSource("assets/audio/sounds/splat.mp3", "static")
end

local function addSprite(sprite, imagePath, xmlPath)
    sprite:setImage(imagePath)
    sprite:setXML(xmlPath)
    table.insert(CookerState.spriteList, sprite)
end

local function playAudio(audio, volume, looping, continuous)
    if not continuous then
        audio:stop()
    end
    audio:setVolume(volume)
    audio:setLooping(looping)
    audio:play()
end

local patties = 5

function CookerState:load()
    if not self.initialized then
        loadAudio()
        local pattyStack = spriteHandler.new()
        addSprite(pattyStack, "assets/images/sheets/patty_Grill.png", "assets/images/sheets/patty_Grill.xml")
        pattyStack:play("raw")
        pattyStack.x = 1025
        pattyStack.y = 225
        pattyStack.rotation = 0
        pattyStack.size = 0.7
        pattyStack.targetSize = 0.7
        pattyStack.spriteType = "pattystack"

        grillImage = love.graphics.newImage("assets/images/grill.png")
        self.initialized = true
    end
end

function CookerState:update(dt)
    local grillCheck = false

    for i = #self.spriteList, 1, -1 do
        local sprite = self.spriteList[i]
        sprite:update(dt)

        if sprite.spriteType == "patty" then
            self:updatePatty(sprite, dt, i)
            if sprite.cookingData.isCooking then
                grillCheck = true
            end
        elseif sprite.spriteType == "pattystack" and love.mouse.isDown(1) and sprite:mouseTouching() and patties > 0 and currentMouseState and not lastMouseState then
            self:createNewPatty()
        end
    end

    if grillCheck then
        playAudio(audioTable.sizzling, 1, true, true)
    else
        audioTable.sizzling:stop()
    end

    -- Remove marked sprites after the iteration
    for _, index in ipairs(spritesToRemove) do
        table.remove(self.spriteList, index)
    end
    spritesToRemove = {}
end

function CookerState:updatePatty(sprite, dt, index)
    local cookingData = sprite.cookingData

    if love.mouse.isDown(1) then
        if sprite:mouseTouching() and not isHoldingPatty then
            isHoldingPatty = true
            heldPatty = sprite
        end

        if heldPatty == sprite then
            if currentMouseState and not lastMouseState then
                playAudio(audioTable.pop, 1, false)
            end

            self:handlePattyDrag(sprite)
        end
    else
        if heldPatty == sprite then
            heldPatty = nil
            isHoldingPatty = false
            playAudio(audioTable.pop2, 1, false)
        end
        self:handlePattyCooking(sprite, dt, index)
    end

    sprite:play(cookingData.state)
    sprite.size = coolStuff.lerp(sprite.size, sprite.targetSize, 10 * dt)
end

function CookerState:handlePattyDrag(sprite)
    local cookingData = sprite.cookingData
    cookingData.isHeld = true
    cookingData.isCooking = false

    sprite.size = 0.75
    sprite.x = love.mouse.getX()
    sprite.y = love.mouse.getY()

end

function CookerState:handlePattyCooking(sprite, dt, index)
    local cookingData = sprite.cookingData

    sprite.targetSize = 0.7

    if sprite.x >= 120 and sprite.x <= 880 and sprite.y >= 150 and sprite.y <= 610 then
        cookingData.timer = cookingData.timer + dt
        cookingData.isCooking = true

        if cookingData.timer >= 1 then
            cookingData.timer = cookingData.timer - 1
            cookingData.cookingPercentage = cookingData.cookingPercentage + (100 / COOK_TIMINGS[cookingData.state])
            print(cookingData.cookingPercentage)
        end
    else
        cookingData.isCooking = false
    end

    if cookingData.cookingPercentage >= 100 then
        self:updateCookingState(cookingData, index)
    end
end

function CookerState:updateCookingState(cookingData, index)
    if cookingData.state == "raw" then
        cookingData.state = "cooked"
    elseif cookingData.state == "cooked" then
        cookingData.state = "overcooked"
    else
        table.insert(spritesToRemove, index)
        self.spriteList[index]:destroy()
    end

    cookingData.timer = 0
    cookingData.cookingPercentage = 0
end

function CookerState:createNewPatty()
    patties = patties - 1
    playAudio(audioTable.pop, 1, false)

    local newPatty = spriteHandler.new()
    addSprite(newPatty, "assets/images/sheets/patty_Grill.png", "assets/images/sheets/patty_Grill.xml")

    newPatty:play("raw")

    newPatty.x = love.mouse.getX()
    newPatty.y = love.mouse.getY()
    newPatty.rotation = 0
    newPatty.size = 0.7
    newPatty.targetSize = 0.7
    newPatty.spriteType = "patty"

    newPatty.cookingData = {
        state = "raw",
        isCooking = false,
        cookingPercentage = 0,
        timer = 0,
        isHeld = false
    }
    
end

function CookerState:draw()
    love.graphics.draw(grillImage, 61.2, 25, 0, 1.3, 1.3)
    love.graphics.print("CookerState", 1190, 10)

    for _, sprite in ipairs(self.spriteList) do
        if sprite.spriteType == "patty" then
            if sprite.cookingData.isCooking then
                self:drawCookingMeter(sprite)
            end
            sprite:draw(sprite.x, sprite.y, sprite.rotation, sprite.size)

        elseif sprite.spriteType == "pattystack" then
            if patties == 0 then
                love.graphics.setColor(0.5,0.5,0.5,0.5)
            end
            sprite:draw(sprite.x, sprite.y, sprite.rotation, sprite.size)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end

    love.graphics.print("Press 'ESCAPE' to return back to the menu.", 10, 700)
end

function CookerState:drawCookingMeter(sprite)
    love.graphics.setColor(0.278, 0.356, 0.478, 1)
    love.graphics.rectangle("fill", sprite.x + sprite.width / 2, sprite.y - 50, 25, 100)
    if sprite.cookingData.state == "raw" then
        love.graphics.setColor(0, 1, 0, 1)
    else
        love.graphics.setColor(1, 0, 0, 1)
    end
    love.graphics.rectangle("fill", sprite.x + sprite.width / 2 + 5, sprite.y - sprite.cookingData.cookingPercentage + 45, 15, sprite.cookingData.cookingPercentage)
    love.graphics.setColor(1, 1, 1, 1)
end

function CookerState:keypressed(key)
    if key == "escape" then
        switchState(MenuState)
        playAudio(audioTable.menu_leave, 1, false)
    end
end

return CookerState