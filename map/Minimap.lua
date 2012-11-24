Minimap = {}

-- constructor
function Minimap:new(_map, _view, _x, _y, ww, wh)
	local object = {
		map = _map,
		view = _view,
		x = _x,
		y = _y,
		width = 100,
		height = 100,
		winWidth = ww,
		winHeight = wh,
		camX = 0,
		camY = 0,
		canvas = 0
	}
			
	setmetatable(object, { __index = Minimap })
	return object
end

function Minimap:init()
	self.canvas = love.graphics.newCanvas(self.map.width, self.map.height)
	for i = 0, self.map.width-1 do
		for j = 0, self.map.height-1 do
			love.graphics.setCanvas(self.canvas)
				love.graphics.draw(self.map.tiles[i][j].mm, i, j)
			love.graphics.setCanvas()
		end
	end
	self.winWidth = self.winWidth/self.map.tileSize
	self.winHeight = self.winHeight/self.map.tileSize
end

function Minimap:updateCanvas(i,j)
	love.graphics.setCanvas(self.canvas)
		love.graphics.draw(self.map.tiles[i][j].mm, i, j)
	love.graphics.setCanvas()
end

-- update the viewwindow according to the x,y coords of the camera
function Minimap:update(x,y)
	self.camX = math.floor(x/self.map.tileSize)
	self.camY = math.floor(y/self.map.tileSize)
	
	local mouseX = love.mouse.getX() 
	local mouseY = love.mouse.getY()
	
	-- move camera to where the mouse clicked on minimap
	if (mouseX > self.x) and (mouseX < self.x + self.width) and (mouseY > self.y) and (mouseY < self.y + self.height) and love.mouse.isDown("l") then
		local viewX = mouseX - self.x
		local viewY = mouseY - self.y
		self.view.x = viewX*self.map.tileSize
		self.view.y = viewY*self.map.tileSize
	end
end

-- draw the minimap at x,y coord on the screen
function Minimap:draw()
	love.graphics.draw(self.canvas, self.x, self.y)
	love.graphics.setColor(255,255,0)
	love.graphics.rectangle("line", self.x+self.camX+0.5, self.y+self.camY+0.5, self.winWidth, self.winHeight)
end