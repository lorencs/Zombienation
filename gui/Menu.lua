Menu = {}

--[[
Mikus:  added alpha value to menu bg color, so it can be a little bit transparent
		i think it looks cool, you can change it back if you want
]]--

-- constructor
function Menu:new(baseX, w, h)
	local object = {
		xs = baseX,
		ys = 0,
		width = w,
		height = h,
		xe = baseX + w,
		ye = h,
		
		buttonWidth = 100,
		buttonHeight = 30,
		
		backColor = {20,20,20,100},
		lineColor = {0,0,100,100},
		
		debugMode = false,
		buildingMode = false,
		drawTile = nil,
		b_type = nil,
		
		mainMenu = {},
		debugMenu = {},
		buildingMenu = {}
	}	
	
	setmetatable(object, { __index = Menu })
	return object
end

-- setup all menues
function Menu:setup()
	self:setMainMenu()
	self:setDebugMenu()
	self:setBuildingMenu()
end

-- set default menu buttons
function Menu:setMainMenu()
	local bh = self.buttonHeight
	-- button positions
	local xn = self.xs
	local yn = self.ys + bh

	-- gold coins
	
	-- create buttons
	buttonNewGame = loveframes.Create("imagebutton")
	buttonNewGame:SetSize(self.width, bh)
	buttonNewGame:SetPos(xn, yn)
	buttonNewGame:SetImage(love.graphics.newImage("gui/restartgame.png"))
	buttonNewGame.OnClick = function(object)
		Gamestate.switch(gameSTATE)
	end
	
	-- create buttons
	buttonPause = loveframes.Create("imagebutton")
	buttonPause:SetSize(self.width, bh)
	buttonPause:SetPos(xn, yn + 35)
	buttonPause:SetImage(love.graphics.newImage("gui/pausegame.png"))
	buttonPause.OnClick = function(object)
		unitManager:pauseGame()	-- pause and resume game
	end
	
	table.insert(self.mainMenu, buttonNewGame)
end


-- set up options for debug mode
function Menu:setDebugMenu()
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
	
	-- checkbox to activate building mode
	local textBuilding = loveframes.Create("text")
	textBuilding:SetPos(width-115, height-87)
	textBuilding:SetMaxWidth(100)
	textBuilding:SetText("Building Mode")
	
	local checkBuilding = loveframes.Create("checkbox")
	checkBuilding:SetPos(width-140, height-87)
	checkBuilding.OnChanged = function(object)
		self.buildingMode = not(self.buildingMode)
	end
			
	table.insert(self.debugMenu, roadButton)
	table.insert(self.debugMenu, waterButton)
	table.insert(self.debugMenu, groundButton)
	table.insert(self.debugMenu, textBuilding)
	table.insert(self.debugMenu, checkBuilding)
		
	-- checkbox to enable Debug
	local checkDebug = loveframes.Create("checkbox")
	checkDebug:SetPos(width-140, height - 30)
	checkDebug.OnChanged = function(object)
		--[[DEBUG = not DEBUG
		roadButton:SetVisible(not roadButton:GetVisible())
		waterButton:SetVisible(not waterButton:GetVisible())
		groundButton:SetVisible(not groundButton:GetVisible())--]]
		self.debugMode = not(self.debugMode)
		if self.buildingMode then
			self.buildingMode = false
			checkBuilding.checked = false
		end
	end	
end

function Menu:setBuildingMenu()
	-- b_type = 66
	buttonB1 = loveframes.Create("imagebutton")
	buttonB1:SetSize(25, 25)
	buttonB1:SetPos(width-150, height-500)		
	buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1.png"))
	buttonB1:SetVisible(false)
	buttonB1.OnClick = function(object)
		buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1selected.png"))
		buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2.png"))
		buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3.png"))
		buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4.png"))
		buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5.png"))
		buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6.png"))
		
		self.b_type = 66
	end
	
	textB1 = loveframes.Create("text")
	textB1:SetPos(width-120, height-500)
	textB1:SetMaxWidth(100)
	textB1:SetText("6 x 6")
	
	-- b_type = 43
	buttonB2 = loveframes.Create("imagebutton")
	buttonB2:SetSize(25, 25)
	buttonB2:SetPos(width-150, height-470)
	buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2.png"))
	buttonB2:SetVisible(false)
	buttonB2.OnClick = function(object)
		buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1.png"))
		buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2selected.png"))
		buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3.png"))
		buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4.png"))
		buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5.png"))
		buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6.png"))
		
		self.b_type = 43
	end
	
	textB2 = loveframes.Create("text")
	textB2:SetPos(width-120, height-470)
	textB2:SetMaxWidth(100)
	textB2:SetText("4 x 3")
	
	-- b_type = 35
	buttonB3 = loveframes.Create("imagebutton")
	buttonB3:SetSize(25, 25)
	buttonB3:SetPos(width-150, height-440)
	buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3.png"))
	buttonB3:SetVisible(false)
	buttonB3.OnClick = function(object)
		buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1.png"))
		buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2.png"))
		buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3selected.png"))
		buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4.png"))
		buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5.png"))
		buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6.png"))
		
		self.b_type = 35
	end
	
	textB3 = loveframes.Create("text")
	textB3:SetPos(width-120, height-440)
	textB3:SetMaxWidth(100)
	textB3:SetText("3 x 5")
	
	-- b_type = 33
	buttonB4 = loveframes.Create("imagebutton")
	buttonB4:SetSize(25, 25)
	buttonB4:SetPos(width-150, height-410)
	buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4.png"))
	buttonB4:SetVisible(false)
	buttonB4.OnClick = function(object)
		buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1.png"))
		buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2.png"))
		buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3.png"))
		buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4selected.png"))
		buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5.png"))
		buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6.png"))
		
		self.b_type = 33
	end
	
	textB4 = loveframes.Create("text")
	textB4:SetPos(width-120, height-410)
	textB4:SetMaxWidth(100)
	textB4:SetText("3 x 3")
	
	-- b_type = 34
	buttonB5 = loveframes.Create("imagebutton")
	buttonB5:SetSize(25, 25)
	buttonB5:SetPos(width-150, height-380)
	buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5.png"))
	buttonB5:SetVisible(false)
	buttonB5.OnClick = function(object)
		buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1.png"))
		buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2.png"))
		buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3.png"))
		buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4.png"))
		buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5selected.png"))
		buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6.png"))
		
		self.b_type = 34
	end
	
	textB5 = loveframes.Create("text")
	textB5:SetPos(width-120, height-380)
	textB5:SetMaxWidth(100)
	textB5:SetText("3 x 4")
	
	-- b_type = 64
	buttonB6 = loveframes.Create("imagebutton")
	buttonB6:SetSize(25, 25)
	buttonB6:SetPos(width-150, height-350)
	buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6.png"))
	buttonB6:SetVisible(false)
	buttonB6.OnClick = function(object)
		buttonB1:SetImage(love.graphics.newImage("gui/buildingButtons/b1.png"))
		buttonB2:SetImage(love.graphics.newImage("gui/buildingButtons/b2.png"))
		buttonB3:SetImage(love.graphics.newImage("gui/buildingButtons/b3.png"))
		buttonB4:SetImage(love.graphics.newImage("gui/buildingButtons/b4.png"))
		buttonB5:SetImage(love.graphics.newImage("gui/buildingButtons/b5.png"))
		buttonB6:SetImage(love.graphics.newImage("gui/buildingButtons/b6selected.png"))
		
		self.b_type = 64
	end
	
	textB6 = loveframes.Create("text")
	textB6:SetPos(width-120, height-350)
	textB6:SetMaxWidth(100)
	textB6:SetText("6 x 4")
	
	
	table.insert(self.buildingMenu, buttonB1)
	table.insert(self.buildingMenu, textB1)
	table.insert(self.buildingMenu, buttonB2)
	table.insert(self.buildingMenu, textB2)
	table.insert(self.buildingMenu, buttonB3)
	table.insert(self.buildingMenu, textB3)
	table.insert(self.buildingMenu, buttonB4)
	table.insert(self.buildingMenu, textB4)
	table.insert(self.buildingMenu, buttonB5)
	table.insert(self.buildingMenu, textB5)
	table.insert(self.buildingMenu, buttonB6)
	table.insert(self.buildingMenu, textB6)
end

-- update menu
function Menu:update()
	
end


-- draw the menu
function Menu:draw()
	-- background
	love.graphics.setColor(self.backColor)
	love.graphics.rectangle("fill", self.xs, self.ys, self.xe, self.ye)
		
	-- outline
	love.graphics.setColor(self.lineColor)
	love.graphics.rectangle("line", self.xs+0.5, self.ys+0.5, self.xe-0.5, self.ye-0.5)
	
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

function Menu:delete()
for _,v in pairs(self.mainMenu) do
		v:Remove()
	end
	for _,v in pairs(self.debugMenu) do
		v:Remove()
	end
	for _,v in pairs(self.buildingMenu) do
		v:Remove()
	end
end
