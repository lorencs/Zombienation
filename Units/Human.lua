Human = {}
Human_mt = { __index = Human }

-- Constructor
function Human:new()

    local new_object = {							-- define our parameters here
	tag = 0,
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
	y_direction = math.random(2),
	attacked = 0								-- if the unit is currently attacked, this var = 1
    }

	setmetatable(new_object, Human_mt )			-- add the new_object to metatable of Human
	setmetatable(Human, { __index = Unit })        -- Human is a subclass of class Unit, so set inheritance..
	
	--self.setupUnit()								-- why doesnt this work ?? for now, just calling setupUnit in main..							
	
    return new_object								--
end

function Human:setupUnit()							-- init vars for Human unit
	self.x = math.random(300, 650) 						-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	self.y = math.random(love.graphics.getHeight() - self.height)
	self.width = 50
	self.height = 50
	self.state = "Going to the store ??"
	self.xSpeed = 10
	self.ySpeed = 10
	self.normalSpeed = 5
	self.runSpeed = 7
	self.tag = human_tag
	human_tag = human_tag + 1
	--print("Human is set !")
	
end

function Human:draw(i)
	--print("Human getting drawn !".. self.x..", ".. self.y)
	playerColor = {0,0,255}
	love.graphics.setColor(playerColor)
	love.graphics.rectangle("fill", self.x, self.y, 10, 10)
	love.graphics.print(self.tag, self.x, self.y + 10)
end

function Human:unitAction()
    --print( " Human ! The unit can do this action .." )

	--print("x is "..x_rand.. " and y is ".. y_rand)
end

--function Human:unitAction2()						-- can overwrite this .. 
  --  print( "aaa Another action it can do .." )
--end

-- Update function
function Human:update(dt, zi)

	if self.attacked == 1 then
		return										-- if the human is attacked, then he can't move (or could make him move very slow?)
	end
	
    -- update the unit's position		
	if self.x_direction == 2 then self.x_direction = -1 end		-- this is for the first time an update happens
	if self.y_direction == 2 then self.y_direction = -1 end
	
	if self.timeTracker > 5 then 								-- after 5 seconds, the Human should change x and y directions
		
		self.x_direction = math.random(-1,1)					-- -1 to 1.. 
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
	

 end
