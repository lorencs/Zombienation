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
	
	suppliesLabelText = loveframes.Create("text")
	suppliesLabelText:SetPos(400 - 80, height - menuWidth + 5)
	suppliesLabelText:SetText("Current Supplies: ")
	suppliesLabelText:SetVisible(false)
	
	currSuppliesText = loveframes.Create("text")
	currSuppliesText:SetPos(400 + 30, height - menuWidth + 5)
	currSuppliesText:SetText(supplies)
	currSuppliesText:SetVisible(false)
	
	-- closest worker
	closestWorkerBtn = loveframes.Create("imagebutton")
	closestWorkerBtn:SetSize(23,23)
	closestWorkerBtn:SetPos(500, height - menuWidth + 34)		
	closestWorkerBtn:SetImage(love.graphics.newImage("gui/workerbutton.png"))
	closestWorkerBtn:SetVisible(false)
	closestWorkerBtn.OnClick = function(object)
		workerPoint = unitManager:getClosestIdleWorker()
		view.x = workerPoint.x - width/2
		view.y = workerPoint.y - height/2
	end
	
	-- closest worker
	closestRangerBtn = loveframes.Create("imagebutton")
	closestRangerBtn:SetSize(23,23)
	closestRangerBtn:SetPos(500, height - menuWidth + 60)		
	closestRangerBtn:SetImage(love.graphics.newImage("gui/rangerbutton.png"))
	closestRangerBtn:SetVisible(false)
	closestRangerBtn.OnClick = function(object)
		rangerPoint = unitManager:getClosestRanger()
		view.x = rangerPoint.x - width/2
		view.y = rangerPoint.y - height/2
	end
	
	-- closest worker
	closestHumanBtn = loveframes.Create("imagebutton")
	closestHumanBtn:SetSize(23,23)
	closestHumanBtn:SetPos(500, height - menuWidth + 87)		
	closestHumanBtn:SetImage(love.graphics.newImage("gui/workerbutton.png"))
	closestHumanBtn:SetVisible(false)
	closestHumanBtn.OnClick = function(object)
		humanPoint = unitManager:getClosestHuman()
		view.x = humanPoint.x - width/2
		view.y = humanPoint.y - height/2
	end
	
	table.insert(self.mainMenu, upgradeWorkerBtn)
	table.insert(self.mainMenu, workerText)
	table.insert(self.mainMenu, upgradeRangerBtn)
	table.insert(self.mainMenu, rangerText)
	table.insert(self.mainMenu, suppliesButton)
	table.insert(self.mainMenu, suppliesText)
	table.insert(self.mainMenu, patrolButton)
	table.insert(self.mainMenu, closestWorkerBtn)
	table.insert(self.mainMenu, closestRangerBtn)
	table.insert(self.mainMenu, closestHumanBtn)
	table.insert(self.mainMenu, patrolText)
	table.insert(self.mainMenu, currSuppliesText)
	table.insert(self.mainMenu, suppliesLabelText)
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
		
	closestWorkerBtn:SetVisible(self.visible)
	closestRangerBtn:SetVisible(self.visible)
	closestHumanBtn:SetVisible(self.visible)
	suppliesLabelText:SetVisible(self.visible)
	currSuppliesText:SetVisible(self.visible)
	currSuppliesText:SetText(supplies)
	
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
