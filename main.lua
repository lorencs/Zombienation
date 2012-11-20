require "map/Map"
require "map/Tile"
require "map/MapGen"
require "gui/Menu"
require "gui/Button"
require "camera"

function love.load()	
	--map = Map:new() 	-- load map functions
	--map:initMap(20,20)		-- init map object
	--map:loadMap("map/mapFile.txt")			-- load map from file
	
	-- generate a map
	generator = MapGen:new()
	generator:newMap(100,100)
	
	-- get the map
	map = generator:getMap()
	
	-- graphics setup
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	menuWidth = 150
	viewWidth = width - menuWidth
	
	-- init menu
	menu = Menu:new(viewWidth, menuWidth, height)
	menu:setButtons()
	
	-- viewpoint
	vspeed = 40						  	
	vpxmin = viewWidth / 2
	vpxmax = (map.width * map.tileSize) - vpxmin
	vpx = vpxmin
	vpymin = height / 2
	vpymax = (map.height * map.tileSize) - vpymin
	vpy = vpymin
	
	-- restrict camera
	camera:setBounds(0, 0, map.width * map.tileSize - viewWidth, 
		map.height * map.tileSize - height)
end

function love.update(dt)
	-- viewpoint movement - arrow keys
	if love.keyboard.isDown("right") then
		vpx = math.clamp(vpx + vspeed, vpxmin, vpxmax)
	end
	if love.keyboard.isDown("left") then
		vpx = math.clamp(vpx - vspeed, vpxmin, vpxmax)
	end
	if love.keyboard.isDown("up") then
		vpy = math.clamp(vpy - vspeed, vpymin, vpymax)
	end
	if love.keyboard.isDown("down") then
		vpy = math.clamp(vpy + vspeed, vpymin, vpymax)
	end
	
	-- center camera
	camera:setPosition(math.floor(vpx - (viewWidth / 2)), 
		math.floor(vpy - height / 2))
end

function love.draw()	
	camera:set()
	
	-- draw the map
	map:drawMap() 		
		
	camera:unset()
	
	-- draw menu
	menu:draw()
end

function love.keyreleased(key)
	if key == "escape" then -- kill app
		love.event.quit()
	end	
end

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end	