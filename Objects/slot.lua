Slot = Entity:extend()

function Slot:new(x,y)
	Slot.super.new(self, x, y)

	self.width = 50
    self.height = 50
    self.weapon = " "
    self.image = love.graphics.newImage("Assets/Images/Tiles/transparent.png")
end

function Slot:update(dt)

end

function Slot:draw()
    --De sloten hebben zijn vierkant
    love.graphics.rectangle("line", self.x, self.y, 50, 50)
    love.graphics.draw(self.image, self.x, self.y)
end