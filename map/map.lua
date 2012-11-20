map = {}

function map:new()
	local object = {
		width = 0,
		height = 0,
		tileSize = 0,
		tiles = {},
		road = 0,
		grass = 0,
		water = 0,
		blocked = 0
	}
	setmetatable(object, { __index = map })
	return object
end

function map:initMap(w,h)
	self.width = w
	self.height = h
	self.tileSize = 25 -- default pixel square size
	
	-- tile types
	self.road = love.graphics.newImage("map/road.png")
	self.grass = love.graphics.newImage("map/grass.png")
	self.water = love.graphics.newImage("map/water.png")
	self.blocked = love.graphics.newImage("map/blocked.png")
end

function map:loadMap(filename)	
	io.input(filename)	
	data = io.read("*all")
	i = 0
	for c in data:gmatch"%u" do -- match all upper case chars
		self.tiles[i] = c
		i = i + 1	
	end
end

function map:drawMap()
	for x=0,self.width-1 do
		for y=0,self.height-1 do
			xb = x * self.tileSize
			yb = y * self.tileSize
			
			id = self.tiles[self:index(x,y)]
			tile = self:getTile(id)
	
			love.graphics.draw(tile, xb, yb)
		end
	end
end

function map:index(x,y)
	return (y * self.width) + x
end

function map:getTile(id)
	if (id == "R") then
		return self.road
	end
	if (id == "W") then
		return self.water
	end
	if (id == "G") then
		return self.grass
	end
	if (id == "B") then
		return self.blocked
	end
end