Map = {}

function Map:new()
	local object = {
		width = 0,
		height = 0,
		tileSize = 0,
		tiles = {},
		buildings = {},
		canvas = 0,
		minimap = nil
	}
	setmetatable(object, { __index = Map })
	return object
end

-- create new w*h map of all grass tiles
function Map:initMap(w,h)
	self.width = w
	self.height = h
	self.tileSize = 25 -- default pixel square size
	self.canvas = love.graphics.newCanvas(self.width*self.tileSize, self.height*self.tileSize)
	--[[for i=0, (w * h - 1) do
		self.tiles[i] = Tile:new()
	end]]--
	self.tiles[-1] = {}
	self.tiles[w] = {}
	for i=0, w-1 do
		self.tiles[i] = {}
		for j=0, h-1 do
			self.tiles[i][j] = Tile:new()
			self.tiles[i][j]:setId("G")
		end
	end
end

function Map:setMinimap(mm)
	self.minimap = mm
end

-- load map from file
function Map:loadMap(filename)	
	io.input(filename)	
	data = io.read("*all")
	x = 0
	y = 0
	for c in data:gmatch"%u" do -- match all upper case chars
		self.tiles[x][y]:setId(c)
		
		x = x + 1	
		if x == self.width then
			x = 0
			y = y + 1
		end
	end
	
	-- find map buildings
	--self:detectBuildings()														** COMMENTED OUT
end

-- save map to file
function Map:saveMap(filename)
	io.output(filename)
	for y=0,self.height-1 do
		for x=0,self.width-1 do
			io.write(self.tiles[x][y]:getId())
		end
		io.write("\n")
	end
end	

-- draw map to canvas
function Map:drawMap()
	resetColor = {255,255,255}
	love.graphics.setColor(resetColor)
	
	self.canvas = love.graphics.newCanvas(self.width*self.tileSize, self.height*self.tileSize)
	
	for x=0,self.width-1 do
		for y=0,self.height-1 do
			xb = x * self.tileSize
			yb = y * self.tileSize

			tile = self.tiles[x][y]
				
			--love.graphics.drawq(tile:getImg(), tile.sprite, xb, yb)
			-- draw to canvas instead, and on each main draw call, draw the canvas
			--self.canvas:renderTo(function()
			love.graphics.setCanvas(self.canvas)
				love.graphics.drawq(tile:getImg(), tile.sprite, xb, yb)
			love.graphics.setCanvas()
			--end)
		end
	end
end

function Map:draw()
	love.graphics.draw(self.canvas, 0,0)
end

-- tile index
function Map:index(x,y)
	return (y * self.width) + x
end

function Map:updateTileInfo(x,y)
	self:getNeighborInfo(x,y)
	self:getNeighborInfo(x,y-1)
	self:getNeighborInfo(x+1,y-1)
	self:getNeighborInfo(x+1,y)
	self:getNeighborInfo(x+1,y+1)
	self:getNeighborInfo(x,y+1)
	self:getNeighborInfo(x-1,y+1)
	self:getNeighborInfo(x-1,y)
	self:getNeighborInfo(x-1,y-1)	
	--self:drawMap()
end

function Map:getNeighborInfo(x,y)
	if (x < 0) or (y < 0) or (x > self.width-1) or (y > self.height-1) then return end
	xb = x * self.tileSize
	yb = y * self.tileSize
	
	if not(minimap == nil) then self.minimap:updateCanvas(x,y) end
	
	--index = self:index(x,y)
	tile = self.tiles[x][y]
	
	-- check bounds and set each neighbor to 1 if it is the same tile
	if (y-1 > -1) then
		--tileN  = self.tiles[self:index(x,y-1)]
		tileN  = self.tiles[x][y-1]
		N = (tile.id == tileN.id) and 1 or 0
	else N = 0 end
	if ((x+1 < self.width) and (y-1 > -1)) then
		--tileNE  = self.tiles[self:index(x+1,y-1)]
		tileNE  = self.tiles[x+1][y-1]
		NE = (tile.id == tileNE.id) and 1 or 0
	else NE = 0 end
	if (x+1 < self.width) then
		--tileE  = self.tiles[self:index(x+1,y)]
		tileE  = self.tiles[x+1][y]
		E = (tile.id == tileE.id) and 1 or 0
	else E = 0 end
	if ((x+1 < self.width) and (y+1 < self.height)) then
		--tileSE  = self.tiles[self:index(x+1,y+1)]
		tileSE  = self.tiles[x+1][y+1]
		SE = (tile.id == tileSE.id) and 1 or 0
	else SE = 0 end
	if (y+1 < self.height) then
		--tileS  = self.tiles[self:index(x,y+1)]
		tileS  = self.tiles[x][y+1]
		S = (tile.id == tileS.id) and 1 or 0
	else S = 0 end
	if ((x-1 > -1) and (y+1 < self.height)) then
		--tileSW  = self.tiles[self:index(x-1,y+1)]
		tileSW  = self.tiles[x-1][y+1]
		SW = (tile.id == tileSW.id) and 1 or 0
	else SW = 0 end
	if (x-1 > -1) then
		--tileW  = self.tiles[self:index(x-1,y)]
		tileW  = self.tiles[x-1][y]
		W = (tile.id == tileW.id) and 1 or 0
	else W = 0 end
	if ((x-1 > -1) and (y-1 > -1)) then
		--tileNW  = self.tiles[self:index(x-1,y-1)]
		tileNW  = self.tiles[x-1][y-1]
		NW = (tile.id == tileNW.id) and 1 or 0
	else NW = 0 end
		
	if (tile.id == "R") then
		self:selectRoadSprite(tile)
	elseif (tile.id == "W") then
		self:selectWaterSprite(tile)	
	elseif (tile.id == "G") then
		self:selectGroundSprite(tile)
	elseif (tile.id == "D") then	-- builDing tile
		self:selectBuildingSprite(tile, x, y)
	end
	
	--self.canvas:renderTo(function()
	love.graphics.setCanvas(self.canvas)
		love.graphics.drawq(tile:getImg(), tile.sprite, xb, yb)
	love.graphics.setCanvas()
	--end)
end


function Map:selectRoadSprite(tile)
	local w = self.tileSize
	spritei = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

	-- eliminate sprites based on neighbor info
	if (N == 1) then
		spritei[2], spritei[3], spritei[4], spritei[7], spritei[8], spritei[10], spritei[13], spritei[16] = 0,0,0,0,0,0,0,0 else 
		spritei[1], spritei[5], spritei[6], spritei[9], spritei[11], spritei[12], spritei[14], spritei[15] = 0,0,0,0,0,0,0,0 end
	if (E == 1) then
		spritei[1], spritei[4], spritei[5], spritei[7], spritei[8], spritei[9], spritei[14], spritei[16] = 0,0,0,0,0,0,0,0 else
		spritei[2], spritei[3], spritei[6], spritei[10], spritei[11], spritei[12], spritei[13], spritei[15] = 0,0,0,0,0,0,0,0 end
	if (S == 1) then
		spritei[2], spritei[5], spritei[6], spritei[8], spritei[9], spritei[10], spritei[11], spritei[16] = 0,0,0,0,0,0,0,0 else
		spritei[1], spritei[3], spritei[4], spritei[7], spritei[12], spritei[13], spritei[14], spritei[15] = 0,0,0,0,0,0,0,0 end
	if (W == 1) then
		spritei[1], spritei[3], spritei[6], spritei[7], spritei[9], spritei[10], spritei[12], spritei[16] = 0,0,0,0,0,0,0,0 else
		spritei[2], spritei[4], spritei[5], spritei[8], spritei[11], spritei[13], spritei[14], spritei[15] = 0,0,0,0,0,0,0,0 end
		
	local i = self:findi(spritei)
	tile.sprite = love.graphics.newQuad((i-1)*w, 0, w, w, tile:getImg():getWidth(), w)
end

function Map:selectWaterSprite(tile)
	local w = self.tileSize
	spritei = {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}

	-- eliminate sprites based on neighbor info
	if (N == 1) then
		spritei[1], spritei[5], spritei[4], spritei[11], spritei[3], spritei[7], spritei[10], spritei[14] = 0,0,0,0,0,0,0,0 else 
		spritei[2], spritei[9], spritei[6], spritei[15], spritei[8], spritei[12], spritei[13], spritei[16] = 0,0,0,0,0,0,0,0 end
	if (E == 1) then
		spritei[1], spritei[5], spritei[4], spritei[11], spritei[2], spritei[9], spritei[6], spritei[15] = 0,0,0,0,0,0,0,0 else
		spritei[3], spritei[7], spritei[10], spritei[14], spritei[8], spritei[12], spritei[13], spritei[16] = 0,0,0,0,0,0,0,0 end
	if (S == 1) then
		spritei[1], spritei[5], spritei[3], spritei[7], spritei[2], spritei[9], spritei[8], spritei[12] = 0,0,0,0,0,0,0,0 else
		spritei[4], spritei[11], spritei[10], spritei[14], spritei[6], spritei[15], spritei[13], spritei[16] = 0,0,0,0,0,0,0,0 end
	if (W == 1) then
		spritei[1], spritei[4], spritei[3], spritei[10], spritei[2], spritei[6], spritei[8], spritei[13] = 0,0,0,0,0,0,0,0 else
		spritei[5], spritei[11], spritei[7], spritei[14], spritei[9], spritei[15], spritei[12], spritei[16] = 0,0,0,0,0,0,0,0 end
		
	local i = self:findi(spritei)
	tile.sprite = love.graphics.newQuad(0, (i-1)*w, w, w, w, tile:getImg():getHeight())
end

function Map:selectGroundSprite(tile)
	local w = self.tileSize

	i = math.random(0, tile:getImg():getWidth()/w - 1)
	--print(i)
	tile.sprite = love.graphics.newQuad(i*w, 0, w, w, tile:getImg():getWidth(), w)
end

-- find the correct sprite within building
function Map:selectBuildingSprite(tile, x, y)
	local building = self:findBuilding(x, y) 
	tile.img = building.img
	tile.sprite = building:getSprite(x, y, self.tileSize)
end

-- return building containing [x,y], else nil
function Map:findBuilding(x, y)
	for _,v in pairs(self.buildings) do
		if x >= v.x and x <= v.xend and y >= v.y and y <= v.yend then
			return v
		end
	end
	-- not found
	return nil
end

-- detect building placement in a pre-loaded map
function Map:detectBuildings()
	-- defining corners
	local topCorner = {}
	local bottomCorner = {}
	
	-- iterate over all tiles, find the building-defining corners
	for y=0,self.height-1 do
		for x=0,self.width-1 do
			-- is a building tile
			local id = self.tiles[x][y]:getId()
			if id == "D" then				
				-- neighbor tiles
				local N = (self.tiles[x][y-1]:getId() == id)
				local S = (self.tiles[x][y+1]:getId() == id)
				local W = (self.tiles[x-1][y]:getId() == id)
				local E = (self.tiles[x+1][y]:getId() == id)
				
				-- test corners
				if not(N) and not(W) and S and E then
					table.insert(topCorner, Point:new(x, y))
				elseif N and W and not(S) and not(E) then
					table.insert(bottomCorner, Point:new(x, y))
				end
			end
		end
	end
	
	-- create buildings based on the corners
	for i,v in pairs(topCorner) do
		-- get type
		local xd = bottomCorner[i].x - v.x + 1
		local yd = bottomCorner[i].y - v.y + 1
		
		local b_type = (xd * 10) + yd
	
		-- create building
		local building = Building:new()
		building:set(v.x, v.y, b_type)		
		table.insert(self.buildings, building)
	end
end

-- add building from here rather than MapGen
-- return success as boolean
function Map:newBuilding(x, y, b_type)
	-- add building to list
	local b = Building:new()
	b:set(x, y, b_type)
	
	-- building out of bounds
	if (b.xend >= self.width) or (b.yend >= self.height) then
		return false
	end
	
	-- already a building here
	if not(self:findBuilding(b.x, b.y) == nil) or
		not(self:findBuilding(b.x, b.yend) == nil) or
		not(self:findBuilding(b.xend, b.y) == nil) or
		not(self:findBuilding(b.xend, b.yend) == nil) then
		
		return false
	end
	
	-- keep this building
	table.insert(self.buildings, b)
	
	-- set and update tiles
	for xi=x,b.xend do
		for yi=y,b.yend do
			self.tiles[xi][yi]:setId("D")
			self:updateTileInfo(xi, yi)
		end
	end
	
	-- success
	return true
end

function Map:addBoundary()
	local boundTile = Tile:new("X")
	for i = -1, self.height do
		self.tiles[-1][i] = boundTile
		self.tiles[self.width][i] = boundTile
	end
	
	for i = -1, self.width do
		self.tiles[i][-1] = boundTile
		self.tiles[i][self.width] = boundTile
	end
end

function Map:findi(spritei)
	for i,v in ipairs(spritei) do
		if (v == 1) then return i end
	end
	print ("didn't find i")
	return 1
end
