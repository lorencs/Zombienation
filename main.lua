require "player/Player"
require "player/SpriteAnimation"
require "enemy/enemy"
require "camera"

function love.load()
	g = love.graphics
	width = g.getWidth()
	height = g.getHeight()
	g.setBackgroundColor(122,235,249)
	groundColor = {25,200,25}
	trunkColor = {139,69,19}
		
	-- restrict camera
	camera:setBounds(0,0,width, math.floor(height / 8))
	
	-- player animation
	animation = SpriteAnimation:new("player/sprites.png", 32, 32, 4, 4)
	animation:load(delayb)
	
	p = Player:new()
	
	p.x = 300
	p.y = 300
	p.width = 32
	p.height = 32
	p.jumpSpeed = -500
	p.runSpeed = 300
	
	gravity = 1800
	yFloor = 500
	delay = 120
	
	--[[e = enemy:new()
	
	e.x = 1500
	e.y = 300
	e.width = 29
	e.height = 55
	e.runSpeed = 150
	e.animation = SpriteAnimation:new("enemy/enemy.png", 29, 55, 10, 1)
	e.animation:load(delay)]]--
end

function love.keyreleased(key)
	if (key == "right") or (key == "left") then
		p:stop()
	end
	
	if (key == "escape") then
		love.event.push('quit')
	end
	
	if (key == "down") then
		p:stop()
	end
end

function love.update(dt)
	if love.keyboard.isDown("right") then
		p:moveRight()
		animation:flip(false, false)
	end
	if love.keyboard.isDown("left") then
		p:moveLeft()
		animation:flip(true, false)
	end	
	if love.keyboard.isDown("up") then
		p:jump()
	end
	if love.keyboard.isDown("down") then
		p:duck()
	end
	
	p:update(dt, gravity)
	
	p.x = math.clamp(p.x, 0, width*2 - p.width)
	if p.y < 0 then p.y = 0 end
	if p.y > yFloor - p.height then
		p:hitFloor(yFloor)
	end
	
	-- update sprite animation
	if (p.state == "stand") then
		animation:switch(1,4,200)
	end
	if (p.state == "moveRight") or (p.state == "moveLeft") then
		animation:switch(2,4,120)
	end
	if (p.state == "jump") or (p.state == "fall") then
		animation:reset()
		animation:switch(3,1,300)
	end
	if (p.state == "shitting") then
		--animation:reset()
		animation:switch(4,4,100)
	end
	animation:update(dt)
	
	for i = 0, p.poopcount-1 do
		p.poops[i].animation:update(dt)
	end
	
	-- update enemy behavior
	--[[if (e.x < p.x) then
		e:moveRight()
		e.animation:flip(false, false)
	elseif (e.x > p.x) then
		e:moveLeft()
		e.animation:flip(true, false)
	end
	e:update(dt, gravity)
	
	if (e.state == "moveLeft") or (e.state == "moveRight")then
		e.animation:switch(1,10,120)
	end
	e.animation:update(dt)
	
	if e.y < 0 then e.y = 0 end
	if e.y > yFloor - e.height then
		e:hitFloor(yFloor)
	end]]--
		
	-- center the camera on the player
    camera:setPosition(math.floor(p.x - width / 2), math.floor(p.y - height / 2))
end

function love.draw()
	--set camera
	camera:set()

	-- round down player values
	local px = math.floor(p.x)
	local py = math.floor(p.y)
	--local ex = math.floor(e.x)
	--local ey = math.floor(e.y)

	-- ground graphics
	g.setColor(groundColor)
	g.rectangle("fill", 0, yFloor, width*2, height)
	
	-- tree!
	g.rectangle("fill", 725,285,125,125)
	g.setColor(trunkColor)
	g.rectangle("fill", 770,410,40,90)
	
	-- player graphics
	g.setColor(255,255,255)
	animation:draw(px,py)
	
	-- poop graphics
	for i = 0, p.poopcount-1 do
		p.poops[i].animation:draw(p.poops[i].x,p.poops[i].y)
	end
	
	-- enemy graphics
	--e.animation:draw(ex,ey)
	
	-- unset camera
	camera:unset()
	
	-- controls info
	g.setColor(0,0,0)
	g.print("LEFT: move left\nRIGHT: move right\nup: jump\ndown: 'duck'", 680,5)
	--g.print("x: ", 745,5)
	--g.print(x, 760,5)
	--g.print("\ny: ", 745,5)
	--g.print(y, 760,19)	
	
	--moar debug 
    local isTrue = ""
    g.print("player coords: ("..px..","..py..")", 5, 5)
    g.print("state: "..p.state, 5, 20)	
	g.print("poop count: "..p.poopcount, 5, 35)
	--g.print("enemy coords: ("..ex..","..ey..")", 5, 55)
	--g.print("enemy state: "..e.state, 5, 70)
	
end

function math.clamp(x, min, max)
	return x < min and min or (x > max and max or x)
end