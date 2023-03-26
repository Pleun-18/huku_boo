tileWidth = 30
tileHeight = 30

--geeft een x waarde aan voor de gegeven tegelcoördinaat
function tileX(x)
	return x*tileWidth-tileWidth
end

--geeft een y waarde aan voor de gegeven tegelcoördinaat
function tileY(y)
	return y*tileHeight-tileHeight
end

tiles = { --tijdelijk vervangen met kleuren todat afbeeldingen te gebruiken zijn
		[0] = { image = love.graphics.newImage("Assets/Images/Tiles/transparent.png")}, --doorzichtige tegels waar geen collision is
		[1] = { image = love.graphics.newImage("Assets/Images/Tiles/stone-grass.jpg")},
		[2] = { image = love.graphics.newImage("Assets/Images/Tiles/stone.png")},
		[3] = { image = love.graphics.newImage("Assets/Images/Tiles/ground-grass.jpg")},
		[4] = { image = love.graphics.newImage("Assets/Images/Tiles/ground.png")},
		[5] = { image = love.graphics.newImage("Assets/Images/Tiles/cracked-stone.png")},
	}

	