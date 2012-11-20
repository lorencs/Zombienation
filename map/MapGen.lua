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
	
	self:blockBoundary() 	-- outline edges black
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
