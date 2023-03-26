Barrel = Entity:extend()

function Barrel:new(x, y)
    Barrel.super.new(self, x, y)
    self.image = love.graphics.newImage("Assets/Images/Items/barrel.png")
    self.strength = 5
    self.weight = 700
    self.frames = {}
    self.frame = 1
    self.steps = 0

    for i=0,3 do
    	table.insert(self.frames, love.graphics.newQuad(1+(tileWidth+1)*i, 1, tileWidth, tileHeight, 125, 32))
    end
end

function Barrel:update(dt)
	self.x = self.x + self.speed*dt
	self.steps = self.steps + self.speed*dt
	
	self.frame = (math.floor(self.steps/10)%4)+1

	Barrel.super.update(self,dt)
end

function Barrel:collide(e, direction)
    Barrel.super.collide(self, e, direction)

	if direction == "left" or direction == "right" then 
		if e:is(Wall) or e.x == e.last.x then 
			self.speed = 0
			else
			if direction == "right" then
				self.x = self.x - 5
				self.speed = -e.speed
			elseif direction == "left" then
				self.x = self.x + 5
				self.speed = e.speed
			end
			
		end
	end
end

function Barrel:checkResolve(e,direction)
	if e:is(Coin) or e:is(Potion) or (e:is(Player) and direction == "top") then
		return false
	else 
		return true
	end
end

function Barrel:draw()
	love.graphics.draw(self.image, self.frames[self.frame],self.x, self.y)
end