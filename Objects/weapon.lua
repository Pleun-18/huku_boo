Weapon = Entity:extend()

--alle properties van de wapens
function Weapon:new(x, y, weaponType)
    Weapon.super.new(self, x, y)
    self.strength = 0
    self.weight = 0
    self.state = "collectable"
    self.isTouched = false
    self.width = tileWidth
    self.height = tileHeight 
    self.scaleX =  1 -- x scale flipt de afbeelding als de waarde negatief is
    self.randomTimeOffset = math.random(0,100) -- zorgt dat de weapons random flippen dus niet allemaal dezelde "animatie" maken

    --alle soorten wapens worden hier gedefineerd
    self.weaponType = weaponType 
    if weaponType == "wooden-sword" then
        self.image = love.graphics.newImage("Assets/Images/Weapons/wooden-sword.png")
        self.damage = 2
    elseif weaponType == "bow" then
        self.image = love.graphics.newImage("Assets/Images/Weapons/bow.png")
        self.damage = 3
    elseif weaponType == "axe" then
        self.image = love.graphics.newImage("Assets/Images/Weapons/axe.png")
        self.damage = 4
    elseif weaponType == "bomb" then
        self.image = love.graphics.newImage("Assets/Images/Weapons/bomb.png")
        self.damage = 4
    end
end

function Weapon:update(dt)
    self:spin(dt)
end

-- getTimer geeft de gametime tussen -1 en 1. 
function Weapon:spin()
    self.scaleX = math.sin(love.timer.getTime() *3 + self.randomTimeOffset)
end

--hier wordt geregistreerd of de wapens worden aangeraakt
function Weapon:collide(e, direction)
    if e:is(Player) or (e:is(Ghost) and e.state == "Player" )then
        self.state = "collected"
        for i,v in ipairs(slots) do
            if v.weapon == " " then
                v.weapon = self.weaponType
                v.image = self.image
                break
            end
        end
        print("collected")
    end
end

--hier wordt de collision gecheckt met de player en ghost en zorgt ervoor dat
--de wapens worden opgeslagen in de inventory als ze de wapen aanraken
function Weapon:checkResolve(e, direction)
    if self.state == "collectable" and (e:is(Player) or (e:is(Ghost) and e.state == "player")) then
        return true
    else
        return false
    end
end

--de wapens worden hier getekend alleen als ze nog niet verzameld zijn. 
function Weapon:draw()
    if self.state == "collectable" then
        love.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, 1, self.width / 2, self.height / 2)
    end
end