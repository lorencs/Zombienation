require "Units/Unit"
require "Units/Zombie"
require "Units/Human"
require "Units/Ranger"
require "Units/Worker"
require "Units/SpriteAnimation"

UnitManager = {}
UnitManager_mt = { __index = UnitManager }

humans_selected = 0
zombies_selected = 0
rangers_selected = 0
workers_selected = 0

	--[[ 

	-> each unit has a unique tag. When zombies chase a unit, they chase them by the tag (eg. human_tag)
	-> number_of_"unit_type" keeps track of all the alive units of that type. They are also the upper limit of the array "unit_type"_list
	
  ]]
  
-- Constructor
function UnitManager:new()
    -- define our parameters here
    local new_object = {
	paused = false,
	RangerCost = 10,
	baseTilePos = nil,
	storeTilePos = nil,
	storeToBasePath = {},
	baseToStorePath = {}
    }
    setmetatable(new_object, UnitManager_mt )
    return new_object
end

function UnitManager:initUnits()

	--[[for i = 0, map.width - 1 do
		for j = 0, map.height - 1 do
			print(map.tiles[i][j].id.." ")
		end
	end--]]
	--[[print(map.tiles[0][0].id)
	print(map.tiles[10][13].id)
	print(map.tiles[10][14].id)
	print(map.tiles[10][15].id)
	print(map.tiles[10][16].id)
	print(map.tiles[10][17].id)
	print(map.tiles[10][18].id)]]
	unitTag = 1
	--human_tag = 1								-- each unit has a unique tag
	--zombie_tag = 1
	--ranger_tag = 1
	--worker_tag = 1
	zombie_list = {}							-- array of zombie objects
	human_list = {}								-- array of human objects
	ranger_list = {}								-- array of ranger objects
	worker_list = {}
	number_of_zombies = orig_number_of_zombies			-- zombies are red
	number_of_humans = orig_number_of_humans			-- humans are blue
	number_of_rangers = orig_number_of_rangers			-- humans are blue
	number_of_workers = orig_number_of_workers			-- 
	number_of_cars = orig_number_of_cars
	
	-- set up zombies
	for i = 1, number_of_zombies do
		zombie_list[i] = Zombie:new()
		zombie_list[i]:setupUnit()
		unitTag = unitTag + 1
		--zombie_tag = zombie_tag + 1
	end
	
	-- set up humans
	for i = 1, number_of_humans do
		human_list[i] = Human:new()
		human_list[i]:setupUnit()
		unitTag = unitTag + 1
		--human_tag = human_tag + 1
	end	
	
	-- only setup rangers at start for testing
	for i = 1, number_of_rangers do
		ranger_list[i] = Ranger:new()
		ranger_list[i]:setupUnit()
		unitTag = unitTag + 1
		--ranger_tag = ranger_tag + 1
	end	
	
	for i = 1, number_of_workers do
		worker_list[i] = Worker:new()
		worker_list[i]:setupUnit()
		unitTag = unitTag + 1
		--worker_tag = worker_tag + 1
	end
	
	self.baseTilePos = map.baseTilePt
	self.storeTilePos = map.storeTilePt
	
	-- get shortest paths from store to base and from base to store and store the 2 lists
	self.storeToBasePath = astar:findPath(self.storeTilePos.x, self.storeTilePos.y, self.baseTilePos.x, self.baseTilePos.y)
	self.baseToStorePath = astar:findPath(self.baseTilePos.x, self.baseTilePos.y, self.storeTilePos.x, self.storeTilePos.y)
	--[[
	for i = 1, number_of_cars do
		car_list[i] = Car:new()
		car_list[i]:setupUnit()
		worker_tag = worker_tag + 1
	end]]
	
end

-- gets the idle worker (if any) that is the closest to your current screen view
function UnitManager:getClosestIdleWorker()
	local unitRet = nil
	local closestDist = nil
	
	for i,v in pairs(worker_list) do
		if v.working == false then
			local distance = Unit:distanceBetweenPoints( (view.x + width / 2), (view.y + height / 2), v.x, v.y )
			if distance ~= nil then
				if closestDist == nil then 
						unitRet = v 
						closestDist = distance
				end
				if distance < closestDist then
					closestDist = distance
					unitRet = v
				end
			end
		end
	end

	if unitRet ~= nil then
		local pt = Point:new(unitRet.x, unitRet.y)
		return pt
	else
		return Point:new(view.x, view.y)
	end
end

-- gets the ranger (if any) that is the closest to your current screen view
function UnitManager:getClosestRanger()
	local unitRet = nil
	local closestDist = nil
	
	for i,v in pairs(ranger_list) do
		local distance = Unit:distanceBetweenPoints( (view.x + width / 2), (view.y + height / 2), v.x, v.y )
		if distance ~= nil then
			if closestDist == nil then 
					unitRet = v 
					closestDist = distance
			end
			if distance < closestDist then
				closestDist = distance
				unitRet = v
			end
		end
	end
	
	if unitRet ~= nil then
		local pt = Point:new(unitRet.x, unitRet.y)
		return pt
	else
		return Point:new(view.x, view.y)
	end
end

-- gets the human (if any) that is the closest to your current screen view
function UnitManager:getClosestHuman()
	local unitRet = nil
	local closestDist = nil
	
	for i,v in pairs(human_list) do
		local distance = Unit:distanceBetweenPoints( (view.x + width / 2), (view.y + height / 2), v.x, v.y )
		if distance ~= nil then
			if closestDist == nil then 
					unitRet = v 
					closestDist = distance
			end
			if distance < closestDist then
				closestDist = distance
				unitRet = v
			end
		end
	end
	
	if unitRet ~= nil then
		local pt = Point:new(unitRet.x, unitRet.y)
		return pt
	else
		return Point:new(view.x, view.y)
	end
end

function UnitManager:resetUnits()

	print("RESETTING UNITS !")
	-- remove all units from tables
	for k in pairs (zombie_list) do
		zombie_list [k] = nil
	end
	for k in pairs (human_list) do
		human_list [k] = nil
	end
	for k in pairs (ranger_list) do
		ranger_list [k] = nil
	end
	for k in pairs (worker_list) do
		worker_list [k] = nil
	end
	-- reset counters and tags
	number_of_humans = 1
	number_of_zombies = 1
	number_of_rangers = 1
	number_of_workers = 1
	--zombie_tag = 1
	--human_tag = 1
	--ranger_tag = 1
	--worker_tag = 1
	unitTag = 1
	-- re init units
	self:initUnits()
	
	--print("humans".. #human_list)
	--print("zombies".. #zombie_list)
end

function UnitManager:pauseGame()
	if self.paused == true then
		self.paused = false
	else
		self.paused = true
	end
end

-- Update function
function UnitManager:update(dt, gravity)
    -- update the unit's position
	
	-- update zombies
	for i = 1, number_of_zombies do
		zombie_list[i]:update(dt, i, self.paused)
		--zombie_list[i].animation:update(dt)
	end
	-- update humans
	for i = 1, number_of_humans do
		human_list[i]:update(dt,i, self.paused)
	end
	-- update rangers
	for i = 1, number_of_rangers do
		ranger_list[i]:update(dt,i, self.paused)
	end
	-- update workers
	for i = 1, number_of_workers do
		worker_list[i]:update(dt,i, self.paused)
	end
	
	
	-- check if zombies need to be deleted (needs to be done separate from updating units otherwise 'it messed things up')
	for i,v in pairs(zombie_list) do
		if v.delete then
			table.remove(zombie_list, i)
			number_of_zombies = number_of_zombies - 1
		end
	end
end

function UnitManager:draw()
	
	-- draw zombies
	for i = 1, number_of_zombies do
		zombie_list[i]:draw(i)
		--zombie_list[i].animation:draw(zombie_list[i].x, zombie_list[i].y)
	end
	
	-- draw humans
	for i = 1, number_of_humans do
		human_list[i]:draw(i)
	end
	
	-- draw rangers
	for i = 1, number_of_rangers do
		ranger_list[i]:draw(i)
	end
	
	-- draw workers
	for i = 1, number_of_workers do
		worker_list[i]:draw(i)
	end
	
	love.graphics.setColor(0,255,0)
	love.graphics.rectangle("fill", self.baseTilePos.x*54, self.baseTilePos.y*54, 54, 54)
	love.graphics.rectangle("fill", self.storeTilePos.x*54, self.storeTilePos.y*54, 54, 54)

end

function UnitManager:selectUnits(x1,y1,x2,y2)
	print("select")
	-- get the max y and x coords
	--if not x1
	self:deselectUnits()
	local max_x = 0
	local min_x = 0
	if x1 < x2 then
		max_x = x2
		min_x = x1
	else
		max_x = x1
		min_x = x2
	end
	
	local max_y = 0
	local min_y = 0
		if y1 < y2 then
		max_y = y2
		min_y = y1
	else
		max_y = y1
		min_y = y2
	end

	for i = 1, number_of_humans do
		if ( ( human_list[i].cx > min_x ) and ( human_list[i].cx < max_x )
			and ( human_list[i].cy > min_y ) and ( human_list[i].cy < max_y ) ) then
			
			human_list[i].selected = true	-- set the selected value to true
			humans_selected = humans_selected + 1
		end
	end
	
	for i = 1, number_of_zombies do
		if ( ( zombie_list[i].cx > min_x ) and ( zombie_list[i].cx < max_x )
			and ( zombie_list[i].cy > min_y ) and ( zombie_list[i].cy < max_y ) ) then
			
			zombie_list[i].selected = true	-- set the selected value to true
			zombies_selected = zombies_selected + 1
		end
	end
	
	for i = 1, number_of_rangers do
		if ( ( ranger_list[i].cx > min_x ) and ( ranger_list[i].cx < max_x )
			and ( ranger_list[i].cy > min_y ) and ( ranger_list[i].cy < max_y ) ) then
			
			ranger_list[i].selected = true	-- set the selected value to true
			rangers_selected = rangers_selected + 1
		end
	end
	
	for i = 1, number_of_workers do
		if ( ( worker_list[i].cx > min_x ) and ( worker_list[i].cx < max_x )
			and ( worker_list[i].cy > min_y ) and ( worker_list[i].cy < max_y ) ) then
			
			worker_list[i].selected = true	-- set the selected value to true
			workers_selected = workers_selected + 1
		end
	end
end

function UnitManager:deselectUnits()
print("deselect")
	for i = 1, number_of_humans do
		human_list[i].selected = false	-- deselect all humans 
	end
	for i = 1, number_of_zombies do
		zombie_list[i].selected = false	-- deselect all zombies 
	end
	for i = 1, number_of_rangers do
		ranger_list[i].selected = false	-- deselect all rangers 
	end
	for i = 1, number_of_workers do
		worker_list[i].selected = false	-- deselect all workers 
	end
	
	humans_selected = 0
	zombies_selected = 0
	rangers_selected = 0
	workers_selected = 0

	
end

function UnitManager:updateUnit(unitOrig, newType)
		--local deadx = u[h_index].x
		--local deady = human_list[h_index].y
		--table.remove(human_list, h_index)							-- remove human from human_list array
end

function UnitManager:createRanger(xo,yo)
	print("Creating a Ranger at x:"..xo..",y:"..yo)
	number_of_rangers = number_of_rangers + 1					-- increase count of zombies alive
	ranger_list[number_of_rangers] = Ranger:new(xo+view.x, yo+view.y)	-- create new zombie at the location of this zombie
	ranger_list[number_of_rangers]:setupUnit()
	unitTag = unitTag + 1
	--ranger_tag = ranger_tag + 1
end

function UnitManager:moveTo(xo,yo)

	for i,v in pairs (human_list) do
		if v.selected == true then
			v:getShortestPath(v.x,v.y,xo,yo)
		end
	end

	for i,v in pairs (worker_list) do
		if v.selected == true then
			--v:getShortestPath(v.x,v.y,xo,yo)
			print("HIIIII")
			v:sendToWork()
		end
	end
end

function UnitManager:collectSupplies()
	--[[for i,v in pairs (worker_list) do
		if v.selected == true then
			v:getShortestPath(v.x,v.y,xo,yo)
			v:sendToWork()
		end
	end]]--
end

function UnitManager:patrol(xtar,ytar)
	for i,v in pairs (ranger_list) do
		if v.selected == true then
			print("patrol")
			v:getShortestPath(v.x,v.y,xtar,ytar)
			v:patrol()
		end
	end
end

function UnitManager:selectedType()
	local total_units_selected = zombies_selected + rangers_selected + workers_selected + humans_selected
	local uType = "X"
	if zombies_selected == 0 and rangers_selected == 0 and workers_selected == 0 then
		uType = "Humans"
	elseif zombies_selected == 0 and rangers_selected == 0 and humans_selected == 0 then
		uType = "Workers"
	elseif zombies_selected == 0 and workers_selected == 0 and humans_selected == 0 then
		uType = "Rangers"
	elseif workers_selected == 0 and rangers_selected == 0 and humans_selected == 0 then
		uType = "Zombies"
	else
		uType = "Mixed"
	end
	return total_units_selected, uType
end

function UnitManager:convertUnits(convType)
	if (convType == "Worker") then
		for i,v in pairs (human_list) do
			if v.selected == true then
				local dx = v.x
				local dy = v.y
				number_of_workers = number_of_workers + 1
				newWorker = Worker:new(dx,dy)
				table.insert(worker_list, newWorker)
				worker_list[number_of_workers]:setupUnit()
				unitTag = unitTag + 1
				--worker_tag = worker_tag + 1
				
				table.remove(human_list, i)
				number_of_humans = number_of_humans - 1
			end
		end
	elseif (convType == "Ranger") then
		for i,v in pairs (human_list) do
			if v.selected == true then
				local dx = v.x
				local dy = v.y
				number_of_rangers = number_of_rangers + 1
				newRanger = Ranger:new(dx,dy)
				table.insert(ranger_list, newRanger)
				ranger_list[number_of_rangers]:setupUnit()
				--ranger_tag = ranger_tag + 1
				unitTag = unitTag + 1
				
				table.remove(human_list, i)
				number_of_humans = number_of_humans - 1
			end
		end
	end	
end

function UnitManager:sendWorkers()
	for i,v in pairs (worker_list) do
		if v.selected == true then
			v:sendToWork()
		end
	end
end
