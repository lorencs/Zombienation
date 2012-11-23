Minimap = {}

-- constructor
function Minimap:new(maparg)
	local object = {
		map = maparg,
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
				love.graphics.draw(self.map.tiles[i][j].mm, i-1, j-1)
			love.graphics.setCanvas()
		end
	end
end

function Minimap:updateCanvas(i,j)
	love.graphics.setCanvas(self.canvas)
		love.graphics.draw(self.map.tiles[i][j].mm, i-1, j-1)
	love.graphics.setCanvas()
end

function Minimap:draw(x,y)
	love.graphics.draw(self.canvas, x,y)
end