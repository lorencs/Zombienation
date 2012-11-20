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
<<<<<<< HEAD
    runSpeed = 0,
	timeTracker = 0,
	initial_direction = 1
=======
    runSpeed = 0
>>>>>>> commit
    }

	setmetatable(new_object, Zombie_mt )			-- add the new_object to metatable of Zombie
	setmetatable(Zombie, { __index = Unit })        -- Zombie is a subclass of class Unit, so set inheritance..
	
<<<<<<< HEAD
	--self.setupUnit()								-- why doesnt this work ?? for now, just calling setupUnit in main..							
=======
	--self.setupUnit()								
>>>>>>> commit
	
    return new_object								--
end

function Zombie:setupUnit()							-- init vars for Zombie unit
	self.x = math.random(650) 						-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	self.y = math.random(love.graphics.getHeight() - self.height)
	self.width = 50
	self.height = 50
	self.state = "Lurching around"
<<<<<<< HEAD
	self.xSpeed = 5
	self.ySpeed = 5
=======
	self.xSpeed = 2
	self.ySpeed = 2
>>>>>>> commit
	self.normalSpeed = 5
	self.runSpeed = 7
	--print("Zombie is set !")
end

function Zombie:draw()
	--print("Zombie getting drawn !".. self.x..", ".. self.y)
	playerColor = {24,33,128}
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
function Zombie:update(dt, gravity)
<<<<<<< HEAD

    -- update the unit's position		
	if not x_direction then x_direction = 1 end		-- this is for the first time an update happens
	if not y_direction then y_direction = 1 end		-- initial direction will be 1,1
	
	if self.timeTracker > 5 then 					-- after 5 seconds, the zombie should change x and y directions
		x_direction = math.random(2)				-- EXCEPT if he sees a target *change*, need to add stuff here
		if (x_direction == 1) then 
			x_direction = -1
		elseif (x_direction == 2) then
			x_direction = 1
		end
		y_direction = math.random(2)				-- can't randomize -1 OR 1, so this is a way around it
		if (y_direction == 1) then 
			y_direction = -1
		elseif (y_direction == 2) then
			y_direction = 1
		end
		self.timeTracker = 0
	end
	
	self.timeTracker = self.timeTracker + dt			-- increasing timeTracker
	
	-- CHECK THE BOUNDARIES HERE. map.width and map.height give the boundaries of the map..
	
	--print("x direction is ".. x_direction)
	--print("x direction is ".. y_direction)
    self.x = self.x + (self.xSpeed * dt * x_direction) 	-- update zombie's movement
    self.y = self.y + (self.ySpeed * dt * y_direction)
 
	
=======
    -- update the unit's position
	local x_direction = math.random(-1,1)
	while (x_direction == 0)
		do x_direction = math.random(-1,1)
	end
	
	--print("x direction is ".. x_direction)
	--local y_direction = math.random()
    self.x = self.x + (self.xSpeed * dt)
    self.y = self.y + (self.ySpeed * dt)
 
>>>>>>> commit
end
