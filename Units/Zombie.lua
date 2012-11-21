Zombie = {}
Zombie_mt = { __index = Zombie }

-- Constructor
function Zombie:new()

    local new_object = {							-- define our parameters here
    x = 0,
    y = 0,
    width = 0,
    height = 0,
    xSpeed = 0,
    ySpeed = 0,
    state = "",
    normalSpeed = 0,
    runSpeed = 0,
	timeTracker = 0,
	initial_direction = 1,
	x_direction = math.random(2),
	y_direction = math.random(2)
    }

	setmetatable(new_object, Zombie_mt )			-- add the new_object to metatable of Zombie
	setmetatable(Zombie, { __index = Unit })        -- Zombie is a subclass of class Unit, so set inheritance..
	
	--self.setupUnit()								-- why doesnt this work ?? for now, just calling setupUnit in main..							
	
    return new_object								--
end

function Zombie:setupUnit()							-- init vars for Zombie unit
	self.x = math.random(650) 						-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	self.y = math.random(love.graphics.getHeight() - self.height)
	self.width = 50
	self.height = 50
	self.state = "Lurching around"
	self.xSpeed = 15
	self.ySpeed = 15
	self.normalSpeed = 5
	self.runSpeed = 7
	--print("Zombie is set !")
	
end

function Zombie:draw()
	--print("Zombie getting drawn !".. self.x..", ".. self.y)
	
	playerColor = {255,0,0}
	love.graphics.setColor(playerColor)
	love.graphics.rectangle("fill", self.x, self.y, 10, 10)
end

function Zombie:unitAction()
    --print( " ZOMBIE ! The unit can do this action .." )

	--print("x is "..x_rand.. " and y is ".. y_rand)
end

--function Zombie:unitAction2()						-- can overwrite this .. 
  --  print( "aaa Another action it can do .." )
--end

-- Update function
function Zombie:update(dt, zi)
    -- update the unit's position		
	--if not x_direction then x_direction = 1 end		
	--if not y_direction then y_direction = 1 end		-- initial direction will be 1,1
	
	--self.lookAround()
	
	if self.x_direction == 2 then self.x_direction = -1 end		-- this is for the first time an update happens
	if self.y_direction == 2 then self.y_direction = -1 end
	
	--randomizer = self.x
	if self.timeTracker > 5 then 					-- after 5 seconds, the zombie should change x and y directions
		
		--randomizer = randomizer + self.x
		self.x_direction = math.random(2)				-- EXCEPT if he sees a target *change*, need to add stuff here
		if (self.x_direction == 1) then 
			self.x_direction = -1
		elseif (self.x_direction == 2) then
			self.x_direction = 1
		end
		--math.randomseed( math.random(5) )
		--randomizer = randomizer + self.y
		self.y_direction = math.random(2)				-- can't randomize -1 OR 1, so this is a way around it
		if (self.y_direction == 1) then 
			self.y_direction = -1
		elseif (self.y_direction == 2) then
			self.y_direction = 1
		end

		self.timeTracker = 0
	end
	
	self.timeTracker = self.timeTracker + dt			-- increasing timeTracker
	
	-- CHECK MAP BOUNDARIES HERE
	--[[
	print("map width is ".. map.width .. " and map height ".. map.height )
	if (self.x < 26) or (self.x > 624) or (self.y < 26) or (self.y > 574) then
		x_direction = 0
		y_direction = 0
		self.timeTracker = self.timeTracker + 5
	end
	]]--
	
	--print("x direction is ".. x_direction)
	--print("x direction is ".. y_direction)
	
    self.x = self.x + (self.xSpeed * dt * self.x_direction) 	-- update zombie's movement
    self.y = self.y + (self.ySpeed * dt * self.y_direction)
 end
 
 function Zombie:lookAround()
	print(zombie_list[zi].x)
	local closest_human = 9999									-- closest_human holds the index of the human
	for i = 1, number_of_humans do								-- that is within this zombie's rand
		print( human_list[i].x.. " and ".. human_list[i].y )	-- If there are none within range, closest_human will stay 9999
		--if ( (human_list[i].x > (self.x - 50)) and (human_list[i].x > self.x + 50) ) and 
		--   ( (human_list[i].y > self.y - 50) and (human_list[i].y > self.y + 50) ) then
		--	print("zombie ".. zi)
		--end
		
		--if human_list[i].x > (self.x - 50) then
		--	print("zombie ".. zi)
		--end
	end
	
	
	--if closest_human != 9999 then
		
	--end
 end
