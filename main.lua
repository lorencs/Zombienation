require "map/map"

function love.load()	
	map = map:new() 	-- load map functions
	map:initMap(20,20)		-- init map object
	map:loadMap("map/mapFile.txt")			-- load map from file
end

function love.update(dt)
end

function love.draw()	
	map:drawMap() 			-- draw the map
end