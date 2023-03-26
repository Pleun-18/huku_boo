require "Screens/gameover"

Player = Entity:extend()

function Player:new(x,y)
	Player.super.new(self, x, y)
    self.height = tileWidth*2
	self.strength = 20
    self.weight = 750
    self.speed = 200  
    self.state = "alive"
    self.activeWeapon = " "
    self.canJump = true
    self.hp = 10
    self.isWalking = false

    slapSound = love.audio.newSource("Assets/Music/slap.mp3", "static")
    arrowSound = love.audio.newSource("Assets/Music/arrow.mp3", "static")

    self.swipeImage = love.graphics.newImage("Assets/Images/Items/Swipe.png")
    self.swipeCounter = 0 --bepaald hoe lang de swipe op het scherm is
    self.swipeScale = 0 --grootte van de swipe
    self.cooldown = 0 --interval tussen de aanvallen

    --all images for the player
    self.image_right = love.graphics.newImage("Assets/Images/Sprites/player_right.png")
    self.image_left = love.graphics.newImage("Assets/Images/Sprites/player_left.png")

    self.imgWoodenSword_right = love.graphics.newImage("Assets/Images/Sprites/player_right_sword.png")
    self.imgWoodenSword_left = love.graphics.newImage("Assets/Images/Sprites/player_left_sword.png")

    self.imgBow_right = love.graphics.newImage("Assets/Images/Sprites/player_right_bow.png")
    self.imgBow_left = love.graphics.newImage("Assets/Images/Sprites/player_left_bow.png")

    self.imgAxe_right = love.graphics.newImage("Assets/Images/Sprites/player_right_axe.png")
    self.imgAxe_left = love.graphics.newImage("Assets/Images/Sprites/player_left_axe.png")

    self.imgBomb_right = love.graphics.newImage("Assets/Images/Sprites/player_right_bomb.png")
    self.imgBomb_left = love.graphics.newImage("Assets/Images/Sprites/player_left_bomb.png")

    local pl_width = self.image_right:getWidth()
    local pl_height = self.image_right:getHeight()

    pl_frames = {}

    local pl_frame_width = 30         
    local pl_frame_height = 60

    for i=0,5 do
        table.insert(pl_frames, love.graphics.newQuad(i*pl_frame_width, 0, pl_frame_width, pl_frame_height, pl_width, pl_height))
    end

    pl_currentFrame = 1

end

function Player:update(dt)
    pl_currentFrame = pl_currentFrame + dt

    pl_currentFrame = pl_currentFrame + 5 * dt
    if pl_currentFrame >= 5 then
        pl_currentFrame = 1
    end

    if love.keyboard.isDown("w") then 
        if self.canJump then
            self.gravity = -1100+self.weight
            self.canJump = false
        end
    end

    if self.last.y ~= self.y then
        self.canJump = false
    end    

    --to toggle between the weapons press one of the number keys
    if love.keyboard.isDown("1") then 
        self.activeWeapon = slots[1].weapon        
    elseif love.keyboard.isDown("2") then 
        self.activeWeapon = slots[2].weapon         
    elseif love.keyboard.isDown("3") then 
        self.activeWeapon = slots[3].weapon    
    elseif love.keyboard.isDown("4") then 
        self.activeWeapon = slots[4].weapon    
    end 

    --if you die you go back to menu
    if self.state == "dead" then
        state = "gameover"
        gameover.init() 
        return
    end 
    
    --if the hp is 0 or lower, you die
    if self.hp <= 0 then 
        self.state = "dead" 
    end 

    Player.super.update(self, dt)

    if love.keyboard.isDown("a") then
        self.direction = "left"
        self.isWalking = true 
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("d") then
        self.direction = "right"
        self.isWalking = true
        self.x = self.x + self.speed * dt
    else
        self.isWalking = false 
    end 

    self.cooldown = self.cooldown - 1*dt
    if self.cooldown < 0 then
        self.cooldown = 0
    end

    --voer verschillende aanvallen uit gebaseerd op welk wapen geselecteerd is
    if love.keyboard.isDown("space") and self.cooldown == 0 then
        if self.activeWeapon == " " then
            Player:attack(1, 20)      --val aan met deze waarden, damage en range
            self.cooldown = 0.5       --zet interval tussen aanvallen op 0.5 seconde
            self.swipeCounter = 0.1   --zet duur van het swipe effect op 0.1 seconde
            self.swipeScale = 0.6     -- zet de schaal van het effect op 0.5
        elseif self.activeWeapon == "wooden-sword" then
            Player:attack(4, 30)
            self.cooldown = 0.8
            self.swipeCounter = 0.3
            self.swipeScale = 1
            love.audio.play(slapSound)
        elseif self.activeWeapon == "bow" then 
            love.audio.play(arrowSound)
            self.cooldown = 2
            if self.direction == "right" then
                table.insert(listOfArrows, Arrow(self.x, self.y, 400))
            elseif self.direction == "left" then
                table.insert(listOfArrows, Arrow(self.x, self.y, -400))
            end
        elseif self.activeWeapon == "axe" then
            Player:attack(8, 45)
            self.cooldown = 1
            self.swipeCounter = 0.5
            self.swipeScale = 1.5
            love.audio.play(slapSound)
        elseif self.activeWeapon == "bomb" then
            self.cooldown = 3
            newBomb = Bomb(self.x, self.y) --maak bomobject aan
            table.insert(objects, newBomb) --plaats bomobject in objects library
        end 
    end

    self.swipeCounter = self.swipeCounter - 1*dt --tel swipeCounter af

    if self.swipeCounter < 0 then --als swipecounter onder 0 komt, terugzetten op 0
        self.swipeCounter = 0
    end
end

--voert een aanval uit op basis van damage, range, en richting
function Player:attack(damage, range)
    for i, v in ipairs(objects) do --doorloopt de objects library

        if player.direction == "right" then   --als de player naar rechts kijkt...
            if player.x + player.width + range > v.x  --en een object door de aanval wordt geraakt
            and player.x < v.x + v.width
            and player.y + player.height > v.y
            and player.y < v.y + v.height then
                if v:is(Enemy) then                 --en het object een enemy is...
                    v.hp = v.hp - damage            --haal de damage af van de enemy hp...
                    v.x = v.x + 30                  --en verschuif de enemy naar rechts
                end
            end

        elseif player.direction == "left" then
            if player.x + player.width > v.x
            and player.x - range < v.x + v.width
            and player.y + player.height > v.y
            and player.y < v.y + v.height then
                if v:is(Enemy) then
                    v.hp = v.hp - damage
                    v.x = v.x - 30
                end
            end
        end
    end
end

--if you touch an enemy when its alive you lose hp and you get pushed back
function Player:collide(e, direction)
    --when touched by an enemy and enemy is alive, get hit and take damage
    if e:is(Enemy) and e.state == "alive" then
        --when hit from the left, get pushed to the right 
        if direction == "left" then 
            self.hp = self.hp - 3
            self.x = self.x + 2 * tileWidth
            self.gravity = -1300 + self.weight
        -- when hit from the right, get pushed to the left
        elseif direction == "right" then 
            self.hp = self.hp - 3
            self.x = self.x - 2 * tileWidth
            self.gravity = -1300 + self.weight
        --when hit from the top...
        elseif direction == "top" then 
            self.hp = self.hp - 3
            e.gravity = -800 + e.weight
        --if you jump on the enemy you kill it
        elseif direction == "bottom" then
            self.hp = self.hp - 3
            self.y = self.y - 2 * tileWidth
            self.gravity = -800 + self.weight
        end
    elseif e:is(Platform) and direction == "bottom" then
        Player.super.collide(self, e, direction)
        self.x = self.x + (e.x - e.last.x)
    else
        Player.super.collide(self, e, direction)
    end
        
    if direction == "bottom" then  
        self.canJump = true 
    end 
        
end


function Player:checkResolve(e, direction)
    if e:is(Enemy) and e.state == "dead" then
        return false 
    end
    return true
end

function Player:draw()
    --maakt een locale var aan dat afhankelijk van welke richting en welk wapen je hebt wordt getekend
    local img = self.image_right
    if self.direction == "right" then
            img = self.image_right
        if self.activeWeapon == "wooden-sword" then 
            img = self.imgWoodenSword_right
        elseif self.activeWeapon == "bow" then 
            img = self.imgBow_right
        elseif self.activeWeapon == "axe" then 
            img = self.imgAxe_right 
        elseif self.activeWeapon == "bomb" then 
            img = self.imgBomb_right
        end 
    elseif self.direction == "left" then
            img = self.image_left
        if self.activeWeapon == "wooden-sword" then 
            img = self.imgWoodenSword_left
        elseif self.activeWeapon == "bow" then 
            img = self.imgBow_left
        elseif self.activeWeapon == "axe" then 
            img = self.imgAxe_left 
        elseif self.activeWeapon == "bomb" then 
            img = self.imgBomb_left
        end 
    end

    --hierin worden de verschillende frames getekend als hij loopt of stilstaat
    if self.state == "alive" then
        if not self.isWalking then
            love.graphics.draw(img, pl_frames[1], self.x, self.y)
        end
        if self.isWalking then
            love.graphics.draw(img, pl_frames[math.floor(pl_currentFrame)], self.x, self.y)
            self.isWalking = false
        end
    elseif self.state == "dead" then 
        love.graphics.draw(self.image_right, self.x, self.y)
    end 

    if self.swipeCounter > 0 then --wanneer de swipe actief is...
        if self.direction == "right" then --en de player naar rechts wijst
            --teken de swipe voor de player, op de juiste grootte
            love.graphics.draw(self.swipeImage, self.x + self.width, self.y + 30 - (30*self.swipeScale)/2, 0, self.swipeScale, self.swipeScale)
        else--maar als de player naar links wijst...
            --teken de swipe voor de player op de juiste hoogte, in spiegelbeeld
            love.graphics.draw(self.swipeImage, self.x, self.y + 30 - (30*self.swipeScale)/2, 0, -self.swipeScale, self.swipeScale)
        end
    end
end