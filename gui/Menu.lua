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
		
		background = love.graphics.newImage("gui/gamemenubg.png"),
		lineColor = {0,0,0,100},
		
		debugMode = false,
		--buildingMode = false,
		drawTile = nil,
		--b_type = nil,
		
		mainMenu = {},
		debugMenu = {},
		--buildingMenu = {},
		
		visible = true
	}	
	
	setmetatable(object, { __index = Menu })
	return object
end

-- setup all menues
function Menu:setup()
	self:setMainMenu()
	self:setDebugMenu()
	--self:setBuildingMenu()
end

-- set default menu buttons
function Menu:setMainMenu()
	local bh = self.buttonHeight
	-- button positions
	local xn = self.xs
	local yn = self.ys + bh

	-- selection text
	selectText = loveframes.Create("text")
	selectText:SetPos(91, height - menuWidth + 15)
	selectText:SetText({{0,0,0,150}, "No Units Selected"})
	
	-- WORKER BTN
	upgradeWorkerBtn = loveframes.Create("imagebutton")
	upgradeWorkerBtn:SetSize(23,23)
	upgradeWorkerBtn:SetPos(92, height - menuWidth + 34)		
	upgradeWorkerBtn:SetImage(love.graphics.newImage("gui/workerbutton.png"))
	upgradeWorkerBtn:SetVisible(false)
	upgradeWorkerBtn.OnClick = function(object)
		unitManager:convertUnits("Worker")
		unitManager:deselectUnits()
	end
	
	workerText = loveframes.Create("text")
	workerText:SetPos(120, height - menuWidth + 38)
	workerText:SetText("Upgrade to Worker")
	workerText:SetVisible(false)
	
	upgradeRangerBtn = loveframes.Create("imagebutton")
	upgradeRangerBtn:SetSize(23,23)
	upgradeRangerBtn:SetPos(92, height - menuWidth + 64)		
	upgradeRangerBtn:SetImage(love.graphics.newImage("gui/rangerbutton.png"))
	upgradeRangerBtn:SetVisible(false)
	upgradeRangerBtn.OnClick = function(object)
		unitManager:convertUnits("Ranger")
		unitManager:deselectUnits()
	end
	
	rangerText = loveframes.Create("text")
	rangerText:SetPos(120, height - menuWidth + 68)
	rangerText:SetText("Upgrade to Ranger")
	rangerText:SetVisible(false)
	
	-- supplies BTN
	suppliesButton = loveframes.Create("imagebutton")
	suppliesButton:SetSize(23,23)
	suppliesButton:SetPos(92, height - menuWidth + 34)		
	suppliesButton:SetImage(love.graphics.newImage("gui/suppliesbutton.png"))
	suppliesButton:SetVisible(false)
	suppliesButton.OnClick = function(object)
		unitManager:sendWorkers()		
	end
	
	suppliesText = loveframes.Create("text")
	suppliesText:SetPos(120, height - menuWidth + 38)
	suppliesText:SetText("Gather Supplies")
	suppliesText:SetVisible(false)
	
	-- PATROL BTN
	patrolButton = loveframes.Create("imagebutton")
	patrolButton:SetSize(23,23)
	patrolButton:SetPos(92, height - menuWidth + 34)		
	patrolButton:SetImage(love.graphics.newImage("gui/patrolbutton.png"))
	patrolButton:SetVisible(false)
	patrolButton.OnClick = function(object)
		selectPatrol = true
	end
	
	patrolText = loveframes.Create("text")
	patrolText:SetPos(120, height - menuWidth + 38)
	patrolText:SetText("Patrol Area")
	patrolText:SetVisible(false)
	
	table.insert(self.mainMenu, upgradeWorkerBtn)
	table.insert(self.mainMenu, workerText)
	table.insert(self.mainMenu, upgradeRangerBtn)
	table.insert(self.mainMenu, rangerText)
	table.insert(self.mainMenu, suppliesButton)
	table.insert(self.mainMenu, suppliesText)
	table.insert(self.mainMenu, patrolButton)
	table.insert(self.mainMenu, patrolText)
end


-- set up options for debug mode
function Menu:setDebugMenu()
	-- debug text
	textDebug = loveframes.Create("text")
	textDebug:SetPos(0 + 31, height - menuWidth + 15)
	textDebug:SetMaxWidth(100)
	textDebug:SetText("Debug")
	
	-- select text
	selectDebug = loveframes.Create("text")
	selectDebug:SetPos(0 + 11, height - menuWidth + 31)
	selectDebug:SetMaxWidth(100)
	selectDebug:SetText("Select Tile")
	selectDebug:SetVisible(false)
	
	-- button to select road tile draw
	roadButton = loveframes.Create("imagebutton")
	roadButton:SetSize(25, 25)
	roadButton:SetPos(15, height-69)		
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
	waterButton:SetPos(45, height-69)		
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
	groundButton:SetPos(15, height-37)		
	groundButton:SetImage(love.graphics.newImage("gui/groundBtn.png"))
	groundButton:SetVisible(false)
	groundButton.OnClick = function(object)
		roadButton:SetImage(love.graphics.newImage("gui/roadBtn.png"))
		waterButton:SetImage(love.graphics.newImage("gui/waterBtn.png"))
		groundButton:SetImage(love.graphics.newImage("gui/groundBtnSelect.png"))
		drawTile = "G" 
	end
	
	-- checkbox to activate building mode
	--[[local textBuilding = loveframes.Create("text")
	textBuilding:SetPos(width-115, height-87)
	textBuilding:SetMaxWidth(100)
	textBuilding:SetText("Building Mode")
	
	local checkBuilding = loveframes.Create("checkbox")
	checkBuilding:SetPos(width-140, height-87)
	checkBuilding.OnChanged = function(object)
		self.buildingMode = not(self.buildingMode)
	end]]--
			
	table.insert(self.debugMenu, roadButton)
	table.insert(self.debugMenu, waterButton)
	table.insert(self.debugMenu, groundButton)
	--table.insert(self.debugMenu, textBuilding)
	--table.insert(self.debugMenu, checkBuilding)
		
	-- checkbox to enable Debug
	checkDebug = loveframes.Create("checkbox")
	checkDebug:SetPos(10, height - menuWidth + 10)
	checkDebug.OnChanged = function(object)
		--[[DEBUG = not DEBUG
		roadButton:SetVisible(not roadButton:GetVisible())
		waterButton:SetVisible(not waterButton:GetVisible())
		groundButton:SetVisible(not groundButton:GetVisible())--]]
		self.debugMode = not(self.debugMode)
		--[[if self.buildingMode then
			self.buildingMode = false
			checkBuilding.checked = false
		end]]--
	end	
end

--[[function Menu:setBuildingMenu()
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
]]--

--update menu
function Menu:showHide(bool)
	if bool then self.visible = not self.visible end
	
	for _,v in pairs(self.mainMenu) do
		v:SetVisible(self.visible)
	end
	for _,v in pairs(self.debugMenu) do
		v:SetVisible(self.visible)
	end
	--[[for _,v in pairs(self.buildingMenu) do
		v:SetVisible(self.visible)
	end]]--
	
	textDebug:SetVisible(self.visible)
	checkDebug:SetVisible(self.visible)
	selectDebug:SetVisible(self.visible)
end

function Menu:update(dt)
	for _,v in pairs(self.mainMenu) do
		v:SetVisible(false)
	end
	for _,v in pairs(self.debugMenu) do
		v:SetVisible(self.debugMode)
	end

	selectDebug:SetVisible(self.debugMode)
	
	local count, uType = unitManager:selectedType()

	local text = {{0,0,0,150}, "No units selected"}
	if (count > 0) then	
		if not (uType == "Mixed") then		
			text = {{0,0,0,255}, count.." "..uType.." Selected"}
		elseif (uType == "Mixed") then
			text = {{0,0,0,255}, count.." "..uType.." Units Selected"}
		end
		
		if uType == "Humans" then
			upgradeWorkerBtn:SetVisible(true)
			workerText:SetVisible(true)
			upgradeRangerBtn:SetVisible(true)
			rangerText:SetVisible(true)
		elseif uType == "Workers" then
			suppliesButton:SetVisible(true)
			suppliesText:SetVisible(true)
		elseif uType == "Rangers" then
			patrolButton:SetVisible(true)
			patrolText:SetVisible(true)
		end
	end
	
	selectText:SetText(text)
end

-- draw the menu
function Menu:draw()
	if self.visible then
		love.graphics.draw(self.background, 0, height-menuWidth)
			
		--[[ outline
		love.graphics.setColor(self.lineColor)
		--love.graphics.rectangle("line", self.xs+0.5, self.ys+0.5, self.xe-0.5, self.ye-0.5)
		love.graphics.rectangle("line", 0.5, height-menuWidth+0.5, width-0.5, menuWidth-0.5)]]--

		--[[ draw the buttons
		for _,v in pairs(self.buttons) do
			v:draw()
		end
		--]]
		
		--[[for _,v in pairs(self.buildingMenu) do
			v:SetVisible(self.buildingMode)
		end]]--		
		
		love.graphics.reset()
	end
end

-- building mode placement rectangle
--[[function Menu:buildingPlacement(map, viewX, viewY)
	if self.buildingMode and not(self.b_type == nil) then
		local t = map.tileSize
		
		local xw = math.floor(self.b_type / 10)
		local yw = (self.b_type % 10)
		
		local x = love.mouse.getX() + viewX
		local xRect = x - (x % t)  		-- snap to tiles
		local xMap = math.floor(x / t)
		local xMapEnd = xMap + xw - 1
		
		local y = love.mouse.getY() + viewY
		local yRect = y - (y % t)
		local yMap = math.floor(y / t)
		local yMapEnd = yMap + yw - 1
		
		-- check possible placement to set color
		if (xMapEnd >= map.width) or (yMapEnd >= map.height) or
			not(map:findBuilding(xMap, yMap) == nil) or
			not(map:findBuilding(xMap, yMapEnd) == nil) or
			not(map:findBuilding(xMapEnd, yMap) == nil) or
			not(map:findBuilding(xMapEnd, yMapEnd) == nil) then
			
			love.graphics.setColor(255, 0, 0)
		else
			love.graphics.setColor(0,200,100)
		end
		
		love.graphics.setLineWidth(1)
		love.graphics.rectangle("line", xRect, yRect, xw * t, yw * t)
	end	
end]]--

function Menu:delete()
for _,v in pairs(self.mainMenu) do
		v:Remove()
	end
	for _,v in pairs(self.debugMenu) do
		v:Remove()
	end
	--[[for _,v in pairs(self.buildingMenu) do
		v:Remove()
	end]]--
	
	textDebug:Remove()
	checkDebug:Remove()
end
