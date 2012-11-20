MapGen = {}

-- constructor
function MapGen:new()
	local object = {
		map = nil,
		width = 0,
		height = 0		
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
	self:blockBoundary() 	-- outline edges black
	self:addCircleLake(15,15,5)
	
	-- some test roads (for quick testing, until debug map draw mode is in)
	m.tiles[654]:setId("R")
	m.tiles[754]:setId("R")
	m.tiles[854]:setId("R")
	m.tiles[954]:setId("R")
	m.tiles[1054]:setId("R")
	m.tiles[655]:setId("R")
	m.tiles[653]:setId("R")
	m.tiles[1053]:setId("R")
	m.tiles[1052]:setId("R")
	m.tiles[1051]:setId("R")
	
	-- save info on each tile's neighbor
	for x=0,self.width-1 do
		for y=0,self.height-1 do
			xb = x * self.map.tileSize
			yb = y * self.map.tileSize

			
			index = self.map:index(x,y)
			tile = self.map.tiles[index]
			
			-- check bounds and set each neighbor to 1 if it is the same tile
			if (y-1 > -1) then
				tileN  = self.map.tiles[self.map:index(x,y-1)]
				self.map.tiles[index].N = (tile.id == tileN.id) and 1 or 0
			end
			if ((x+1 < self.width) and (y-1 > -1)) then
				tileNE  = self.map.tiles[self.map:index(x+1,y-1)]
				self.map.tiles[index].NE = (tile.id == tileNE.id) and 1 or 0
			end
			if (x+1 < self.width) then
				tileE  = self.map.tiles[self.map:index(x+1,y)]
				self.map.tiles[index].E = (tile.id == tileE.id) and 1 or 0
			end
			if ((x+1 < self.width) and (y+1 < self.height)) then
				tileSE  = self.map.tiles[self.map:index(x+1,y+1)]
				self.map.tiles[index].SE = (tile.id == tileSE.id) and 1 or 0
			end
			if (y+1 < self.height) then
				tileS  = self.map.tiles[self.map:index(x,y+1)]
				self.map.tiles[index].S = (tile.id == tileS.id) and 1 or 0
			end
			if ((x-1 > -1) and (y+1 < self.height)) then
				tileSW  = self.map.tiles[self.map:index(x-1,y+1)]
				self.map.tiles[index].SW = (tile.id == tileSW.id) and 1 or 0
			end
			if (x-1 > -1) then
				tileW  = self.map.tiles[self.map:index(x-1,y)]
				self.map.tiles[index].W = (tile.id == tileW.id) and 1 or 0
			end
			if ((x-1 > -1) and (y-1 > -1)) then
				tileNW  = self.map.tiles[self.map:index(x-1,y-1)]
				self.map.tiles[index].NW = (tile.id == tileNW.id) and 1 or 0
			end								
		end
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
		m.tiles[i]:setId("B")
		index = m:index(i, maxy)
		m.tiles[index]:setId("B")
	end
	
	-- left/right tiles
	for i=0,maxy do
		index = m:index(0,i)
		m.tiles[index]:setId("B")
		index = m:index(maxx, i)
		m.tiles[index]:setId("B")
	end	

end

-- add rectangular lake
function MapGen:addLake(x, y, width, height)
	m = self.map
	
	for xi=0,width-1 do
		for yi=0,height-1 do
			index = m:index(x+xi, y+yi)
			m.tiles[index]:setId("W")
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

-- add road 
function MapGen:addRoad(x1, y1, x2, y2)
	
end
