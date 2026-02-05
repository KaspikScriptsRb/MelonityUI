local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MUILib = {}
MUILib.__index = MUILib
local Theme = {
	MainBG = Color3.fromRGB(24, 25, 32),
	SidebarBG = Color3.fromRGB(18, 19, 24),
	TopBarBG = Color3.fromRGB(20, 21, 27),
	PanelBG = Color3.fromRGB(30, 31, 38),
	Accent = Color3.fromRGB(255, 46, 105),
	Text = Color3.fromRGB(255, 255, 255),
	TextGray = Color3.fromRGB(130, 132, 142),
	Border = Color3.fromRGB(40, 42, 50),
	SearchBG = Color3.fromRGB(15, 16, 20)
}
local function tween(o, t, p)
	TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end
local function round(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
	return c
end
function MUILib:CreateWindow(opts)
	local screen = Instance.new("ScreenGui")
	screen.Name = "MelonityUI"
	screen.Parent = CoreGui
	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(980, 620)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.MainBG
	main.BorderSizePixel = 0
	main.Parent = screen
	round(main, 6)
	local drag, start, pPos
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			start = i.Position
			pPos = main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - start
			main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
	end)
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 45)
	topBar.BackgroundColor3 = Theme.TopBarBG
	topBar.BorderSizePixel = 0
	topBar.Parent = main
	round(topBar, 6)
	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(24, 24)
	logo.Position = UDim2.new(0, 15, 0.5, -12)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://13000639907"
	logo.ImageColor3 = Theme.Accent
	logo.Parent = topBar
	local gSearch = Instance.new("Frame")
	gSearch.Size = UDim2.fromOffset(350, 28)
	gSearch.Position = UDim2.new(0, 50, 0.5, -14)
	gSearch.BackgroundColor3 = Theme.SearchBG
	gSearch.Parent = topBar
	round(gSearch, 4)
	local si = Instance.new("ImageLabel")
	si.Size = UDim2.fromOffset(14, 14)
	si.Position = UDim2.new(0, 10, 0.5, -7)
	si.Image = "rbxassetid://6031154871"
	si.ImageColor3 = Theme.TextGray
	si.BackgroundTransparency = 1
	si.Parent = gSearch
	local gInp = Instance.new("TextBox")
	gInp.Size = UDim2.new(1, -35, 1, 0)
	gInp.Position = UDim2.new(0, 30, 0, 0)
	gInp.BackgroundTransparency = 1
	gInp.Text = ""
	gInp.PlaceholderText = "Search"
	gInp.PlaceholderColor3 = Theme.TextGray
	gInp.TextColor3 = Theme.Text
	gInp.TextSize = 13
	gInp.Font = Enum.Font.GothamMedium
	gInp.TextXAlignment = Enum.TextXAlignment.Left
	gInp.Parent = gSearch
	local tabsHolder = Instance.new("Frame")
	tabsHolder.Size = UDim2.new(1, 0, 0, 40)
	tabsHolder.Position = UDim2.new(0, 0, 0, 45)
	tabsHolder.BackgroundColor3 = Theme.TopBarBG
	tabsHolder.BorderSizePixel = 0
	tabsHolder.Parent = main
	local tLayout = Instance.new("UIListLayout")
	tLayout.FillDirection = "Horizontal"
	tLayout.Padding = UDim.new(0, 20)
	tLayout.VerticalAlignment = "Center"
	tLayout.Parent = tabsHolder
	Instance.new("UIPadding", tabsHolder).PaddingLeft = UDim.new(0, 15)
	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 220, 1, -85)
	sidebar.Position = UDim2.new(0, 0, 0, 85)
	sidebar.BackgroundColor3 = Theme.SidebarBG
	sidebar.BorderSizePixel = 0
	sidebar.Parent = main
	local navT = Instance.new("TextLabel")
	navT.Text = "Навигация"
	navT.Size = UDim2.new(1, -30, 0, 30)
	navT.Position = UDim2.new(0, 15, 0, 10)
	navT.BackgroundTransparency = 1
	navT.TextColor3 = Theme.Text
	navT.TextSize = 15
	navT.Font = Enum.Font.GothamBold
	navT.TextXAlignment = "Left"
	navT.Parent = sidebar
	local sideSearch = gSearch:Clone()
	sideSearch.Size = UDim2.new(1, -30, 0, 26)
	sideSearch.Position = UDim2.new(0, 15, 0, 45)
	sideSearch.Parent = sidebar
	local navScroll = Instance.new("ScrollingFrame")
	navScroll.Size = UDim2.new(1, 0, 1, -150)
	navScroll.Position = UDim2.new(0, 0, 0, 80)
	navScroll.BackgroundTransparency = 1
	navScroll.BorderSizePixel = 0
	navScroll.ScrollBarThickness = 0
	navScroll.Parent = sidebar
	Instance.new("UIListLayout", navScroll).Padding = UDim.new(0, 2)
	local profile = Instance.new("Frame")
	profile.Size = UDim2.new(1, 0, 0, 60)
	profile.Position = UDim2.new(0, 0, 1, -60)
	profile.BackgroundColor3 = Theme.SearchBG
	profile.Parent = sidebar
	local av = Instance.new("ImageLabel")
	av.Size = UDim2.fromOffset(36, 36)
	av.Position = UDim2.new(0, 15, 0.5, -18)
	av.Image = "rbxassetid://13000639907"
	av.Parent = profile
	round(av, 18)
	local uName = Instance.new("TextLabel")
	uName.Text = "Naeldin#306783"
	uName.Size = UDim2.new(1, -65, 0, 15)
	uName.Position = UDim2.new(0, 60, 0.5, -10)
	uName.BackgroundTransparency = 1
	uName.TextColor3 = Theme.Text
	uName.Font = Enum.Font.GothamMedium
	uName.TextSize = 13
	uName.TextXAlignment = "Left"
	uName.Parent = profile
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -220, 1, -85)
	content.Position = UDim2.new(0, 220, 0, 85)
	content.BackgroundTransparency = 1
	content.Parent = main
	local window = setmetatable({Tabs = {}, TabHolder = tabsHolder, Content = content, Nav = navScroll}, MUILib)
	return window
end
function MUILib:AddTopTab(name)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 0, 1, 0)
	b.AutomaticSize = "X"
	b.BackgroundTransparency = 1
	b.Text = "  " .. name:upper()
	b.TextColor3 = Theme.TextGray
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.Parent = self.TabHolder
	local p = Instance.new("ScrollingFrame")
	p.Size = UDim2.new(1, -20, 1, -20)
	p.Position = UDim2.new(0, 10, 0, 10)
	p.BackgroundTransparency = 1
	p.BorderSizePixel = 0
	p.Visible = false
	p.ScrollBarThickness = 0
	p.Parent = self.Content
	local gl = Instance.new("UIGridLayout")
	gl.CellPadding = UDim2.fromOffset(10, 10)
	gl.CellSize = UDim2.new(0.5, -5, 0, 10)
	gl.Parent = p
	gl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		p.CanvasSize = UDim2.fromOffset(0, gl.AbsoluteContentSize.Y)
	end)
	local tab = {Page = p, Main = self}
	b.MouseButton1Click:Connect(function()
		for _, t in pairs(self.Tabs) do
			t.P.Visible = false
			t.B.TextColor3 = Theme.TextGray
		end
		p.Visible = true
		b.TextColor3 = Theme.Accent
	end)
	table.insert(self.Tabs, {P = p, B = b})
	if #self.Tabs == 1 then p.Visible = true b.TextColor3 = Theme.Accent end
	function tab:AddSideEntry(text)
		local eb = Instance.new("TextButton")
		eb.Size = UDim2.new(1, 0, 0, 32)
		eb.BackgroundTransparency = 1
		eb.Text = "      " .. text
		eb.TextColor3 = Theme.TextGray
		eb.Font = Enum.Font.GothamMedium
		eb.TextSize = 13
		eb.TextXAlignment = "Left"
		eb.Parent = self.Main.Nav
		local ind = Instance.new("Frame")
		ind.Size = UDim2.fromOffset(4, 4)
		ind.Position = UDim2.new(0, 15, 0.5, -2)
		ind.BackgroundColor3 = Theme.TextGray
		ind.Parent = eb
		round(ind, 2)
		eb.MouseEnter:Connect(function()
			tween(eb, 0.2, {TextColor3 = Theme.Text})
			tween(ind, 0.2, {BackgroundColor3 = Theme.Accent})
		end)
		eb.MouseLeave:Connect(function()
			tween(eb, 0.2, {TextColor3 = Theme.TextGray})
			tween(ind, 0.2, {BackgroundColor3 = Theme.TextGray})
		end)
		return eb
	end
	function tab:CreateSection(title)
		local s = Instance.new("Frame")
		s.BackgroundColor3 = Theme.PanelBG
		s.BorderSizePixel = 0
		s.AutomaticSize = "Y"
		s.Parent = p
		round(s, 4)
		local l = Instance.new("Frame")
		l.Size = UDim2.new(0, 3, 0, 18)
		l.Position = UDim2.new(0, 0, 0, 12)
		l.BackgroundColor3 = Theme.Accent
		l.Parent = s
		local st = Instance.new("TextLabel")
		st.Text = title
		st.Size = UDim2.new(1, -20, 0, 40)
		st.Position = UDim2.new(0, 15, 0, 0)
		st.BackgroundTransparency = 1
		st.TextColor3 = Theme.Text
		st.Font = Enum.Font.GothamBold
		st.TextSize = 14
		st.TextXAlignment = "Left"
		st.Parent = s
		local c = Instance.new("Frame")
		c.Size = UDim2.new(1, -24, 0, 0)
		c.Position = UDim2.new(0, 12, 0, 40)
		c.AutomaticSize = "Y"
		c.BackgroundTransparency = 1
		c.Parent = s
		Instance.new("UIListLayout", c).Padding = UDim.new(0, 8)
		local sec = {}
		function sec:AddToggle(o)
			local r = Instance.new("Frame")
			r.Size = UDim2.new(1, 0, 0, 26)
			r.BackgroundTransparency = 1
			r.Parent = c
			local tl = Instance.new("TextLabel")
			tl.Text = o.Text
			tl.Size = UDim2.new(1, -45, 1, 0)
			tl.BackgroundTransparency = 1
			tl.TextColor3 = Theme.Text
			tl.Font = Enum.Font.Gotham
			tl.TextSize = 13
			tl.TextXAlignment = "Left"
			tl.Parent = r
			local bg = Instance.new("TextButton")
			bg.Size = UDim2.new(0, 34, 0, 18)
			bg.Position = UDim2.new(1, -34, 0.5, -9)
			bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
			bg.Text = ""
			bg.Parent = r
			round(bg, 9)
			local d = Instance.new("Frame")
			d.Size = UDim2.fromOffset(14, 14)
			d.Position = UDim2.new(0, 2, 0.5, -7)
			d.BackgroundColor3 = Theme.Text
			d.Parent = bg
			round(d, 7)
			local state = false
			bg.MouseButton1Click:Connect(function()
				state = not state
				tween(bg, 0.2, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 55)})
				tween(d, 0.2, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
				if o.Callback then o.Callback(state) end
			end)
		end
		return sec
	end
	return tab
end
_G.MUILib = MUILib
return MUILib
