Switch = Entity:extend()

function Switch:new(x,y,switchType,switchNumber)
	Switch.super.new(self)
	self.x = x
	self.y = y
	self.type = switchType
	self.number = switchNumber
	self.active = false
	self.coolDown = 0.5
	self.strength = 100
	self.image = love.graphics.newImage("Assets/Images/Items/Switch.png")

	self.img_off = love.graphics.newQuad(31, 0, 30, 30, 61, 30)
	self.img_on = love.graphics.newQuad(0, 0, 30, 30, 61, 30)
end

function Switch:update(dt)
	Switch.super.update(self, dt)
	if self.type == "toggle" then
		if love.keyboard.isDown("e") and self.coolDown >= 0.5 and 
		(Switch.super.checkCollision(self, player) or (Switch.super.checkCollision(self, ghost) and ghost.state == "Player")) then
			self.active = not self.active
			self.coolDown = 0
		end
		if self.coolDown < 0.5 then
			self.coolDown = self.coolDown + 1 * dt
		else 
			self.coolDown = 0.5
		end
	elseif self.type == "hold" then
		if love.keyboard.isDown("e") and 
		(Switch.super.checkCollision(self, player) or (Switch.super.checkCollision(self, ghost) --[[and ghost.state == "Player"]])) then
			self.active = true
		else
			self.active = false
		end
	elseif self.type == "oneclick" then
	 	if love.keyboard.isDown("e") and 
	 	(Switch.super.checkCollision(self, player) or (Switch.super.checkCollision(self, ghost) --[[and ghost.state == "Player"]])) then
	 		self.active = true
	 	end

	elseif self.type == "trigger" then
	 	if (Switch.super.checkCollision(self, player) or (Switch.super.checkCollision(self, ghost) and ghost.state == "Player")) then
	 		self.active = true
	 	end
	 end
end

function Switch:checkResolve(e)
		return false
end

function Switch:draw()
	if self.type ~= "trigger" then
		if self.active then
			love.graphics.draw(self.image, self.img_on, self.x, self.y)
		else
			love.graphics.draw(self.image, self.img_off, self.x, self.y)
		end
	end
end
