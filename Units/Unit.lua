Unit = {}
Unit_mt = { __index = Unit }

--[[ 
d
	unit info .. 
	no enumerations in lua so.. 
	unitTypes:
		zombie = 0
		civilian = 1
		armedCivilian = 2
		etc ?
]]--

-- Constructor
function Unit:new()
    -- define our parameters here
    local new_object = {
    x = 0,
    y = 0,
	--radius = 5,
    width = 0,
    height = 0,
    xSpeed = 0,
    ySpeed = 0,
    state = "",
    normalSpeed = 0,
    runSpeed = 0,
	--selected = true
    }
    setmetatable(new_object, Unit_mt )
    return new_object
end

function Unit:getDirection(angle, unitSpeed)				-- returns a point (x and y) given an angle
    
	dvector = Point:new()
	local angle_rad = self.angle * (math.pi/180)
	dvector.x = math.cos(angle_rad) * unitSpeed
	dvector.y = math.sin(angle_rad) * unitSpeed
	--print( "x and y are ".. " "..math.cos(angle).. ", ".. dvector.y )
	return dvector
end

function Unit:getDirectionOnly(angle)				-- returns a point (x and y) given an angle
    
	dvector = Point:new()
	local angle_rad = self.angle * (math.pi/180)
	dvector.x = math.cos(angle_rad)
	dvector.y = math.sin(angle_rad)
	--print( "x and y are ".. " "..math.cos(angle).. ", ".. dvector.y )
	return dvector
end

function Unit:unitAction2()
    print( "Another action it can do .." )
end

-- Update function
function Unit:update(dt, gravity)
    -- update the unit's position
    -- self.x = self.x + (self.xSpeed * dt)
    -- self.y = self.y + (self.ySpeed * dt)
 
	
end
