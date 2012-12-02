Sector = {}

function Sector:new(xa, ya, xb, yb, d)
	local object = {
		x1 = xa,
		y1 = ya,
		x2 = xb,
		y2 = yb,
		sectorType = nil,
		divide = d,		-- orientation of bisector
		depthValue = nil
	}
	setmetatable(object, { __index = Sector })
	return object
end

function Sector:yd()
	return self.y2 - self.y1
end
function Sector:xd()
	return self.x2 - self.x1
end
function Sector:area()
	return self:xd() * self:yd()
end

-- start as point
function getSectors(start, width, height)
	sectors = {}
	cycle = {}

	s = Sector:new(start.x , start.y , start.x + width-1, start.y + height-1, "H")
	table.insert(sectors, s)
	table.insert(cycle, s)
	
	local depth = 50
	local splitChance = 0.65

	for d=0,depth do
		cycle = {}	-- reset cycle
		for _,v in pairs(sectors) do
			if math.random() < splitChance then				
				a,b = v:split()
				if not(a == nil) then table.insert(cycle, a) end
				if not(b == nil) then table.insert(cycle, b) end				
			else
				table.insert(cycle, v)
			end
		end
		
		sectors = cycle
	end
	
	return sectors
end

function Sector:split()
	local a,b = nil,nil
	local xd, yd = self:xd(), self:yd()
	
	-- control splits
	local minLen = 10
	local minArea = 30
	
	if (yd < minLen and xd < minLen) or self:area() < minArea then
		return self, nil
	elseif yd < minLen and xd > 2*yd then
		self.divide = "V"
	elseif xd < minLen and yd > 2*xd then
		self.divide = "H"
	end

	if self.divide == "H" then
		local partway = yd / 3
		local r = math.floor((math.random() * partway) + partway)
		if r < 3 then r = 3 end
		local boundY = self.y1 + r
		
		a = Sector:new(self.x1, self.y1, self.x2, boundY, "V")
		b = Sector:new(self.x1, boundY, self.x2, self.y2, "V")
	elseif self.divide == "V" then
		local partway = xd / 3
		local r = math.floor((math.random() * partway) + partway)
		if r < 3 then r = 3 end
		local boundX = self.x1 + r
		
		a = Sector:new(self.x1, self.y1, boundX, self.y2, "H")
		b = Sector:new(boundX, self.y1, self.x2, self.y2, "H")
	end
	
	return a,b
end

-- semi-randomness
function Sector:placeBuildings(map)
	if self.sectorType == "residential" then
		self:residential(map)
	elseif self.sectorType == "park" then
		self:park(map)
	end
end

-- residential sector
function Sector:residential(map)
	local r = math.random()
	local x1,y1,x2,y2 = self.x1, self.y1, self.x2, self.y2
		
	-- choose sector color
	local style = nil
	if math.random() < 0.5 then
		style = "2"
	end
		
	-- north road
	local yn = y1+1 -- building placement y 
	for x=x1+1,x2-1 do		
		if tileHere(map,x,y1,"R") and tileHere(map,x,yn,"G") then						
			if math.random() < 0.7 then
				if math.random() < 0.5 then
					map:newBuilding(x,yn,11,"N",style)
				elseif tileHere(map,x,yn+1,"G") then
					map:newBuilding(x,yn,12,"N",style)				
				end
			end
		end
	end
	-- west road
	local xn = x1+1
	for y=y1+1,y2-1 do		
		if tileHere(map,x1,y,"R") and tileHere(map,xn,y,"G") then
			if math.random() < 0.7 then
				if math.random() < 0.5 then
					map:newBuilding(xn,y,11,"W",style)
				elseif tileHere(map,xn+1,y,"G") then
					map:newBuilding(xn,y,21,"W",style)					
				end
			end
		end
	end
	-- south road
	local yn = y2-1
	for x=x1+1,x2-1 do		
		if tileHere(map,x,y2,"R") and tileHere(map,x,yn,"G") then
			if math.random() < 0.7 then
				if math.random() < 0.5 then
					map:newBuilding(x,yn,11,"S",style)
				elseif tileHere(map,x,yn-1,"G") then
					map:newBuilding(x,yn-1,12,"S",style)
				end
			end
		end
	end
	-- east road
	local xn = x2-1
	for y=y1+1,y2-1 do
		if tileHere(map,x2,y,"R") and tileHere(map,xn,y,"G") then
			if math.random() < 0.7 then
				if math.random() < 0.5 then
					map:newBuilding(xn,y,11,"E",style)
				elseif tileHere(map,xn-1,y,"G") then
					map:newBuilding(xn-1,y,21,"E",style)
				end
			end
		end
	end
end

-- place commercial buildings
function Sector:commercial(map)
	
end

-- place a park
function Sector:park(map)
	-- no tiny parks
	if self:xd() < 6 or self:yd() < 6 or self:area() < 50 then
		return
	end
	
	-- change sector into grass
	self:fillWithGrass(map)
	
	-- self ref
	local x1,y1,x2,y2 = self.x1, self.y1, self.x2, self.y2
	
	-- local vars
	local gapSide = math.floor(math.random() * 4)
	local xmid = x1 + math.floor(self:xd() / 2) + 1
	local ymid = y1 + math.floor(self:yd() / 2) + 1	
	local dir,style = nil,nil
	
	-- north side
	local yn = y1+1 -- building placement y 
	for x=x1+1,x2-1 do		
		--if tileHere(map,x,yn,"G") then						
			if gapSide == 0 then
				if not(x == xmid) then
					map:newBuilding(x,yn,11,dir,style)
				end
			else
				map:newBuilding(x,yn,11,dir,style)
			end
		--end
	end
	-- west road
	local xn = x1+1
	for y=y1+1,y2-1 do		
		--if tileHere(map,xn,y,"G") then
			if gapSide == 1 then
				if not(y == ymid) then
					map:newBuilding(xn,y,11,dir,style)
				end
			else
				map:newBuilding(xn,y,11,dir,style)
			end
		--end
	end
	-- south road
	local yn = y2
	for x=x1+1,x2 do		
		--if tileHere(map,x,yn,"G") then
			if gapSide == 2 then
				if not(x == xmid) then
					map:newBuilding(x,yn,11,dir,style)
				end
			else 
				map:newBuilding(x,yn,11,dir,style)
			end
		--end
	end
	-- east road
	local xn = x2
	for y=y1+1,y2 do
		--if tileHere(map,xn,y,"G") then
			if gapSide == 3 then
				if not(y == ymid) then
					map:newBuilding(xn,y,11,dir,style)
				end
			else
				map:newBuilding(xn,y,11,dir,style)
			end
		--end
	end	
end

function Sector:fillWithGrass(map)
	for x=self.x1+1,self.x2 do
		for y=self.y1+1,self.y2 do
			map.tiles[x][y]:setId("G")
		end
	end
end

function tileHere(map,x,y,t)
	return map.tiles[x][y]:getId() == t
end

function outputSectors(sectors)
	io.output("sectors.txt")
	
	for _,v in pairs(sectors) do
		io.write("["..v.x1..","..v.y1.."]-["..v.x2..","..v.y2.."]")
		io.write("\n")
	end
end




