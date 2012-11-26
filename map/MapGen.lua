MapGen = {}

-- constructor
function MapGen:new()
	local object = {
		map = nil,
		width = 0,
		height = 0,
	}
			
	setmetatable(object, { __index = MapGen })
	return object
end

-- create new blank map
function MapGen:newMap(w, h)
	self.width = w
	self.height = h
	
	self.map = Map:new() 	-- constr obj
	self.map:initMap(w,h)   -- default blank map	
	
	
	-- default map
	--self:blockBoundary() 	-- outline edges black
	self:addCircleLake(15,15,5)
	
	-- some test roads (for quick testing, until debug map draw mode is in)
	self:addRoad(24, 6, 24, 10)
	self:addRoad(23, 6, 25, 6)
	self:addRoad(21, 10, 23, 10)
	
	-- a couple random buildings
	self:addBuilding(5, 5, 66)
	self:addBuilding(27, 28, 43)
	self:addBuilding(33, 48, 35)
	self:addBuilding(55, 92, 33)
	self:addBuilding(78, 12, 34)
	self:addBuilding(12, 84, 64)
	
	-- save info on each tile's neighbor
	for x=0,self.width-1 do
		for y=0,self.height-1 do
			self.map:getNeighborInfo(x,y)						
		end
	end
	
	self.map:drawMap()
end

-- create random map based on difficulty
function MapGen:randomMap(difficulty)
	-- init new map
	self.width = 100 -- / random number
	self.height = 100 -- / rand
	self.map = Map:new()
	self.map:initMap(self.width, self.height)
	
	-- roads
	self:generateRoads(difficulty)
	
	-- water
	self:generateWater(difficulty)
	
	-- buildings
	self:generateBuildings(difficulty)
	
	
	-- draw the map
	self.map:drawMap()
end

-- create a random road network
function MapGen:generateRoads(difficulty)
	local m = self.map
	local freq = 12
	local pin = 100 	-- start value
	
	-- random road grid
	for x=0,m.width-1 do
		for y=0,m.height-1 do
			if x % freq > pin then
				m.tiles[x][y]:setId("R")
				m:updateTileInfo(x,y)
			end
			if y % freq > pin then
				m.tiles[x][y]:setId("R")
				m:updateTileInfo(x,y)
			end
			pin = math.floor(math.random() * freq * 1.1)
		end
	end
		
	-- thin road grid
	self:removeRoads(2)
	-- remove road islands
	self:removeRoads(1)
	
	-- remove small road pockets
	-- create connected components
	-- remove cc st. cc.size < freq
end

-- remove less connected roads
function MapGen:removeRoads(threshold)
	local m = self.map 
	
	for x=0,m.width-1 do
		for y=0,m.height-1 do
			if m.tiles[x][y]:getId() == "R" then
				local count = 0
				if x-1 > -1 and m.tiles[x-1][y]:getId() == "R" then
					count = count + 1
				end
				if x+1 < m.width and m.tiles[x+1][y]:getId() == "R" then
					count = count + 1
				end
				if y-1 > -1 and m.tiles[x][y-1]:getId() == "R" then
					count = count + 1
				end
				if y+1 < m.height and m.tiles[x][y+1]:getId() == "R" then
					count = count + 1
				end
				
				if count < threshold then
					m.tiles[x][y]:setId("G")
					m:updateTileInfo(x,y)
				end
			end
		end
	end
end

-- create water bodies using a depth map
function MapGen:generateWater(difficulty)
	local waterLevel = 3
	local range = 15
	
	-- not too much water
	local area = self.map.width * self.map.height
	local max = math.floor(area * 0.25)
	local min = math.floor(area * 0.05)
	local count = self.map.width * self.map.height
	
	-- generate a depth map
	while count > max or count < min  do
		count = 0
		depth = create(self.width, self.height, f)
		for x=0,self.map.width-1 do
			for y=0,self.height-1 do
				if depth[x][y] < -waterLevel then
					count = count + 1
				end
			end
		end
	end
	
	-- set map tiles
	for x=0,self.map.width-1 do
		for y=0,self.map.height-1 do
			if depth[x][y] < -waterLevel or depth[x][y] > range*waterLevel then
				self:addCircleLake(x,y,1)
				self.map:updateTileInfo(x,y)
			end
		end
	end
end

-- place random buildings
function MapGen:generateBuildings(difficulty)
	-- nothing thus far
end

-- load default map
function MapGen:defaultMap()
	-- load default map if it exists
	if io.open("map/defaultMap.txt", "r") then
		self.map = Map:new()
		self.map:initMap(100, 100)
		self.map:loadMap("map/defaultMap.txt")
		
		-- save info on each tile's neighbor
		for x=0,self.map.width-1 do
			for y=0,self.map.height-1 do
				self.map:getNeighborInfo(x,y)						
			end
		end
		
		self.map:drawMap()
	-- generate a random map
	else
		--self:newMap(100,100)
		self:randomMap(100, 100, 0)
	end
end

-- return map reference
function MapGen:getMap()
	return self.map
end

-- outline map with blocked tiles
function MapGen:blockBoundary()
	m = self.map
	maxy = self.height - 1
	maxx = self.width - 1
	
	-- top/bottom tiles
	for i=0,maxx do
		m.tiles[i][0]:setId("B")
		--index = m:index(i, maxy)
		m.tiles[i][maxy]:setId("B")
	end
	
	-- left/right tiles
	for i=0,maxy do
		--index = m:index(0,i)
		m.tiles[0][i]:setId("B")
		--index = m:index(maxx, i)
		m.tiles[maxx][i]:setId("B")
	end	

end

-- add rectangular lake
function MapGen:addLake(x, y, width, height)
	m = self.map
	
	for xi=0,width-1 do
		for yi=0,height-1 do
			--index = m:index(x+xi, y+yi)
			local xn = x + xi
			local yn = y + yi
			if (xn > -1) and (xn < m.width) and (yn > -1) and (yn < m.height) then
				m.tiles[x+xi][y+yi]:setId("W")
			end
		end
	end
end

-- add "circular" lake
function MapGen:addCircleLake(x, y, r)
	self:addLake(x-r, y-1, r*2 + 1, 3)		-- center block
	
	-- "circle"
	local n = r - 1
	for i=2,r do
		self:addLake(x - n, y - i, n*2 + 1, 1)
		self:addLake(x - n, y + i, n*2 + 1, 1)
		n = n - 1
	end
end

-- add road - only right angles
function MapGen:addRoad(x1, y1, x2, y2)
	m = self.map
	
	-- vertical
	if x1 == x2 then
		for y=y1,y2 do
			m.tiles[x1][y]:setId("R")
		end
	-- horizontal
	elseif y1 == y2 then		
		for x=x1,x2 do
			m.tiles[x][y1]:setId("R")
		end
	end
end

-- add building from predefined types
function MapGen:addBuilding(x, y, b_type)
	self.map:newBuilding(x, y, b_type)
end
