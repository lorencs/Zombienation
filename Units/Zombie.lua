Zombie = {}
Zombie_mt = { __index = Zombie }

--[[ 
		BUG TO BE FIXED: zombies eating humans at the same time.. gives error at line 169
				ADD THE STATE OF EACH ZOMBIE ON SCREEEN AND SEE WHATS GOING ON ! AFTER EATING A HUMAN, THE ZOMBIE SHOULD GO BACK
				TO HUNTING ! SOMETIMES IT IGNORES HUMANS AFTER IT EATS ONE
				
		BUG FIX : HAVE TO ADD A CHECK IF THE HUMAN IS STILL ALIVE (if 2 zombies chase her.. check if human is still alive before attempting to
		remove human from human_list)
]]

see_human_dist = 50				-- at what distance will the zombie see the human ?

-- Constructor
function Zombie:new(x_new, y_new)

    local new_object = {							-- define our parameters here
    tag = 0,
	dirVector = 0,
	x = x_new,
    y = y_new,
	angle = 30,
	targetAngle = 0,
	dirVec = 0,										-- 0 for negative, 1 for positive
	radius = 4,
    width = 0,
    height = 0,
	speed = 0,
    state = "",
    normalSpeed = 0,
    runSpeed = 0,
	directionTimer = 0,
	time_kill = 0,
	initial_direction = 1,
	x_direction = math.random(-1,1),
	y_direction = math.random(-1,1),
	fol_human = 0,									-- index of the human in human_list that this zombie will follow. if it's 0, then this zombie
    animation = 0,
	spriteImage = 0,
	selected = false
	}												-- is not following a human (yet !)

	setmetatable(new_object, Zombie_mt )			-- add the new_object to metatable of Zombie
	setmetatable(Zombie, { __index = Unit })        -- Zombie is a subclass of class Unit, so set inheritance..
	
	--self:setupUnit()					
	
    return new_object								--
end

function Zombie:setupUnit()							-- init vars for Zombie unit
	if not self.x then self.x = math.random(650) end
	if not self.y then self.y = math.random(love.graphics.getHeight() - self.height) end
	
	self.speed = 20
	self.dirVector = self:getDirection(self.angle, self.speed)
	self.x_direction = 0
	self.y_direction = 0
	--hey = 345.1235
	--print(hey)
	self.width = 50
	self.height = 50
	self.state = "Looking around"
	self.xSpeed = 25
	self.ySpeed = 25
	self.normalSpeed = 5
	self.runSpeed = 7
	self.tag = zombie_tag
	zombie_tag = zombie_tag + 1
	
	--self.spriteImage = love.graphics.newImage("Units/images/pika.png")
	--delay = 120
	--self.animation = SpriteAnimation:new("Units/images/robosprites.png", 32, 32, 4, 4)
    --self.animation:load(delay)
end

function Zombie:draw(i)
	--self.animation:draw(self.x,self.y)
	--love.graphics.draw(self.spriteImage, self.x, self.y)
	love.graphics.setColor(211,211,211,150)
	love.graphics.circle( "fill", self.x + self.radius, self.y + self.radius, 35, 15 )
	
	angleDir = self:getDirection(self.angle, self.speed)
	print("x:".. angleDir.x.. ", y:".. angleDir.y)
	love.graphics.setColor(216,216,216)
	--love.graphics.triangle("fill", self.x + self.radius, self.y + self.radius, 
	--						self.x + math.cos(self.angle * (math.pi/180) )*90 + self.radius, self.y + math.sin(self.angle * (math.pi/180) )*36 + self.radius - 15,
	--						self.x + math.cos(self.angle * (math.pi/180) )*90 + self.radius,self.y + math.sin(self.angle * (math.pi/180) )*36 + self.radius + 15)
	
	love.graphics.triangle("fill", 
		self.x + self.radius, self.y + self.radius,
		self.x + math.cos( (self.angle - 50) * (math.pi/180) )*90 + self.radius, self.y + math.sin( (self.angle - 50) * (math.pi/180) )*90 + self.radius,
		self.x + math.cos( (self.angle + 50 ) * (math.pi/180) )*90 + self.radius,self.y + math.sin( (self.angle + 50) * (math.pi/180) )*90 + self.radius)
	
	if self.selected then
		love.graphics.setColor(0,255,0, 150)
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 9, 15 )
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 10, 15 )
	end
	
	playerColor = {255,0,0}
	love.graphics.setColor(playerColor)
	--love.graphics.rectangle("fill", self.x, self.y, 10, 10)
	love.graphics.circle("fill", self.x + self.radius, self.y + self.radius, 8, 15)
	love.graphics.line(self.x + self.radius,self.y + self.radius, self.x + math.cos(self.angle * (math.pi/180) )*30 + self.radius , self.y + math.sin(self.angle * (math.pi/180))* 30 + self.radius)
	love.graphics.setColor(0,255,0)
	love.graphics.line(self.x + self.radius,self.y + self.radius, self.x + math.cos(self.targetAngle * (math.pi/180) )*30 + self.radius , self.y + math.sin(self.targetAngle * (math.pi/180))* 30 + self.radius)
	-- for debugging:	FIELD OF VIEW OF ZOMBIE:
	
	--love.graphics.rectangle("line", self.x - see_human_dist, self.y, 10, 10)
	--love.graphics.rectangle("line", self.x, self.y + see_human_dist, 10, 10)
	--love.graphics.rectangle("line", self.x + see_human_dist, self.y, 10, 10)
	--love.graphics.rectangle("line", self.x, self.y - see_human_dist, 10, 10)
	-- end debugging
	
	love.graphics.print(self.tag.. " ".. self.state, self.x, self.y + 10)
end

function Zombie:unitAction()
    --print( " ZOMBIE ! The unit can do this action .." )
	--print("x is "..x_rand.. " and y is ".. y_rand)
end

-- Update function
function Zombie:update(dt, zi)

	--self.animation:update(dt)
	
	--if self.fol_human ~= 0 then									-- if zombie is following a human
		--self:follow_human(dt)									
		--return
	--else														-- else look around 
		self:lookAround(zi)
	--end
	
	
	-- after 5 seconds, the zombie should change his direction (x and y)
	if self.directionTimer > 5 then 							
		self.targetAngle = math.random(360)
		local newAngle = 180 + self.angle
		
		
		if newAngle < 360 then
			if (self.targetAngle < newAngle) and (self.targetAngle > self.angle) then
				self.dirVec = 0
			else
				self.dirVec = 1
			end
		else
			newAngle = newAngle - 360
			if (self.targetAngle > newAngle) and (self.targetAngle < self.angle) then
				self.dirVec = 1
			else
				self.dirVec = 0
			end
		end
		
		self.directionTimer = 0						-- reset directionTimer
		--print("dir:".. self.dirVec)
	end
		
	-- if it did not reach the targetAngle
	if ((self.targetAngle - 1) < self.angle) and ((self.targetAngle + 1) > self.angle) then
		--print("target reached ")
	else
		-- every update, the unit is trying to get towards the target angle by changing its angle slowly.
		if self.dirVec == 0 then			-- positive direction
			self.angle = self.angle + 0.2
		elseif self.dirVec == 1 then		-- negative direction
			self.angle = self.angle - 0.2
		end
		
		-- reset angles if they go over 360 or if they go under 0
		if self.angle > 360 then
			self.angle = self.angle - 360
		end
		
		if self.angle < 0 then
			self.angle = 360 + self.angle
		end
	end
		
	--end
	self.dirVector = self:getDirection(self.angle, self.speed)
	self.x = self.x + (dt * self.dirVector.x)
	self.y = self.y + (dt * self.dirVector.y)
	-- update direction time ( after 5 seconds, the unit will randomly change direction )
	self.directionTimer = self.directionTimer + dt			-- increasing directionTimer
	
	-- checking map boundaries
	--[[local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	if (self.x < 2) or (self.x > (map_w - 2)) or (self.y < 2) or (self.y > (map_h -2)) then
		x_direction = 0
		y_direction = 0
		self.directionTimer = self.directionTimer + 5
	end]]
	
	-- update zombie's movement
    --self.x = self.x + (self.xSpeed * dt * self.x_direction)
    --self.y = self.y + (self.ySpeed * dt * self.y_direction)
	--self.x = self.x + (dt * self.dirVector.x)
	--self.y = self.y + (dt * self.dirVector.y)
	--self.animation:update(dt)
 end
 
 -- look around; if there is a human at a dist of 'see_human_dist', then follow human
 function Zombie:lookAround(zi)
	
	-- fol_human is the index of the human object to follow and eat
	for i = 1, number_of_humans do								-- that is within this zombie's rand
		if ( (human_list[i].x > (self.x - see_human_dist)) and (human_list[i].x < self.x + see_human_dist) ) and 		-- IF human is within field of view
		   ( (human_list[i].y > self.y - see_human_dist) and (human_list[i].y < self.y + see_human_dist) ) then
		   
			--self.fol_human = i
			self.fol_human = human_list[i].tag
			self.state = "Chasing ".. self.fol_human
		end
		
		-- if zombie saw a human close enough and it is following it, break out of loop
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
	   
	   -- set human's attacked state to 1
		human_list[h_index].attacked = 1
		
		if (self.time_kill > 2) then								-- unit with index 'fol_human' should be dead by now !
			
			--local dead_x_coord = human_list[h_index].x				-- save coords of dead unit
			--local dead_y_coord = human_list[h_index].y
			
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
	
	-- code for following the human unit
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
 
 -- alerting all zombies that human with tag 'human_tag' is dead
 function Zombie:tellZombies(human_tag)
	-- if zombie i is following human with index fol_human, it should stop as that human is dead
	for i = 1, number_of_zombies do
		if zombie_list[i].fol_human == human_tag then		
			zombie_list[i].fol_human = 0
			zombie_list[i].time_kill = 0
			zombie_list[i].state = "Looking around"
		end
	end
end
 