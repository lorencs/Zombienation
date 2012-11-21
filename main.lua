require "map/Map"
require "map/Tile"
require "map/MapGen"
require "gui/Menu"
require "gui/Button"
require "camera"
require "Units/Unit"
require "Units/Zombie"
require "Units/Human"

--[[ 
	write little messages here so changes arent confusing ? if i do modify something and it still needs to be changed,
	i put a comment with a tag *change* right by the line
	
	mikus: 
		- hid cursor, replaced with a zombie hand (just a random image i found for now)
		- added mouse isDown check to draw road tiles
]]--

-- game settings
number_of_zombies = 3			-- zombies are red
number_of_humans = 5			-- humans are blue

function love.load()	
	DEBUG = true
	--map = Map:new() 	-- load map functions
	--map:initMap(20,20)		-- init map object
	--map:loadMap("map/mapFile.txt")			-- load map from file
	
	randomizer = math.random(30,60)				-- seeding randomizer
	math.randomseed( os.time() + randomizer )
	
	-- unit testing BELOW ===========
	zombie_list = {}							-- array of zombie objects
	human_list = {}								-- array of human objects
	
	player = Unit:new()
	--print(player:unitAction())
	--print(player:unitAction2())
	
	
	for i = 1, number_of_zombies do
		zombie_list[i] = Zombie:new()
		zombie_list[i]:setupUnit()
	end
	
	for i = 1, number_of_humans do
		human_list[i] = Human:new()
		human_list[i]:setupUnit()
	end
	--zombie = Zombie:new()
	--zombie:setupUnit()
	
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
		
	-- cursor
	love.mouse.setVisible(false)
	cursor = love.graphics.newImage("gui/cursor.png")
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
	for i = 1, number_of_zombies do
		zombie_list[i]:update(dt, i)
	end
	for i = 1, number_of_humans do
		human_list[i]:update(dt,i)
	end
	
	-- map editing
	if DEBUG then
		if love.mouse.isDown("l") then
			xpos = love.mouse.getX() + vpx - vpxmin
			ypos = love.mouse.getY() + vpy - vpymin
			xpos = math.floor(xpos / map.tileSize)
			ypos = math.floor(ypos / map.tileSize)
			map.tiles[map:index(xpos,ypos)]:setId("R");
			map:updateTileInfo(xpos,ypos)
		end
	end
	
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
	for i = 1, number_of_zombies do
		zombie_list[i]:draw()
	end
	for i = 1, number_of_humans do
		human_list[i]:draw()
	end
	
	-- unset camera
	camera:unset()					
	
	-- draw menu
	menu:draw()
	
	-- debug
	love.graphics.setColor(255,255,255)
	love.graphics.print("Camera Cood: ["..vpx..","..vpy.."]", 0, 0)
	love.graphics.print("Mouse Cood: ["..love.mouse.getX()..","..love.mouse.getY().."]", 0, 15)
	
	-- cursor
	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())
	
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