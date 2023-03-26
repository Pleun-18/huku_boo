require "Screens/gameover"
---------------------------------------------------
-- Village : Enemy
---------------------------------------------------
EnemyVillage = Enemy:extend()

--all enemy properties
function EnemyVillage:new(x,y)
	EnemyVillage.super.new(self, x, y)
	self.state = "alive"
	self.width = tileWidth 
	self.height = tileHeight*2
	self.strength = 10
	self.speed = 30
    self.weight = 750
    self.steps = 0

	-- Afbeeldingen Village
    self.enemyVillage_image_right = love.graphics.newImage("Assets/Images/Sprites/enemy_village1.png")
    self.enemyVillage_image_left = love.graphics.newImage("Assets/Images/Sprites/enemy_village2.png")
    self.enemyVillage_image_dead = love.graphics.newImage("Assets/Images/Sprites/enemy_village_dead.png") 

    local enemyVillage_width = self.enemyVillage_image_right:getWidth()
    local enemyVillage_height = self.enemyVillage_image_right:getHeight()

    enemyVillage_frames = {}

    local enemyVillage_frame_width = 30         
    local enemyVillage_frame_height = 60

    for i=0,5 do
        table.insert(enemyVillage_frames, love.graphics.newQuad(i*enemyVillage_frame_width, 0, enemyVillage_frame_width, enemyVillage_frame_height, enemyVillage_width, enemyVillage_height))
    end

    enemyVillage_currentFrame = 1
end

function EnemyVillage:update(dt)
	EnemyVillage.super.update(self, dt)
	
    enemyVillage_currentFrame = enemyVillage_currentFrame + dt

    enemyVillage_currentFrame = enemyVillage_currentFrame + 1 * dt
    if enemyVillage_currentFrame >= 5 then
        enemyVillage_currentFrame = 1
    end

	--an if statement for the automatic movement of the enemy
	if self.state == "alive" then 	
		if 	self.steps > 150 or
			self.steps < 0 then
			self.speed = -self.speed
		end
		self.x = self.x + self.speed*dt
		self.steps = self.steps + self.speed*dt
	end 
end

--a function to register the collision
function EnemyVillage:collide(e, direction)
    if self.state == "alive" or self.state == "dead" then 
	    EnemyVillage.super.collide(self, e, direction)
	    if direction == "bottom" then
	        self.canJump = true
	    end
	else end 
end

--draws the enemy
function EnemyVillage:draw()
	if self.state == "alive" then 
		if self.last.x >= self.x then
        	love.graphics.draw(self.enemyVillage_image_left, enemyVillage_frames[math.floor(enemyVillage_currentFrame)] ,self.x, self.y)
		elseif self.last.x <= self.x then 
			love.graphics.draw(self.enemyVillage_image_right, enemyVillage_frames[math.floor(enemyVillage_currentFrame)] ,self.x, self.y)
		end
	elseif self.state == "dead" then
		love.graphics.draw(self.enemyVillage_image_right, enemyVillage_frames[1],self.x + 60, self.y + 15, 90)
	end 
end

---------------------------------------------------
-- Castle : Enemy
---------------------------------------Z------------
EnemyCastle = Enemy:extend()

function EnemyCastle:new(x,y)
	EnemyCastle.super.new(self, x, y)
	self.state = "alive"
	self.width = tileWidth 
	self.height = tileHeight*2
	self.strength = 10
	self.speed = 30
    self.weight = 750
    self.steps = 0

    -- Afbeeldingen Castle
    self.enemyCastle_image_right = love.graphics.newImage("Assets/Images/Sprites/enemy_castle1.png")
    self.enemyCastle_image_left = love.graphics.newImage("Assets/Images/Sprites/enemy_castle2.png")
    self.enemyCastle_image_dead = love.graphics.newImage("Assets/Images/Sprites/enemy_castle_dead.png") 

    local enemyCastle_width = self.enemyCastle_image_right:getWidth()
    local enemyCastle_height = self.enemyCastle_image_right:getHeight()

    enemyCastle_frames = {}

    local enemyCastle_frame_width = 30         
    local enemyCastle_frame_height = 60

    for i=0,5 do
        table.insert(enemyCastle_frames, love.graphics.newQuad(i*enemyCastle_frame_width, 0, enemyCastle_frame_width, enemyCastle_frame_height, enemyCastle_width, enemyCastle_height))
    end

    enemyCastle_currentFrame = 1
end

--all the updates for the enemy
function EnemyCastle:update(dt)
	EnemyCastle.super.update(self, dt)
	
    enemyCastle_currentFrame = enemyCastle_currentFrame + dt

    enemyCastle_currentFrame = enemyCastle_currentFrame + 5 * dt
    if enemyCastle_currentFrame >= 5 then
        enemyCastle_currentFrame = 1
    end

	--an if statement for the automatic movement of the enemy
	if self.state == "alive" then 	
		if 	self.steps > 200 or
			self.steps < 0 then
			self.speed = -self.speed
		end
		self.x = self.x + self.speed*dt
		self.steps = self.steps + self.speed*dt
	end 
end

--a function to register the collision
function EnemyCastle:collide(e, direction)
    if self.state == "alive" or self.state == "dead" then 
	    EnemyCastle.super.collide(self, e, direction)
	    if direction == "bottom" then
	        self.canJump = true
	    end
	else end 
end

--draws the enemy

function EnemyCastle:draw()
	if self.state == "alive" then 
		if self.last.x <= self.x then 
			love.graphics.draw(self.enemyCastle_image_right, enemyCastle_frames[math.floor(enemyCastle_currentFrame)] ,self.x, self.y)
		elseif self.last.x >= self.x then 
			love.graphics.draw(self.enemyCastle_image_left, enemyCastle_frames[math.floor(enemyCastle_currentFrame)] ,self.x, self.y)
		end
	elseif self.state == "dead" then
		love.graphics.draw(self.enemyCastle_image_right, enemyCastle_frames[1],self.x + 60, self.y + 15, 90)
	end 
end

---------------------------------------------------
-- Woods : Enemy
---------------------------------------------------
EnemyWoods = Enemy:extend()

function EnemyWoods:new(x,y)
	EnemyWoods.super.new(self, x, y)
	self.state = "alive"
	self.width = tileWidth 
	self.height = tileHeight*2
	self.strength = 10
	self.speed = 30
    self.weight = 750
    self.steps = 0

    -- Afbeeldingen woods
    self.enemyWoods_image_right = love.graphics.newImage("Assets/Images/Sprites/enemy_woods1.png")
    self.enemyWoods_image_left = love.graphics.newImage("Assets/Images/Sprites/enemy_woods2.png")
    self.enemyWoods_image_dead = love.graphics.newImage("Assets/Images/Sprites/enemy_woods_dead.png") 

    local enemyWoods_width = self.enemyWoods_image_right:getWidth()
    local enemyWoods_height = self.enemyWoods_image_right:getHeight()

    enemyWoods_frames = {}

    local enemyWoods_frame_width = 30         
    local enemyWoods_frame_height = 60

    for i=0,5 do
        table.insert(enemyWoods_frames, love.graphics.newQuad(i*enemyWoods_frame_width, 0, enemyWoods_frame_width, enemyWoods_frame_height, enemyWoods_width, enemyWoods_height))
    end

    enemyWoods_currentFrame = 1
end

--all the updates for the enemy
function EnemyWoods:update(dt)
	EnemyWoods.super.update(self, dt)
	
    enemyWoods_currentFrame = enemyWoods_currentFrame + dt

    enemyWoods_currentFrame = enemyWoods_currentFrame + 5 * dt
    if enemyWoods_currentFrame >= 5 then
        enemyWoods_currentFrame = 1
    end

	--an if statement for the automatic movement of the enemy
	if self.state == "alive" then 	
		if 	self.steps > 100 or
			self.steps < 0 then
			self.speed = -self.speed
		end
		self.x = self.x + self.speed*dt
		self.steps = self.steps + self.speed*dt
	end 
end

--a function to register the collision
function EnemyWoods:collide(e, direction)
    if self.state == "alive" or self.state == "dead" then 
	    EnemyWoods.super.collide(self, e, direction)
	    if direction == "bottom" then
	        self.canJump = true
	    end
	else end 
end

--draws the enemy

function EnemyWoods:draw()
	if self.state == "alive" then 
		if self.last.x <= self.x then 
			love.graphics.draw(self.enemyWoods_image_right, enemyWoods_frames[math.floor(enemyWoods_currentFrame)] ,self.x, self.y)
		elseif self.last.x >= self.x then 
			love.graphics.draw(self.enemyWoods_image_left, enemyWoods_frames[math.floor(enemyWoods_currentFrame)] ,self.x, self.y)
		end
	elseif self.state == "dead" then
		love.graphics.draw(self.enemyWoods_image_right, enemyWoods_frames[1],self.x + 60, self.y + 15, 90)
    end

end

---------------------------------------------------
-- Cat : Enemy
---------------------------------------------------
Cat = Enemy:extend()

--all enemy properties
function Cat:new(x,y)
	Cat.super.new(self, x, y)
	self.state = "alive"
	self.width = tileWidth 
	self.height = 23
	self.strength = 5
	self.speed = 50
    self.weight = 750
    self.steps = 0
    self.image_cat_left = love.graphics.newImage("Assets/Images/Sprites/cat_left.png")
    self.image_cat_right = love.graphics.newImage("Assets/Images/Sprites/cat_right.png")
    self.image_cat_dead = love.graphics.newImage("Assets/Images/Sprites/cat-dead.png") 

    local enemyCat_width = self.image_cat_right:getWidth()
    local enemyCat_height = self.image_cat_right:getHeight()

    enemyCat_frames = {}

    local enemyCat_frame_width = 30         
    local enemyCat_frame_height = 23

    for i=0,5 do
        table.insert(enemyCat_frames, love.graphics.newQuad(i*enemyCat_frame_width, 0, enemyCat_frame_width, enemyCat_frame_height, enemyCat_width, enemyCat_height))
    end

    enemyCat_currentFrame = 1
end

--all the updates for the enemy
function Cat:update(dt)
	Cat.super.update(self, dt)
	enemyCat_currentFrame = enemyCat_currentFrame + dt

    enemyCat_currentFrame = enemyCat_currentFrame + 5 * dt
    if enemyCat_currentFrame >= 5 then
        enemyCat_currentFrame = 1
    end

	--an if statement for the automatic movement of the enemy
	if self.state == "alive" then 	
		if 	self.steps > 150 or
			self.steps < 0 then
			self.speed = -self.speed
		end
		self.x = self.x + self.speed*dt
		self.steps = self.steps + self.speed*dt
	end

	--gameover als je de cat doodmaakt
	if self.state == "dead" then 
        --self.image = love.graphics.newImage("Assets/Images/enemy-dead.png")
        state = "gameover"
        gameover.init() 
        return
    end 
end

--a function to register the collision
function Cat:collide(e, direction)
    if self.state == "alive" or self.state == "dead" then 
	    Cat.super.collide(self, e, direction)
	    if direction == "bottom" then
	        self.canJump = true
	    end
	else end 
end

--draws the enemy
function Cat:draw()
	if self.state == "alive" then 
		if self.last.x <= self.x then  
			love.graphics.draw(self.image_cat_right, enemyCat_frames[math.floor(enemyCat_currentFrame)] ,self.x, self.y)
		elseif self.last.x >= self.x then 
			love.graphics.draw(self.image_cat_left, enemyCat_frames[math.floor(enemyCat_currentFrame)] ,self.x, self.y)
		end
	elseif self.state == "dead" then
		love.graphics.draw(self.image_cat_right, enemyCat_frames[1],self.x + 60, self.y + 15, 90)
	end 
end