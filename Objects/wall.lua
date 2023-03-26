Wall = Entity:extend()

function Wall:new(x,y,image)
	Wall.super.new(self, x, y, image)
	self.strength = 10000
	self.weight = 0
	self.breakable = false 
end