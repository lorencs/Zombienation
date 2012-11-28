function createMaze(width, height)
	local maze = {}
	local drill = {}
	
	-- empty maze
	for x=0,width-1 do
		maze[x] = {}
		for y=0,height-1 do
			maze[x][y] = false
		end
	end
	
	-- start in the middle
	s = Point:new(math.floor(width/2), math.floor(height/2))
	table.insert(drill, s)
	
	cur = s
	local i = 0
	--local cur = drill[0]
	print("TEST "..cur.x..","..cur.y)
	-- loop through the drill
	while not(cur == nil) do
		local removeDrill = false
		
		r = math.floor(math.random() * 4)
		print(i..": "..r)
		
		if r == 0 then
			cur.y = cur.y - 2
			if cur.y < 0 or maze[cur.x][cur.y] then
				removeDrill = true
				break
			end
			maze[cur.x][cur.y+1] = true
			break
			
		elseif r == 1 then
			cur.y = cur.y + 2
			if cur.y >= height or maze[cur.x][cur.y] then
				removeDrill = true
				break
			end
			maze[cur.x][cur.y-1] = true
			break
			
		elseif r == 2 then
			cur.x = cur.x - 2
			if cur.x < 0 or maze[cur.x][cur.y] then
				removeDrill = true
				break
			end
			maze[cur.x+1][cur.y] = true
			break
			
		else	-- r = 3
			cur.x = cur.x + 2
			if cur.x >= width or maze[cur.x][cur.y] then
				removeDrill = true
				break
			end
			maze[cur.x-1][cur.y] = true
			break
			
		end
		
		if removeDrill then
			table.remove(drill, i)
		else
			table.insert(drill, Point:new(cur.x, cur.y))
			maze[cur.x][cur.y] = true
		end
			
		i = i + 1
	end
	
	return maze
end


-- dump to file
function outputMaze(noise, width, height)
	io.output("maze.txt")
	
	for x=0,width-1 do
		for y=0,height-1 do
			if noise[x][y] then
				io.write(".")
			else
				io.write("#")
			end
		end
		io.write("\n")
	end
end