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
		drawTile = nil,
		
		mainMenu = {},
		debugMenu = {}
	}	
	
	setmetatable(object, { __index = Menu })
	return object
end

-- set default menu buttons
function Menu:setMainMenu()
	local bh = self.buttonHeight
	-- button positions
	local xn = self.xs
	local yn = self.ys + bh

	-- create buttons
	buttonNewGame = loveframes.Create("imagebutton")
	buttonNewGame:SetSize(self.width, bh)
	buttonNewGame:SetPos(xn, yn)
	buttonNewGame:SetImage(love.graphics.newImage("gui/menunewgame.png"))
	buttonNewGame.OnClick = function(object)
		-- restart game
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
	
	table.insert(self.debugMenu, roadButton)
	table.insert(self.debugMenu, waterButton)
	table.insert(self.debugMenu, groundButton)
		
	-- checkbox to enable Debug
	local checkDebug = loveframes.Create("checkbox")
	checkDebug:SetPos(width-140, height - 30)
	checkDebug.OnChanged = function(object)
		--[[DEBUG = not DEBUG
		roadButton:SetVisible(not roadButton:GetVisible())
		waterButton:SetVisible(not waterButton:GetVisible())
		groundButton:SetVisible(not groundButton:GetVisible())--]]
		self.debugMode = not(self.debugMode)
	end	
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
	love.graphics.rectangle("line", self.xs, self.ys, self.xe, self.ye)
	
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
	
	
	love.graphics.reset()
end
