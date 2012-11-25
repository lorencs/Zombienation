require "map/Map"
require "map/Tile"
require "map/Building"
require "map/MapGen"
require "map/Minimap"
require "gui/Menu"
require "gui/StartMenu"
require "gui/PauseMenu"
require "gui/View"
require "camera"
require "units/UnitManager"
require "loveframes/init"
require "Units/Point"

--[[ 
	write little messages here so changes arent confusing ? if i do modify something and it still needs to be changed,
	i put a comment with a tag *change* right by the line
	
	mike:
		- viewpoint code, clean up this main file a bit
		- moved all the menu type code to the menu type file
		- map changes saved in "map/defaultMap.txt"
		- building editing with debug menu 
			- still buggy: allows overlapping buildings
			- todo: snap the draw box to tiles
	
	mikus: 
		- hid cursor, replaced with a zombie hand (just a random image i found for now)
		- added mouse isDown check to draw road tiles
	
	mihai: (reminder to myself to print out states.. check arrays.. there was a small bug which i cant reproduce. if you find a bug, save the file and line
	 and write it here please !)
		- zombies wonder around.. transform human after 2 seconds of 'eating them (??)'
		- human n zombie moving around while zombie is feasting on human.. will change so they stay in same place when 
		-- zombie eats human
		
		- have some animation code, didnt work out, commented out, ignore it, its together with the unit code so it shouldnt
		- confuse anything..
		
		- mike, can we get rid of the black outline around the map ?
			-- if you want to..it was a boundary those are just blocked tiles
		
		-Update: I added some main menu pics.. idk if they're good or not.. use em or not, idc. and here s some other images ( have to look
		through the pages):
		http://gmc.yoyogames.com/index.php?showtopic=513891&st=0
]]--

-- game settings
gold = 0
orig_number_of_zombies = 1			-- zombies are red
orig_number_of_humans = 150			-- humans are blue
									-- i thought this was a poem
									-- i wish it was too

-- gamestate
Gamestate = require "utils/gamestate"
Timer = require "utils/timer"
startMenuSTATE = Gamestate.new()
gameSTATE = Gamestate.new()
endingSTATE = Gamestate.new()
paused = false

function love:load()	
	-- debug menu bools
	drawTile = "R"
	dragSelect = false
	dragx, dragy = 0, 0
	defaultFont = love.graphics.newFont(12)
	
	-- music
	music = love.audio.newSource("/units/fellowship.mp3") 
	
	-- seeding randomizer
	randomizer = math.random(30,60)				
	math.randomseed( os.time() + randomizer )
	
	-- initiate units
	unitManager = UnitManager:new()
	unitManager:initUnits()
	
	-- generate a map
	generator = MapGen:new()
	generator:defaultMap()
	
	-- get the map	
	map = generator:getMap()
	
	-- graphics setup	
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	menuWidth = 200
	viewWidth = width - menuWidth
	
	-- viewpoint
	view = View:new(viewWidth, map)
	
	-- minimap
	minimap = Minimap:new(map, view, unitManager, width - 150, height - map.height - 100, width, height)
	minimap:init()
	map:setMinimap(minimap)
		
	-- restrict camera
	camera:setBounds(0, 0, map.width * map.tileSize - viewWidth, map.height * map.tileSize - height)
		
	-- cursor
	love.mouse.setVisible(false)
	cursor = love.graphics.newImage("gui/cursor.png")
	
	Gamestate.switch(startMenuSTATE)
end

------------------ START STATE CODE ----------------------------------------------

function startMenuSTATE:init()
	startMenu = StartMenu:new(width/2 - 100, height/2 + 100)
	startMenu:setup()
	titleScreen = love.graphics.newImage("gui/titleScreen.png")
	alpha = 0
	Timer.add(0.005, function(func) alpha = alpha+1 Timer.add(0.005, func) end)
end

function startMenuSTATE:update(dt)
	Timer.update(dt)
	if (alpha == 255) then Timer.clear() end
	if love.keyboard.isDown(" ") then
		Gamestate.switch(gameSTATE)
	end
	
	loveframes.update(dt)
end

function startMenuSTATE:draw()
	love.graphics.setColor(255,255,255,alpha)
	love.graphics.draw(titleScreen, 0, 0)
	
	loveframes.draw()
	
	-- cursor
	love.graphics.reset()	
	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())		
end

function startMenuSTATE:mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function startMenuSTATE:mousereleased(x, y, button)
	loveframes.mousereleased(x, y, button)
end

function startMenuSTATE:leave()
	startMenu:delete()
end

------------------ GAME STATE CODE ----------------------------------------------

-- this function is called everytime the game restarts
-- put any resetting code in here
function gameSTATE:enter()
	-- init menu
	menu = Menu:new(viewWidth, menuWidth, height)
	menu:setup()
	
	-- pause menu
	pauseMenu = PauseMenu:new(width/2 - 100, height/2 - 100)
	pauseMenu:setup()
	
	-- reset units
	unitManager:resetUnits()	
end

function gameSTATE:leave()
	-- init menu
	menu:delete()
	pauseMenu:delete()
end

function gameSTATE:pauseResume()
	unitManager:pauseGame()	-- pause and resume game
	paused = not paused
end

function gameSTATE:update(dt)
	-- restrict drag select
	if dragSelect and (love.mouse.getX() >= viewWidth) then
		love.mouse.setPosition(viewWidth - (love.mouse.getX() - viewWidth), love.mouse.getY())
	end

	-- viewpoint movement - arrow keys
	view:update(dt)
	
	-- update unit positions
	unitManager:update(dt)
	
	-- current mouse position
	xpos = math.floor((love.mouse.getX() + view.x) / map.tileSize)
	ypos = math.floor((love.mouse.getY() + view.y) / map.tileSize)
	
	-- map editing
	if menu.buildingMode then
		if love.mouse.isDown("l") and love.mouse.getX() < viewWidth then
			if (xpos > -1) and (ypos > -1) and (xpos < map.width) and (ypos < map.height) then
				map:newBuilding(xpos, ypos, menu.b_type)
				local xd = math.floor(menu.b_type / 10)
				local yd = menu.b_type % 10
				
				-- update all relevent tiles
				for xi=xpos,xpos+xd-1 do
					for yi=ypos,ypos+yd-1 do
						map:updateTileInfo(xi, yi)
					end
				end				
			end
		end
	elseif menu.debugMode then
		if love.mouse.isDown("l") and (love.mouse.getX() < viewWidth)then
			if (xpos > -1) and (ypos > -1) and (xpos < map.width) and (ypos < map.height) then
				--map.tiles[map:index(xpos,ypos)]:setId(drawTile)
				map.tiles[xpos][ypos]:setId(drawTile);
				map:updateTileInfo(xpos,ypos)
			end
		end
	end
	
	
	-- center camera
	--camera:setPosition(math.floor(vpx - (viewWidth / 2)), 
	--	math.floor(vpy - height / 2))
	camera:setPosition(math.floor(view.x), math.floor(view.y))
	
	-- update minimap
	minimap:update(view.x,view.y)
	
	-- loveframes
	loveframes.update(dt)
end

function gameSTATE:draw()
	local mx = love.mouse.getX()
	local my = love.mouse.getY()

-- restrict drag select
	if dragSelect and (mx >= viewWidth) then
		love.mouse.setPosition(viewWidth - (mx - viewWidth), my)
	end	
	-- gotta set font to default because loveframes imagebutton messes it up for some reason
	love.graphics.setFont(defaultFont)
	-- set camera
	camera:set()					
	
	-- draw the map
	map:draw() 		
	
	-- building placement
	if menu.buildingMode and not(menu.b_type == nil) then
		local xw = math.floor(menu.b_type / 10)
		local yw = menu.b_type % 10
		
		love.graphics.setColor(0,255,255)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", mx + view.x, my + view.y, 
			xw * map.tileSize, yw * map.tileSize)
	end
	
	-- draw the units
	unitManager:draw()
	
	-- unset camera
	camera:unset()					
	
	-- draw menu
	menu:draw()
	
	-- draw minimap
	minimap:draw()
	
	-- drag selection
	if (not(menu.debugMode) and not(menu.buildingMode) and dragSelect) then 
		love.graphics.setColor(50,50,50,50)
		love.graphics.rectangle("fill", dragx, dragy, mx - dragx, my - dragy)
		love.graphics.setColor(50,50,50,150)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", dragx+0.5, dragy+0.5, math.floor(mx) - dragx, math.floor(my) - dragy)
	end
	
	-- pause menu
	pauseMenu:draw()
	
	-- debug
	love.graphics.setColor(255,255,255)
	love.graphics.print("Camera Cood: ["..view.x..","..view.y.."]", 0, 0)
	love.graphics.print("Mouse Cood: ["..mx..","..my.."]", 0, 15)
	love.graphics.print("Zombies alive: " .. number_of_zombies, 0, 30)
	love.graphics.print("Humans alive: " .. number_of_humans, 0, 45)
	love.graphics.print("Framerate: " .. love.timer.getFPS(), 0, 60)
	love.graphics.print("Press ( P / S ) for music", 0, 75)
	love.graphics.print("Gold: ".. gold, 715, 0)
	
	-- loveframes
	loveframes.draw()
	
	-- cursor
	love.graphics.reset()	
	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())	
	
	love.graphics.reset()	
end

-- callback functions needed by loveframes, we can use them too
function gameSTATE:mousepressed(x, y, button)
	if (x < viewWidth) and not menu.debugMode then
		unitManager:deselectUnits()
		if (button == "l") then		
			dragSelect = true
			dragx, dragy = x, y
		end
	end
	
	minimap:mousepressed(x, y, button)
	loveframes.mousepressed(x, y, button)
end

function gameSTATE:mousereleased(x, y, button)
	-- process loveframes callback first so that DEBUG can be set to false
	loveframes.mousereleased(x, y, button)
	
	minimap:mousereleased()
	
	if (button == "l") and not menu.debugMode and (x < viewWidth) then
		dragSelect = false
		unitManager:selectUnits(dragx+view.x, dragy+view.y, x+view.x, y+view.y)
	end	
end

function gameSTATE:keypressed(key, unicode)
	loveframes.keypressed(key, unicode)
end


function gameSTATE:keyreleased(key)
	if key == "escape" then 
		if not paused then -- show pause menu
			pauseMenu:showHide()
			gameSTATE:pauseResume()
		else
			pauseMenu:showHide()
			gameSTATE:pauseResume()
		end
	elseif key == "p" then
		love.audio.play(music)
	elseif key == "s" then
		love.audio.stop()
	end	
	
	--loveframes
	loveframes.keyreleased(key)
end

-- love callbacks redirected to gamestate
function love.draw()
    Gamestate.draw()
end

function love.update(dt)
	loveframes.update(dt)
    Gamestate.update(dt) 
end

function love.keyreleased(key)
    Gamestate.keyreleased(key)
end

function love.keypressed(key)
    Gamestate.keypressed(key)
end

function love.mousepressed(x, y, button)
	Gamestate.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	Gamestate.mousereleased(x, y, button)
end
-----------------------------------------------

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end	