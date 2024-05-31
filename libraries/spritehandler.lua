local SpriteHandler = {}

function SpriteHandler.new()
    local self = {
        image = nil,
        animations = {},
        currentAnimation = nil,
        currentFrame = 1,
        paused = false,
        fps = 24,
        checked = false,
        isMouseTouching = false,
        width = 0,
        height = 0
    }

    -- Set the image for the sprite handler
    function self:setImage(imgPath)
        self.image = love.graphics.newImage(imgPath)
    end

    -- Parse XML and set animations STARLING AND SPARROW V2 LIMITED FUNCTIONALITY
    function self:setXML(filePath)
        local data = love.filesystem.read(filePath)
        if not data then
            print("Error: Could not read file " .. filePath)
            return
        end

        local imageWidth = self.image:getWidth()
        local imageHeight = self.image:getHeight()

        for name, x, y, width, height in data:gmatch('<SubTexture name="([^"]+)" x="(%d+)" y="(%d+)" width="(%d+)" height="(%d+)"') do
            local animationName = name:match("([^%d]+)")
            if not self.animations[animationName] then
                self.animations[animationName] = {}
            end

            self.width = tonumber(width)
            self.height = tonumber(height)
            table.insert(self.animations[animationName], {
                quad = love.graphics.newQuad(
                    tonumber(x), tonumber(y),
                    tonumber(width), tonumber(height),
                    imageWidth, imageHeight
                ),
                width = tonumber(width),
                height = tonumber(height),
                offsetX = 0,
                offsetY = 0
            })
        end
    end

    -- Set frames per second
    function self:setFPS(fps)
        self.fps = fps
    end

    -- Play a specified animation
    function self:play(animationName)
        if self.animations[animationName] then
            self.currentAnimation = animationName
            self.currentFrame = 1
        else
            print("Animation '" .. animationName .. "' not found.")
        end
    end

    -- Stop the current animation
    function self:stop()
        self.currentAnimation = nil
    end

    -- Pause the current animation
    function self:pause()
        self.paused = true
    end

    -- Resume the current animation
    function self:resume()
        self.paused = false
    end

    -- Check if the mouse is touching the sprite
    function self:mouseTouching()
        if self.checked then
            self.checked = false
            return self.isMouseTouching
        end
    end

    -- Update the sprite handler
    function self:update(dt)
        if self.currentAnimation and not self.paused then
            self.currentFrame = self.currentFrame + self.fps * dt
            if self.currentFrame >= #self.animations[self.currentAnimation] + 1 then
                self.currentFrame = 1
            end
        end
    end

    -- Draw the sprite at a given position
    function self:draw(x, y, rotation, size)
        if self.currentAnimation then
            local animationFrames = self.animations[self.currentAnimation]
            local frame = math.min(math.floor(self.currentFrame), #animationFrames)
            local animation = animationFrames[frame]
            local quad = animation.quad
            local width = animation.width
            local height = animation.height
            local offsetX = animation.offsetX
            local offsetY = animation.offsetY

            local mouseX, mouseY = love.mouse.getPosition()

            self.checked = true
            self.isMouseTouching = mouseX >= x - width/2 and mouseX <= x + width/2 and mouseY >= y - height/2 and mouseY <= y + height/2
            love.graphics.draw(self.image, quad, x - offsetX, y - offsetY, rotation, size, size, width/2, height/2)
        end
    end

    -- Deletes the sprite
    function self:destroy()
        self.image = nil
        self.animations = {}
    end

    return self
end

return SpriteHandler
