Bomb = Entity:extend()

function Bomb:new(x, y)
    Bomb.super.new(self, x, y)
    self.image = love.graphics.newImage("Assets/Images/Items/Bomb.png")
    self.strength = 5
    self.weight = 700
    self.frames = {}
    self.frame = 1
    self.explosionSize = 0 --houdt bij hover de explosie loopt
    self.steps = 0 --houdt afgelegde afstand bij
    self.touchable = false --bepaalt of bom aangeraakt kan worden door player
    self.fuse = 3 --totale tijd voor de explosie

    bombSound = love.audio.newSource("Assets/Music/bomb.mp3", "static")

    for i=0,4 do
    	table.insert(self.frames, love.graphics.newQuad(1+(tileWidth+1)*i, 1, tileWidth, tileHeight, 156, 32)) --maak quads voor de bom
    end
end

function Bomb:update(dt)
	print("check")
	if self.explosionSize <=0 then --laat de bom heen en weer rollen wanneer explosie niet plaatsvindt
		self.x = self.x + self.speed*dt --verander positie gebaseerd op speed
		self.steps = self.steps + self.speed*dt --houd afgelegde afstand bij op basis van speed
		
		self.frame = ( math.floor(self.steps/10)%4)+1 --verander frame op basis van afgelegde afstand
	end

	if not Bomb.super.checkCollision(self, player) then --wanneer player niet over de bom staat, 
		self.touchable = true --dan kan de bom aangeraakt worden
	end

	self.fuse = self.fuse - 1*dt --timer voor explosie, telt ieder frame af

	if self.fuse <= 0 then --wanneer te timer is afgelopen
		self.speed = 0 --stop horizontale beweging
		self.gravity = 0 --stop verticale beweging
		self.explosionSize = self.explosionSize + 30*dt --laat de explosie verder lopen

		love.audio.play(bombSound)

		if self.explosionSize >= 5 then --wanneer de explosie op zn; grootst is
			self.x = self.x - 60 --verschuif hitbox 2 tiles naar links
			self.y = self.y - 60 --verschuif hitbox 2 tiles naar boven
			self.width = 150 --maak breedte 5 tiles groot
			self.height = 150 --maak hoogte 5 tils groot
			
			for i,v in ipairs(objects) do
				if Bomb.super.checkCollision(self, v) then --als de hitbox van de bom overlapt met een object...
					if v:is(Player) or (v:is(Ghost) and v.state == "player") or v:is(Enemy) then --en het object een player, posessed enemy, of enemy is...
						v.hp = v.hp - 10 --haal 10 van object's hp af
					end
				end
			end

			for i = #walls, 1, -1 do
				if Bomb.super.checkCollision(self, walls[i]) then --als bomb hitbox overlapt met een wall...
					if walls[i].breakable == true then --en de muur breekbaar is...
						table.remove(walls, i) --verwijder de muur uit de lijst van muren
					end
				end
			end
			
			for i,v in ipairs(objects) do
				if v == self then --wanneer bom zichzelf tegenkomt in de lijst...
					table.remove(objects,i) --verwijdert het zichzelf uit de lijst...
					break --en breekt de loop af
				end
			end
		end
	end

	Bomb.super.update(self,dt) --update
end

function Bomb:collide(e, direction)
	if self.fuse > 0 then --wanner bom nog niet ontploft is...
	    Bomb.super.collide(self, e, direction) --collide
		if direction == "left" or direction == "right" then --als richting links of rechts is...
			if e:is(Wall) or e.x == e.last.x then --en e is een wall, of e staat stil...
				self.speed = 0 --stop met rollen
			else--anders
				if direction == "right" then --als richting rechts is...
					self.x = self.x - 5 --verschuif iets naar links
					self.speed = -e.speed --neem speed van e over
				elseif direction == "left" then --als richting links is...
					self.x = self.x + 5 --verschuif iets naar rechts
					self.speed = e.speed --neem speed van e over
				end
			end	
		end
	end
end

function Bomb:checkResolve(e,direction)
	if e:is(Player) and not self.touchable then --wanneer de speler de bom nog niet mag aanraken...
		return false --laat de bom niet aanraken
	end

	if e:is(Coin) or e:is(Potion) or (e:is(Ghost) and e.state == "ghost") then --laat bom niet coins, potions of ghost aanraken.
		return false
	else 
		return true
	end
end

function Bomb:draw()
	if self.explosionSize <= 0 then --wanneer explosie nog niet plaatsvindt...
		love.graphics.draw(self.image, self.frames[self.frame],self.x, self.y) --teken de bom zelf, afhankelijk van frames
	elseif self.explosionSize >= 5 then --wanneer explosie op grootste punt is...
		love.graphics.draw(self.image, self.frames[5], self.x, self.y, 0, self.explosionSize, self.explosionSize) --teken explosie over hele hitbox
	else --wanneer explosie nog bezig is...
		love.graphics.draw(self.image, self.frames[5], self.x - self.explosionSize*15 + 15, self.y - self.explosionSize*15 + 15, 0, self.explosionSize, self.explosionSize) --teken explosie afhankelijk wan hoever explosie is
	end
end