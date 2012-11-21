require "Units/Unit"
require "Units/Zombie"
require "Units/Human"
require "Units/SpriteAnimation"

UnitManager = {}
UnitManager_mt = { __index = UnitManager }

--[[ 
d
	unit info .. 
	no enumerations in lua so.. 
	unitTypes:
		zombie = 0
		civilian = 1
		armedCivilian = 2
		etc ?
]]--

-- Constructor
function UnitManager:new()
    -- define our parameters here
    local new_object = {
    zombies_alive = 0,
	humans_alive = 0
    }
    setmetatable(new_object, UnitManager_mt )
    return new_object
end

function UnitManager:initUnits()
	-- generating units (Unit Manager coming soon, will make this much shorter )
	
	zombie_list = {}							-- array of zombie objects
	human_list = {}								-- array of human objects
	
	-- set up zombies
	for i = 1, number_of_zombies do
		zombie_list[i] = Zombie:new()
		zombie_list[i]:setupUnit()
	end
	
	-- set up humans
	for i = 1, number_of_humans do
		human_list[i] = Human:new()
		human_list[i]:setupUnit()
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