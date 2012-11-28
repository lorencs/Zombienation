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
	print("generating random map")
	-- init new map
	self.width = 100 -- / random number
	self.height = 100 -- / rand
	self.map = Map:new()
	self.map:initMap(self.width, self.height)
	
	local freq = 4
	-- roads
	print("--placing roads")
	self:generateRoads()	
	-- water
	print("--filling depth map")
	self:generateWater()	
	-- update roads
	--print("--pruning roadways1")
	--self:thinRoads(freq, difficulty, false)		
	-- buildings
	--print("--placing buildings")
	--self:generateBuildings(difficulty)
	-- update roads
	--print("--pruning roadways2")
	--self:removeRoads(1)
	--self:thinRoads(math.floor(freq / 2), difficulty, true)
	
	print("--updating tile info")
	-- update tiles
	local m = self.map
	for x=0,m.width-1 do
		for y=0,m.height-1 do
			m:updateTileInfo(x,y)
		end
	end
	
	-- draw the map
	print("--drawing canvas")
	self.map:drawMap()
	print("-complete")
end

-- create a random road network
function MapGen:generateRoads()
	local m = self.map
	local freq = 12
	local pin = 100 	-- start value
	local chance = 0.075
	
	-- random road grid
	for x=0,m.width-1 do
		for y=0,m.height-1 do
			--if x % freq > pin then
			if x % freq == 1 and math.random() > chance then
				m.tiles[x][y]:setId("R")
			end
			--if y % freq > pin then
			if y % freq == 1 and math.random() > chance then 
				m.tiles[x][y]:setId("R")
			end
			pin = math.floor(math.random() * freq)
		end
	end
end

-- thin roads and remove ones that don't make sense
function MapGen:thinRoads(freq, difficulty, veryThin)
	
	if veryThin then
		-- remove less connected roads
		--self:removeRoads(2)
		-- remove road islands
		self:removeRoads(1)
	end
	
	
	-- find and remove connected components
	local scale = 3
	smallRoads = self:findConnectedComponents(0, scale*freq, "R")
	self:removeComponents(smallRoads, "G")		
end

-- set neighbors (neighborType) of tile (tileType) to resetValue 
-- if not(minN < #neighbors < maxN)
function MapGen:removeTiles(tileType, neighborType, resetValue, minN, maxN)
	local m = self.map 
	
	for x=0,m.width-1 do
		for y=0,m.height-1 do
			if m.tiles[x][y]:getId() == tileType then
				local count = 0
				if x-1 > -1 and m.tiles[x-1][y]:getId() == neighborType then
					count = count + 1
				end
				if x+1 < m.width and m.tiles[x+1][y]:getId() == neighborType then
					count = count + 1
				end
				if y-1 > -1 and m.tiles[x][y-1]:getId() == neighborType then
					count = count + 1
				end
				if y+1 < m.height and m.tiles[x][y+1]:getId() == neighborType then
					count = count + 1
				end
				
				if count < minN or count > maxN then
					m.tiles[x][y]:setId(resetValue)
				end
			end
		end
	end
end

function MapGen:findConnectedComponents(minSize, maxSize, tileType)
	nodes = {}
	open = {}
	closed = {}
	components = {}
	local m = self.map
	
	-- all tiles of type tileType
	for x=0,m.width-1 do
		for y=0,m.height-1 do
			if m.tiles[x][y]:getId() == tileType then
				table.insert(nodes, Point:new(x,y))
			end
		end
	end
	
	-- find components
	cur = table.remove(nodes)
	while not(cur == nil) do
		comp = {}
		table.insert(comp, cur)
		self:getNeighbors(cur, nodes, open)
		
		-- consider all neighbors
		local size = 1
		cur = table.remove(open)
		while not(cur == nil) do
			table.insert(comp, cur)
			self:getNeighbors(cur, nodes, open)
			cur = table.remove(open)
			size = size + 1
		end
		
		-- ignore small/big components
		if size > minSize and size < maxSize then
			table.insert(components, comp)
		end
		
		cur = table.remove(nodes)
	end
	
	return components
end

-- get neighbors of tile from nodes
function MapGen:getNeighbors(p, nodes, neighbors)
	local m = self.map
	
	if p.x > 0 then
		consider(nodes, p.x-1, p.y, neighbors)
	end
	if p.x+1 < m.width then
		consider(nodes, p.x+1, p.y, neighbors)
	end
	if p.y > 0 then
		consider(nodes, p.x, p.y-1, neighbors)
	end
	if p.y+1 < m.height then
		consider(nodes, p.x, p.y+1, neighbors)
	end
end

-- find and remove tile[x,y] in nodes, add to neighbors
function consider(nodes, x, y, neighbors)
	for i,v in pairs(nodes) do
		if v.x == x and v.y == y then
			table.insert(neighbors, v)
			table.remove(nodes, i)			
			return
		end
	end
end

-- reset tiles belonging to components
function MapGen:removeComponents(comps, tileType)
	cur = table.remove(comps)
	while not(cur == nil) do
		for _,v in pairs(cur) do
			self.map.tiles[v.x][v.y]:setId(tileType)
		end
		cur = table.remove(comps)
	end
end

-- create water bodies using a depth map
function MapGen:generateWater()
	local m = self.map
	local w = m.width
	local h = m.height
	
	-- high octave results in lower values, smoother distribution
	local octaves = 10
	depth = generatePerlinNoise(octaves, w, h)
	--outputNoise(depth, w, h)		-- print depth map to file
	
	local waterLevel = 35	-- tweak this to work with octaves
	
	for x=0,w-1 do
		for y=0,h-1 do
			if depth[x][y] < waterLevel then
				self:addCircleLake(x,y,3)	-- "smooth" water bodies
			end
		end
	end
	
	-- remove useless land
	self:removeTiles("G", "W", "W", 0, 2)
	self:removeTiles("G", "W", "W", 0, 3)
end

-- place random buildings
function MapGen:generateBuildings(difficulty)
	-- place halls
	print("---halls")
	self:placeBuildings(500, 1000, 66, true)
	-- place arenas
	print("---arenas")
	self:placeBuildings(200, 500, 43, true)
	-- place barns
	print("---barns")
	self:placeBuildings(100, 250, 34, true)
	-- place garages
	print("---garages")
	self:placeBuildings(50, 100, 64, false)
	-- place scrapers
	print("---scrapers")
	self:placeBuildings(30, 60, 35, true)
	-- place houses
	print("---houses")
	self:placeBuildings(0, 20, 33, true)
end

function MapGen:placeBuildings(minSize, maxSize, b_type, middle)
	local chance = 0.05
	build = self:findConnectedComponents(minSize, maxSize, "G")
	for i,v in pairs(build) do
		if middle then
			pos = self:findMiddle(v)
		else
			pos = table.remove(v)
		end
				
		if math.random() > chance then
			if self.map:newBuilding(pos.x, pos.y, b_type) then
				print("----"..i)
			end
		end
	end
end

-- find a midpoint in a connected component
function MapGen:findMiddle(component)
	local x,y,c = 0,0,0
	for i,v in pairs(component) do
		x = x + v.x
		y = y + v.y
		c = c + 1
	end
	local xn = math.floor(x / c)
	local yn = math.floor(y / c)
	
	return Point:new(xn, yn)
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
	self.map:addBoundary()
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
