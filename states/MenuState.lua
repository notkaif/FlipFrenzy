MenuState = {}
MenuState.initialized = false

require("states.CookerState") -- Ensure CookerState is loaded

local switchState = stateManager.switchState

local assets = {
    logo = nil,
    burgerbg = nil,
    logoGlow = nil,
}

MenuState.spriteList = {}
local bgy = 0
local logoY = 0

local amplitude = 10
local frequency = 1
local time = 0
local baseY = 40

local function addSprite(sprite, imagePath, xmlPath)
    sprite:setImage(imagePath)
    sprite:setXML(xmlPath)
    table.insert(MenuState.spriteList, sprite)
end

local function playAudio(audio, volume, looping, continuous)
    if not continuous then audio:stop() end
    audio:setVolume(volume)
    audio:setLooping(looping)
    audio:play()
end

function MenuState:load()
    if not self.initialized then
        assets.logo = love.graphics.newImage("assets/images/logo.png")
        assets.logoGlow = love.graphics.newImage("assets/images/logoglow.png")
        assets.burgerbg = love.graphics.newImage("assets/images/burgerbackground.png")

        local playButton = spriteHandler.new()
        addSprite(playButton, "assets/images/sheets/playbutton.png", "assets/images/sheets/playbutton.xml")

        playButton:play("playbuttonNEW")
        playButton.x = 640
        playButton.y = 570
        playButton.rotation = 0
        playButton.size = 1
        playButton.spriteType = "playbutton"

        playButton.targetSize = 1

        local infoButton = spriteHandler.new()
        addSprite(infoButton, "assets/images/sheets/infobutton.png", "assets/images/sheets/infobutton.xml")

        infoButton:play("infobutton")
        infoButton.x = 100
        infoButton.y = 580
        infoButton.rotation = 0
        infoButton.size = 1
        infoButton.spriteType = "infobutton"

        infoButton.targetSize = 1

        logoY = baseY
        bgy = 0
        self.initialized = true
    end
end

function MenuState:update(dt)
    time = time + dt
    logoY = baseY + amplitude * math.sin(2 * math.pi * frequency * time)
    bgy = (bgy - dt * 100) % -177

    for _, sprite in ipairs(self.spriteList) do
        sprite:update(dt)

        if sprite:mouseTouching() then
            if sprite.spriteType == "playbutton" then
                sprite.targetSize = 1.05
            else
                sprite.targetSize = 1.05
            end
            if currentMouseState and not lastMouseState then
                if love.mouse.isDown(1) and sprite.spriteType == "playbutton" then
                    switchState(CookerState)
                    playAudio(audioTable.menu_activate, 0.3, false)
                elseif love.mouse.isDown(1) and sprite.spriteType == "infobutton" then
                    playAudio(audioTable.menu_activate, 0.3, false)
                end
            end
        else
            sprite.targetSize = 1
        end

        local lerpSpeed = 10 * dt
        sprite.size = coolStuff.lerp(sprite.size, sprite.targetSize, lerpSpeed)
        
    end
end

function MenuState:draw()
    love.graphics.draw(assets.burgerbg, 0, bgy)
    love.graphics.draw(assets.logoGlow, 24)
    love.graphics.draw(assets.logo, 129, logoY, 0, 0.7, 0.7)

    for _, sprite in ipairs(self.spriteList) do
        sprite:draw(sprite.x, sprite.y, sprite.rotation, sprite.size)
    end

    love.graphics.print("MenuState", 1200, 10)
end

function MenuState:keypressed(key)
    if key == "return" then
        switchState(CookerState)
        playAudio(audioTable.menu_activate, 0.3, false)
    end
end

return MenuState
