MenuState = {}
MenuState.initialized = false

require("states.CookerState") -- Ensure CookerState is loaded

local switchState = stateManager.switchState

local assets = {
    logo = nil,
    burgerbg = nil,
    logoGlow = nil,
    activateSound = nil
}

local spriteList = {}
local bgy = 0
local logoY = 0

local amplitude = 10
local frequency = 1
local time = 0
local baseY = 40

local function addSprite(sprite, imagePath, xmlPath)
    sprite:setImage(imagePath)
    sprite:setXML(xmlPath)
    table.insert(spriteList, sprite)
end

function MenuState:load()
    if not self.initialized then
        assets.logo = love.graphics.newImage("assets/images/logo.png")
        assets.logoGlow = love.graphics.newImage("assets/images/logoglow.png")
        assets.burgerbg = love.graphics.newImage("assets/images/burgerbackground.png")
        assets.activateSound = love.audio.newSource("assets/audio/sounds/menu_activate.ogg", "static")

        local playButton = spriteHandler.new()
        addSprite(playButton, "assets/images/sheets/playbutton.png", "assets/images/sheets/playbutton.xml")

        playButton:Play("playbuttonNEW")
        playButton.x = 474
        playButton.y = 508
        playButton.rotation = 0
        playButton.size = 1
        playButton.spriteType = "playbutton"

        playButton.targetSize = 1
        playButton.targetX = 474
        playButton.targetY = 508

        local infoButton = spriteHandler.new()
        addSprite(infoButton, "assets/images/sheets/infobutton.png", "assets/images/sheets/infobutton.xml")

        infoButton:Play("infobutton")
        infoButton.x = 28
        infoButton.y = 535
        infoButton.rotation = 0
        infoButton.size = 1
        infoButton.spriteType = "infobutton"

        infoButton.targetSize = 1
        infoButton.targetX = 28
        infoButton.targetY = 535

        logoY = baseY
        bgy = 0
        self.initialized = true
    end
end

function MenuState:update(dt)
    time = time + dt
    logoY = baseY + amplitude * math.sin(2 * math.pi * frequency * time)
    bgy = (bgy - dt * 100) % -177

    for _, sprite in ipairs(spriteList) do
        sprite:update(dt)

        if sprite:MouseTouching() then

            if sprite.spriteType == "playbutton" then
                sprite.targetSize = 1.05
                sprite.targetX = 465.725
                sprite.targetY = 504.125

            else
                sprite.targetSize = 1.05
                sprite.targetX = 24.725
                sprite.targetY = 531.825
            end

            if love.mouse.isDown(1) and sprite.spriteType == "playbutton" then
                switchState(CookerState)
                assets.activateSound:setLooping(false)
                assets.activateSound:setVolume(0.3)
                assets.activateSound:play()

            elseif love.mouse.isDown(1) and sprite.spriteType == "infobutton" then
                assets.activateSound:setLooping(false)
                assets.activateSound:setVolume(0.3)
                assets.activateSound:play()
            end
            
        elseif sprite.spriteType == "playbutton" then
            sprite.targetSize = 1
            sprite.targetX = 474
            sprite.targetY = 508
        else
            sprite.targetSize = 1
            sprite.targetX = 28
            sprite.targetY = 535
        end

        local lerpSpeed = 10 * dt
        sprite.x = coolStuff.lerp(sprite.x, sprite.targetX, lerpSpeed)
        sprite.y = coolStuff.lerp(sprite.y, sprite.targetY, lerpSpeed)
        sprite.size = coolStuff.lerp(sprite.size, sprite.targetSize, lerpSpeed)
    end
end

function MenuState:draw()
    love.graphics.draw(assets.burgerbg, 0, bgy)
    love.graphics.draw(assets.logoGlow, 24)
    love.graphics.draw(assets.logo, 129, logoY, 0, 0.7, 0.7)

    for _, sprite in ipairs(spriteList) do
        sprite:draw(sprite.x, sprite.y, sprite.rotation, sprite.size)
    end

    love.graphics.print("MenuState", 1200, 10)
end

function MenuState:keypressed(key)
    if key == "return" then
        switchState(CookerState)
        assets.activateSound:setLooping(false)
        assets.activateSound:setVolume(0.3)
        assets.activateSound:play()
    end
end

return MenuState