District = {}


function District:new(xa, ya, xb, yb, d)
	local object = {
		x1 = xa,
		y1 = ya,
		x2 = xb, 
		y2 = yb,
		
		sectors = {},
		depth = {},	-- depth map for assigning sector types
		
		divide = d, -- orientation of bisector
		
		sectorCount_residential = 0,
		sectorCount_commercial = 0,
		sectorCount_rural = 0,
		sectorCount_industrial = 0,
		sectorCount_park = 0,
		
		max_residential = 5,
		max_commercial = 4,
		max_rural = 3,
		max_industrial = 2,
		max_park = 1
	}
	setmetatable(object, { __index = District })
	return object
end

-- district properties
function District:yd()
	return self.y2 - self.y1
end
function District:xd()
	return self.x2 - self.x1
end
function District:area()
	return self:yd() * self:xd()
end

-- split city into multiple districts
function getDistricts(width, height)
	districts = {}
	cycle = {}

	s = District:new(0,0, width-1, height-1, "H")
	table.insert(districts, s)
	table.insert(cycle, s)
	
	local depth = 3
	local splitChance = 0.85

	for d=0,depth do
		cycle = {}	-- reset cycle
		for i,v in pairs(districts) do
			if math.random() < splitChance then
				a,b = v:split()				
				if not(a == nil) then table.insert(cycle, a) end
				if not(b == nil) then table.insert(cycle, b) end				
			else
				table.insert(cycle, v)
			end
		end

		districts = cycle
	end
	
	return districts
end

-- split this district into 2
-- add one to bound for double road-age
-- 1/3 < bound < 2/3
function District:split()
	if self.divide == "H" then
		local partway = self:yd() / 3
		local boundY = self.y1 + math.floor((math.random() * partway) + partway)		
		a = District:new(self.x1, self.y1, self.x2, boundY, "V")
		b = District:new(self.x1, boundY+1, self.x2, self.y2, "V")
	else -- self.divide == "V"
		local partway = self:xd() / 3
		local boundX = self.x1 + math.floor((math.random() * partway) + partway)
		a = District:new(self.x1, self.y1, boundX, self.y2, "H")
		b = District:new(boundX+1, self.y1, self.x2, self.y2, "H")
	end
	
	return a,b
end

-- create sectors for this district
function District:createSectors(map)
	local octaves = 10
	
	-- generate depth map
	self.depth = generatePerlinNoise(octaves, self:xd()+1, self:yd()+1)
	-- split into sectors
	self.sectors = getSectors(Point:new(self.x1, self.y1), self:xd(), self:yd())
	
	-- assign sector types
	for _,v in pairs(self.sectors) do
		
		-- get sector depth value
		local count = 0
		local sum = 0
		for x=v.x1-self.x1,v.x2-self.x1-1 do
			for y=v.y1-self.y1,v.y2-self.y1-1 do				
				sum = sum + self.depth[x][y]
				count = count+1
			end
		end
		local avgDepth = math.floor(sum / count)

		v.sectorType = self:getTypeFromDepth(avgDepth)
		v.depthValue = math.floor((avgDepth / 20) % 5)
	end
	--
end

-- use depth value to determine sector type
function District:getTypeFromDepth(depth)
	local numTypes = 5
	local depthDivisor = 100 / numTypes
	
	local val = math.floor((depth / depthDivisor) % numTypes)
	
	-- val frequency order ~= { 2, 3, 1, 4, 0 }
	
	if val == 2 then
		self.sectorCount_residential = self.sectorCount_residential + 1
		return "residential"		
	elseif val == 3 then
		self.sectorCount_commercial = self.sectorCount_commercial + 1
		return "commercial"
	elseif val == 1 then
		self.sectorCount_rural = self.sectorCount_rural + 1
		return "rural"
	elseif val == 4 then
		self.sectorCount_park = self.sectorCount_park + 1
		return "park"
	elseif val == 0 then
		self.sectorCount_industrial = self.sectorCount_industrial + 1
		return "industrial"
	else
		return "undefined"
	end
end


