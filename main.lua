require "map/map"
require "gui/Menu"
require "gui/Button"

function love.load()	
	map = map:new() 	-- load map functions
	map:initMap(20,20)		-- init map object
	map:loadMap("map/mapFile.txt")			-- load map from file
	
	-- graphics setup
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	menuWidth = 150
	viewWidth = width - menuWidth
	
	-- init menu
	menu = Menu:new(viewWidth, menuWidth, height)
	menu:setButtons()
end

function love.update(dt)
end

function love.draw()	
	map:drawMap() 			-- draw the map
	
	-- draw menu
	menu:draw()
end