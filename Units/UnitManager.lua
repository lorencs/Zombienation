require "Units/Unit"
require "Units/Zombie"
require "Units/Human"
require "Units/SpriteAnimation"

UnitManager = {}
UnitManager_mt = { __index = UnitManager }
	--[[ 

	-> each unit has a unique tag. When zombies chase a unit, they chase them by the tag (eg. human_tag)
	-> number_of_"unit_type" keeps track of all the alive units of that type. They are also the upper limit of the array "unit_type"_list
	
  ]]
  
  	selectedUnitsCount = 0
	selected_units = {}
		
-- Constructor
function UnitManager:new()
    -- define our parameters here
    local new_object = {
	paused = false,
	RangerCost = 10
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
	human_tag = 1								-- each unit has a unique tag
	zombie_tag = 1
	ranger_tag = 1
	zombie_list = {}							-- array of zombie objects
	human_list = {}								-- array of human objects
	ranger_list = {}								-- array of ranger objects
	
	number_of_zombies = orig_number_of_zombies			-- zombies are red
	number_of_humans = orig_number_of_humans			-- humans are blue
	number_of_rangers = orig_number_of_rangers			-- humans are blue
	-- generating units (Unit Manager coming soon, will make this much shorter )
	
	-- set up zombies
	for i = 1, number_of_zombies do
		zombie_list[i] = Zombie:new()
		zombie_list[i]:setupUnit()
		zombie_tag = zombie_tag + 1
	end
	
	-- set up humans
	for i = 1, number_of_humans do
		human_list[i] = Human:new()
		human_list[i]:setupUnit()
		human_tag = human_tag + 1
	end	
	
	-- no rangers at start
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
	
	-- reset counters and tags
	number_of_humans = 1
	number_of_zombies = 1
	number_of_rangers = 1
	zombie_tag = 1
	human_tag = 1
	ranger_tag = 1
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
	
	-- draw ranger
	for i = 1, number_of_rangers do
		ranger_list[i]:draw(i)
	end
end

function UnitManager:selectUnits(x1,y1,x2,y2)
	-- get the max y and x coords
	--if not x1
	print("select")
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
			selected_units[i] = human_list[i].tag
			selectedUnitsCount = selectedUnitsCount + 1
		end
	end
	
	for i = 1, number_of_zombies do
		if ( ( zombie_list[i].cx > min_x ) and ( zombie_list[i].cx < max_x )
			and ( zombie_list[i].cy > min_y ) and ( zombie_list[i].cy < max_y ) ) then
			
			zombie_list[i].selected = true	-- set the selected value to true
		end
	end
	
	for i = 1, number_of_rangers do
		if ( ( ranger_list[i].cx > min_x ) and ( ranger_list[i].cx < max_x )
			and ( ranger_list[i].cy > min_y ) and ( ranger_list[i].cy < max_y ) ) then
			
			ranger_list[i].selected = true	-- set the selected value to true
		end
	end
	
end

function UnitManager:deselectUnits()
	print("deselect")
	for i = 1, number_of_humans do
		human_list[i].selected = false	-- deselect all zombies 
	end
	for i = 1, number_of_zombies do
		zombie_list[i].selected = false	-- deselect all zombies 
	end
	for i = 1, number_of_rangers do
		ranger_list[i].selected = false	-- deselect all zombies 
	end
	selectedUnitsCount = 0
	
end

function UnitManager:moveTo(xo,yo)
	print("hi")
	
	--number_of_zombies = number_of_zombies + 1					-- increase count of zombies alive
	--zombie_list[number_of_zombies] = Zombie:new(xo, yo)	-- create new zombie at the location of this zombie
	--zombie_list[number_of_zombies]:setupUnit()					-- setup zombie
	number_of_humans = number_of_humans + 1					-- increase count of zombies alive
	human_list[number_of_humans] = Human:new(xo, yo)	-- create new zombie at the location of this zombie
	human_list[number_of_humans]:setupUnit()					-- setup zombie
	
	--[[
	for i = 1, number_of_humans do
		if human_list[i].selected == true then
			local angle = Unit:angleToXY(human_list[i].x,human_list[i].y, xo,yo)
			human_list[i].targetAngle = angle
			human_list[i].controlled = true
		end
	end
	
	for i = 1, number_of_zombies do
		if zombie_list[i].selected == true then
			local angle = Unit:angleToXY(zombie_list[i].x,zombie_list[i].y, xo,yo)
			--zombie_list[i].targetAngle = angle
			--zombie_list[i].controlled = true
		end
	end
	--]]
end

