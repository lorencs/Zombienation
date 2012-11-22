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