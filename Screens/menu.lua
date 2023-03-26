menu = {}

BUTTON_HEIGHT = 64

local function newButton(text, fn)
	return {
		text = text,
		fn = fn, 

		now = false, 
		last = false
	}
end

local buttons = {}
local font = nil


menu.loadButtons = true

function menu.init()
	enterGame = false 

	menu.doneStart = false
	menu.doneLoad = false
	menu.doneSetting = false
	menu.doneExit = false

	font = love.graphics.newFont("Assets/Lettertypes/Amatic-Bold.ttf", 32)

	if menu.loadButtons == true then
	table.insert(buttons, newButton(
			"New Game", 
			function ()
				menuLevel.doneTutorial = true		
				print("tutorial")
				selectedLevel = 1 
				enterGame = true 
				menu.doneStart = true		
				print("starting game")
			end))

	table.insert(buttons, newButton(
			"Load Game", 
			function ()
				love.timer.sleep(1)
				menu.doneLoad = true
				print("load game")
			end))

	table.insert(buttons, newButton(
			"Settings", 
			function ()
				menu.doneSetting = true
				print("setting menu")
			end))

	table.insert(buttons, newButton(
			"Exit Game", 
			function ()
				menu.doneExit = true
				love.event.quit(0)
			end))
		end

		menu.loadButtons = false
end

function menu.update(dt)
	
end

function menu.draw()
	love.graphics.setBackgroundColor( 220/255, 220/255, 220/255 )

	local ww = love.graphics.getWidth()
	local wh = love.graphics.getHeight()

	local button_width = ww * (1/3)
	local margin = 16

	local total_height = (BUTTON_HEIGHT + margin) * #buttons
	local cursor_y = 0

	for i, button in ipairs(buttons) do
		button.last = button.now

		local bx = (ww * 0.5) - (button_width * 0.5)
		local by = (wh * 0.8) - (total_height * 0.8) + cursor_y

		local color = {169/255, 169/255, 169/255}
		local mx, my = love.mouse.getPosition()

		local hot = mx > bx and mx < bx + button_width and
					my > by and my < by + BUTTON_HEIGHT

		if hot then
			color = {0.57, 0.102, 0.48}
		end

		--[[button.now = love.mouse.isDown(1)
		if button.now then 
			while love.mouse.isDown(1) do 
				--comment
			end 
			if button.now and not button.last and hot then
				button.fn()
			end
		end]]
		button.now = love.mouse.isDown(1)
		if button.now and not button.last and hot then
			button.fn()
		end

		love.graphics.setColor(unpack(color))
		love.graphics.rectangle("fill", bx, by, button_width, BUTTON_HEIGHT)
		love.graphics.setColor(0.00, 0.00, 0.00)

		local textW = font:getWidth(button.text)
		local textH = font:getHeight(button.text)
		love.graphics.print(button.text, font, (ww * 0.5) - textW * 0.5, by + textH * 0.01)

		cursor_y = cursor_y + (BUTTON_HEIGHT + margin)

		font40 = love.graphics.newFont("Assets/Lettertypes/AmaticSC-Regular.ttf", 72)
		love.graphics.setFont(font40)
		love.graphics.print("HUKU", 350, 100)
	end
end