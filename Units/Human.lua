Human = {}
Human_mt = { __index = Human }

-- Constructor
function Human:new()

    local new_object = {					-- define our parameters here
	tag = 0,								-- tag of unit
    x = 0,									-- x and y coordinates ( by default, left top )
    y = 0,
	cx = 0,									-- centered x and y coordinates of the unit
	cy = 0,
	radius = 4,
	angle = math.random(360),				-- randomize initial angles
	targetAngle = math.random(360),
    width = 0,
    height = 0,
    state = "",
	speed = 0,
	normalSpeed = 20,
	panicSpeed = 26,
    runSpeed = 0,
	directionTimer = 0,
	initial_direction = 1,
	attacked = 0,								-- if the unit is currently attacked, this var = 1
    panicMode = false,							-- panic mode is on if this is true..
	panicTimer = 0,									-- a unit that has spotted a zombie will be in panic mode for 6-7 seconds ( after spotting last zombie )
	v1 = Point:new(0,0),							-- vertices for the field of view triangle
	v2 = Point:new(0,0),
	v3 = Point:new(0,0),
	selected = false,
	color = 0
	}

	setmetatable(new_object, Human_mt )				-- add the new_object to metatable of Human
	setmetatable(Human, { __index = Unit })        -- Human is a subclass of class Unit, so set inheritance..				
	
    return new_object
end

function Human:setupUnit()

	local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	
	self.x = math.random(10, map_w - self.radius * 2) 							-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	self.y = math.random(10, map_h - self.radius * 2)
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	
	self.width = 50
	self.height = 50
	self.state = "Chilling"
	self.speed = self.normalSpeed
	self.tag = human_tag
	self.directionTimer = 0
	human_tag = human_tag + 1
end

function Human:draw(i)
	
	------------------------------- UPDATE FIELD OF VIEW VERTICES
	self.v1 = Point:new(self.x + self.radius, self.y + self.radius)
	self.v2 = Point:new(self.x + math.cos( (self.angle - 70) * (math.pi/180) )*180 + self.radius, self.y + math.sin( (self.angle - 70) * (math.pi/180) )*180 + self.radius)
	self.v3 = Point:new(self.x + math.cos( (self.angle + 70 ) * (math.pi/180) )*180 + self.radius, self.y + math.sin( (self.angle + 70) * (math.pi/180) )*180 + self.radius)
	
	------------------------------- IF UNIT IS SELECTED.. DRAW:
	if self.selected then
		love.graphics.setColor(0,0,255,125)
		-- draw field of view
		love.graphics.triangle( "fill", 
			self.v1.x,self.v1.y,
			self.v2.x,self.v2.y,
			self.v3.x,self.v3.y
		)
		
		-- draw line for angle and targetAngle
		love.graphics.line(self.x + self.radius,self.y + self.radius, 
							self.x + math.cos(self.angle * (math.pi/180) )*30 + self.radius , 
							self.y + math.sin(self.angle * (math.pi/180))* 30 + self.radius)
		love.graphics.setColor(0,255,0)
		love.graphics.line(self.x + self.radius,self.y + self.radius, 
							self.x + math.cos(self.targetAngle * (math.pi/180) )*30 + self.radius , 
							self.y + math.sin(self.targetAngle * (math.pi/180))* 30 + self.radius)
			
		-- draw circle around selected unit
		love.graphics.setColor(0,255,0, 150)
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 5, 15 )
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 6, 15 )
		
		-- draw state of unit
		love.graphics.print(self.state, self.x, self.y + 15)
	end
	
	------------------------------- DRAW UNIT ( A CIRCLE FOR NOW )
	playerColor = {0,0,255}
	love.graphics.setColor(playerColor)
	if self.color == 1 then love.graphics.setColor(255,255,23, 150) end
	love.graphics.circle("fill", self.x + self.radius, self.y + self.radius, self.radius, 15)
	
	-- print tag to screen.. for debug !
	love.graphics.print(self.tag, self.x, self.y + 10)

end

function Human:runAwayFrom(zom_x, zom_y)
	local x_v, y_v = 0
	if (self.x < zom_x) and (self.y < zom_y) then
		x_v = zom_x - self.x
		y_v = zom_y - self.y
		self.targetAngle = math.deg( math.atan(y_v / x_v) ) + 180
	elseif (self.x > zom_x) and (self.y < zom_y) then
		x_v = self.x - zom_x
		y_v = zom_y - self.y
		self.targetAngle = math.deg( math.atan(y_v / x_v) )
		self.targetAngle = 180 - self.targetAngle + 180
	elseif (self.x > zom_x) and (self.y > zom_y) then
		x_v = self.x - zom_x
		y_v = self.y - zom_y
		self.targetAngle = math.deg( math.atan(y_v / x_v) )
		self.targetAngle = 180 + self.targetAngle + 180
	elseif (self.x < zom_x) and (self.y > zom_y) then
		x_v = zom_x - self.x
		y_v = self.y - zom_y
		self.targetAngle = math.deg( math.atan(y_v / x_v) )
		self.targetAngle = 360 - self.targetAngle + 180
	end
end

 -- look around for zombies; panic if one is around !
 function Human:lookAround()
	
	-- for each zombie
	for i = 1, number_of_zombies do
	
		if (self.v1.x ~= 0) then					-- initially, v1.x is 0 as it has not been set so this is an exception case.
			local zombie_point = Point:new(zombie_list[i].cx, zombie_list[i].cy)
			local val = self:pTriangle(zombie_point, self.v1, self.v2, self.v3)
			if val == true then										-- if zombie i is in the field of view of this human
				self.state = "Running from  ".. zombie_list[i].tag
				self.panicMode = true
				self.panicTimer = 6									-- panic for 6 seconds since last seeing a zombie !
				
				self:runAwayFrom(zombie_list[i].x, zombie_list[i].y)
				--[[
				-- run away from the zombie !
				self.targetAngle = zombie_list[i].angle + 180
				]]
				-- reset angles if they go over 360 or if they go under 0
				if self.targetAngle > 360 then
					self.targetAngle = self.targetAngle - 360
				end
				
				if self.targetAngle < 0 then
					self.targetAngle = 360 + self.targetAngle
				end
				
			end
		end
	end
 end
 
-- update function
function Human:update(dt, zi, paused)

	------------------------------- CHECK PAUSE AND ATTACKED
	-- if game is paused, do not update any values
	if paused == true then return end
	
	-- if the human is attacked, then he can't move (or could make him move very slow?)
	if self.attacked == 1 then
		return							
	end
	
	------------------------------- RANDOMIZING DIRECTION AFTER 5 SECONDS
	-- after 5 seconds, the zombie should change his direction (x and y)
	if self.directionTimer > 5 then 
	
		-- randomize a degree, 0 to 360
		self.targetAngle = math.random(360)
		
		-- get the angle direction ( positive or negative on axis )
		self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)
		
		-- reset directionTimer
		self.directionTimer = 0						
	end
	
	------------------------------- PANIC MODE
	-- look around for zombies
	self:lookAround()
	-- if panicZombieAngle is true.. increase speed and change targetAngle to run away from the zombie !
	if self.panicMode == true then
	
		-- change speed to panicSpeed
		self.speed = self.panicSpeed
		
		--print(self.tag.." is runnign with angle: ".. self.targetAngle.. ", z angle:".. self.panicZombieAngle)
		
		-- decrease the panicTimer
		self.panicTimer = self.panicTimer - dt
		
		-- while in panic mode, self.targetAngle should never change as the human is trying to run from the zombies
		self.directionTimer = 0
		
		-- get the angle direction ( positive or negative on axis )
		self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)
		
		-- stop panicking if panicTimer is < 0
		if self.panicTimer < 0 then
			self.speed = self.normalSpeed
			self.state = "chilling !"
			self.panicMode = false
		end
	end
	
	------------------------------- CHECK MAP BOUNDARIES
	local val = self:checkMapBoundaries(self.x,self.y, self.radius)
	if val ~= 999 then			-- if it is too close to a boundary..
		self.angle = val
		--print(self.tag..", new target:".. self.targetAngle)
	end
	
	------------------------------- UPDATE SELF.ANGLE
	if ((self.targetAngle - 1) < self.angle) and ((self.targetAngle + 1) > self.angle) then
		-- target has been reached, no need to change the direction vector; keep the same self.angle value !
	else
		-- every update, the unit is trying to get towards the target angle by changing its angle slowly.
		if self.dirVec == 0 then			-- positive direction	( opposite of conventional as y increases downwards )
			if self.panicMode == true then		-- if the human is panicking, he is able to turn much faster
				self.angle = self.angle + 1
			else
				self.angle = self.angle + 0.2
			end
		elseif self.dirVec == 1 then		-- negative direction
			if self.panicMode == true then		-- if the human is panicking, he is able to turn much faster
				self.angle = self.angle - 1
			else
				self.angle = self.angle - 0.2
			end
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
	self.directionTimer = self.directionTimer + dt

 end
