Building = {}
													  -- b_type	
b6x6 = love.graphics.newImage("map/buildings/b1.png") -- 66	- hall
b4x3 = love.graphics.newImage("map/buildings/b2.png") -- 43 - arena
b3x5 = love.graphics.newImage("map/buildings/b3.png") -- 35 - scraper
--b3x3 = love.graphics.newImage("map/buildings/b4.png") -- 33 - house
b3x4 = love.graphics.newImage("map/buildings/b5.png") -- 34 - barn
--b6x4 = love.graphics.newImage("map/buildings/b6.png") -- 64 - garage

-- new b_type
house = love.graphics.newImage("map/buildings/house.png") -- 1x1
garage = love.graphics.newImage("map/buildings/garage.png") -- 2x1

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

function Building:set(x, y, b_type)
	self.x = x
	self.y = y		
	self.width = math.floor(b_type / 10)
	self.height = b_type % 10
	self.xend = x + self.width - 1
	self.yend = y + self.height - 1		
	
	--[[ type check
	if b_type == 66 then
		self.img = b6x6
	elseif b_type == 43 then
		self.img = b4x3
	elseif b_type == 35 then
		self.img = b3x5
	elseif b_type == 33 then
		self.img = b3x3
	elseif b_type == 34 then
		self.img = b3x4
	elseif b_type == 64 then
		self.img = b6x4
	end
	--]]
	
	if b_type == 11 then
		self.img = house
	elseif b_type == 21 then
		self.img = garage
	end
end

function Building:getSprite(x, y, w)
	local xi = (x - self.x) * w
	local yi = (y - self.y) * w
	
	return love.graphics.newQuad(xi, yi, w, w, self.img:getWidth(), self.img:getHeight())
end