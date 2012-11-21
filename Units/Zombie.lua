Zombie = {}
Zombie_mt = { __index = Zombie }

see_human_dist = 20				-- at what distance will the zombie see the human ?
-- Constructor
function Zombie:new(x_new, y_new)

    local new_object = {							-- define our parameters here
    x = x_new,
    y = y_new,
    width = 0,
    height = 0,
    xSpeed = 0,
    ySpeed = 0,
    state = "",
    normalSpeed = 0,
    runSpeed = 0,
	timeTracker = 0,
	time_kill = 0,
	initial_direction = 1,
	x_direction = math.random(2),
	y_direction = math.random(2),
	fol_human = 0,									-- index of the human in human_list that this zombie will follow. if it's 0, then this zombie
    animation = 0
	}												-- is not following a human (yet !)

	setmetatable(new_object, Zombie_mt )			-- add the new_object to metatable of Zombie
	setmetatable(Zombie, { __index = Unit })        -- Zombie is a subclass of class Unit, so set inheritance..
	
	--self.setupUnit()								-- why doesnt this work ?? for now, just calling setupUnit in main..							
	
    return new_object								--
end

function Zombie:setupUnit()							-- init vars for Zombie unit
	if not self.x then self.x = math.random(650) end
	if not self.y then self.y = math.random(love.graphics.getHeight() - self.height) end
	--self.x = math.random(650) 						-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	--self.y = math.random(love.graphics.getHeight() - self.height)
	self.width = 50
	self.height = 50
	self.state = "Lurching around"
	self.xSpeed = 25
	self.ySpeed = 25
	self.normalSpeed = 5
	self.runSpeed = 7
	
	--print("NEW ZOMBIE dead x:".. self.x.. ", y:"..self.y)
	-- zombie animation
	--delay = 120
	--self.animation = SpriteAnimation:new("Units/Untitled.png", 128, 128, 16, 3)
	--self.animation:start(1)
	--self.animation:switch(1,1,100)
	--self.animation:load(120)
	
	--print("Zombie is set !")

	
end

function Zombie:draw(i)
	--print("Zombie getting drawn !".. self.x..", ".. self.y)
	
	playerColor = {255,0,0}
	love.graphics.setColor(playerColor)
	love.graphics.rectangle("fill", self.x, self.y, 10, 10)
	
	-- for debugging:
	love.graphics.rectangle("line", self.x - see_human_dist, self.y, 10, 10)
	love.graphics.rectangle("line", self.x, self.y + see_human_dist, 10, 10)
	love.graphics.rectangle("line", self.x + see_human_dist, self.y, 10, 10)
	love.graphics.rectangle("line", self.x, self.y - see_human_dist, 10, 10)
	-- end debugging
	
	love.graphics.print(i, self.x, self.y + 10)
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

	--print("map width tiles:".. map.width.. ", height tiles:".. map.height)
	--print("map width:".. map.width*map.tileSize.. ", height:".. map.height*map.tileSize)
	
    -- update the unit's position		
	
	if self.fol_human ~= 0 then									-- if zombie is following a human
		self:follow_human(dt)									-- ..
		return
	else														-- else look around 
		self:lookAround(zi)
	end
	
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
 
 function Zombie:lookAround(zi)
	
	-- fol_human is the index of the human object to follow and eat
	for i = 1, number_of_humans do								-- that is within this zombie's rand
		--print( human_list[i].x.. " and ".. human_list[i].y )	-- If there are none within range, closest_human will stay 9999
		if ( (human_list[i].x > (self.x - see_human_dist)) and (human_list[i].x < self.x + see_human_dist) ) and 
		   ( (human_list[i].y > self.y - see_human_dist) and (human_list[i].y < self.y + see_human_dist) ) then
			self.fol_human = i
		end
		
		if self.fol_human ~= 0 then break end

		--if human_list[i].x > (self.x - see_human_dist) then
		--	print("zombie ".. zi)
		--end
	end
	
	if self.fol_human ~= 0 then
		--print("following human ".. self.fol_human)
	end
	
 end

 function Zombie:follow_human(dt)
	--print("im still following ".. self.fol_human)
	--print("zombie x ".. self.x.. ", y:".. self.y)
	--print("human x ".. human_list[self.fol_human].x.. ", y:".. human_list[self.fol_human].y)
	--print(self.x)
	local same_location = 2
	if ( (human_list[self.fol_human].x > (self.x - same_location)) and (human_list[self.fol_human].x < self.x + same_location) ) and 
	   ( (human_list[self.fol_human].y > self.y - same_location) and (human_list[self.fol_human].y < self.y + same_location) ) then
		--print("hello !")
		if (self.time_kill > 2) then								-- unit with index 'fol_human' should be dead by now !
		
			local dead_x_coord = human_list[self.fol_human].x
			local dead_y_coord = human_list[self.fol_human].y
			--print("dead x:".. dead_x_coord.. ", y:"..dead_y_coord)
			number_of_zombies = number_of_zombies + 1				-- increase count of zombies alive
			zombie_list[number_of_zombies] = Zombie:new(self.x, self.y)	-- create new zombie at the location of
			zombie_list[number_of_zombies]:setupUnit()														-- the human, and set him up !
			
			table.remove(human_list, self.fol_human)				-- remove human from human_list array
			number_of_humans = number_of_humans - 1					-- decrease count of humans alive
			
			self.time_kill = 0										-- reset timer for time to kill a unit
			self.fol_human = 0										-- reset fol_human as the zombie is not following any units anymore
			
			return
		end
		self.time_kill = self.time_kill + dt
	end
	
	-- if human.x = self.x (or y) , then self.x (or y) will stay the same so no need to add cond for it
	if human_list[self.fol_human].y > self.y then
		self.y = self.y + (self.ySpeed * dt * 1)
	elseif human_list[self.fol_human].y < self.y then
		self.y = self.y + (self.ySpeed * dt * (-1))
	end
	
	if human_list[self.fol_human].x > self.x then
		self.x = self.x + (self.xSpeed * dt * 1)
	elseif human_list[self.fol_human].x < self.x then
		self.x = self.x + (self.xSpeed * dt * (-1))
	end															
	
	
 end
 