local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MUILib = {
	Language = "RU",
	Labels = {},
	SidebarEntries = {},
	Tabs = {}
}
MUILib.__index = MUILib
local Theme = {
	MainBG = Color3.fromRGB(24, 25, 33),
	SidebarBG = Color3.fromRGB(18, 19, 25),
	TopBarBG = Color3.fromRGB(20, 21, 28),
	PanelBG = Color3.fromRGB(30, 31, 40),
	Accent = Color3.fromRGB(255, 46, 105),
	ToggleOn = Color3.fromRGB(46, 255, 113),
	ToggleOff = Color3.fromRGB(255, 46, 69),
	Text = Color3.fromRGB(255, 255, 255),
	TextGray = Color3.fromRGB(130, 132, 142),
	Border = Color3.fromRGB(45, 46, 55),
	SearchBG = Color3.fromRGB(15, 16, 22)
}
local function tween(o, t, p)
	TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end
local function makeRound(gui, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = gui
end
local function getTranslated(input)
	if type(input) == "table" then
		return input[MUILib.Language] or input["EN"] or "None"
	end
	return tostring(input)
end
function MUILib:UpdateLabels()
	for _, data in pairs(self.Labels) do
		local txt = getTranslated(data.Source)
		data.Obj.Text = data.Upper and txt:upper() or txt
	end
end
function MUILib:RegisterLabel(obj, source, isUpper)
	table.insert(self.Labels, {Obj = obj, Source = source, Upper = isUpper})
	local txt = getTranslated(source)
	obj.Text = isUpper and txt:upper() or txt
end
function MUILib:CreateWindow()
	local win = {Tabs = {}}
	local screen = Instance.new("ScreenGui")
	screen.Name = "MelonityUI"
	screen.Parent = CoreGui
	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(980, 640)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.MainBG
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = screen
	makeRound(main, 8)
	local drag, start, pPos
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag, start, pPos = true, i.Position, main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
			local d = i.Position - start
			main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
	local top = Instance.new("Frame")
	top.Size = UDim2.new(1, 0, 0, 45)
	top.BackgroundColor3 = Theme.TopBarBG
	top.BorderSizePixel = 0
	top.Parent = main
	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(24, 24)
	logo.Position = UDim2.new(0, 15, 0.5, -12)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://13000639907"
	logo.ImageColor3 = Theme.Accent
	logo.Parent = top
	local searchH = Instance.new("Frame")
	searchH.Size = UDim2.fromOffset(380, 28)
	searchH.Position = UDim2.new(0, 50, 0.5, -14)
	searchH.BackgroundColor3 = Theme.SearchBG
	searchH.Parent = top
	makeRound(searchH, 4)
	local gInp = Instance.new("TextBox")
	gInp.Size = UDim2.new(1, -40, 1, 0)
	gInp.Position = UDim2.new(0, 30, 0, 0)
	gInp.BackgroundTransparency = 1
	gInp.Text = ""
	gInp.PlaceholderText = "Search"
	gInp.PlaceholderColor3 = Theme.TextGray
	gInp.TextColor3 = Theme.Text
	gInp.Font = "GothamMedium"
	gInp.TextSize = 13
	gInp.TextXAlignment = "Left"
	gInp.Parent = searchH
	local langBtn = Instance.new("TextButton")
	langBtn.Size = UDim2.new(0, 100, 0, 26)
	langBtn.Position = UDim2.new(1, -115, 0.5, -13)
	langBtn.BackgroundColor3 = Theme.SearchBG
	langBtn.Text = "🇷🇺 RU"
	langBtn.TextColor3 = Theme.TextGray
	langBtn.Font = "GothamMedium"
	langBtn.TextSize = 12
	langBtn.Parent = top
	makeRound(langBtn, 4)
	langBtn.MouseButton1Click:Connect(function()
		self.Language = (self.Language == "RU") and "EN" or "RU"
		langBtn.Text = (self.Language == "RU") and "🇷🇺 RU" or "🇺🇸 EN"
		self:UpdateLabels()
	end)
	local th = Instance.new("Frame")
	th.Size = UDim2.new(1, 0, 0, 40)
	th.Position = UDim2.new(0, 0, 0, 45)
	th.BackgroundColor3 = Theme.TopBarBG
	th.Parent = main
	Instance.new("UIListLayout", th).FillDirection = "Horizontal"
	th.UIListLayout.Padding = UDim.new(0, 20)
	th.UIListLayout.VerticalAlignment = "Center"
	Instance.new("UIPadding", th).PaddingLeft = UDim.new(0, 20)
	local sb = Instance.new("Frame")
	sb.Size = UDim2.new(0, 220, 1, -85)
	sb.Position = UDim2.new(0, 0, 0, 85)
	sb.BackgroundColor3 = Theme.SidebarBG
	sb.BorderSizePixel = 0
	sb.Parent = main
	local sideSearch = searchH:Clone()
	sideSearch.Size = UDim2.new(1, -30, 0, 26)
	sideSearch.Position = UDim2.new(0, 15, 0, 10)
	sideSearch.Parent = sb
	local ns = Instance.new("ScrollingFrame")
	ns.Size = UDim2.new(1, 0, 1, -100)
	ns.Position = UDim2.new(0, 0, 0, 45)
	ns.BackgroundTransparency = 1
	ns.BorderSizePixel = 0
	ns.ScrollBarThickness = 0
	ns.Parent = sb
	Instance.new("UIListLayout", ns).Padding = UDim.new(0, 2)
	local prof = Instance.new("Frame")
	prof.Size = UDim2.new(1, 0, 0, 60)
	prof.Position = UDim2.new(0, 0, 1, -60)
	prof.BackgroundColor3 = Theme.SearchBG
	prof.Parent = sb
	local ct = Instance.new("Frame")
	ct.Size = UDim2.new(1, -240, 1, -105)
	ct.Position = UDim2.new(0, 230, 0, 95)
	ct.BackgroundTransparency = 1
	ct.Parent = main
	sideSearch.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = sideSearch.TextBox.Text:lower()
		for _, v in pairs(self.SidebarEntries) do v.Visible = v.Name:lower():find(q) ~= nil end
	end)
	function win:AddTopTab(nameData)
		local t = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton")}
		t.P.Size = UDim2.new(1, 0, 1, 0)
		t.P.BackgroundTransparency = 1
		t.P.BorderSizePixel = 0
		t.P.Visible = false
		t.P.ScrollBarThickness = 0
		t.P.Parent = ct
		local tL = Instance.new("UIListLayout")
		tL.Padding = UDim.new(0, 15)
		tL.Parent = t.P
		tL:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() t.P.CanvasSize = UDim2.fromOffset(0, tL.AbsoluteContentSize.Y) end)
		MUILib:RegisterLabel(t.B, nameData, true)
		t.B.Size = UDim2.new(0, 0, 1, 0)
		t.B.AutomaticSize = "X"
		t.B.BackgroundTransparency = 1
		t.B.TextColor3 = Theme.TextGray
		t.B.Font = "GothamBold"
		t.B.TextSize = 11
		t.B.Parent = th
		t.B.MouseButton1Click:Connect(function()
			for _, v in pairs(self.Tabs) do v.P.Visible = false v.B.TextColor3 = Theme.TextGray end
			t.P.Visible = true t.B.TextColor3 = Theme.Accent
		end)
		table.insert(self.Tabs, t)
		if #self.Tabs == 1 then t.P.Visible = true t.B.TextColor3 = Theme.Accent end
		function t:AddSideEntry(names)
			local e = Instance.new("TextButton")
			e.Name = getTranslated(names)
			e.Size = UDim2.new(1, 0, 0, 32)
			e.BackgroundTransparency = 1
			e.TextColor3 = Theme.TextGray
			e.Font = "GothamMedium"
			e.TextSize = 13
			e.TextXAlignment = "Left"
			e.Parent = ns
			MUILib:RegisterLabel(e, names, false)
			local ind = Instance.new("Frame")
			ind.Size = UDim2.fromOffset(4, 4)
			ind.Position = UDim2.new(0, 12, 0.5, -2)
			ind.BackgroundColor3 = Theme.TextGray
			ind.Parent = e
			makeRound(ind, 2)
			e.MouseEnter:Connect(function() tween(e, 0.2, {TextColor3 = Theme.Text}) tween(ind, 0.2, {BackgroundColor3 = Theme.Accent}) end)
			e.MouseLeave:Connect(function() tween(e, 0.2, {TextColor3 = Theme.TextGray}) tween(ind, 0.2, {BackgroundColor3 = Theme.TextGray}) end)
			table.insert(MUILib.SidebarEntries, e)
			return e
		end
		function t:CreateSection(names)
			local sec = {}
			local sf = Instance.new("Frame")
			sf.Size = UDim2.new(1, 0, 0, 0)
			sf.BackgroundColor3 = Theme.PanelBG
			sf.AutomaticSize = "Y"
			sf.Parent = t.P
			makeRound(sf, 4)
			local line = Instance.new("Frame")
			line.Size = UDim2.new(0, 3, 1, 0)
			line.BackgroundColor3 = Theme.Accent
			line.BorderSizePixel = 0
			line.Parent = sf
			makeRound(line, 4)
			local lt = Instance.new("TextLabel")
			MUILib:RegisterLabel(lt, names, false)
			lt.Size = UDim2.new(1, -30, 0, 40)
			lt.Position = UDim2.new(0, 15, 0, 0)
			lt.BackgroundTransparency = 1
			lt.TextColor3 = Theme.Text
			lt.Font = "GothamBold"
			lt.TextSize = 13
			lt.TextXAlignment = "Left"
			lt.Parent = sf
			local c = Instance.new("Frame")
			c.Size = UDim2.new(1, -30, 0, 0)
			c.Position = UDim2.new(0, 20, 0, 40)
			c.AutomaticSize = "Y"
			c.BackgroundTransparency = 1
			c.Parent = sf
			Instance.new("UIListLayout", c).Padding = UDim.new(0, 10)
			function sec:AddToggle(names, default, callback)
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 26)
				r.BackgroundTransparency = 1
				r.Parent = c
				local tl = Instance.new("TextLabel")
				MUILib:RegisterLabel(tl, names, false)
				tl.Size = UDim2.new(1, -45, 1, 0)
				tl.BackgroundTransparency = 1
				tl.TextColor3 = Theme.Text
				tl.Font = "Gotham"
				tl.TextSize = 12
				tl.TextXAlignment = "Left"
				tl.Parent = r
				local bg = Instance.new("TextButton")
				bg.Size = UDim2.fromOffset(34, 18)
				bg.Position = UDim2.new(1, -34, 0.5, -9)
				bg.BackgroundColor3 = Theme.MainBG
				bg.Text = ""
				bg.Parent = r
				makeRound(bg, 9)
				local d = Instance.new("Frame")
				d.Size = UDim2.fromOffset(14, 14)
				d.Position = UDim2.new(0, 2, 0.5, -7)
				d.BackgroundColor3 = Theme.TextGray
				d.Parent = bg
				makeRound(d, 7)
				local st = default or false
				local function up()
					tween(bg, 0.2, {BackgroundColor3 = st and Theme.Accent or Theme.MainBG})
					tween(d, 0.2, {Position = st and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
					if callback then callback(st) end
				end
				bg.MouseButton1Click:Connect(function() st = not st up() end)
				up()
			end
			function sec:AddSlider(names, min, max, default, callback)
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 40)
				r.BackgroundTransparency = 1
				r.Parent = c
				local tl = Instance.new("TextLabel")
				MUILib:RegisterLabel(tl, names, false)
				tl.Size = UDim2.new(1, 0, 0, 15)
				tl.BackgroundTransparency = 1
				tl.TextColor3 = Theme.Text
				tl.Font = "Gotham"
				tl.TextSize = 12
				tl.TextXAlignment = "Left"
				tl.Parent = r
				local vL = Instance.new("TextLabel")
				vL.Text = tostring(default)
				vL.Size = UDim2.new(0, 40, 0, 20)
				vL.Position = UDim2.new(1, -40, 0.5, 0)
				vL.BackgroundColor3 = Theme.MainBG
				vL.TextColor3 = Theme.Text
				vL.Parent = r
				makeRound(vL, 4)
				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, -50, 0, 4)
				bar.Position = UDim2.new(0, 0, 0.75, 0)
				bar.BackgroundColor3 = Theme.MainBG
				bar.Parent = r
				makeRound(bar, 2)
				local fill = Instance.new("Frame")
				fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
				fill.BackgroundColor3 = Theme.Accent
				fill.Parent = bar
				makeRound(fill, 2)
				local h = Instance.new("Frame")
				h.Size = UDim2.fromOffset(12, 12)
				h.AnchorPoint = Vector2.new(0.5, 0.5)
				h.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
				h.BackgroundColor3 = Theme.Text
				h.Parent = bar
				makeRound(h, 6)
				local drag = false
				local function up(i)
					local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local v = math.floor(min + (max - min) * p)
					fill.Size = UDim2.new(p, 0, 1, 0)
					h.Position = UDim2.new(p, 0, 0.5, 0)
					vL.Text = tostring(v)
					if callback then callback(v) end
				end
				h.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
				UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then up(i) end end)
			end
			return sec
		end
		return t
	end
	return win
end
return MUILib
