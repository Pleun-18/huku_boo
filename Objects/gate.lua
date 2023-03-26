-- Brings you from map to map throughout different levels

Gate = Entity:extend()

function Gate:new(x, y)
    Gate.super.new(self, x, y)
    self.strength = 0
    self.weight = 0
    self.width = 30
    self.height = 60
    self.pl_isTouched = false
    self.gh_isTouched = false
    self.gateState = "closed"
    self.houseState = "closed"
    self.image = love.graphics.newImage("Assets/Images/items/gate1.png")
    self.image_open = love.graphics.newImage("Assets/Images/items/gate2.png")
    self.image_house1 = love.graphics.newImage("Assets/Images/items/house6.png")
    self.image_house2 = love.graphics.newImage("Assets/Images/items/house7.png")

end

function Gate:update(dt)
    Gate.super.update(self, dt)

    if (self.gateState  == "open" or self.houseState == "open") and self.pl_isTouched == true and self.gh_isTouched == true then       
        print("next level entered")
        selectedLevel = selectedLevel + 1
        game.init()
    end
end

--function to register collision and let the player jump on top of a box
function Gate:collide(e, direction)
    if e:is(Player) then 
            self.isTouched = true
            self.gateState = "open"
            self.houseState = "open"
            self.pl_isTouched = true
            print("Player opened gate")
            return true 
    elseif e:is(Ghost) and ghost.state == "player" then
            self.isTouched = true
            self.gateState = "open"
            self.houseState = "open"
            self.gh_isTouched = true
            print("Ghost openend gate")
            return true 
    end
end

function Gate:checkResolve(e, direction)
    if e:is(Player) or e:is(Ghost) then
        return true
    else 
        return false
    end
end

function Gate:draw()
    if self.gateState == "closed" and (selectedLevel == 1 or selectedLevel == 2 or selectedLevel == 3) then
        love.graphics.draw(self.image, self.x, self.y) 
    elseif self.gateState == "open" and (selectedLevel == 1 or selectedLevel == 2 or selectedLevel == 3) then
        love.graphics.draw(self.image_open, self.x, self.y) 
    end
    if self.houseState == "closed" and selectedLevel == 4 then
        love.graphics.draw(self.image_house1, self.x, self.y)
        self.gateState = "gone"
    elseif self.houseState == "open" and selectedLevel == 4 then
        love.graphics.draw(self.image_house2, self.x, self.y)
        self.gateState = "gone"
    end
end