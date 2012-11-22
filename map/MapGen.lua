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
	self:blockBoundary() 	-- outline edges black
	self:addCircleLake(15,15,5)
	
	-- some test roads (for quick testing, until debug map draw mode is in)
	m.tiles[24][6]:setId("R")
	m.tiles[24][7]:setId("R")
	m.tiles[24][8]:setId("R")
	m.tiles[24][9]:setId("R")
	m.tiles[24][10]:setId("R")
	m.tiles[25][6]:setId("R")
	m.tiles[23][6]:setId("R")
	m.tiles[23][10]:setId("R")
	m.tiles[22][10]:setId("R")
	m.tiles[21][10]:setId("R")
	
	-- save info on each tile's neighbor
	for x=0,self.width-1 do
		for y=0,self.height-1 do
			self.map:getNeighborInfo(x,y)						
		end
	end
	
	self.map:drawMap()

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

-- add road 
function MapGen:addRoad(x1, y1, x2, y2)
	
end
