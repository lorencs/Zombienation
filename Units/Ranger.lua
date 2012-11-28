Ranger = {}
Ranger_mt = { __index = Ranger }

-- Constructor
function Ranger:new(xnew,ynew)

    local new_object = {					-- define our parameters here
	tag = 0,								-- tag of unit
    x = xnew,									-- x and y coordinates ( by default, left top )
    y = ynew,
	cx = 0,									-- centered x and y coordinates of the unit
	cy = 0,
	radius = 4,
	angle = math.random(360),				-- randomize initial angles
	targetAngle = math.random(360),
    width = 0,
    height = 0,
    state = "",
	statestr = "",
	speed = 0,
	normalSpeed = 15,
	huntingSpeed = 17,
    runSpeed = 0,
	directionTimer = 0,
	initial_direction = 1,
	fov_radius = 150,
	fov_angle = 150,
	fovStartAngle = 0,
	fovEndAngle = 0,
	attacked = 0,								-- if the unit is currently attacked, this var = 1
    --huntingMode = false,							-- chase zombie 
	--shootingMode = false,							-- stop and shoot zombie
	panicTimer = 0,									-- a unit that has spotted a zombie will be in panic mode for 6-7 seconds ( after spotting last zombie )
	interval = 0,									-- interval of time before unit changes angle (randomized every time)
	v1 = Point:new(0,0),							-- vertices for the field of view triangle
	v2 = Point:new(0,0),
	v3 = Point:new(0,0),
	selected = false,
	color = 0,
	controlled = false,
	onCurrentTile = 0,
	neighbourTiles = {}
	}

	setmetatable(new_object, Ranger_mt )				-- add the new_object to metatable of Ranger
	setmetatable(Ranger, { __index = Unit })        -- Ranger is a subclass of class Unit, so set inheritance..				
	
    return new_object
end

function Ranger:setupUnit()

	local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	
	if not self.x then self.x = math.random(self.radius * 3, map_w - self.radius * 3) end
	if not self.y then self.y = math.random(self.radius * 3, map_h - self.radius * 3) end
	
	--------------------------               TILE CHECKS
	--print("Tile type:".. map.tiles[self.y][self.x].id)
	-- the unit must be randomized on a GROUND tile
	self.onCurrentTile = self:xyToTileType(self.x, self.y)
	
	while not (self.onCurrentTile == "R" or self.onCurrentTile == "G") do
		self.x = math.random(self.radius * 3, map_w - self.radius * 3)
		self.y = math.random(self.radius * 3, map_h - self.radius * 3)
		self.onCurrentTile = self:xyToTileType(self.x, self.y)
	end
	--print("W:"..map.tiles[-1][-1].id)
	-- get neighbour tile types
	self:updateNeighbours(self)
	--------------------------		  TILE CHECKS
	
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	
	self.fovStartAngle = self.angle - self.angle/2
	self.fovEndAngle = self.angle + self.angle/2
	
	self.state = "seeking"
	self.speed = self.normalSpeed
	self.tag = ranger_tag
	self.directionTimer = 0
	
	self.interval = math.random(3,7)
end

function Ranger:draw(i)
	
	------------------------------- UPDATE FIELD OF VIEW VERTICES
	-- for triangle:
	--self.v1 = Point:new(self.x + self.radius, self.y + self.radius)
	--self.v2 = Point:new(self.x + math.cos( (self.angle - 70) * (math.pi/180) )*180 + self.radius, self.y + math.sin( (self.angle - 70) * (math.pi/180) )*180 + self.radius)
	--self.v3 = Point:new(self.x + math.cos( (self.angle + 70 ) * (math.pi/180) )*180 + self.radius, self.y + math.sin( (self.angle + 70) * (math.pi/180) )*180 + self.radius)
	-- for arc:
	self.fovStartAngle = self.angle - self.angle/2
	self.fovEndAngle = self.angle + self.angle/2
	------------------------------- IF UNIT IS SELECTED.. DRAW:
	if self.selected then
		love.graphics.setColor(0,255,0,50)
		-- draw triangle field of view
		--[[love.graphics.triangle( "fill", 
			self.v1.x,self.v1.y,
			self.v2.x,self.v2.y,
			self.v3.x,self.v3.y
		)]]
		
		-- draw the arc field of view
		love.graphics.arc( "fill", self.x + self.radius, self.y + self.radius, self.fov_radius, math.rad(self.angle + self.fov_angle/2), math.rad(self.angle - self.fov_angle/2) )
		
		-- draw line for angle and targetAngle
		love.graphics.line(self.x + self.radius,self.y + self.radius, 
							self.x + math.cos(self.angle * (math.pi/180))* 30 + self.radius , 
							self.y + math.sin(self.angle * (math.pi/180))* 30 + self.radius)
		love.graphics.setColor(0,255,0)
		love.graphics.line(self.x + self.radius,self.y + self.radius, 
							self.x + math.cos(self.targetAngle * (math.pi/180))*30 + self.radius , 
							self.y + math.sin(self.targetAngle * (math.pi/180))* 30 + self.radius)
			
		-- draw circle around selected unit
		love.graphics.setColor(0,255,0, 150)
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 5, 15 )
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 6, 15 )
		
		
		--love.graphics.rectangle()
		love.graphics.rectangle( "fill", 0, 0, 25, 25 )
		
		
		-- draw state of unit
		love.graphics.print(self.statestr, self.x, self.y + 15)
	end
	
	------------------------------- DRAW UNIT ( A CIRCLE FOR NOW )
	playerColor = {0,255,0}
	love.graphics.setColor(playerColor)
	if self.color == 1 then love.graphics.setColor(255,255,23, 150) end
	love.graphics.circle("fill", self.x + self.radius, self.y + self.radius, self.radius, 15)
	
	-- print tag to screen.. for debug !
	love.graphics.print(self.tag, self.x, self.y + 10)

end

--ranja dont run like no pussy
function Ranger:hunt(zom_x, zom_y)
	local x_v, y_v = 0
	if (self.x < zom_x) and (self.y < zom_y) then
		x_v = zom_x - self.x
		y_v = zom_y - self.y
		self.targetAngle = math.deg( math.atan(y_v / x_v) ) --+ 180
	elseif (self.x > zom_x) and (self.y < zom_y) then
		x_v = self.x - zom_x
		y_v = zom_y - self.y
		self.targetAngle = math.deg( math.atan(y_v / x_v) )
		self.targetAngle = 180 - self.targetAngle + 180
	elseif (self.x > zom_x) and (self.y > zom_y) then
		x_v = self.x - zom_x
		y_v = self.y - zom_y
		self.targetAngle = math.deg( math.atan(y_v / x_v) )
		self.targetAngle = 180 + self.targetAngle --+ 180
	elseif (self.x < zom_x) and (self.y > zom_y) then
		x_v = zom_x - self.x
		y_v = self.y - zom_y
		self.targetAngle = math.deg( math.atan(y_v / x_v) )
		self.targetAngle = 360 - self.targetAngle --+ 180
	end
end

 -- look around for zombies; hunt dat bitch if one is around !
 function Ranger:lookAround()
	
	-- for each zombie
	for i = 1, number_of_zombies do
	
			local zombie_point = Point:new(zombie_list[i].cx, zombie_list[i].cy)
			--local val = self:pTriangle(zombie_point, self.v1, self.v2, self.v3)						-- detect zombies in a triangle
			local val = self:pointInArc(self.x, self.y, zombie_point.x, zombie_point.y, 
										self.fov_radius, self.fovStartAngle, self.fovEndAngle)	-- detect zomvies in an arc (pie shape)
			if val then										-- if zombie i is in the field of view of this Ranger
				self.statestr = "Hunting  ".. zombie_list[i].tag
				self.state = "hunting"
				self:hunt(zombie_list[i].x, zombie_list[i].y)

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
 
-- update function
function Ranger:update(dt, zi, paused)
	
	------------------------------- CHECK PAUSE AND ATTACKED; LOOK AROUND FOR ZOMBIES
	-- if game is paused, do not update any values
	if paused == true then return end
	
	-- if the Ranger is attacked, then he can't move (or could make him move very slow?)
	if self.attacked == 1 then return end
	
	--updating neighbours
	self:updateNeighbours(self)
	
	if self.state == "seeking" then
	------------------------------- RANDOMIZING DIRECTION AFTER 5 SECONDS.. unless it's controlled by penguins !
		-- after 'interval' seconds, the ranger should change his direction (x and y)
		if self.directionTimer > self.interval then 
		
			-- randomize a degree, 0 to 360
			self.targetAngle = math.random(360)
			
			-- get the angle direction ( positive or negative on axis )
			self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)
			
			-- reset directionTimer
			self.directionTimer = 0	

			-- randomize interval again
			self.interval = math.random(3,7)
		end
	end
	
	-- look around for zombies
	self:lookAround()
	
	------------------------------- HUNTING MODE
	-- if panicZombieAngle is true.. increase speed and change targetAngle to run away from the zombie !
	if self.state == "hunting" then
		
		-- change speed to huntingSpeed
		self.speed = self.huntingSpeed
			
		-- decrease the panicTimer
		-- self.panicTimer = self.panicTimer - dt
			
		-- while in panic mode, self.targetAngle should never change as the Ranger is trying to run from the zombies
		--self.directionTimer = 0
			
		-- get the angle direction ( positive or negative on axis ) given the current angle and the targetAngle
		self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)
	else
		self.speed = self.normalSpeed
		self.state = "seeking"
		
		
	end
	
	-- check which tiles to go on in order to avoid buildings, water, etc
	--self:checkTiles()
	
	------------------------------- UPDATE SELF.ANGLE
	if ((self.targetAngle - 1) < self.angle) and ((self.targetAngle + 1) > self.angle) then
		-- target has been reached, no need to change the direction vector; keep the same self.angle value !
				-- reset angles if they go over 360 or if they go under 0
		if self.angle > 360 then
			self.angle = self.angle - 360
		end
		
		if self.angle < 0 then
			self.angle = 360 + self.angle
		end
	else
		-- every update, the unit is trying to get towards the target angle by changing its angle slowly.
		if self.dirVec == 0 then				-- positive direction	( opposite of conventional as y increases downwards )
			if self.state == "hunting" or self.controlled then		-- if the Ranger is panicking, he is able to turn much faster
				self.angle = self.angle + 1
			else
				self.angle = self.angle + 0.3
			end
		elseif self.dirVec == 1 then			-- negative direction
			if self.state == "hunting" or self.controlled then		-- if the Ranger is panicking, he is able to turn much faster
				self.angle = self.angle - 1
			else
				self.angle = self.angle - 0.3
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
	
		--if self.x < 0 or self.x > map.tileSize*map.width or self.y < 0 or self.y > map.tileSize*map.height then
	--	--print("tag:"..self.tag..", prevdt:"..self.prevDt..",prevdy:"..self.prevdy..",prevdx:"..self.prevdx)
	--	print("out of boundaries:"..self.tag)
	--end
	
	------------------------------------------------------------------------------ UPDATE MOVEMENT
	-- get direction vector
	self.dirVector = self:getDirection(self.angle, self.speed)
	
	-- checking the tile that the unit is or will be on
	local next_x = self.x + (dt * self.dirVector.x)
	local next_y = self.y + (dt * self.dirVector.y)
	
	local nextTileType = self:xyToTileType(next_x,next_y)
	-- check next tile (not in panic mode)
	if  not (nextTileType == "G" or nextTileType == "R") then
		self.directionTimer = self.directionTimer + dt
		self.state = "STUCK !"
		self:avoidTile(self)
		return
	end
	
	------------------------------- CHECK MAP BOUNDARIES 						** IF IN PANIC MODE, MAYBE SHOULD CHECK WHERE ZOMBIE IS COMING FROM AND THEN SET THE TARGET ANGLE
	if next_x < 0 or next_x > map.tileSize*map.width or next_y < 0 or next_y > map.tileSize*map.height then
		self.state = "WTF"
		self.directionTimer = self.directionTimer + dt
		return
	end																															-- ** IN THE OTHER DIRECTION !
	local val = self:checkMapBoundaries(next_x,next_y, self.radius)											
	if val ~= 999 then			-- if it is too close to a boundary..
		self.angle = val
		self.targetAngle = val
		--return
	end
	------------------------------- END OF BOUNDARY CHECK
	
	-- update Ranger's movement
	self.x = self.x + (dt * self.dirVector.x)
	self.y = self.y + (dt * self.dirVector.y)
	
	-- update the center x and y values of the unit
	self.cx = self.x + self.radius
	self.cy = self.y + self.radius
	-- update direction time ( after 5 seconds, the unit will randomly change direction )
	self.directionTimer = self.directionTimer + dt

 end
