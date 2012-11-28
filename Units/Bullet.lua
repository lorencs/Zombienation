Bullet = {}

-- Constructor
function Bullet:new(_x,_y,_angle, ranger)

    local object = {					
	id = 0,								
    x = _x,									-- x and y coordinates 
    y = _y,
	prevx = _x,
	prevy = _y,
	angle = _angle,
    state = "",
	speed = 160,
	delete = false,
	lifetime = 0,
	parent = ranger
	}

	setmetatable(object, { __index = Bullet})		
	
    return object
end

function Bullet:draw()
	love.graphics.setColor(0,0,0)
	love.graphics.line(self.prevx, self.prevy, self.x, self.y)	
end

-- update function
function Bullet:update(dt, paused)
	if not paused then
		if self.lifetime > 5 then 
			self.delete = true
			return
		end
		
		self.prevx = self.x
		self.prevy = self.y
		self.x = self.x + math.cos(self.angle * (math.pi/180))*self.speed*dt
		self.y = self.y + math.sin(self.angle * (math.pi/180))*self.speed*dt
		-- check if any zombies are hit 
		for i = 1, number_of_zombies do
			
			if (self:distanceBetweenPoints(self.x, self.y, zombie_list[i].cx, zombie_list[i].cy) <= zombie_list[i].radius) then
				zombie_list[i]:die()
				self.parent:stopChasing()
				self.delete = true
				break
			end
		end 
		self.lifetime = self.lifetime + dt
	end
end

function Bullet:distanceBetweenPoints(x1, y1, x2, y2)
	local x_v1, y_v1 = 0
	
	x_v1 = x2 - x1
	y_v1 = y2 - y1
	return math.sqrt( x_v1 * x_v1 + y_v1 * y_v1 )
end
