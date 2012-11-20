Map = {}

-- road special tiles
--road = love.graphics.newImage("map/road.png")

-- water special tiles
--water = love.graphics.newImage("map/water.png")


function Map:new()
	local object = {
		width = 0,
		height = 0,
		tileSize = 0,
		tiles = {}--[[,
		road = 0,
		grass = 0,
		water = 0,
		blocked = 0
		--]]
	}
	setmetatable(object, { __index = Map })
	return object
end

-- create new w*h map of all grass tiles
function Map:initMap(w,h)
	self.width = w
	self.height = h
	self.tileSize = 25 -- default pixel square size
	
	for i=0, (w * h - 1) do
		self.tiles[i] = Tile:new()
	end
	
	--[[ tile types
	self.road = love.graphics.newImage("map/road.png")
	self.grass = love.graphics.newImage("map/grass.png")
	self.water = love.graphics.newImage("map/water.png")
	self.blocked = love.graphics.newImage("map/blocked.png")
	--]]
end

-- load map from file
function Map:loadMap(filename)	
	io.input(filename)	
	data = io.read("*all")
	i = 0
	for c in data:gmatch"%u" do -- match all upper case chars
		self.tiles[i] = c
		i = i + 1	
	end
end

-- save map to file
function Map:saveMap(filename)
	-- check overwrite
	-- save representation
end	

-- draw map to screen
function Map:drawMap()
	resetColor = {255,255,255}
	love.graphics.setColor(resetColor)
	
	for x=0,self.width-1 do
		for y=0,self.height-1 do
			xb = x * self.tileSize
			yb = y * self.tileSize
						
			--id = self.tiles[self:index(x,y)]
			--tile = self:getTile(id)
			
			
			index = self:index(x,y)
			tile = self.tiles[index]
			
			sprite = 0
							
			if (tile.id == "R") then
				sprite = self:selectRoadSprite(tile)
			elseif (tile.id == "W") then
				sprite = self:selectWaterSprite(tile)			
			else
				sprite = tile:getImg()
			end
	
			love.graphics.draw(sprite, xb, yb)
		end
	end
end

-- tile index
function Map:index(x,y)
	return (y * self.width) + x
end


function Map:selectRoadSprite(tile)
	-- code will go here to select special tile
	return tile:getImg()
end

function Map:selectWaterSprite(tile)
	-- code will go here to select special tile
	return tile:getImg()
end
--[[
function Map:getTile(id)
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
--]]