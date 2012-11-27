Tile = {}

-- tile images
road = love.graphics.newImage("map/roadSprites.png")
grass = love.graphics.newImage("map/grassTest.png")
water = love.graphics.newImage("map/waterSprites.png")
blocked = love.graphics.newImage("map/blocked.png")
roadMM = love.graphics.newImage("map/roadMM.png")
grassMM = love.graphics.newImage("map/grassMM.png")
waterMM = love.graphics.newImage("map/waterMM.png")
blockedMM = love.graphics.newImage("map/blockedMM.png")

-- constructor
function Tile:new(_id)
	local object = {
		id = _id,
		img = blocked,
		mm = grassMM,
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
		self.mm = grassMM
	elseif self.id == "R" then
		self.img = road
		self.mm = roadMM
	elseif self.id == "W" then
		self.img = water
		self.mm = waterMM
	elseif self.id == "B" then
		self.img = blocked
		self.mm = blockedMM
	elseif self.id == "D" then
		--self.img = building
		self.mm = blockedMM
	end
end
function Tile:getImg()
	return self.img
end
