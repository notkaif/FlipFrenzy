local SpriteHandler = {}

function SpriteHandler.new() -- Creating a new sprite
	local self = {}

	local image               -- Sets spritesheet image
	local animations = {}     -- Table with all possible animations in the spritesheet

	local currentAnimation = nil -- Current animation to be played
	local currentFrame = 1    -- Current frame of the animation
	local paused = false      -- Animation paused or not
	local fps = 24            -- Animation playback FPS

	local checked = false
	local isMouseTouching = false

	function self:setImage(imgPath) -- Sets the spritesheet image
		image = love.graphics.newImage(imgPath)
	end

	function self:setXML(filePath) -- Sets the spritesheets XML data (Sparrow v2 or Starling format half supported)
		local data = love.filesystem.read(filePath)
		local _, _, imagePath = data:find('imagePath="([^"]+)"')

		for name, x, y, width, height in
		data:gmatch('<SubTexture name="([^"]+)" x="(%d+)" y="(%d+)" width="(%d+)" height="(%d+)"')
		do
			local animationName = name:match("([^%d]+)")
			animations[animationName] = animations[animationName] or {}
			table.insert(animations[animationName], {
				quad = love.graphics.newQuad(
					tonumber(x),
					tonumber(y),
					tonumber(width),
					tonumber(height),
					image:getWidth(),
					image:getHeight()
				),
				width = tonumber(width),
				height = tonumber(height),
			})
		end
	end

	function self:setFPS(f) -- Sets the animation playback FPS
		fps = f
	end

	function self:Play(animationName) -- Plays the animation passed through
		if animations[animationName] then
			currentAnimation = animationName
			currentFrame = 1
		else
			print("Animation '" .. animationName .. "' not found.")
		end
	end

	function self:Stop() -- Stops the current animation
		currentAnimation = nil
	end

	function self:Pause() -- Pauses the current animation
		paused = true
	end

	function self:Resume() -- Resumes the current animation
		if currentFrame >= #animations[currentAnimation] + 1 then -- If resumed when animation was fully complete, it will play the animation again.
			currentFrame = 1
		end
		paused = false
	end

	function self:MouseTouching()
		if checked then
			checked = false
			return isMouseTouching
		end
	end

	function self:update(dt) -- Updates the animation each frame
		if currentAnimation and not paused then
			currentFrame = currentFrame + fps * dt
			if currentFrame >= #animations[currentAnimation] + 1 then
				return "animFinish"
			end
		end
	end

	function self:draw(x, y, rotation, sizeMultiplier) -- Draws the sprite at the x and y provided
		if currentAnimation then
			local animationFrames = animations[currentAnimation]
			local frame = math.min(math.floor(currentFrame), #animationFrames)
			local animation = animationFrames[frame]
			local quad = animation.quad
			local width = animation.width * sizeMultiplier
			local height = animation.height * sizeMultiplier

			local mouseX, mouseY = love.mouse.getPosition()

			checked = true
			isMouseTouching = mouseX >= x and mouseX <= x + width and mouseY >= y and mouseY <= y + height

			love.graphics.draw(image, quad, x, y, rotation, sizeMultiplier, sizeMultiplier)
		end
	end

	function self:Destroy()
        image = nil
        animations = {}
		self = nil
    end

	return self
end

return SpriteHandler