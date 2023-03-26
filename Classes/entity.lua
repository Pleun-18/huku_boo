--[[LevelLoadingTest]]--

Entity = Object:extend()
--maak een nieuw object aan dat reageert op zwaartekracht en collision
function Entity:new(x, y, image)
	self.x = x 
	self.y = y 
	self.image = image 
	self.width = tileWidth
	self.height = tileHeight

	self.last = {}
	self.last.x = self.x
	self.last.y = self.y

	self.strength = 0
	self.tempStrength = 0

    self.speed = 0
    self.gravity = 0
    self.weight = 0
end
--update het object
function Entity:update(dt)

	self.last.x = self.x
	self.last.y = self.y
    --wanneer object tegen een muur staat, kan deze niet verder gedrukt worden
	self.tempStrength = self.strength
    --vergroot de zwaartekracht terwijl object valt
    self.gravity = self.gravity + self.weight * dt
    --laat object vallen m.b.v. de zwaartekracht
    self.y = self.y + self.gravity * dt
end

--controleer of twee objecten overlappen
function Entity:checkCollision(e)
	return self.x + self.width > e.x
    and self.x < e.x + e.width
    and self.y + self.height > e.y
    and self.y < e.y + e.height
end

--controleer of objecten horizontaal overlapten
function Entity:wasHorizontallyAligned(e)
    return self.last.x < e.last.x + e.width and self.last.x + self.width > e.last.x
end

--controleer of objecten verticaal overlapten
function Entity:wasVerticallyAligned(e)
    return self.last.y < e.last.y + e.height and self.last.y + self.height > e.last.y
end

--Controleer of objecten colliden, of ze beide willen resolven, en resolven wanneer dat zo is.
function Entity:resolveCollision(e)
    --Als object meer strength heeft dan het andere object, voer deze functie uit voor het andere object.
	if self.tempStrength > e.tempStrength then
        return e:resolveCollision(self)
    end
    --Als objecten colliden, controleer of beide collision willen resolven. 
	if self:checkCollision(e) then
		self.tempStrength = e.tempStrength
        --Als objecten verticaal overlapten...
		if self:wasVerticallyAligned(e) then
            --En huidig object links staat van het andere object...
			if self.x + self.width/2 < e.x + e.width/2  then
                --controleer of beide objecten willen resolven
                local a = self:checkResolve(e, "right")
                local b = e:checkResolve(self, "left")
                -- Als a en b beide willen resolven, resolve dan de collision. .
                if a and b then
                    self:collide(e, "right")
                end
            else
                local a = self:checkResolve(e, "left")
                local b = e:checkResolve(self, "right")
                if a and b then
                    self:collide(e, "left")
                end
            end
        elseif self:wasHorizontallyAligned(e) then
        	if self.y + self.height/2 < e.y + e.height/2 then
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "bottom")
                end
            else
                local a = self:checkResolve(e, "bottom")
                local b = e:checkResolve(self, "top")
                if a and b then
                    self:collide(e, "top")
                end
            end
        end
        return true
	end
	return false
end

--controleer of object de collision wilt resolven met het andere object, in de gegeven richting
function Entity:checkResolve(e, direction)
    return true
end

--voer actie uit wanneer de collision resolved wordt. 
function Entity:collide(e, direction)
    if direction == "right" then
        local pushback = self.x + self.width - e.x
        self.x = self.x - pushback
    elseif direction == "left" then
        local pushback = e.x + e.width - self.x
        self.x = self.x + pushback
    elseif direction == "bottom" then
        local pushback = self.y + self.height - e.y
        self.y = self.y - pushback
        self.gravity = 0
    elseif direction == "top" then
        local pushback = e.y + e.height - self.y
        self.y = self.y + pushback
        self.gravity = 0
    end
end

--teken het object
function Entity:draw()
	love.graphics.draw(self.image, self.x, self.y)
end