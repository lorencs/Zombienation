require "map/Map"
require "map/Tile"
require "map/MapGen"
require "gui/Menu"
require "gui/Button"
require "camera"
require "Units/Unit"
require "Units/Zombie"

--[[ 
	write little messages here so changes arent confusing ? if i do modify something and it still needs to be changed,
	i put a comment with a tag *change* right by the line
	
]]--

function love.load()	
	--map = Map:new() 	-- load map functions
	--map:initMap(20,20)		-- init map object
	--map:loadMap("map/mapFile.txt")			-- load map from file
	

	-- unit testing BELOW ===========

	player = Unit:new()
	--print(player:unitAction())
	--print(player:unitAction2())
	
	zombie = Zombie:new()
	zombie:setupUnit()
	--print(zombie:unitAction())
	--print(zombie:unitAction2())
	

	-- unit testing ABOVE ===========
	
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
	vspeed = 100						  	
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
	
	-- update unit positions
	zombie:update(dt)
	
	-- center camera
	camera:setPosition(math.floor(vpx - (viewWidth / 2)), 
		math.floor(vpy - height / 2))
end

function love.draw()	
	-- set camera
	camera:set()					
	
	-- draw the map
	map:drawMap() 		
	
	-- draw the units
	zombie:draw()
	
	-- unset camera
	camera:unset()					
	
	-- draw menu
	menu:draw()
	
	-- debug
	love.graphics.setColor(255,255,255)
	love.graphics.print("Camera Cood: ["..vpx..","..vpy.."]", 0, 0)
	love.graphics.print("Mouse Cood: ["..love.mouse.getX()..","..love.mouse.getY().."]", 0, 15)
	love.graphics.reset()
end

function love.keyreleased(key)
	if key == "escape" then -- kill app
		love.event.quit()
	end	
end

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end	