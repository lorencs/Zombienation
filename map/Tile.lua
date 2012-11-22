Tile = {}

-- tile images
road = love.graphics.newImage("map/roadSprites.png")
grass = love.graphics.newImage("map/grass.png")
water = love.graphics.newImage("map/waterSprites.png")
blocked = love.graphics.newImage("map/blocked.png")

-- constructor
function Tile:new()
	local object = {
		id = "G", 	-- default grass tile
		img = grass,
		sprite = love.graphics.newQuad(0, 0, 25, 25, 400, 25)
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
