require "map/Map"
require "map/Tile"
require "map/MapGen"
require "gui/Menu"
require "gui/Button"
require "camera"
require "Units/Unit"
require "Units/Zombie"
require "Units/Human"
require "Units/SpriteAnimation"

--[[ 
	write little messages here so changes arent confusing ? if i do modify something and it still needs to be changed,
	i put a comment with a tag *change* right by the line
	
	mikus: 
		- hid cursor, replaced with a zombie hand (just a random image i found for now)
		- added mouse isDown check to draw road tiles
	
	mihai:
		- zombies wonder around.. transform human after 2 seconds of 'eating them (??)'
		- human n zombie moving around while zombie is feasting on human.. will change so they stay in same place when 
		-- zombie eats human
		
		- have some animation code, didnt work out, commented out, ignore it, its together with the unit code so it shouldnt
		- confuse anything..
		
		- mike, can we get rid of the black outline around the map ?
]]--

-- game settings
number_of_zombies = 1			-- zombies are red
number_of_humans = 15			-- humans are blue

function love.load()	
	DEBUG = true
	--map = Map:new() 	-- load map functions
	--map:initMap(20,20)		-- init map object
	--map:loadMap("map/mapFile.txt")			-- load map from file
	
	randomizer = math.random(30,60)				-- seeding randomizer
	math.randomseed( os.time() + randomizer )
	
	-- generating units (Unit Manager coming soon, will make this much shorter )
	zombie_list = {}							-- array of zombie objects
	human_list = {}								-- array of human objects
		
	for i = 1, number_of_zombies do
		zombie_list[i] = Zombie:new()
		zombie_list[i]:setupUnit()
	end
	
	for i = 1, number_of_humans do
		human_list[i] = Human:new()
		human_list[i]:setupUnit()
	end	
	
	-- end of generating units
	
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
		--zombie_list[i].animation:update(dt)
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
		zombie_list[i]:draw(i)
		--zombie_list[i].animation:draw(zombie_list[i].x, zombie_list[i].y)
	end
	for i = 1, number_of_humans do
		human_list[i]:draw(i)
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