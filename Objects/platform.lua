Platform = Entity:extend()

function Platform:new(x, y, s, speed, leftRight, horizontal, size, targetNumber)
	self.strength = 100
	self.image = love.graphics.newImage("assets/images/tiles/platform.png")
	self.active = false

	Platform.super.new(self)

	self.x = x 						--starting x
	self.y = y 						--starting y
	self.s = s 						--desired travel distance
	self.speed = speed 				--self explanatory
	self.leftRight = leftRight 		--boolean value that determines travel direction
	self.horizontal = horizontal 	--determines the orientation of the platform
	self.size = size 				--object that has a tileset of the platform
	if leftRight then 				--logs starting position in the correct axis
		self.s0 = x
	else 
		self.s0 = y
	end
	if horizontal then   			--increse platform size in the right direction
		self.width = tileWidth * self.size
	else
		self.height = tileHeight * self.size
	end
	self.strength = 100				--strength in collision
	self.image = love.graphics.newImage("assets/images/tiles/platform.png")
	self.active = false				--if the platform is on or off
	self.targetNumber = targetNumber--what button the platform should be looking at
end

function Platform:update(dt)
	Platform.super.update(self, dt) 

	for i,v in ipairs(objects) do
		if v:is(Switch) and v.number == self.targetNumber then
			self.active = v.active
		end
	end

	if self.leftRight then --if the platform moves left and right
		if self.s > 0 then --if the travel distance is positive (right)
			if self.active then --move depending on if the platform is active or not
				self.x = self.x + self.speed * dt
			else
				self.x = self.x - self.speed * dt
			end
			if self.x > (self.s0 + self.s) then --when platform reaches the end of travel, stop there
				self.x = self.s0 + self.s
				if self.targetNumber == 0 then --if there is no input button, platform should reverse at the end of travel path
					self.active = false
				end
			elseif self.x < self.s0 then
				self.x = self.s0
				if self.targetNumber == 0 then
					self.active = true
				end
			end
		elseif self.s < 0 then --if the travel distance is negative (left)
			if self.active then
				self.x = self.x + self.speed * dt
			else
				self.x = self.x - self.speed * dt
			end

			if self.x < (self.s0 + self.s) then
				self.x = self.s0 + self.s
				if self.targetNumber == 0 then
					self.active = false
				end
			elseif self.x > self.s0 then
				self.x = self.s0
				if self.targetNumber == 0 then
					self.active = true
				end
			end
		end
	else --If platform moves up/down
		if self.s > 0 then --if the travel distance is positive (down)
			if self.active then
				self.y = self.y + self.speed * dt
			else
				self.y = self.y - self.speed * dt
			end
			if self.y > (self.s0 + self.s) then
				self.y = self.s0 + self.s
				if self.targetNumber == 0 then
					self.active = false
				end
			elseif self.y < self.s0 then
				self.y = self.s0
				if self.targetNumber == 0 then
					self.active = true
				end
			end
		elseif self.s < 0 then --if the travel distance is negative (up)
			if self.active then
				self.y = self.y - self.speed * dt
			else
				self.y = self.y + self.speed * dt
			end

			if self.y < (self.s0 + self.s) then
				self.y = self.s0 + self.s
				if self.targetNumber == 0 then
					self.active = false
				end
			elseif self.y > self.s0 then
				self.y = self.s0
				if self.targetNumber == 0 then
					self.active = true
				end
			end
		end
	end
end

function Platform:checkresolve(e)
	if e:is(Wall) then
		return false
	else
		return true
	end
end

function Platform:draw()
	if self.horizontal then
		for i=1, self.size do
			love.graphics.draw(self.image, self.x + (i-1)*tileWidth, self.y)
		end
	else
		for i=1, self.size do
			love.graphics.draw(self.image, self.x, self.y + (i-1)*tileHeight)
		end
	end
end