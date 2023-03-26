--[PlatformerTest: wall.lua]--

Coin = Entity:extend()
score = 0
function Coin:new(x, y)
    
    Coin.super.new(self, x, y)
    self.img = love.graphics.newImage("Assets/Images/Items/coin.png")
    self.width = tileWidth
    self.height = tileHeight
    self.strength = 0
    self.weight = 0
    self.isTouched = false
    self.state = "Collectable"
    self.scaleX =  1 -- x scale flipt de afbeelding als de waarde negatief is
    self.randomTimeOffset = math.random(0,100) -- zorgt dat de coins random flippen dus niet allemaal dezelde "animatie" maken

end

function Coin:update(dt)
    self:spin(dt)
end

-- getTimer geeft de gametime tussen -1 en 1. 
function Coin:spin()
    self.scaleX = math.sin(love.timer.getTime() *2 + self.randomTimeOffset)
end

-- wanneer de player de coin van alle kanten collide dan isTouched true en veranderd het de staat naar collected. score counter +1
function Coin:collide(e, direction)
    --Coin.super.collide(self, e, direction)
    if e:is(Player) and self.isTouched == false then 
            self.isTouched = true 
            self.state = "collected"
            score = score + 1
    elseif e:is(Ghost) and ghost.state == "player" and self.isTouched == false then 
            self.isTouched = true 
            self.state = "collected"
            score = score + 1
    end
end

function Coin:checkResolve(e, direction)
    if e:is(Player) and self.isTouched == false then
        return true
    elseif e:is(Ghost) and ghost.state == "player" and self.isTouched == false then
        return true
    end
    return false
end

-- tekent een coin alleen als de staat collecteble is op de x / y cordinaten, rotatie 0, scale en helft width/height
function Coin:draw()
	if self.state == "Collectable" then 
		love.graphics.draw(self.img, self.x + 15, self.y + 15, 0, self.scaleX, 1, self.width / 2, self.height / 2)
    end
end