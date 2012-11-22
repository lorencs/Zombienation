require "gui/MenuItem"

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
		
		buttons = {},
		items = {}
	}	
	
	setmetatable(object, { __index = Menu })
	return object
end

function Menu:setButtons()
	-- button positions
	local xn = self.xs + 15
	local yn = self.ys + 30
	
	-- create buttons
	b_new = Button:new(xn, yn, self.buttonWidth, self.buttonHeight,
		"New Game")
	table.insert(self.buttons, b_new)
	

end


-- draw the menu
function Menu:draw()
	-- background
	love.graphics.setColor(self.backColor)
	love.graphics.rectangle("fill", self.xs, self.ys, self.xe, self.ye)
		
	-- outline
	love.graphics.setColor(self.lineColor)
	love.graphics.rectangle("line", self.xs, self.ys, self.xe, self.ye)
	
	-- draw the buttons
	for _,v in pairs(self.buttons) do
		v:draw()
	end
	
	love.graphics.reset()
end
