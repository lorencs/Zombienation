Astar = {}
Astar_mt = { __index = Astar }

function Astar:new()
    -- define our parameters here
    local new_object = {
    --nodeX = 0,
    --nodeY = 0,
	--cost = 0,
	--parentNode = 0
    }
    setmetatable(new_object, Astar_mt )
    return new_object
end

function Astar:findPath(startX, startY, endX, endY)
	
	--local openLCount = 1
	--local closedLCount = 1
	local openList = {}
	local closedList = {}
	if (startX == endX) and (startY == endY) then return end	-- already at the target
	
	currentNode = Node:new()
	
	
	startNode = Node:new(startX, startY)
	openList[1] = startNode
	--local n = 0
	print("Calculating Shortest Path ")
	while #openList > 0 do
		
		--[[n = n + 1
		if n > 2 then 
			while 1 do end
		end]]
		local retList = {}
		--print("open List count:"..#openList)
		currentNode = self:lowestCostNodeInArray(openList)
		--if currentNode == 0 then return end
		-- if the current node is at endX and endY, path found
		if (currentNode.nodeX == endX) and (currentNode.nodeY == endY) then
			print("Path found !")
			
			local listToRet = currentNode.parentNode
			while (listToRet.parentNode ~= nil) do
				--print("x:"..listToRet.nodeX..",y:"..listToRet.nodeY)
				listToRet = listToRet.parentNode
				local p = Point:new(listToRet.nodeX, listToRet.nodeY)
				table.insert(retList, p)
			end
			return retList
		end
		
		table.insert(closedList, currentNode)
		local ind = self:indexOfNode(openList,currentNode)
		table.remove(openList, ind)
		
		local currentX = currentNode.nodeX
		local currentY = currentNode.nodeY

		for yy = -1,1 do
			local newY = currentY + yy
					
			for xx = -1, 1 do
				local newX = currentX + xx
				if not ((yy == 0) and (xx == 0)) then
					-- checking bounds:
					if (newX>=0) and (newY>=0) and (newX < map.width*map.tileSize) and (newY < map.height*map.tileSize) then
						-- if node isn't in open list
						
						if not (self:nodeInArray(openList, newX, newY)) then
							if not (self:nodeInArray(closedList, newX, newY)) then
							--print("newX:"..newX..",newY:"..newY)
								if (map.tiles[newX][newY].id == "G") or (map.tiles[newX][newY].id == "R") then
									local aNode = Node:new()
									aNode.nodeX = newX
									aNode.nodeY = newY
									aNode.parentNode = currentNode
									aNode.cost = currentNode.cost + 1
									aNode.cost = aNode.cost + math.abs(newX - endX) + math.abs(newY - endY)
									table.insert(openList, aNode)
								end
							end
						end
					end
				end
			end
		end
	end
	print("No Path Found !")
	return nil
end
	-- i is index, v is object
	--for i,v in pairs(zombie_list) do
	--	print("index:"..i)
	--	print("object..tag:"..v.tag)
	--end
	
function Astar:indexOfNode(list, node)
	for i,v in pairs(list) do
		if node == v then
			return i
		end
	end
	return nil
end

function Astar:lowestCostNodeInArray(list)
	n = Node:new()
	lowest = 0
	
	for i,v in pairs (list) do
		if (lowest == 0) then lowest = v
		else
			if v.cost < lowest.cost then
				lowest = v
			end
		end
	end
	return lowest
end

function Astar:nodeInArray(list, xa,ya)
	--print("in FUNC:"..xa..",y:"..ya)
	
	for i,k in pairs (list) do
		if (k.nodeX == xa) and (k.nodeY == y) then
			return k
		end
	end
	--print("in FUNC:"..#list)
	return nil
end

