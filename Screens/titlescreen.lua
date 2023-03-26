titlescreen = {}

function titlescreen.init()

	state = "titlescreen"
	titlescreen.done = false

	titlescreen.image = love.graphics.newImage("Assets/Images/backgrounds/logo3.jpg")
	titlescreen.x = 60
	titlescreen.y = 100
end

function titlescreen.update(dt)

end

function titlescreen.draw()
	love.graphics.draw(titlescreen.image, titlescreen.x, titlescreen.y)
	font40 = love.graphics.newFont("Assets/Lettertypes/AmaticSC-Regular.ttf", 72)
	love.graphics.setFont(font40)
	love.graphics.print("Press Enter to start", 200, 380)
end