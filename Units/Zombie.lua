Zombie = {}
Zombie_mt = { __index = Zombie }

--[[ 
		BUG TO BE FIXED: zombies eating humans at the same time.. gives error at line 169
				ADD THE STATE OF EACH ZOMBIE ON SCREEEN AND SEE WHATS GOING ON ! AFTER EATING A HUMAN, THE ZOMBIE SHOULD GO BACK
				TO HUNTING ! SOMETIMES IT IGNORES HUMANS AFTER IT EATS ONE
				
		BUG FIX : HAVE TO ADD A CHECK IF THE HUMAN IS STILL ALIVE (if 2 zombies chase her.. check if human is still alive before attempting to
		remove human from human_list)
]]
see_human_dist = 20				-- at what distance will the zombie see the human ?
-- Constructor
function Zombie:new(x_new, y_new)

    local new_object = {							-- define our parameters here
    tag = 0,
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
    animation = 0,
	spriteImage = 0
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
	self.state = "Looking around"
	self.xSpeed = 25
	self.ySpeed = 25
	self.normalSpeed = 5
	self.runSpeed = 7
	self.tag = zombie_tag
	zombie_tag = zombie_tag + 1
	
	--self.spriteImage = love.graphics.newImage("Units/citizenzombie1.png")
	--print("NEW ZOMBIE dead x:".. self.x.. ", y:"..self.y)
	-- zombie animation
	--delay = 120
	--self.animation = SpriteAnimation:new("Units/s2.png", 32, 32, 3, 1)
	--self.animation:start(1)
	--self.animation:switch(1,1,100)
	--self.animation:load(delay)
	
	--print("Zombie is set !")

	
end

function Zombie:draw(i)
	--print("Zombie getting drawn !".. self.x..", ".. self.y)
	
	playerColor = {255,0,0}
	love.graphics.setColor(playerColor)
	love.graphics.rectangle("fill", self.x, self.y, 10, 10)
	--love.graphics.draw(self.spriteImage, self.x, self.y)
	
	--self.animation:draw(self.x,self.y)
	-- for debugging:
	love.graphics.rectangle("line", self.x - see_human_dist, self.y, 10, 10)
	love.graphics.rectangle("line", self.x, self.y + see_human_dist, 10, 10)
	love.graphics.rectangle("line", self.x + see_human_dist, self.y, 10, 10)
	love.graphics.rectangle("line", self.x, self.y - see_human_dist, 10, 10)
	-- end debugging
	
	love.graphics.print(self.tag.. " ".. self.state, self.x, self.y + 10)
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
		self.x_direction = math.random(-1,1)		-- -1 to 1..
		self.y_direction = math.random(-1,1)				

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
	
	--self.animation:update(dt)
 end
 
 -- look around; if there is a human at a dist of 'see_human_dist', then follow human
 function Zombie:lookAround(zi)
	
	-- fol_human is the index of the human object to follow and eat
	for i = 1, number_of_humans do								-- that is within this zombie's rand
		if ( (human_list[i].x > (self.x - see_human_dist)) and (human_list[i].x < self.x + see_human_dist) ) and 
		   ( (human_list[i].y > self.y - see_human_dist) and (human_list[i].y < self.y + see_human_dist) ) then
		   
			--self.fol_human = i
			self.fol_human = human_list[i].tag
			self.state = "Chasing ".. self.fol_human
		end
		
		if self.fol_human ~= 0 then break end

	end
	
 end

 function Zombie:follow_human(dt)
	
	
	-- find the index of the human followed in the 'human_list' array
	local h_index = 0
	for i = 1, number_of_humans do
		if human_list[i].tag == self.fol_human then
			h_index = i
		end
	end
	
	-- if zombie is 'same_location' distance away from unit.. it is attacking the unit !
	local same_location = 2
	
	if ( (human_list[h_index].x > (self.x - same_location)) and (human_list[h_index].x < self.x + same_location) ) and 
	   ( (human_list[h_index].y > self.y - same_location) and (human_list[h_index].y < self.y + same_location) ) then
	   
	   -- human wi
		human_list[h_index].attacked = 1
		
		if (self.time_kill > 2) then								-- unit with index 'fol_human' should be dead by now !
		
			local dead_x_coord = human_list[h_index].x				-- save coords of dead unit
			local dead_y_coord = human_list[h_index].y
			
			table.remove(human_list, h_index)						-- remove human from human_list array
			number_of_humans = number_of_humans - 1					-- decrease count of humans alive
			
			number_of_zombies = number_of_zombies + 1					-- increase count of zombies alive
			zombie_list[number_of_zombies] = Zombie:new(self.x, self.y)	-- create new zombie at the location of this zombie
			zombie_list[number_of_zombies]:setupUnit()					-- setup zombie
			
			-- tell all zombies that human with tag 'self.fol_human' is dead
			self:tellZombies(self.fol_human)		
			
			-- reset timer for time to kill a unit
			self.time_kill = 0										
			self.fol_human = 0				-- reset fol_human as the zombie is not following any units anymore
			self.state = "Looking around"
			return
		end
		
		self.time_kill = self.time_kill + dt
	end
	
	-- if human.x = self.x (or y) , then self.x (or y) will stay the same so no need to add cond for it
	if human_list[h_index].y > self.y then
		self.y = self.y + (self.ySpeed * dt * 1)
	elseif human_list[h_index].y < self.y then
		self.y = self.y + (self.ySpeed * dt * (-1))
	end
	
	if human_list[h_index].x > self.x then
		self.x = self.x + (self.xSpeed * dt * 1)
	elseif human_list[h_index].x < self.x then
		self.x = self.x + (self.xSpeed * dt * (-1))
	end															
	
	
 end
 
 function Zombie:tellZombies(human_index)
	for i = 1, number_of_zombies do
		if zombie_list[i].fol_human == human_index then		-- if zombie i is following human with index fol_human, it should stop as that human is dead
			zombie_list[i].fol_human = 0
			zombie_list[i].time_kill = 0
			self.state = "Looking around"
		end
	end
end
 