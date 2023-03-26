Potion = Entity:extend()

    potion1Counter = 0
    potion2Counter = 0
    potion3Counter = 0
    potion4Counter = 0

function Potion:new(x, y, type)
    --the potion counters    
    
    Potion.super.new(self, x, y)
    self.strength = 0
    self.weight = 0
    self.state = "collectable"
    self.isTouched = false

    self.potionType = type
    if type == 1 then
        self.image = love.graphics.newImage("Assets/Images/Items/potion1.png")
    elseif type == 2 then
        self.image = love.graphics.newImage("Assets/Images/Items/potion2.png")
    elseif type == 3 then
        self.image = love.graphics.newImage("Assets/Images/Items/potion3.png")
    elseif type == 4 then
        self.image = love.graphics.newImage("Assets/Images/Items/potion4.png")
    end
end

function Potion:update(dt)

end

function Potion:collide(e, direction)
    if e:is(Player) and self.isTouched == false then
        if direction == "left" or direction == "top" or direction == "right" or direction == "bottom" then
            self.isTouched = true
            self.state = "collected"
            return true
        else
            self.state = "collectable"
        end     
    elseif e:is(Ghost) and self.isTouched == false then
        if ghost.state == "player" then 
            if direction == "left" or direction == "top" or direction == "right" or direction == "bottom" then
                self.isTouched = true
                self.state = "collected"
                return true
            else
                self.state = "collectable"
            end
        end 
    end
    return true
end

function Potion:checkResolve(e, direction)
    if e:is(Player) and self.isTouched == false then
        if direction == "left" or direction == "top" or direction == "right" or direction == "bottom" then
            self.isTouched = true
            self.state = "collected"
            if self.potionType == 1 then
                potion1Counter = potion1Counter + 1
            elseif self.potionType == 2 then
                potion2Counter = potion2Counter + 1
            elseif self.potionType == 3 then
                potion3Counter = potion3Counter + 1
            elseif self.potionType == 4 then
                potion4Counter = potion4Counter + 1
            end
            return true
        end 
    elseif e:is(Ghost) and self.isTouched == false then
        if ghost.state == "player" then 
            if direction == "left" or direction == "top" or direction == "right" or direction == "bottom" then
                self.isTouched = true
                self.state = "collected"
                if self.potionType == 1 then
                    potion1Counter = potion1Counter + 1
                elseif self.potionType == 2 then
                    potion2Counter = potion2Counter + 1
                elseif self.potionType == 3 then
                    potion3Counter = potion3Counter + 1
                elseif self.potionType == 4 then
                    potion4Counter = potion4Counter + 1
                end
                return true
            end 
        end 
    else
        return false
    end 
end

function Potion:draw()
    if self.state == "collectable" then
        love.graphics.draw(self.image, self.x, self.y)
    end
end