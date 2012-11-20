Tile = {}

-- tile images
road = love.graphics.newImage("map/road.png")
grass = love.graphics.newImage("map/grass.png")
water = love.graphics.newImage("map/water.png")
blocked = love.graphics.newImage("map/blocked.png")

-- constructor
function Tile:new()
	local object = {
		id = "G", 	-- default grass tile
		img = grass,
		-- neighbor info
		N = 0,
		NE = 0,
		E = 0,
		SE = 0,
		S = 0,
		SW = 0,
		W = 0,
		NW = 0
	}
	setmetatable(object, { __index = Tile })
	return object
end

-- tile identifier
function Tile:setId(val)
	self.id = val
	self:resetImg()
end
function Tile:getId()
	return self.id
end

-- tile image file
function Tile:resetImg()
	if self.id == "G" then
		self.img = grass
	elseif self.id == "R" then
		self.img = road
	elseif self.id == "W" then
		self.img = water
	elseif self.id == "B" then
		self.img = blocked
	end
end
function Tile:getImg()
	return self.img
end
