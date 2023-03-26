Witch = Entity:extend()

--all enemy properties
function Witch:new(x,y)
	Witch.super.new(self, x, y)
	self.state = "alive"
    self.weight = 2000
	self.strength = 2000
    self.image_witch = love.graphics.newImage("Assets/Images/Sprites/heks_front.png")

	local witch_width = self.image_witch:getWidth()
    local witch_height = self.image_witch:getHeight()

    witch_frames = {}

    local witch_frame_width = 30         
    local witch_frame_height = 60

    for i=0,4 do
        table.insert(witch_frames, love.graphics.newQuad(i*witch_frame_width, 0, witch_frame_width, witch_frame_height, witch_width, witch_height))
    end

    witch_currentFrame = 1
end

function Witch:update(dt)

witch_currentFrame = witch_currentFrame + dt
    if witch_currentFrame >= 4 then
        witch_currentFrame = 1
    end
end

function Witch:draw()
	love.graphics.draw(self.image_witch, witch_frames[math.floor(witch_currentFrame)], self.x, self.y)
end