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

    }
    setmetatable(new_object, UnitManager_mt )
    return new_object
end

function UnitManager:initUnits()
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

-- Update function
function UnitManager:update(dt, gravity)
    -- update the unit's position
	
	-- update zombies
	for i = 1, number_of_zombies do
		zombie_list[i]:update(dt, i)
		--zombie_list[i].animation:update(dt)
	end
	-- update humans
	for i = 1, number_of_humans do
		human_list[i]:update(dt,i)
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
end

function UnitManager:selectUnits(x1,y1,x2,y2)
	-- get the max y and x coords
	--if not x1
	
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
		if ( ( human_list[i].x > min_x ) and ( human_list[i].x < max_x )
			and ( human_list[i].y > min_y ) and ( human_list[i].y < max_y ) ) then
			human_list[i].selected = true	-- set the selected value to true
			selected_units[i] = human_list[i].tag
			selectedUnitsCount = selectedUnitsCount + 1
		end
	end
	
	
	
end

function UnitManager:deselectUnits()
	for i = 1, number_of_humans do
		human_list[i].selected = false	-- deselect all zombies 
	end
	selectedUnitsCount = 0
	
end
