Tile = {}

-- constructor
function Tile:new(_id, ts)
	local object = {
		id = _id,
		img = blocked,
		mm = grassMM,
		tileSize = ts,
		sprite = love.graphics.newQuad(0, 0, ts, ts, ts*16, ts*3),
		NE = false,
		SE = false,
		SW = false,
		NW = false
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
	elseif self.id == "P" then
		self.img = fence
		self.mm = fenceMM
	end
end
function Tile:getImg()
	return self.img
end
