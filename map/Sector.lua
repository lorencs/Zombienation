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
	end
end

-- residential sector
function Sector:residential(map)
	local r = math.random()
	local x1,y1,x2,y2 = self.x1, self.y1, self.x2, self.y2
		
	-- north road
	local yn = y1+1 -- building placement y 
	for x=x1+1,x2-1 do		
		if tileHere(map,x,y1,"R") and tileHere(map,x,yn,"G") then						
			if math.random() < 0.7 then
				if math.random() < 0.5 then
					map:newBuilding(x,yn,11,"N")
				elseif tileHere(map,x+1,yn,"G") then
					map:newBuilding(x,yn,21,"N")
					x = x + 1				
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
					map:newBuilding(xn,y,11,"W")
				elseif tileHere(map,xn,y+1,"G") then
					map:newBuilding(xn,y,12,"W")
					y = y + 1
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
					map:newBuilding(x,yn,11,"S")
				elseif tileHere(map,x+1,yn,"G") then
					map:newBuilding(x,yn,21,"S")
					x = x + 1
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
					map:newBuilding(xn,y,11,"E")
				elseif tileHere(map,xn,y+1,"G") then
					map:newBuilding(xn,y,12,"E")
					y = y + 1
				end
			end
		end
	end
end

-- place commercial buildings
function Sector:commercial(map)
	
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




