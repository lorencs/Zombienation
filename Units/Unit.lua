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

function Unit:unitAction()
    print( "The unit can do this action .." )
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
