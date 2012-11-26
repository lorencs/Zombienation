Zombie = {}
Zombie_mt = { __index = Zombie }

--[[ 
		nothing here. move on.
]]

-- see_human_dist = 50				-- at what distance will the zombie see the human ?

-- Constructor
function Zombie:new(x_new, y_new)

    local new_object = {							-- define our parameters here
    tag = 0,										-- tag of unit			
	dirVector = 0,
	x = x_new,										-- x and y coordinates ( by default, left top )
    y = y_new,
	cx = 0,											-- centered x and y coordinates of the unit
	cy = 0,
	angle = math.random(360),						-- randomize initial angles
	targetAngle = math.random(360),
	dirVec = 0,										-- 0 for negative, 1 for positive
	radius = 4,
    width = 0,
    height = 0,
	speed = 0,
    state = "",
    runSpeed = 0,
	directionTimer = 0,
	time_kill = 0,
	initial_direction = 1,
	x_direction = math.random(-1,1),
	y_direction = math.random(-1,1),
	fov_radius = 75,
	fovStartAngle = 0,
	fovEndAngle = 0,
	fol_human = 0,									-- index of the human in human_list that this zombie will follow. if it's 0, then this zombie
	selected = false,
	v1 = Point:new(0,0),							-- vertices for the field of view triangle
	v2 = Point:new(0,0),
	v3 = Point:new(0,0),
	controlled = false,
	onCurrentTile = 0,
	neighbourTiles = {}
	}												-- is not following a human (yet !)

	setmetatable(new_object, Zombie_mt )			-- add the new_object to metatable of Zombie
	setmetatable(Zombie, { __index = Unit })        -- Zombie is a subclass of class Unit, so set inheritance..
	
	--self:setupUnit()					
	
    return new_object								--
end

function Zombie:setupUnit()							-- init vars for Zombie unit

	local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	
	--print("map size W:"..map_w..", H:".. map_h)
	--print("spawning boundaries: x:".. (self.radius * 3) .. ", ".. (map_w - self.radius * 3) )
	--print("spawning boundaries: y:".. (self.radius * 3) .. ", ".. (map_h - self.radius * 3) )
	if not self.x then self.x = math.random(self.radius * 3, map_w - self.radius * 3) end
	if not self.y then self.y = math.random(self.radius * 3, map_h - self.radius * 3) end
	
	-- the unit must be randomized on a GROUND tile
	--[[self.onCurrentTile = self:xyToTileType(self.x, self.y)
	while self.onCurrentTile ~= "G" do
		self.x = math.random(self.radius * 3, map_w - self.radius * 3)
		self.y = math.random(self.radius * 3, map_h - self.radius * 3)
		self.onCurrentTile = self:xyToTileType(self.x, self.y)
	end]]
	
	-- get neighbour tile types
	--self:updateNeighbours(self)

	--local val = math.random(1,5)
	--print("val:"..val)
	
	-- print( math.tan(5))		-- prints (in degrees) 5/1 ( 5 degrees / 1 degree )
	
	--print(self:xyToTileType(250,350))				-- FIRST WATER
	
	self.cx = self.x + self.radius
	self.cy = self.y - self.radius
	
	self.speed = 30
	self.dirVector = self:getDirection(self.angle, self.speed)
	self.x_direction = 0
	self.y_direction = 0
	self.width = 50
	self.height = 50
	self.state = "Looking around"
	self.normalSpeed = 5
	self.runSpeed = 7
	self.tag = zombie_tag
	zombie_tag = zombie_tag + 1
	
	------------------------------- ANIMATION
	--self.spriteImage = love.graphics.newImage("Units/images/pika.png")
	--delay = 120
	--self.animation = SpriteAnimation:new("Units/images/robosprites.png", 32, 32, 4, 4)
    --self.animation:load(delay)
end

function Zombie:draw(i)

	love.graphics.setColor(211,211,211,150)
	
	------------------------------- UPDATE FIELD OF VIEW VERTICES
	-- for triangle:
	self.v1 = Point:new(self.x + self.radius, self.y + self.radius)
	self.v2 = Point:new(self.x + math.cos( (self.angle - 40) * (math.pi/180) )*90 + self.radius, self.y + math.sin( (self.angle - 40) * (math.pi/180) )*90 + self.radius)
	self.v3 = Point:new(self.x + math.cos( (self.angle + 40 ) * (math.pi/180) )*90 + self.radius, self.y + math.sin( (self.angle + 40) * (math.pi/180) )*90 + self.radius)
	-- for arc:
	self.fovStartAngle = self.angle - 45
	self.fovEndAngle = self.angle + 45
	
	------------------------------- IF UNIT IS SELECTED.. DRAW:
	if self.selected then	
	
		love.graphics.setColor(201,85,91,125)	
		
		-- draw the arc field of view
		love.graphics.arc( "fill", self.x + self.radius, self.y + self.radius, self.fov_radius, math.rad(self.angle + 45), math.rad(self.angle - 45) )
		-- love.graphics.arc( mode, x, y, radius, angle1, angle2, segments )
		
		-- draw the triangle fov
		--[[love.graphics.triangle( "fill",
			self.v1.x,self.v1.y,
			self.v2.x,self.v2.y,
			self.v3.x,self.v3.y
			)--]]
		
		-- draw line for angle and targetAngle
		love.graphics.line(self.x + self.radius,self.y + self.radius, 
							self.x + math.cos(self.angle * (math.pi/180) )*30 + self.radius , 
							self.y + math.sin(self.angle * (math.pi/180))* 30 + self.radius)
		love.graphics.setColor(0,255,0)
		love.graphics.line(self.x + self.radius,self.y + self.radius, 
							self.x + math.cos(self.targetAngle * (math.pi/180) )*30 + self.radius , 
							self.y + math.sin(self.targetAngle * (math.pi/180))* 30 + self.radius)
		
		-- draw green circle around him
		love.graphics.setColor(0,255,0, 150)
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 9, 15 )
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 10, 15 )
		
		--love.graphics.circle( "fill", self.x + self.radius, self.y + self.radius, 70, 25 )
	end
	
	playerColor = {255,0,0}
	love.graphics.setColor(playerColor)
	
	------------------------------- DRAW UNIT ( A CIRCLE FOR NOW )
	love.graphics.circle("fill", self.x + self.radius, self.y + self.radius, 8, 15)
	love.graphics.print(self.tag.. " ".. self.state, self.x, self.y + 10)
	
	------------------------------- DEBUG CODE -------------------------------------
	
	-- for debugging:	FIELD OF VIEW OF ZOMBIE:
	--love.graphics.rectangle("line", self.x - see_human_dist, self.y, 10, 10)
	--love.graphics.rectangle("line", self.x, self.y + see_human_dist, 10, 10)
	--love.graphics.rectangle("line", self.x + see_human_dist, self.y, 10, 10)
	--love.graphics.rectangle("line", self.x, self.y - see_human_dist, 10, 10)
	-- end debugging
	

end

-- Update function
function Zombie:update(dt, zi, paused)
	--self.animation:update(dt)
	
	------------------------------- CHECK PAUSE AND LOOK AROUND / FOLLOW HUMAN
	-- if game is paused, do not update any values
	if paused == true then return end
	
	if self.fol_human ~= 0 then			-- if zombie is following a human				
		self:follow_human(dt)			-- zombie is following a human
		return							-- no need to update anything else here so return
	else
		self:lookAround(zi)				-- else look around 
	end
	
	------------------------------- RANDOMIZING DIRECTION AFTER 5 SECONDS
	if self.directionTimer > 5 then
	
		-- randomize a degree, 0 to 360
		self.targetAngle = math.random(360)
		
	-- get the angle direction ( positive or negative on axis ) given the current angle and the targetAngle
		self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)

		-- reset directionTimer
		self.directionTimer = 0						
	end
	
	------------------------------- CHECK MAP BOUNDARIES
	local val = self:checkMapBoundaries(self.x,self.y, self.radius)
	if val ~= 999 then			-- if it is too close to a boundary..
		self.angle = val
	end
	
	------------------------------- UPDATE SELF.ANGLE
	if ((self.targetAngle - 1) < self.angle) and ((self.targetAngle + 1) > self.angle) then		-- targetAngle reached
	else																						-- else.. 
	
		-- every update, the unit is trying to get towards the target angle by changing its angle slowly.
		if self.dirVec == 0 then			-- positive direction	( opposite of conventional as y increases downwards )
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
	
	------------------------------- UPDATE MOVEMENT
	-- get direction vector
	self.dirVector = self:getDirection(self.angle, self.speed)
	
	-- update zombie's movement
	self.x = self.x + (dt * self.dirVector.x)
	self.y = self.y + (dt * self.dirVector.y)
	-- update the center x and y values of the unit
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	
	-- update direction time ( after 5 seconds, the unit will randomly change direction )
	self.directionTimer = self.directionTimer + dt			-- increasing directionTimer
	
	--self.animation:update(dt)
 end
 
 function Zombie:lookAround(zi)
 
	-- fol_human stores the tag of the human to be followed ( if any )
	for i = 1, number_of_humans do
	
		if (self.v1.x ~= 0) then									-- initially, v1.x is 0 as it has not been set so this is an exception case.
			
			local human_point = Point:new(human_list[i].cx, human_list[i].cy)
			--local val = self:pTriangle(human_point, self.v1, self.v2, self.v3)						-- detect humans in a triangle
			local val = self:pointInArc(self.x, self.y, human_point.x, human_point.y, 
										self.fov_radius, self.fovStartAngle, self.fovEndAngle)	-- detect humans in an arc (pie shape)
			if val == true then										-- if human i is in the field of view of the zombie
				self.fol_human = human_list[i].tag
				self.state = "Chasing ".. self.fol_human	
				human_list[i].color = 1
			end
		end
		
		-- zombie found a human to chase; break out of loop
		if self.fol_human ~= 0 then break end
	end
 end
 
 function Zombie:follow_human(dt)

	-- find the index (in the 'human_list' array) of the human followed 
	local h_index = 0
	for i = 1, number_of_humans do
		if human_list[i].tag == self.fol_human then
			h_index = i
		end
	end
	
	-- if zombie is 'same_location' distance away from unit.. it is attacking the unit !
	local same_location = 2

	------------------------------- CALCULATE DISTANCE BETWEEN ZOMBIE AND THE HUMAN IT IS FOLLOWING
	local dist = self:distanceBetweenPoints(self.cx,self.cy,human_list[h_index].cx, human_list[h_index].cy)
	
	-- if its very close, zombie eats human
	if dist < (self.radius * 2 + 7) then
	   
	   -- set human's attacked state to 1
		human_list[h_index].attacked = 1
		
		if (self.time_kill > 2) then									-- unit with index 'fol_human' should be dead by now !
			local deadx = human_list[h_index].x
			local deady = human_list[h_index].y
			table.remove(human_list, h_index)							-- remove human from human_list array
			number_of_humans = number_of_humans - 1						-- decrease count of humans alive
			
			number_of_zombies = number_of_zombies + 1					-- increase count of zombies alive
			zombie_list[number_of_zombies] = Zombie:new(deadx, deady)	-- create new zombie at the location of this zombie
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
		return								-- no need to follow the human unit anymore
	elseif	dist > 120 then					-- if zombie is too far, abandon the follow
		self.fol_human = 0					-- unset follow
		self.state = "Looking around"
		human_list[h_index].panicMode = false		-- the human is not in panicMode anymore as it is not being followed anymore
	end

	
	------------------------------- FOLLOWING THE HUMAN
	
	-- get angle from this zombie's position to the human's position
	self.targetAngle = self:angleToXY(self.x,self.y,human_list[h_index].x,human_list[h_index].y)
	
	-- check map boundaries
	local val = self:checkMapBoundaries(self.x,self.y, self.radius)
	if val ~= 999 then			-- if it is too close to a boundary..
		self.angle = val
	end
	
	-- get the angle direction ( positive or negative on axis ) given the current angle and the targetAngle
	self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)
	
	if ((self.targetAngle - 1) < self.angle) and ((self.targetAngle + 1) > self.angle) then
		-- target has been reached, no need to change the direction vector; keep the same self.angle value !
	else
		-- every update, the unit is trying to get towards the target angle by changing its angle slowly.
		if self.dirVec == 0 then			-- positive direction	( opposite of conventional as y increases downwards )
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
	
	-- get direction vector
	self.dirVector = self:getDirection(self.angle, self.speed)
	
	-- update zombie's movement
	self.x = self.x + (dt * self.dirVector.x)
	self.y = self.y + (dt * self.dirVector.y)												
	-- update the center x and y values of the unit
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	
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
 