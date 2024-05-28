MenuState = {}
MenuState.initialized = false

require("states.CookerState") -- -- Make sure the CookerState is loaded so references to CookerState wont return a nil value

local switchState = stateManager.switchState

local logo, burgerbg, logoGlow, activateSound

local spriteList = {}

local function addSprite(sprite, imagePath, xmlPath)
    sprite:setImage(imagePath)
    sprite:setXML(xmlPath)
    table.insert(spriteList, sprite)
end

local bgy
local logoY

local amplitude = 10
local frequency = 2
local time = 0
local baseY = 40

function MenuState:load()
    if not MenuState.initialized then
        bgy = 0
        logoY = baseY
        logo = love.graphics.newImage("assets/images/logo.png")
        logoGlow = love.graphics.newImage("assets/images/logoglow.png")
        burgerbg = love.graphics.newImage("assets/images/burgerbackground.png")

        local playButton = spriteHandler.new()
        addSprite(playButton, "assets/images/sheets/playbutton.png", "assets/images/sheets/playbutton.xml")

        playButton:Play("playbuttonNEW")
        playButton.x = 474
        playButton.y = 508
        playButton.rotation = 0
        playButton.size = 1

        activateSound = love.audio.newSource("assets/audio/sounds/menu_activate.ogg", "static")
    end

    MenuState.initialized = true
end

function MenuState:update(dt)
    time = time + dt
    logoY = baseY + amplitude * math.sin(2 * math.pi * frequency * time)
    bgy = bgy - dt * 100

    if bgy <= -177 then
        bgy = 0
    end

    for i, sprite in pairs(spriteList) do
        sprite:update(dt)

        if sprite:MouseTouching() then
            sprite.targetsize = 1.05
            sprite.targetX = 465.725
            sprite.targetY = 504.125

            if love.mouse.isDown(1) then
                switchState(CookerState)
                activateSound:setVolume(0.3)
                activateSound:play()
            end
        else
            sprite.targetsize = 1
            sprite.targetX = 474
            sprite.targetY = 508
        end

        local lerpSpeed = 10 * dt
        sprite.x = coolStuff.lerp(sprite.x, sprite.targetX, lerpSpeed)
        sprite.y = coolStuff.lerp(sprite.y, sprite.targetY, lerpSpeed)
        sprite.size = coolStuff.lerp(sprite.size, sprite.targetsize, lerpSpeed)
    end
end

function MenuState:draw()
    love.graphics.draw(burgerbg, 0, bgy)
    love.graphics.draw(logoGlow, 24)
    love.graphics.draw(logo, 129, logoY, 0, .7, .7)

    for _, sprite in pairs(spriteList) do
        sprite:draw(sprite.x, sprite.y, sprite.rotation, sprite.size)
    end

    love.graphics.print("MenuState", 1200, 10)
end

function MenuState:keypressed(key)
    if key == "return" then
        switchState(CookerState)
        activateSound:setVolume(0.3)
        activateSound:play()
    end
end

return MenuState
