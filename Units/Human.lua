Human = {}
Human_mt = { __index = Human }

-- Constructor
function Human:new()

    local new_object = {							-- define our parameters here
	tag = 0,										-- tag of unit
    x = 0,											-- x and y coordinates ( by default, left top )
    y = 0,
	cx = 0,											-- centered x and y coordinates of the unit
	cy = 0,
	radius = 4,
	angle = 30,
	targetAngle = 0,
    width = 0,
    height = 0,
    state = "",
	speed = 0,
    runSpeed = 0,
	directionTimer = 0,
	initial_direction = 1,
	x_direction = math.random(-1,1),
	y_direction = math.random(-1,1),
	attacked = 0,								-- if the unit is currently attacked, this var = 1
    selected = false,
	color = 0
	}

	setmetatable(new_object, Human_mt )				-- add the new_object to metatable of Human
	setmetatable(Human, { __index = Unit })        -- Human is a subclass of class Unit, so set inheritance..				
	
    return new_object
end

function Human:setupUnit()							-- init vars for Human unit
	self.x = math.random(300, 650) 						-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	self.y = math.random(love.graphics.getHeight() - self.height)
	self.cx = self.x + self.radius
	self.cy = self.y - self.radius
	self.width = 50
	self.height = 50
	self.state = "Going to the store ??"
	self.speed = 20
	self.runSpeed = 7
	self.tag = human_tag
	self.directionTimer = 0
	human_tag = human_tag + 1
	--print("Human is set !")
	
end

function Human:draw(i)
	
	-- if selected, draw circle around unit
	if self.selected then
		love.graphics.setColor(0,255,0, 150)
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 9, 15 )
		love.graphics.circle( "line", self.x + self.radius, self.y + self.radius, 10, 15 )
	end
	
	
	
	playerColor = {0,0,255}
	love.graphics.setColor(playerColor)
	if self.color == 1 then love.graphics.setColor(255,0,0) end
	love.graphics.circle("fill", self.x + self.radius, self.y + self.radius, 8, 15)
	
	-- print tag to screen.. for debug !
	love.graphics.print(self.tag, self.x, self.y + 10)
end

-- Update function
function Human:update(dt, zi)

	-- if the human is attacked, then he can't move (or could make him move very slow?)
	if self.attacked == 1 then
		return							
	end
	
	-- after 5 seconds, the zombie should change his direction (x and y)
	if self.directionTimer > 5 then 
	
		-- randomize a degree, 0 to 360
		self.targetAngle = math.random(360)
		
		-- get the angle direction ( positive or negative on axis )
		self.dirVec = self:calcShortestDirection(self.angle, self.targetAngle)
		
		-- reset directionTimer
		self.directionTimer = 0						
	end
		
		
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
	-- update direction time ( after 5 seconds, the unit will randomly change direction )
	self.directionTimer = self.directionTimer + dt			-- increasing directionTimer	

 end
