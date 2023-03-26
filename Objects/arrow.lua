Arrow = Object:extend()

function Arrow:new(x, y, speed)
    self.image = love.graphics.newImage("Assets/Images/Weapons/arrow2.png")
    self.x = x
    self.y = y
    self.speed = speed
    self.isTouched = false
    --We'll need these for collision checking
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

end

function Arrow:update(dt)
    self.x = self.x + self.speed * dt

    for i, v in ipairs(objects) do --doorloopt de objects library

        if self.x + self.width > v.x  --en een object door de aanval wordt geraakt
            and self.x < v.x + v.width
            and self.y + self.height > v.y
            and self.y < v.y + v.height then 
                print("hit!")
            if v:is(Enemy) then            --en het object een enemy is...
                v.hp = v.hp - 6           --haal de damage af van de enemy hp...
                self.isTouched = true      --en verschuif de enemy naar rechts
            end
        end
    end
end

function Arrow:draw()
    if player.direction == "right" then
        love.graphics.draw(self.image, self.x, self.y + 30, 0, 0.5)
    elseif player.direction == "left" then
        love.graphics.draw(self.image, self.x, self.y + 30, 0, -0.5, 0.5)
    end
end
