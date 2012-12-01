Building = {}
													  -- b_type	
b6x6 = love.graphics.newImage("map/buildings/b1.png") -- 66	- hall
b4x3 = love.graphics.newImage("map/buildings/b2.png") -- 43 - arena
b3x5 = love.graphics.newImage("map/buildings/b3.png") -- 35 - scraper
--b3x3 = love.graphics.newImage("map/buildings/b4.png") -- 33 - house
b3x4 = love.graphics.newImage("map/buildings/b5.png") -- 34 - barn
--b6x4 = love.graphics.newImage("map/buildings/b6.png") -- 64 - garage

-- new b_type
houseN = love.graphics.newImage("map/buildings/houseN.png") -- 1x1
houseW = love.graphics.newImage("map/buildings/houseW.png")
houseS = love.graphics.newImage("map/buildings/houseS.png")
houseE = love.graphics.newImage("map/buildings/houseE.png")

garageN = love.graphics.newImage("map/buildings/garageN.png") -- 2x1
garageW = love.graphics.newImage("map/buildings/garageW.png") -- 1x2
garageS = love.graphics.newImage("map/buildings/garageS.png")
garageE = love.graphics.newImage("map/buildings/garageE.png")

-- need minimap images

function Building:new()
	local object = {
		x = 0,
		y = 0,
		xend = 0,
		yend = 0,
		width = 0,
		height = 0,
		img = nil
	}
	setmetatable(object, { __index = Building })
	return object
end

function Building:set(x, y, b_type,dir)
	self.x = x
	self.y = y		
	self.width = math.floor(b_type / 10)
	self.height = b_type % 10
	self.xend = x + self.width - 1
	self.yend = y + self.height - 1		
	
	if b_type == 11 then
		if dir == "N" then self.img = houseN 
		elseif dir == "W" then self.img = houseW
		elseif dir == "S" then self.img = houseS
		elseif dir == "E" then self.img = houseE
		end
	elseif b_type == 21 then
		if dir == "N" then self.img = garageN
		elseif dir == "S" then self.img = garageS
		end
	elseif b_type == 12 then
		if dir == "W" then self.img = garageW 
		elseif dir == "E" then self.img = garageE
		end
	end
end

function Building:getSprite(x, y, w)
	local xi = (x - self.x) * w
	local yi = (y - self.y) * w
	
	return love.graphics.newQuad(xi, yi, w, w, self.img:getWidth(), self.img:getHeight())
end