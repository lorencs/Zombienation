View = {}

function View:new(w, map)
	local object = {
		speed = 1000,
		width = w,
		--x = love.graphics.getWidth() / 2,
		--y = love.graphics.getHeight() / 2,
		x = 0,
		y = 0,
		
		xmin = 0,
		xmax = (map.width * map.tileSize) - w,
		ymin = 0,
		ymax = (map.height * map.tileSize) - love.graphics.getHeight() 	
	}
	setmetatable(object, { __index = View })
	return object
end

function View:update(dt)
	-- viewpoint movement - arrow keys
	if love.keyboard.isDown("right") then
		self.x = math.clamp(self.x + dt*self.speed, 
			self.xmin, self.xmax)
	end
	if love.keyboard.isDown("left") then
		self.x = math.clamp(self.x - dt*self.speed, 
			self.xmin, self.xmax)
	end
	if love.keyboard.isDown("up") then
		self.y = math.clamp(self.y - dt*self.speed, 
			self.ymin, self.ymax)
	end
	if love.keyboard.isDown("down") then
		self.y = math.clamp(self.y + dt*self.speed, 
			self.ymin, self.ymax)
	end
end