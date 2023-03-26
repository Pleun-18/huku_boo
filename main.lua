require "Screens/titlescreen"
require "Screens/menu"
require "Screens/setting"
require "Screens/load"
require "Screens/menuLevel"
require "Screens/game"
require "Screens/gameover"

--stel het formaat van het venster in op 800x650
gameWidth = 800
gameHeight = 650

fontCounter = love.graphics.newFont("Assets/Lettertypes/Amatic-Bold.ttf", 25)
startMusic = love.audio.newSource("Assets/Music/magical.mp3", "stream")
gameMusic = love.audio.newSource("Assets/Music/darkMisty.mp3", "static")
gameOverMusic = love.audio.newSource("Assets/Music/gameOver.mp3", "static")

function love.load()

    state = "titlescreen"  --begin state

    titlescreen.init()
end

function love.update(dt)
    --Update de game afhankelijk van de huidige state
    if state == "titlescreen" then
        titlescreen.update(dt)
        --love.audio.play(startMusic)
    elseif state == "menu" then
        menu.update(dt)
    elseif state == "menuLevel" then
        menuLevel.update(dt)
    elseif state == "load" then
        load.update(dt)
    elseif state == "setting" then
        setting.update(dt)
    elseif state == "game" then
        game.update(dt)
        --love.audio.stop(startMusic)
        --love.audio.play(gameMusic)
    elseif state == "gameover" then 
        gameover.update(dt)
        --love.audio.play(gameOverMusic)
    end

    --Schakel tussen states
    --Schakel van menu naar andere schermen
    if state == "menu" and menu.doneStart == true then
        state = "game"
        game.init()
        menu.doneStart = false         
    elseif state == "menu" and menu.doneSetting == true then
        setting.init()
        state = "setting"
    elseif state == "menu" and menu.doneLoad == true then
        state = "menuLevel"
        menuLevel.init()        
    elseif state == "menu" and menu.doneExit == true then
        love.event.quit(0)
    --Schakel van settings naar menu
    elseif state == "setting" and setting.backToMenu == true then
        menu.init()
        state = "menu"
    --Schakel van load naar menu
    elseif state == "load" and load.backToMenu == true then
        menu.init()
        state = "menu"
    --Schakel van levels naar menu
    elseif state == "menuLevel" and enterGame == true then
        state = "game"
        game.init()         
        enterGame = false
    --Schakel van game naar levels
    elseif state == "game" and enterMenu == true then 
        state = "menuLevel"
        enterMenu = false
    elseif state == "gameover" and gameover.playAgain == true then 
        state = "menuLevel" 
        menuLevel.init()
        gameover.playAgain = false
    elseif state == "gameover" and gameover.backToMenu == true then 
        state = "menu"
        menu.init() 
        gameover.backToMenu = false
    end 
    
end

function love.draw()
    --Teken het spel op basis van de state
    if state == "titlescreen" then
        titlescreen.draw()
    elseif state == "menu" then
        menu.draw()
        --love.audio.stop(music)
    elseif state == "menuLevel" then
        menuLevel.draw()
    elseif state == "load" then
       load.draw()
    elseif state == "setting" then
        setting.draw()
    elseif state == "game" then
        game.draw()
    elseif state == "gameover" then 
        gameover.draw()
    end
end

function love.keypressed(key)
    --return key is de enter key op je toetsenbord
    if key == "return" then
        state = "menu"
        menu.init()
    end

    --ga terug naar menu wanneer op escape gedrukt wordt
    if  key == "escape" then
        state = "menu"
        menu.init()        
        --love.audio.stop(music)
    end
    
    --ga terug naar levelmenu wanneer op escape gedrukt wordt
    if key == "escape" and state == "game" then
        state = "menuLevel"
        menuLevel.init()        
        --love.audio.stop(music)
    end

    --save de game met f1
    if key == "f1" then
        saveGame()
    end
end