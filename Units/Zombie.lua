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
    runSpeed = 0
    }

	setmetatable(new_object, Zombie_mt )			-- add the new_object to metatable of Zombie
	setmetatable(Zombie, { __index = Unit })        -- Zombie is a subclass of class Unit, so set inheritance..
	
	--self.setupUnit()								
	
    return new_object								--
end

function Zombie:setupUnit()							-- init vars for Zombie unit
	self.x = math.random(650) 						-- NOTE ! need to change this to (screenWidth - menuWidth) *change*
	self.y = math.random(love.graphics.getHeight() - self.height)
	self.width = 50
	self.height = 50
	self.state = "Lurching around"
	self.xSpeed = 2
	self.ySpeed = 2
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
    -- update the unit's position
	local x_direction = math.random(-1,1)
	while (x_direction == 0)
		do x_direction = math.random(-1,1)
	end
	
	--print("x direction is ".. x_direction)
	--local y_direction = math.random()
    self.x = self.x + (self.xSpeed * dt)
    self.y = self.y + (self.ySpeed * dt)
 
end
