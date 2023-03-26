require "Screens/gameover"

Ghost = Entity:extend()

function Ghost:new(x,y)
    Ghost.super.new(self, x, y)
    self.width = tileWidth
    self.height = tileWidth*2
    self.strength = 15
    self.weight = 0  
    self.speed = 200
    self.state = "ghost"
    self.ghostdirection = "front"
    self.enemydirection = "right"
    
    -- afbeeldingen geest
    self.image = love.graphics.newImage("Assets/Images/Sprites/ghost.png")
    self.image_left = love.graphics.newImage("Assets/Images/Sprites/ghost-left.png")
    self.image_right = love.graphics.newImage("Assets/Images/Sprites/ghost-right.png")

    --afbeeldingen enemy village
    self.image_enemyVillage_right = love.graphics.newImage("Assets/Images/Sprites/enemy_village1.png")
    self.image_enemyVillage_left = love.graphics.newImage("Assets/Images/Sprites/enemy_village2.png")

    -- afbeeldingen enemy castle
    self.image_enemyCastle_right = love.graphics.newImage("Assets/Images/Sprites/enemy_castle1.png")
    self.image_enemyCastle_left = love.graphics.newImage("Assets/Images/Sprites/enemy_castle2.png")

    -- afbeeldingen enemy woods
    self.image_enemyWoods_right = love.graphics.newImage("Assets/Images/Sprites/enemy_woods1.png")
    self.image_enemyWoods_left = love.graphics.newImage("Assets/Images/Sprites/enemy_woods2.png")
    self.activeWeapon = 10
    self.hp = 10
    self.isMoving = false 

    local width = self.image:getWidth()
    local height = self.image:getHeight()

    frames = {}

    local frame_width = 30         
    local frame_height = 60

    for i=0, 3 do
        table.insert(frames, love.graphics.newQuad(i*frame_width, 0, frame_width, frame_height, width, height))
    end

    currentFrame = 1
end

function Ghost:update(dt)
    Ghost.super.update(self, dt)
    currentFrame = currentFrame + dt

    currentFrame = currentFrame + 1 * dt
    if currentFrame >= 3 then
        currentFrame = 1
    end

    if self.state == "ghost" then 
        self.canJump = false 
        if love.keyboard.isDown("up") then
            self.isMoving = true 
            self.width = tileWidth 
            self.height= tileWidth *2
            self.y = self.y - self.speed * dt
        elseif love.keyboard.isDown("down") then
            self.isMoving = true 
            self.width = tileWidth 
            self.height= tileWidth *2
            self.y = self.y + self.speed * dt
        end

    elseif self.state == "dead" then 
        state = "gameover"
        gameover.init() 
        return
    end 
    
    if love.keyboard.isDown("left") then
        self.isMoving = true 
        self.ghostdirection = "left"
        self.enemydirection = "left" 
        if self.state == "ghost" then 
            self.width = 30
            self.height = 60
        end 
        self.x = self.x - self.speed * dt
    elseif love.keyboard.isDown("right") then
        self.isMoving = true 
        self.ghostdirection = "right"
        self.enemydirection = "right" 
        if self.state == "ghost" then 
            self.width = 30
            self.height = 60
        end 
        self.x = self.x + self.speed * dt
    else 
        self.isMoving = false 
    end
    
    if self.hp <= 0 then 
        self.state = "dead" 
    end 

    if self.last.y ~= self.y then
        self.canJump = false
    end
end

function love.keypressed(key)   
    if key == "up" then
        ghost:jump()
    end
    if key == "z" then 
        ghost.state = "ghost"
        Enemy.state = "dead"
        Enemy.x = ghost.x 
        Enemy.y = ghost.y  
        ghost.weight = 0
        ghost.height = tileWidth*2 
    end 
end

function Ghost:collide(e, direction)
    --possesion part
    if e:is(Enemy) and e.state == "dead" and self.state == "ghost" then
        if direction == "left" or direction == "right" or direction == "bottom" then             
            e.state = "posessed"
            self.state = "player"
            self.canJump = true
            self.width = 30
            self.height = 60
            self.weight = e.weight
            self.strength = e.strength           
            self.image_enemy = e.image
            self.image_dead = e.image_dead
        end
    elseif e:is(Enemy) and e.state == "alive" then 
        if self.state == "player" then 
            if direction == "left" then 
                self.hp = self.hp - 3
                self.x = self.x + 0.5 * tileWidth
            elseif direction == "right" then 
                self.hp = self.hp - 3
                self.x = self.x - 0.5 * tileWidth
            elseif direction == "top" then 
                self.hp = self.hp - 3
            elseif direction == "bottom" then
                self.y = self.y - 0.5 * tileWidth
                self.gravity = -800+self.weight
            end
        end 
    else
        Ghost.super.collide(self, e, direction)
        if direction == "bottom" then  
            self.canJump = true 
        end 
    end   
end

function Ghost:jump()
    if self.canJump then
        self.gravity = -1100+self.weight
        self.canJump = false
    end
end

function Ghost:checkResolve(e, direction)
    if e:is(Enemy) and e.state == "dead" then
        if direction ~= "top" then
            return true
        else
            return false
        end
    end
    return true
end

function Ghost:draw()
    local ghostImg = self.image
    local enemyImg = self.image_enemyVillage_right
    local enemy_frames = enemyVillage_frames
    local enemy_currentFrame = enemyVillage_currentFrame

    --verandert de ghostImg afhankelijk van de direction en of hij beweegt wel of niet
    if self.ghostdirection == "font" then 
        ghostImg = self.image
    elseif self.ghostdirection == "left" then 
        if self.isMoving then 
            ghostImg = self.image_left 
        else 
            ghostImg = self.image
        end  
    elseif self.ghostdirection == "right" then 
        if self.isMoving then 
            ghostImg = self.image_right 
        else 
            ghostImg = self.image
        end 
    end 
 
    --verandert de enemyImg afhankelijk van welk level je zit en welke enemy je dus wilt hebben 
    if selectedLevel == 1 or selectedLevel == 2 then
        enemy_frames = enemyVillage_frames 
        enemy_currentFrame = enemyVillage_currentFrame
        if self.enemydirection == "right" then 
            enemyImg = self.image_enemyVillage_right
        elseif self.enemydirection == "left" then 
            enemyImg = self.image_enemyVillage_left
        end 
    elseif selectedLevel == 3 then
        enemy_frames = enemyCastle_frames 
        enemy_currentFrame = enemyCastle_currentFrame
        if self.enemydirection == "right" then 
            enemyImg = self.image_enemyCastle_right
        elseif self.enemydirection == "left" then 
            enemyImg = self.image_enemyCastle_left
        end 
    elseif selectedLevel == 4 then
        enemy_frames = enemyWoods_frames 
        enemy_currentFrame = enemyWoods_currentFrame
        if self.enemydirection == "right" then 
            enemyImg = self.image_enemyWoods_right
        elseif self.enemydirection == "left" then 
            enemyImg = self.image_enemyWoods_left
        end 
    end 

    --draws the ghost depending its state 
    if self.state == "ghost" then 
        if not self.isMoving then  
            love.graphics.draw(ghostImg, frames[math.floor(currentFrame)], self.x, self.y)
        elseif self.isMoving then  
            love.graphics.draw(ghostImg, self.x, self.y)
        end 
    elseif self.state == "player" then 
        if self.isMoving then  
            love.graphics.draw(enemyImg, enemy_frames[math.floor(enemy_currentFrame)], self.x, self.y)
        elseif not self.isMoving then  
            love.graphics.draw(enemyImg, enemy_frames[1], self.x, self.y)
        end 
    end  

end