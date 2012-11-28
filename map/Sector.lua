Sector = {}

function Sector:new(xa, ya, xb, yb)
	local object = {
		x1 = xa,
		y1 = ya,
		x2 = xb,
		y2 = yb
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

function getSectors(width, height)
	sectors = {}
	cycle = {}

	s = Sector:new(0,0, width-1, height-1)
	table.insert(sectors, s)
	table.insert(cycle, s)
	
	local depth = 25
	local areaMin = 100
	local horizontal = true

	for d=0,depth do
		cycle = {}	-- reset cycle
		for i,v in pairs(sectors) do
			a,b = splitSector(v, horizontal, areaMin)
			if not(a == nil) then table.insert(cycle, a) end
			if not(b == nil) then table.insert(cycle, b) end				
		end
		horizontal = not(horizontal)

		sectors = cycle
	end
	
	return sectors
end

function splitSector(s, horizontal, areaMin)
	if (s:xd() * s:yd()) < areaMin then
		return s, nil
	end

	if horizontal then
		local boundY = s.y1 + math.floor(math.random() * s:yd())		
		a = Sector:new(s.x1, s.y1, s.x2, boundY)
		b = Sector:new(s.x1, boundY, s.x2, s.y2)
	else
		local boundX = s.x1 + math.floor(math.random() * s:xd())
		a = Sector:new(s.x1, s.y1, boundX, s.y2)
		b = Sector:new(boundX, s.y1, s.x2, s.y2)
	end
	
	return a,b
end

function outputSectors(sectors)
	io.output("sectors.txt")
	
	for _,v in pairs(sectors) do
		io.write("["..v.x1..","..v.y1.."]-["..v.x2..","..v.y2.."]")
		io.write("\n")
	end
end




