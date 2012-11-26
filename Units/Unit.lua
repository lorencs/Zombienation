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

function Unit:calcShortestDirection(angle, targetAngle)
		local dirVec = -1
		local newAngle = 180 + angle		-- current angle + 180 degrees
		-- if newAngle is < 360
		if newAngle < 360 then
			if (targetAngle < newAngle) and (targetAngle > angle) then
				dirVec = 0
			else
				dirVec = 1
			end
		else	-- if newAngle is > 360
			newAngle = newAngle - 360
			if (targetAngle > newAngle) and (targetAngle < angle) then
				dirVec = 1
			else
				dirVec = 0
			end
		end
		return dirVec
end

function Unit:getDirection(angle, unitSpeed)				-- returns a point (x and y) given an angle
    
	dvector = Point:new()
	local angle_rad = self.angle * (math.pi/180)
	dvector.x = math.cos(angle_rad) * unitSpeed
	dvector.y = math.sin(angle_rad) * unitSpeed
	
	return dvector
end

function Unit:getAngle(x,y)				-- returns a point (x and y) given an angle
	retAngle = math.tan( y/x )
	return retAngle * (180 / math.pi)
end

function Unit:checkMapBoundaries(mx, my, unitRadius)
	-- checking map boundaries
	local map_w = map.width*map.tileSize
	local map_h = map.height*map.tileSize
	
	if  (my < unitRadius * 2) then							-- too close to the top of the screen
		return math.random(5,175)
	elseif (mx < unitRadius * 2) then						-- too close to the left side of the screen
		return math.random(275,355)
	elseif (my > (map_h - unitRadius * 2)) then				-- too close to the bottom of the screen
		return math.random(185,355)
	elseif (mx > (map_w - unitRadius * 2)) then				-- too close to the right side of the screen
		return math.random(95,265)
	end
	
	return 999
end

 -- distance between 2 points
 function Unit:distanceBetweenPoints(x1,y1,x2,y2)
 
	local x_v1, y_v1 = 0
	
	if (x1 < x2) and (y1 < y2) then
		x_v1 = x2 - x1
		y_v1 = y2 - y1
		return math.sqrt( x_v1 * x_v1 + y_v1 * y_v1 )
	elseif (x1 > x2) and (y1 < y2) then
		x_v1 = x1 - x2
		y_v1 = y2 - y1
		return math.sqrt( x_v1 * x_v1 + y_v1 * y_v1 )
	elseif (x1 > x2) and (y1 > y2) then
		x_v1 = x1 - x2
		y_v1 = y1 - y2
		return math.sqrt( x_v1 * x_v1 + y_v1 * y_v1 )
	elseif (x1 < x2) and (y1 > y2) then
		x_v1 = x2 - x1
		y_v1 = y1 - y2
		return math.sqrt( x_v1 * x_v1 + y_v1 * y_v1 )
	end
	return 9999
 end
 
function Unit:pointInTriangle(p, az, b, c)			-- arguments: Point p, Point a, Point b, Point c

    as_x = p.x-az.x
    as_y = p.y-az.y
	
	if ( ( (b.x-az.x)*as_y-(b.y-az.y)*as_x ) > 0 ) then
		s_ab = 1
	else
		s_ab = 0
	end

    if((c.x-az.x)*as_y-(c.y-az.y)*as_x > 0 == s_ab) then return false end
	--print("x,y:"..az.x.. ","..az.y)
    if((c.x-b.x)*(p.y-b.y)-(c.y-b.y)*(p.x-b.x) > 0 ~= s_ab) then return false end
	
    return true
end

function Unit:pointInArc(x1, y1, x2, y2, fovRadius, startAngle, endAngle)
	if self:distanceBetweenPoints(x1,y1,x2,y2) < fovRadius then			-- if the point x2,y2 is < fovRadius, it is in the circle

		local angleToPoint = self:angleToXY(x1,y1,x2,y2)
		if  angleToPoint >= startAngle and angleToPoint <= endAngle then
			return true
		elseif endAngle > 360 then						-- EXCEPTIONS ! if endAngle is > 360 or startAngle < 0 .. then boundary check is diff
			endAngle = endAngle - 360
			if angleToPoint >= 0 and angleToPoint < endAngle then
				return true
			end
		elseif startAngle < 0 then
			startAngle = 360 + startAngle
			if angleToPoint >= startAngle and angleToPoint < 360 then
				return true
			end
		end
	end
	return false
end

-- gets the angle from x1,y1 through to point x2,y2
function Unit: angleToXY(x1,y1,x2,y2)
	local x_v, y_v = 0
	local angleRet = 0
	if (x1 < x2) and (y1 < y2) then
		x_v = x2 - x1
		y_v = y2 - y1
		angleRet = math.deg( math.atan(y_v / x_v) )
	elseif (x1 > x2) and (y1 < y2) then
		x_v = x1 - x2
		y_v = y2 - y1
		angleRet = math.deg( math.atan(y_v / x_v) )
		angleRet = 180 - angleRet
	elseif (x1 > x2) and (y1 > y2) then
		x_v = x1 - x2
		y_v = y1 - y2
		angleRet = math.deg( math.atan(y_v / x_v) )
		angleRet = 180 + angleRet
	elseif (x1 < x2) and (y1 > y2) then
		x_v = x2 - x1
		y_v = y1 - y2
		angleRet = math.deg( math.atan(y_v / x_v) )
		angleRet = 360 - angleRet
	end
	return angleRet
end

function Unit:sign(p1, p2, p3)
  return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y)
end

	-- checks if point 'pt' is in a triangle with vertices v1,v2,v3
function Unit:pTriangle(pt, v1, v2, v3)

  if (self:sign(pt, v1, v2) < 0) then
	b1 = 1
  else
	b1 = 0
  end
  
  if (self:sign(pt, v2, v3) < 0) then
	b2 = 1
  else
	b2 = 0
  end
  
  if (self:sign(pt, v3, v1) < 0) then
	b3 = 1
  else
	b3 = 0
  end

  return ((b1 == b2) and (b2 == b3))
end
