game = {}

--[[INIT======================================================================]]

function game.init()

    enterGame = true 
    
    print("loading game")

	Object = require "Classes/classic"
	require "levels"
	require "Objects/tiles"
	require "Classes/entity"
	require "Objects/wall"
	require "Objects/player"
    require "Objects/arrow"
    require "Objects/ghost"
	require "Objects/box"
    require "Objects/barrel"
    require "Objects/weapon"
	require "Classes/enemy"
    require "Objects/enemies"
    require "Objects/coin"
    require "Objects/potion"
    require "Objects/gate"
    require "Objects/slot"
    require "Objects/platform"
    require "Objects/switch"
    require "Objects/witch"
    require "Objects/bomb"

	tilemap = levels[selectedLevel].map
	walls = {} 
    gates = {}
    objects = {}
    slots = {}
    body_frames = {}
    listOfArrows = {}

    translateX = 0
    screenCanvas = love.graphics.newCanvas(400, 650)

    for i,U in ipairs(tilemap) do
        for j,V in ipairs(U) do
            if V ~= 0 then
                table.insert(walls, Wall(tileWidth*j-tileWidth, tileWidth*i-tileWidth, tiles[V].image))
                if V == 5 then --als je tile 5 is zijn het de breekbare tiles
                    walls[#walls].breakable = true
                end
            end
        end
    end

    --de images
    images = {}
    images.potion1 = love.graphics.newImage("Assets/Images/Items/potion1.png")
    images.potion2 = love.graphics.newImage("Assets/Images/Items/potion2.png")
    images.potion3 = love.graphics.newImage("Assets/Images/Items/potion3.png")
    images.potion4 = love.graphics.newImage("Assets/Images/Items/potion4.png")

    --aanmaken en invoegen van gates uit "gates"
    for i, v in ipairs(levels[selectedLevel].gates) do
        if v[1] == "gate" then
            local newGate = Gate(tileX(v[2]),tileY(v[3]))
            table.insert(objects, newGate)
        end
    end 

    
        -- Only execute this if you don't have a save file

        --aanmaken en invoegen van spelers
        player = Player(
            tileX(levels[selectedLevel].player[1]),
            tileY(levels[selectedLevel].player[2])
        )
        print("player x: " .. 
            tileX(levels[selectedLevel].player[1])..
            "| player y: ".. 
            tileY(levels[selectedLevel].player[2])
        )

        ghost = Ghost(
            tileX(levels[selectedLevel].ghost[1]),
            tileY(levels[selectedLevel].ghost[2])
        )
        print("ghost x: " .. 
            tileX(levels[selectedLevel].ghost[1]) ..
            "| ghost y: ".. 
            tileY(levels[selectedLevel].ghost[2])
        )

        witch = Witch(
            tileX(levels[selectedLevel].witch[1]),
            tileY(levels[selectedLevel].witch[2])
        )

        table.insert(objects, witch)
        table.insert(objects, player)
        table.insert(objects, ghost)
       
        --aanmaken en invoegen van items uit object "props"
        --voegt items toe aan objects
        for i, v in ipairs(levels[selectedLevel].props) do
            if v[1] == "Box" then
                local newObject = Box(tileX(v[2]),tileY(v[3]))
                table.insert(objects, newObject)
            elseif v[1] == "Barrel" then
                local newObject = Barrel(tileX(v[2]),tileY(v[3]))
                table.insert(objects, newObject)
            elseif v[1] == "Platform" then 
                local newObject = Platform(tileX(v[2]), tileY(v[3]), tileX(v[4]), v[5], v[6], v[7], v[8], v[9])
                table.insert(objects, newObject)
            end
        end

        --aanmaken van de switches
        for i, v in ipairs(levels[selectedLevel].switches) do
                local newSwitch = Switch(tileX(v[1]),tileY(v[2]), v[3], i)
                table.insert(objects, newSwitch)
        end

        --aanmaken en invoegen van items uit object "enemies"
        --voegt items toe aan objects
        --controleert het type enemy
        for i, v in ipairs(levels[selectedLevel].enemies) do
            if v[1] == "enemy_village" then 
                local newEnemy = EnemyVillage(tileX(v[2]),tileY(v[3]))
                table.insert(objects, newEnemy)
            elseif v[1] == "enemy_castle" then
                local newEnemy = EnemyCastle(tileX(v[2]),tileY(v[3]))
                table.insert(objects, newEnemy)
            elseif v[1] == "enemy_woods" then
                local newEnemy = EnemyWoods(tileX(v[2]),tileY(v[3]))
                table.insert(objects, newEnemy)
            elseif v[1] == "cat" then
                local newEnemy = Cat(tileX(v[2]),tileY(v[3]))
                table.insert(objects, newEnemy)
            end
        end
        --aanmaken en invoegen van items uit object "weapons"
        --voegt items toe aan weapons
        --controleert het type wapen en het materiaal
        for i, v in ipairs(levels[selectedLevel].weapons) do
            if v[1] == "wooden-sword" then
                newWeapon = Weapon(tileX(v[2]),tileY(v[3]), v[1])
                table.insert(objects, newWeapon)
            elseif v[1] == "bow" then
                newWeapon = Weapon(tileX(v[2]),tileY(v[3]), v[1])
                table.insert(objects, newWeapon)
            elseif v[1] == "axe" then
                newWeapon = Weapon(tileX(v[2]),tileY(v[3]), v[1])
                table.insert(objects, newWeapon)
            elseif v[1] == "bomb" then
                newWeapon = Weapon(tileX(v[2]),tileY(v[3]), v[1])
                table.insert(objects, newWeapon)
            end
        end

        --aanmaken en invoegen van items uit object "coins"
        --voegt items toe aan coins
        for i, v in ipairs(levels[selectedLevel].coins) do
            if v[1] == "coin" then     
                local newCoin = Coin(tileX(v[2]),tileX(v[3]))
                table.insert(objects, newCoin)
            end
        end

        --aanmaken en invoegen van items uit object "potions"
        for i, v in ipairs(levels[selectedLevel].potions) do
            if v[1] == "1" then
                local newPotion = Potion(tileX(v[2]),tileY(v[3]), 1)
                table.insert(objects, newPotion)
            elseif v[1] == "2" then
                local newPotion = Potion(tileX(v[2]),tileY(v[3]), 2)
                table.insert(objects, newPotion)
            elseif v[1] == "3" then
                local newPotion = Potion(tileX(v[2]),tileY(v[3]), 3)
                table.insert(objects, newPotion)
            elseif v[1] == "4" then
                local newPotion = Potion(tileX(v[2]),tileY(v[3]), 4)
                table.insert(objects, newPotion)
            end
        end

        slot1 = Slot(200, 40)
        slot2 = Slot(260, 40)
        slot3 = Slot(320, 40)
        slot4 = Slot(380, 40)

        table.insert(slots, slot1)
        table.insert(slots, slot2)
        table.insert(slots, slot3)
        table.insert(slots, slot4)


    print("done loading")
    --print("==============================")

    if selectedLevel == 2 or selectedLevel == 1 then
        background = love.graphics.newImage("Assets/Images/backgrounds/background_5.jpg")
    elseif selectedLevel == 3 then
        background = love.graphics.newImage("Assets/Images/backgrounds/background_9.jpg")
    elseif selectedLevel == 4 then
        background = love.graphics.newImage("Assets/Images/backgrounds/background_3.jpg")
    elseif selectedLevel == 5 then
        background = love.graphics.newImage("Assets/Images/backgrounds/background_6.jpg")
    end

    --all images for the tutorial text
    textImage1 = love.graphics.newImage("Assets/Images/backgrounds/openingText.png")
    textImage2 = love.graphics.newImage("Assets/Images/backgrounds/boxText.png")
    textImage3 = love.graphics.newImage("Assets/Images/backgrounds/coinText.png")
    textImage4 = love.graphics.newImage("Assets/Images/backgrounds/weaponText.png")
    textImage5 = love.graphics.newImage("Assets/Images/backgrounds/enemyText.png")
    textImage6 = love.graphics.newImage("Assets/Images/backgrounds/switchText.png")
    textImage7 = love.graphics.newImage("Assets/Images/backgrounds/endText.png")

    --all images for the end screen with the witch
    witchText1 = love.graphics.newImage("Assets/Images/backgrounds/witch1.png")
    witchText2 = love.graphics.newImage("Assets/Images/backgrounds/witch2.png")
    witchText3 = love.graphics.newImage("Assets/Images/backgrounds/witch3.png")
    witchText4 = love.graphics.newImage("Assets/Images/backgrounds/witch5.png")
    witchBody = love.graphics.newImage("Assets/Images/Sprites/ghost_body.png")
    witchTextImage3 = true
    witchTextImage4 = false

    local body_width = witchBody:getWidth()
    local body_height = witchBody:getHeight()
    local body_frame_width = 62       
    local body_frame_height = 102

    for i=0,4 do
        table.insert(body_frames, love.graphics.newQuad(i*body_frame_width, 0, body_frame_width, body_frame_height, body_width, body_height))
    end

    body_currentFrame = 1

end

--[[UPDATE======================================================================]]


function game.update(dt)
	if love.keyboard.isDown("escape") or player.y > love.graphics.getHeight() or ghost.y > love.graphics.getHeight() then
		state = "menu"
        enterMenu = true 
	end

    if love.keyboard.isDown("space") then
        print("arrow shot")
    end

    for i,v in ipairs(listOfArrows) do
        v:update(dt)
        if v.isTouched == true then
            --Remove it from the list
            table.remove(listOfArrows, i)
            score = score + 1
        end
    end

    body_currentFrame = body_currentFrame + 4 * dt
    if body_currentFrame >= 4 then
        body_currentFrame = 1
    end

    for i,v in ipairs(witch) do
        v:update(dt)
    end

    for i,v in ipairs(walls) do
        v:update(dt)
    end

    for i,v in ipairs(gates) do
        v:update(dt)
    end

    for i,v in ipairs(objects) do
        v:update(dt)
    end

    for i,v in ipairs(slots) do
        v:update(dt)
    end

    --houdt de loop in stand
    local loop = true
    --houdt bij of de loop niet te lang duurt
    --breekt de loop af wanneer deze (vermoedelijk) vastzit
    local limit = 0

    while loop do
    	loop = false

    	limit = limit+1
	    if limit > 100 then
	    	break
	    end

        --controleer collisions voor objects tegen andere objects en enemies
	    for i=1,#objects-1 do
	        for j=i+1,#objects do
	            local collision = objects[i]:resolveCollision(objects[j])
	            if collision then
	            	loop = true
	            end
            end
	    end

        --controlleer collision voor muren tegen objects en enemies
        for i,wall in ipairs(walls) do
            for j,object in ipairs(objects) do
                local collision = object:resolveCollision(wall)
                if collision then
                    loop = true
                end
            end
        end

    end

    --focus de camera op de player, tot aan de randen van het level
    --verander de translateX om het gehele beeld te verschuiven
    if 	player.x > love.graphics.getWidth()/2 and 
    	player.x < #tilemap[1]*tileWidth - love.graphics.getWidth()/2 then
    		translateX = -player.x + love.graphics.getWidth()/2
    elseif player.x > #tilemap[1]*tileWidth - love.graphics.getWidth()/2 then
    		translateX = -#tilemap[1]*tileWidth + love.graphics.getWidth()
    else translateX = 0
    end
end


--[[DRAW======================================================================]]

function playersSeparated()
    if selectedLevel ~= 5 then    
        if  math.abs(player.x - ghost.x) >= 400 or
            math.abs(player.y - ghost.y) >= 300 then 
            return true 
        elseif 
            math.abs(ghost.x - player.x) >= 300 or
            math.abs(ghost.y - player.y) >= 400 then 
            return true
        else 
            return false 
        end
    end 
end


function drawGame(focus)
    love.graphics.push()
    love.graphics.translate(-focus.x + 200, 0)
    
    for i,v in ipairs(walls) do
        love.graphics.draw(v.image, v.x, v.y)
    end
    
    for i,v in ipairs(gates) do
        v:draw()
    end

    for i,v in ipairs(objects) do
        v:draw()
    end
    
    love.graphics.pop()
end

function drawButton()
    love.graphics.setColor(0.745,0.745,0.745)
    love.graphics.rectangle("fill", 355, 360, 100, 40, 10, 11)
    love.graphics.setColor(0.00, 0.00, 0.00)
    local font = love.graphics.newFont("Assets/Lettertypes/Amatic-Bold.ttf", 20)
    love.graphics.print("Generate Body",font, 373, 365)

    if love.mouse.isDown(1) then
        witchTextImage3 = false
        witchTextImage4 = true
    end
end


function game.draw()
    love.graphics.setBackgroundColor(49/255, 99/255, 49/255)

    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end

    for i,v in ipairs(listOfArrows) do
            v:draw()
    end

    if playersSeparated() then 
        love.graphics.push()
        love.graphics.setCanvas(screenCanvas)
        love.graphics.clear()
            drawGame(player)
        love.graphics.setCanvas()
        love.graphics.draw(screenCanvas, 0,0)

        love.graphics.setCanvas(screenCanvas)
        love.graphics.clear()
            drawGame(ghost)
        love.graphics.setCanvas()
        love.graphics.draw(screenCanvas,400,0)
        love.graphics.pop()
        love.graphics.line(400, 0, 400, 650)
    else
        love.graphics.push() 
        love.graphics.translate(translateX, 0)
        
        for i,v in ipairs(walls) do
            love.graphics.draw(v.image, v.x, v.y)
        end

        for i,v in ipairs(gates) do
            v:draw()
        end

        for i,v in ipairs(objects) do
            v:draw()
        end

        love.graphics.pop()
    end
    
    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.print("HP: " .. player.hp, fontCounter, 10, 10)
    love.graphics.print("Coins: " .. score, fontCounter, 10, 40)

    love.graphics.draw(images.potion1, 600, 50)
    love.graphics.print(potion1Counter,fontCounter, 620, 50)
    love.graphics.draw(images.potion2, 650, 50)
    love.graphics.print(potion2Counter,fontCounter, 670, 50)
    love.graphics.draw(images.potion3, 700, 50)
    love.graphics.print(potion3Counter,fontCounter, 720, 50)
    love.graphics.draw(images.potion4, 750, 50)
    love.graphics.print(potion4Counter,fontCounter, 770, 50)

    for i,v in ipairs(slots) do
        v:draw()
    end

    --alle tekst voor de tutorial: 
    if selectedLevel == 1 then 
        if player.x < 200  then
            love.graphics.draw(textImage1, 200, 100, 0, 1, 1)
        elseif player.x and ghost.x > 20 *tileWidth and player.x and ghost.x < 40 * tileWidth then
            love.graphics.draw(textImage2, 200, 100, 0, 1, 1)
        elseif player.x and ghost.x > 45*tileWidth and player.x and ghost.x < 55*tileWidth then 
            love.graphics.draw(textImage3, 200, 100, 0, 1, 1)
        elseif player.x and ghost.x > 70*tileWidth and player.x and ghost.x < 85*tileWidth then 
            love.graphics.draw(textImage4, 200, 100, 0, 1, 1)
        elseif player.x and ghost.x > 90*tileWidth and player.x and ghost.x < 100*tileWidth then 
            love.graphics.draw(textImage5, 200, 100, 0, 1, 1)
        elseif player.x and ghost.x > 110*tileWidth and player.x and ghost.x < 120*tileWidth then 
            love.graphics.draw(textImage6, 200, 100, 0, 1, 1)
        elseif player.x and ghost.x > 135*tileWidth and player.x and ghost.x < 140*tileWidth then 
            love.graphics.draw(textImage7, 200, 100, 0, 1, 1)
        end  
    end

    --alle tekst voor de witch house
    local down = love.mouse.isDown(1)
    if selectedLevel == 5 then
        if player.x < 100 then
            love.graphics.draw(witchText1, 250, 120, 0, 1, 1)
        elseif player.x > 100 and player.x < 200 then
            love.graphics.draw(witchText2, 250, 120, 0, 1, 1)
        elseif player.x > 200 and player.x < 300 and witchTextImage3 == true then
            love.graphics.draw(witchText3, 250, 120, 0, 1, 1)
            love.graphics.draw(images.potion1, 310, 300)
            love.graphics.print(potion1Counter,fontCounter, 330, 300)
            love.graphics.draw(images.potion2, 360, 300)
            love.graphics.print(potion2Counter,fontCounter, 380, 300)
            love.graphics.draw(images.potion3, 410, 300)
            love.graphics.print(potion3Counter,fontCounter, 430, 300)
            love.graphics.draw(images.potion4, 460, 300)
            love.graphics.print(potion4Counter,fontCounter, 480, 300)
            drawButton()
        elseif witchTextImage3 == false and witchTextImage4 == true then
            love.graphics.draw(witchText4, 250, 120, 0, 1, 1)
            love.graphics.draw(witchBody, body_frames[math.floor(body_currentFrame)], 370, 250)

            love.graphics.setColor(0.745,0.745,0.745)
            love.graphics.rectangle("fill", 360, 380, 75, 40, 10, 11)
            love.graphics.setColor(0.00, 0.00, 0.00)
            local font = love.graphics.newFont("Assets/Lettertypes/Amatic-Bold.ttf", 20)
            love.graphics.print("Escape",font, 385, 385)
        end
    end

    for i,v in ipairs(witch) do
        v:draw()
    end

    love.graphics.setColor(1,1,1)

end