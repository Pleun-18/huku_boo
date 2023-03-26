Box = Entity:extend()

--all box properties
function Box:new(x, y)
    Box.super.new(self, x, y)
    self.strength = 0
    self.weight = 400
    self.image = love.graphics.newImage("Assets/Images/items/box.png")
end

--function to register collision and let the player jump on top of a box
function Box:collide(e, direction)
    Box.super.collide(self, e, direction)
    if direction == "bottom" then
        self.canJump = true
    end
end

function Box:draw()
	love.graphics.draw(self.image, self.x, self.y)
end