require "map/Map"
require "map/Tile"
require "map/MapGen"
require "gui/Menu"
require "gui/Button"
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
number_of_zombies = 1			-- zombies are red
number_of_humans = 50			-- humans are blue
								-- i thought this was a poem
								-- i wish it was too

function love.load()	
	-- debug menu bools
	DEBUG = false
	drawTile = "R"
	dragSelect = false
	dragx, dragy = 0
	
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
	generator:newMap(100,100)
	
	-- get the map
	map = generator:getMap()
	
	-- graphics setup
	width = love.graphics.getWidth()
	height = love.graphics.getHeight()
	
	menuWidth = 200
	viewWidth = width - menuWidth
	
	-- viewpoint
	view = View:new(viewWidth, map)
	
	-- init menu
	menu = Menu:new(viewWidth, menuWidth, height)
	menu:setButtons()
	
	-- loveframes debug menu stuff (for testing)
		
		-- debug text
		local textDebug = loveframes.Create("text")
		textDebug:SetPos(width-115, height - 27)
		textDebug:SetMaxWidth(100)
		textDebug:SetText("Debug")
		
		-- button to select road tile draw
		roadButton = loveframes.Create("imagebutton")
		roadButton:SetSize(25, 25)
		roadButton:SetPos(width-140, height-62)		
		roadButton:SetImage(love.graphics.newImage("gui/roadBtnSelect.png"))
		roadButton:SetVisible(false)
		roadButton.OnClick = function(object)
			roadButton:SetImage(love.graphics.newImage("gui/roadBtnSelect.png"))
			waterButton:SetImage(love.graphics.newImage("gui/waterBtn.png"))
			groundButton:SetImage(love.graphics.newImage("gui/groundBtn.png"))
			drawTile = "R" 
		end
		
		-- button to select water tile draw
		waterButton = loveframes.Create("imagebutton")
		waterButton:SetSize(25, 25)
		waterButton:SetPos(width-114, height-62)		
		waterButton:SetImage(love.graphics.newImage("gui/waterBtn.png"))
		waterButton:SetVisible(false)
		waterButton.OnClick = function(object)
			roadButton:SetImage(love.graphics.newImage("gui/roadBtn.png"))
			waterButton:SetImage(love.graphics.newImage("gui/waterBtnSelect.png"))
			groundButton:SetImage(love.graphics.newImage("gui/groundBtn.png"))
			drawTile = "W" 
		end
		
		-- button to select ground tile draw
		groundButton = loveframes.Create("imagebutton")
		groundButton:SetSize(25, 25)
		groundButton:SetPos(width-88, height-62)		
		groundButton:SetImage(love.graphics.newImage("gui/groundBtn.png"))
		groundButton:SetVisible(false)
		groundButton.OnClick = function(object)
			roadButton:SetImage(love.graphics.newImage("gui/roadBtn.png"))
			waterButton:SetImage(love.graphics.newImage("gui/waterBtn.png"))
			groundButton:SetImage(love.graphics.newImage("gui/groundBtnSelect.png"))
			drawTile = "G" 
		end
		
		-- checkbox to enable Debug
		local checkDebug = loveframes.Create("checkbox")
		checkDebug:SetPos(width-140, height - 30)
		checkDebug.OnChanged = function(object)
			DEBUG = not DEBUG
			roadButton:SetVisible(not roadButton:GetVisible())
			waterButton:SetVisible(not waterButton:GetVisible())
			groundButton:SetVisible(not groundButton:GetVisible())
		end	
	
	-- restrict camera
	camera:setBounds(0, 0, map.width * map.tileSize - viewWidth, 
		map.height * map.tileSize - height)
		
	-- cursor
	love.mouse.setVisible(false)
	cursor = love.graphics.newImage("gui/cursor.png")
end

function love.update(dt)
	-- viewpoint movement - arrow keys
	view:update(dt)
	
	-- update unit positions
	unitManager:update(dt)
	
	-- map editing
	if DEBUG then
		if love.mouse.isDown("l") and (love.mouse.getX() < viewWidth)then
			--xpos = love.mouse.getX() + vpx - vpxmin
			xpos = love.mouse.getX() + view.x 
			--ypos = love.mouse.getY() + vpy - vpymin
			ypos = love.mouse.getY() + view.y
			xpos = math.floor(xpos / map.tileSize)
			ypos = math.floor(ypos / map.tileSize)
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
		
	-- loveframes
	loveframes.update(dt)
end

function love.draw()	
	-- gotta set font to default because loveframes imagebutton messes it up for some reason
	love.graphics.setFont(love.graphics.newFont(12))
	-- set camera
	camera:set()					
	
	-- draw the map
	map:draw() 		
	
	-- draw the units
	unitManager:draw()
	
	-- unset camera
	camera:unset()					
	
	-- draw menu
	menu:draw()
	
	-- drag selection
	if (dragSelect) then 
		love.graphics.setColor(50,50,50,50)
		love.graphics.rectangle("fill", dragx, dragy, love.mouse.getX() - dragx, love.mouse.getY() - dragy)
		love.graphics.setColor(50,50,50,150)
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", dragx+0.5, dragy+0.5, math.floor(love.mouse.getX()) - dragx, math.floor(love.mouse.getY()) - dragy)
	end
	
	-- debug
	love.graphics.setColor(255,255,255)
	love.graphics.print("Camera Cood: ["..view.x..","..view.y.."]", 0, 0)
	love.graphics.print("Mouse Cood: ["..love.mouse.getX()..","..love.mouse.getY().."]", 0, 15)
	love.graphics.print("Zombies alive: " .. number_of_zombies, 0, 30)
	love.graphics.print("Humans alive: " .. number_of_humans, 0, 45)
	love.graphics.print("Framerate: " .. love.timer.getFPS(), 0, 60)
	love.graphics.print("Press ( P / S ) for music", 0, 75)
	
	-- loveframes
	loveframes.draw()
	
	-- cursor
	love.graphics.reset()	
	love.graphics.draw(cursor, love.mouse.getX(), love.mouse.getY())	
	
	love.graphics.reset()	
end

-- callback functions needed by loveframes, we can use them too
function love.mousepressed(x, y, button)
	if (button == "l") and (x < viewWidth) then
		dragSelect = true
		dragx, dragy = math.floor(love.mouse.getX()), math.floor(love.mouse.getY())
	end
	
	loveframes.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
	if (button == "l") then
		dragSelect = false
		unitManager:selectUnits(dragx, dragy, love.mouse.getX(), love.mouse.getY())
	end
	
	loveframes.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
	loveframes.keypressed(key, unicode)
end


function love.keyreleased(key)
	if key == "escape" then -- kill app
		love.event.quit()
	elseif key == "p" then
		love.audio.play(music)
	elseif key == "s" then
		love.audio.stop()
	end	
	
	--loveframes
	loveframes.keyreleased(key)
end

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end	