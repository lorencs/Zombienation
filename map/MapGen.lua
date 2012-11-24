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

-- load default map
function MapGen:defaultMap()
	--defaultMap = ("map/defaultMap.txt")
	
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
	else
		self:newMap(100,100)
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
			m.tiles[x+xi][y+yi]:setId("W")
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
	--[[
	m = self.map
	
	-- add building to list
	local b = Building:new()
	b:set(x, y, b_type)
	table.insert(m.buildings, b)
	
	-- set tile ids
	for xi=x,x+b.width-1 do
		for yi=y,y+b.height-1 do
			m.tiles[xi][yi]:setId("D")
		end
	end
	--]]
	self.map:newBuilding(x, y, b_type)
end
