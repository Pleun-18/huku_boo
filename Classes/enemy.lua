Enemy = {}

Enemy = Entity:extend()

--all enemy properties
function Enemy:new(x,y)
	Enemy.super.new(self, x, y)
	self.state = "alive"
	self.width = tileWidth 
	self.height = tileWidth
	self.strength = 10
	self.speed = 30
    self.weight = 750
    self.steps = 0
    self.hp = 10
    self.image = love.graphics.newImage("Assets/Images/Sprites/enemy.png")
    self.image_dead = love.graphics.newImage("Assets/Images/Sprites/enemy-dead.png") 
end

--all the updates for the enemy
function Enemy:update(dt)
	Enemy.super.update(self, dt)
	--an if statement for the automatic movement of the enemy
	if self.state == "alive" then 	
		if 	self.steps > 150 or
			self.steps < 0 then
			self.speed = -self.speed
		end
		self.x = self.x + self.speed*dt
		self.steps = self.steps + self.speed*dt
	end 

	--enemy gaat dood bij hp 
	if self.hp <= 0 and self.state ~= "posessed" then 
		self.state = "dead" 
		 self.width = 60
         self.height = 30
	end 
	--print("state" .. self.state)
end

--a function to register the collision
function Enemy:collide(e, direction)
    if self.state == "alive" or self.state == "dead" then 
	    Enemy.super.collide(self, e, direction)
	    if direction == "bottom" then
	        self.canJump = true
	    end 
	else
	end
end

--draws the enemy
function Enemy:draw()
	if self.state == "alive" then 
		love.graphics.draw(self.image, self.x, self.y)
	elseif self.state == "dead" then
		love.graphics.draw(self.image_dead, self.x, self.y)
	end 
end