menuLevel = {}
selectedLevel = 1

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

menuLevel.loadButtons = true

function menuLevel.init()

	menuLevel.doneTutorial = false
	menuLevel.doneLv1 = false
	menuLevel.doneLv2 = false
	menuLevel.doneLv3 = false

	font = love.graphics.newFont("Assets/Lettertypes/Amatic-Bold.ttf", 32)

	if menuLevel.loadButtons == true then
	table.insert(buttons, newButton(
			"lv 1", 
			function ()		
				menuLevel.doneLv1 = true		
				print("lv 1")
				selectedLevel = 2 --its 2 because level1 is now the tutorial
				enterGame = true 
			end))

	table.insert(buttons, newButton(
			"lv 2", 
			function ()
				menuLevel.doneLv2 = true
				print("lv 2")
				selectedLevel = 3
				enterGame = true 
			end))

	table.insert(buttons, newButton(
			"lv 3", 
			function ()
				menuLevel.doneLv3 = true
				print("lv 3")
				selectedLevel = 4
				enterGame = true 
				print("level", selectedLevel)
			end))
	table.insert(buttons, newButton(
			"Witch's house", 
			function ()
				menuLevel.doneLv4 = true
				print("lv 4")
				selectedLevel = 5
				enterGame = true 
				print("level", selectedLevel)
			end))
		end

		menuLevel.loadButtons = false
end

function menuLevel.update(dt)
end

function menuLevel.draw()
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