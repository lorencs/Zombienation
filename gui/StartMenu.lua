StartMenu = {}

--[[
Mikus:  added alpha value to menu bg color, so it can be a little bit transparent
		i think it looks cool, you can change it back if you want
]]--

-- constructor
function StartMenu:new(_x,_y)
	local object = {
		x = _x,
		y = _y
	}	
	
	setmetatable(object, { __index = StartMenu })
	return object
end

function StartMenu:setup()
	bSG = love.graphics.newImage("gui/startgame.png")
	bOpt = love.graphics.newImage("gui/options.png")
	bQt = love.graphics.newImage("gui/quit.png")
	
	-- create buttons
	buttonStartGame = loveframes.Create("imagebutton")
	buttonStartGame:SetPos(self.x, self.y)
	buttonStartGame:SetImage(bSG)
	buttonStartGame:SizeToImage() 
	buttonStartGame.OnClick = function(object)
		Gamestate.switch(gameSTATE)
	end
	
	-- create buttons
	buttonOptions = loveframes.Create("imagebutton")
	buttonOptions:SetPos(self.x, self.y + 35)
	buttonOptions:SetImage(bOpt)
	buttonOptions:SizeToImage() 
	buttonOptions.OnClick = function(object)
		print("NO OPTIONS YET SON")
	end
	
	-- create buttons
	buttonQuit = loveframes.Create("imagebutton")
	buttonQuit:SetPos(self.x, self.y + 70)
	buttonQuit:SetImage(bQt)
	buttonQuit:SizeToImage() 
	buttonQuit.OnClick = function(object)
		love.event.quit()
	end
end

-- update menu
function StartMenu:update()
	
end


-- draw the menu
function StartMenu:draw()
	--[[ draw the buttons
	for _,v in pairs(self.buttons) do
		v:draw()
	end
	--]]
	for _,v in pairs(self.mainMenu) do
		v:SetVisible(not(self.debugMode))
	end
	for _,v in pairs(self.debugMenu) do
		v:SetVisible(self.debugMode)
	end
	for _,v in pairs(self.buildingMenu) do
		v:SetVisible(self.buildingMode)
	end
	
	
	love.graphics.reset()
end

function StartMenu: delete()
	buttonStartGame:Remove()
	buttonOptions:Remove()
	buttonQuit:Remove()
end
