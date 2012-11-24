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
	paused = false
    }
    setmetatable(new_object, UnitManager_mt )
    return new_object
end

function UnitManager:initUnits()

	number_of_zombies = orig_number_of_zombies			-- zombies are red
	number_of_humans = orig_number_of_humans			-- humans are blue
	-- generating units (Unit Manager coming soon, will make this much shorter )
	
	zombie_list = {}							-- array of zombie objects
	zombie_tag = 1
	human_list = {}								-- array of human objects
	human_tag = 1								-- each unit has a unique tag
	
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
end

function UnitManager:resetUnits()

	--print("ini humans".. #human_list)
	--print("ini zombies".. #zombie_list)
	
	-- remove all units from tables
	for k in pairs (zombie_list) do
		zombie_list [k] = nil
	end
	for k in pairs (human_list) do
		human_list [k] = nil
	end
	
	-- reset counters
	number_of_humans = 0
	number_of_zombies = 0
	
	-- re init units
	self:initUnits()
	
	--print("humans".. #human_list)
	--print("zombies".. #zombie_list)
end

function UnitManager:pauseGame()
	self.paused = true
end

function UnitManager:resumeGame()
	self.paused = false
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
	
end

function UnitManager:draw()
	
	--if self.paused == 1 then return end		-- game is paused
	
	-- draw zombies
	for i = 1, number_of_zombies do
		zombie_list[i]:draw(i)
		--zombie_list[i].animation:draw(zombie_list[i].x, zombie_list[i].y)
	end
	-- draw humans
	for i = 1, number_of_humans do
		human_list[i]:draw(i)
	end
end

function UnitManager:selectUnits(x1,y1,x2,y2)
	-- get the max y and x coords
	--if not x1
	print("select")
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
	
end

function UnitManager:deselectUnits()
print("deselect")
	for i = 1, number_of_humans do
		human_list[i].selected = false	-- deselect all zombies 
	end
	selectedUnitsCount = 0
	
end
