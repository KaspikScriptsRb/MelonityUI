local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local MUILib = {}
MUILib.__index = MUILib

local activeNotifies = {}
local notifyOffset = 0
local notifySpacing = 85

local currentLanguage = "ru" -- "ru" or "en"

local defaultTheme = {
	Background = Color3.fromRGB(40, 42, 54),
	NavBackground = Color3.fromRGB(46, 48, 60),
	PanelBackground = Color3.fromRGB(52, 54, 70),
	PanelBorder = Color3.fromRGB(255, 80, 150),
	Accent = Color3.fromRGB(255, 80, 150),
	TextPrimary = Color3.fromRGB(245, 246, 255),
	TextSecondary = Color3.fromRGB(185, 190, 205),
	SearchBackground = Color3.fromRGB(38, 40, 52),
}

local Theme = {
	MainBG = defaultTheme.Background,
	SidebarBG = defaultTheme.NavBackground,
	TopBarBG = defaultTheme.NavBackground,
	PanelBG = defaultTheme.PanelBackground,
	Accent = defaultTheme.Accent,
	ToggleOn = Color3.fromRGB(46, 255, 113),
	ToggleOff = Color3.fromRGB(255, 46, 69),
	Text = defaultTheme.TextPrimary,
	TextGray = Color3.fromRGB(130, 132, 142),
	Border = Color3.fromRGB(45, 46, 55)
}

local function tween(o, t, p)
	TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end

local function round(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
end

local function addStroke(p, c, t)
	local s = Instance.new("UIStroke")
	s.Color = c
	s.Thickness = t
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = p
	return s
end

function MUILib:CreateWindow(opts)
	local win = {Tabs = {}, SidebarEntries = {}, CurrentTab = nil, CurrentSideEntry = nil}
	local screen = Instance.new("ScreenGui")
	screen.Name = "MelonityUI"
	screen.Parent = CoreGui

	local draggingSlider = false

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(980, 640)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.MainBG
	main.BorderSizePixel = 0
	main.Parent = screen
	round(main, 4)

	local drag, start, pPos
	main.InputBegan:Connect(function(i)
		if draggingSlider then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag = true
			start = i.Position
			pPos = main.Position
		end
	end)
	UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

	local visible = true
	local function toggleVisible()
		visible = not visible
		if visible then
			main.Visible = true
			tween(main, 0.25, {Size = UDim2.fromOffset(980, 640), BackgroundTransparency = 0})
		else
			tween(main, 0.25, {Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1})
			task.delay(0.26, function()
				main.Visible = false
			end)
		end
	end

	UserInputService.InputBegan:Connect(function(input, gp)
		if gp then return end
		if input.KeyCode == Enum.KeyCode.Insert then
			toggleVisible()
		end
	end)

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1, 0, 0, 45)
	top.BackgroundColor3 = Theme.TopBarBG
	top.Parent = main
	round(top, 4)

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(24, 24)
	logo.Position = UDim2.new(0, 15, 0.5, -12)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://75683973301629"
	logo.Parent = top

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0, 200, 0, 24)
	titleLabel.Position = UDim2.new(0, 50, 0.5, -12)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = (opts and opts.Title) or "Melonity"
	titleLabel.Font = "GothamBold"
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = Theme.Text
	titleLabel.TextXAlignment = "Left"
	titleLabel.Parent = top

	local searchH = Instance.new("Frame")
	searchH.Size = UDim2.fromOffset(380, 28)
	searchH.Position = UDim2.new(0, 50, 0.5, -14)
	searchH.BackgroundColor3 = defaultTheme.SearchBackground
	searchH.Parent = top
	round(searchH, 4)

	local gInp = Instance.new("TextBox")
	gInp.Size = UDim2.new(1, -10, 1, 0)
	gInp.Position = UDim2.new(0, 30, 0, 0)
	gInp.BackgroundTransparency = 1
	gInp.Text = ""
	gInp.PlaceholderText = "Search sections"
	gInp.PlaceholderColor3 = Theme.TextGray
	gInp.TextColor3 = Theme.Text
	gInp.Font = "GothamMedium"
	gInp.TextSize = 13
	gInp.TextXAlignment = "Left"
	gInp.Parent = searchH
	gInp.ClearTextOnFocus = false
	gInp.FocusLost:Connect(function()
		local query = string.lower(gInp.Text or "")
		for _, tab in pairs(win.Tabs) do
			if tab.P then
				for _, child in ipairs(tab.P:GetChildren()) do
					if child:IsA("Frame") then
						local label = child:FindFirstChildOfClass("TextLabel")
						local txt = label and string.lower(label.Text or "") or ""
						if query == "" or txt:find(query, 1, true) then
							child.Visible = true
						else
							child.Visible = false
						end
					end
				end
			end
		end
	end)

	local langButton = Instance.new("TextButton")
	langButton.Size = UDim2.new(0, 120, 0, 24)
	langButton.Position = UDim2.new(1, -150, 0.5, -12)
	langButton.BackgroundColor3 = defaultTheme.SearchBackground
	langButton.AutoButtonColor = false
	langButton.Text = ""
	langButton.Parent = top
	round(langButton, 4)

	local langLabel = Instance.new("TextLabel")
	langLabel.Size = UDim2.new(1, -10, 1, 0)
	langLabel.Position = UDim2.new(0, 8, 0, 0)
	langLabel.BackgroundTransparency = 1
	langLabel.TextColor3 = Theme.Text
	langLabel.Font = "GothamMedium"
	langLabel.TextSize = 12
	langLabel.TextXAlignment = "Left"
	langLabel.Parent = langButton

	local function updateLangLabel()
		if currentLanguage == "ru" then
			langLabel.Text = "🇷🇺 Русский  ▼"
		else
			langLabel.Text = "🇬🇧 English  ▼"
		end
	end
	updateLangLabel()

	local langMenu = Instance.new("Frame")
	langMenu.Size = UDim2.new(0, 120, 0, 56)
	langMenu.Position = UDim2.new(1, -150, 0, 40)
	langMenu.BackgroundColor3 = Theme.TopBarBG
	langMenu.Visible = false
	langMenu.Parent = top
	round(langMenu, 4)

	local langLayout = Instance.new("UIListLayout")
	langLayout.FillDirection = Enum.FillDirection.Vertical
	langLayout.Padding = UDim.new(0, 2)
	langLayout.Parent = langMenu

	local function createLangOption(text, code)
		local b = Instance.new("TextButton")
		b.Size = UDim2.new(1, 0, 0, 26)
		b.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		b.BackgroundTransparency = 0.8
		b.AutoButtonColor = false
		b.Font = "GothamMedium"
		b.TextSize = 12
		b.TextColor3 = Theme.Text
		b.TextXAlignment = "Left"
		b.Text = text
		b.Parent = langMenu
		b.MouseButton1Click:Connect(function()
			currentLanguage = code
			updateLangLabel()
			langMenu.Visible = false
		end)
	end

	createLangOption("🇷🇺 Русский", "ru")
	createLangOption("🇬🇧 English", "en")

	local menuOpen = false
	langButton.MouseButton1Click:Connect(function()
		menuOpen = not menuOpen
		langMenu.Visible = menuOpen
	end)

	local th = Instance.new("Frame")
	th.Size = UDim2.new(1, -16, 0, 36)
	th.Position = UDim2.new(0, 8, 0, 49)
	th.BackgroundColor3 = Theme.TopBarBG
	th.Parent = main
	round(th, 4)
	local tl = Instance.new("UIListLayout")
	tl.FillDirection = "Horizontal"
	tl.Padding = UDim.new(0, 20)
	tl.VerticalAlignment = "Center"
	tl.Parent = th
	Instance.new("UIPadding", th).PaddingLeft = UDim.new(0, 20)

	local sb = Instance.new("Frame")
	sb.Size = UDim2.new(0, 220, 1, -85)
	sb.Position = UDim2.new(0, 0, 0, 85)
	sb.BackgroundColor3 = Theme.SidebarBG
	sb.Parent = main
	round(sb, 4)

	local navT = Instance.new("TextLabel")
	navT.Text = "Навигация"
	navT.Size = UDim2.new(1, -30, 0, 40)
	navT.Position = UDim2.new(0, 15, 0, 5)
	navT.BackgroundTransparency = 1
	navT.TextColor3 = Theme.Text
	navT.Font = "GothamBold"
	navT.TextSize = 14
	navT.TextXAlignment = "Left"
	navT.Parent = sb

	local ns = Instance.new("ScrollingFrame")
	ns.Size = UDim2.new(1, 0, 1, -100)
	ns.Position = UDim2.new(0, 0, 0, 45)
	ns.BackgroundTransparency = 1
	ns.BorderSizePixel = 0
	ns.ScrollBarThickness = 0
	ns.Parent = sb
	Instance.new("UIListLayout", ns).Padding = UDim.new(0, 2)

	-- поиск по подвкладкам (героям) в навигации
	local navSearch = Instance.new("Frame")
	navSearch.Size = UDim2.new(1, -30, 0, 26)
	navSearch.Position = UDim2.new(0, 15, 0, 40)
	navSearch.BackgroundColor3 = defaultTheme.SearchBackground
	navSearch.Parent = sb
	round(navSearch, 4)
	local navBox = Instance.new("TextBox")
	navBox.Size = UDim2.new(1, -10, 1, 0)
	navBox.Position = UDim2.new(0, 5, 0, 0)
	navBox.BackgroundTransparency = 1
	navBox.Text = ""
	navBox.PlaceholderText = "Search heroes"
	navBox.PlaceholderColor3 = Theme.TextGray
	navBox.TextColor3 = Theme.Text
	navBox.Font = "GothamMedium"
	navBox.TextSize = 12
	navBox.TextXAlignment = "Left"
	navBox.ClearTextOnFocus = false
	navBox.Parent = navSearch

	navBox.FocusLost:Connect(function()
		local q = string.lower(navBox.Text or "")
		for _, child in ipairs(ns:GetChildren()) do
			if child:IsA("TextButton") then
				local txt = string.lower(child.Name or child.Text or "")
				child.Visible = (q == "" or txt:find(q, 1, true))
			end
		end
	end)

	local prof = Instance.new("Frame")
	prof.Size = UDim2.new(1, -16, 0, 58)
	prof.Position = UDim2.new(0, 8, 1, -66)
	prof.BackgroundColor3 = defaultTheme.SearchBackground
	prof.Parent = sb
	round(prof, 4)

	local av = Instance.new("ImageLabel")
	av.Size = UDim2.fromOffset(36, 36)
	av.Position = UDim2.new(0, 15, 0.5, -18)
	av.BackgroundTransparency = 1
	av.Image = "rbxassetid://13000639907"
	av.Parent = prof
	round(av, 18)

	local uN = Instance.new("TextLabel")
	uN.Text = (Players.LocalPlayer and Players.LocalPlayer.Name) or "Player"
	uN.Size = UDim2.new(1, -65, 0, 15)
	uN.Position = UDim2.new(0, 60, 0.5, -10)
	uN.BackgroundTransparency = 1
	uN.TextColor3 = Theme.Text
	uN.Font = "GothamMedium"
	uN.TextSize = 13
	uN.TextXAlignment = "Left"
	uN.Parent = prof

	local lp = Players.LocalPlayer
	if lp then
		local ok, thumb = pcall(function()
			return Players:GetUserThumbnailAsync(lp.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and thumb then
			av.Image = thumb
		end
	end

	local ct = Instance.new("Frame")
	ct.Size = UDim2.new(1, -220, 1, -85)
	ct.Position = UDim2.new(0, 220, 0, 85)
	ct.BackgroundTransparency = 1
	ct.Parent = main

	function win:AddTopTab(name, icon)
		local t = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton"), Window = self}
		t.P.Size = UDim2.new(1, -30, 1, -20)
		t.P.Position = UDim2.new(0, 15, 0, 10)
		t.P.BackgroundTransparency = 1
		t.P.BorderSizePixel = 0
		t.P.Visible = false
		t.P.ScrollBarThickness = 0
		t.P.Parent = ct
		local tLayout = Instance.new("UIListLayout")
		tLayout.Padding = UDim.new(0, 12)
		tLayout.Parent = t.P
		tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() t.P.CanvasSize = UDim2.fromOffset(0, tLayout.AbsoluteContentSize.Y) end)
		
		t.B.Size = UDim2.new(0, 0, 1, 0)
		t.B.AutomaticSize = "X"
		t.B.BackgroundTransparency = 1
		t.B.BorderSizePixel = 0
		t.B.Text = (icon and "   " or "") .. name:upper()
		t.B.TextColor3 = Theme.TextGray
		t.B.Font = "GothamBold"
		t.B.TextSize = 11
		t.B.Parent = th
		
		local indicator = Instance.new("Frame")
		indicator.Name = "Indicator"
		indicator.Size = UDim2.new(1, 0, 0, 2)
		indicator.Position = UDim2.new(0, 0, 1, -2)
		indicator.BackgroundColor3 = Theme.Accent
		indicator.BorderSizePixel = 0
		indicator.Visible = false
		indicator.Parent = t.B
		round(indicator, 1)
		
		t.B.MouseButton1Click:Connect(function()
			for _, v in pairs(self.Tabs) do 
				v.P.Visible = false 
				v.B.TextColor3 = Theme.TextGray
				if v.B:FindFirstChild("Indicator") then
					v.B.Indicator.Visible = false
				end
			end
			t.P.Visible = true 
			t.B.TextColor3 = Theme.Accent
			t.B.Indicator.Visible = true
		end)
		table.insert(self.Tabs, t)
		if #self.Tabs == 1 then 
			t.P.Visible = true 
			t.B.TextColor3 = Theme.Accent
			t.B.Indicator.Visible = true
		end

		function t:AddSideEntry(text)
			local e = Instance.new("TextButton")
			e.Name = text
			e.Size = UDim2.new(1, 0, 0, 32)
			e.BackgroundTransparency = 1
			e.Text = "      " .. text
			e.TextColor3 = Theme.TextGray
			e.Font = "GothamMedium"
			e.TextSize = 13
			e.TextXAlignment = "Left"
			e.Parent = ns
			local ind = Instance.new("Frame")
			ind.Size = UDim2.new(0, 3, 0, 18)
			ind.Position = UDim2.new(0, 8, 0.5, -9)
			ind.BackgroundColor3 = Theme.Accent
			ind.BackgroundTransparency = 1
			ind.Parent = e
			round(ind, 2)

			-- Create content frame for this hero
			local contentFrame = Instance.new("Frame")
			contentFrame.Name = "Content"
			contentFrame.Size = UDim2.new(1, 0, 0, 0)
			contentFrame.AutomaticSize = "Y"
			contentFrame.BackgroundTransparency = 1
			contentFrame.Visible = false
			contentFrame.Parent = t.P

			local function setSelected(sel)
				if sel then
					e.TextColor3 = Theme.Text
					ind.BackgroundTransparency = 0
					contentFrame.Visible = true
				else
					e.TextColor3 = Theme.TextGray
					ind.BackgroundTransparency = 1
					contentFrame.Visible = false
				end
			end

			e.MouseEnter:Connect(function()
				if win.CurrentSideEntry ~= e then
					tween(e, 0.15, {TextColor3 = Theme.Text})
				end
			end)

			e.MouseLeave:Connect(function()
				if win.CurrentSideEntry ~= e then
					tween(e, 0.15, {TextColor3 = Theme.TextGray})
				end
			end)

			e.MouseButton1Click:Connect(function()
				if win.CurrentSideEntry and win.CurrentSideEntry ~= e then
					local oldInd = win.CurrentSideEntry:FindFirstChildOfClass("Frame")
					if oldInd then
						oldInd.BackgroundTransparency = 1
					end
					local oldContent = win.CurrentSideEntry:FindFirstChild("Content")
					if oldContent then
						oldContent.Visible = false
					end
					win.CurrentSideEntry.TextColor3 = Theme.TextGray
				end
				win.CurrentSideEntry = e
				setSelected(true)
			end)

			-- first element immediately selected
			if not win.CurrentSideEntry then
				win.CurrentSideEntry = e
				setSelected(true)
			end

			-- Override CreateSection to add to this hero's content frame
				local sec = {}
				local sf = Instance.new("Frame")
				sf.Size = UDim2.new(1, 0, 0, 0)
				sf.BackgroundColor3 = Theme.PanelBG
				sf.AutomaticSize = "Y"
				sf.Parent = contentFrame
				round(sf, 4)
				local l = Instance.new("Frame")
				l.Size = UDim2.new(0, 3, 1, 0)
				l.Position = UDim2.new(0, 0, 0, 0)
				l.BackgroundColor3 = Theme.Accent
				l.Parent = sf
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 2)
				corner.Parent = l
				local lt = Instance.new("TextLabel")
				lt.Text = title
				lt.Size = UDim2.new(1, -20, 0, 40)
				lt.Position = UDim2.new(0, 15, 0, 0)
				lt.BackgroundTransparency = 1
				lt.TextColor3 = Theme.Text
				lt.Font = "GothamBold"
				lt.TextSize = 13
				lt.TextXAlignment = "Left"
				lt.Parent = sf
				local c = Instance.new("Frame")
				c.Size = UDim2.new(1, -24, 0, 0)
				c.Position = UDim2.new(0, 12, 0, 40)
				c.AutomaticSize = "Y"
				c.BackgroundTransparency = 1
				c.Parent = sf
				local cl = Instance.new("UIListLayout")
				cl.Padding = UDim.new(0, 8)
				cl.Parent = c
				local cp = Instance.new("UIPadding")
				cp.PaddingBottom = UDim.new(0, 8)
				cp.Parent = c

				function sec:AddToggle(o)
					local r = Instance.new("Frame")
					r.Size = UDim2.new(1, 0, 0, 26)
					r.BackgroundTransparency = 1
					r.Parent = c
					local label = Instance.new("TextLabel")
					label.Text = o.Text
					label.Size = UDim2.new(1, -55, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Theme.Text
					label.Font = "Gotham"
					label.TextSize = 12
					label.TextXAlignment = "Left"
					label.Parent = r

				if o.SubText then
					local sub = Instance.new("TextLabel")
					sub.Size = UDim2.new(1, -55, 0, 16)
					sub.Position = UDim2.new(0, 0, 0, 16)
					sub.BackgroundTransparency = 1
					sub.Text = resolveText(o.SubText)
					sub.TextColor3 = Theme.TextGray
					sub.Font = "GothamBold"
					sub.TextSize = 11
					sub.TextXAlignment = "Left"
					sub.Parent = r
					r.Size = UDim2.new(1, 0, 0, 34)
				end
					local bg = Instance.new("TextButton")
					bg.Size = UDim2.new(0, 36, 0, 18)
					bg.Position = UDim2.new(1, -45, 0.5, -9)
					bg.BackgroundColor3 = Theme.MainBG
					bg.Text = ""
					bg.Parent = r
					round(bg, 9)
					local dot = Instance.new("Frame")
					dot.Size = UDim2.fromOffset(14, 14)
					dot.Position = UDim2.new(0, 2, 0.5, -7)
					dot.BackgroundColor3 = Theme.TextGray
					dot.Parent = bg
					round(dot, 7)
					local state = o.Default or false
					local function update()
						tween(bg, 0.2, {BackgroundColor3 = state and Theme.Accent or Theme.MainBG})
						tween(dot, 0.2, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = state and Theme.Text or Theme.TextGray})
						if o.Callback then o.Callback(state) end
					end
					bg.MouseButton1Click:Connect(function() state = not state update() end)
					update()
					return {
						Set = function(v)
							state = v and true or false
							update()
						end,
						Get = function()
							return state
						end,
					}
				end

				function sec:AddItemToggle(o)
					if not c:FindFirstChild("Grid") then
						local g = Instance.new("Frame")
						g.Name = "Grid"
						g.Size = UDim2.new(1, -12, 0, 0)
						g.AutomaticSize = "Y"
						g.BackgroundTransparency = 1
						g.Parent = c
						local gl = Instance.new("UIGridLayout")
						gl.CellSize = UDim2.fromOffset(38, 38)
						gl.CellPadding = UDim2.fromOffset(6, 6)
						gl.Parent = g
					end
					local b = Instance.new("TextButton")
					b.BackgroundColor3 = Theme.MainBG
					b.Text = ""
					b.Parent = c.Grid
					round(b, 4)
					local s = addStroke(b, Theme.ToggleOff, 1.5)
					local img = Instance.new("ImageLabel")
					img.Size = UDim2.new(0.65, 0, 0.65, 0)
					img.Position = UDim2.new(0.175, 0, 0.175, 0)
					img.BackgroundTransparency = 1
					img.Image = o.Icon or ""
					img.Parent = b
					local state = o.Default or false

					local function apply()
						tween(s, 0.2, {Color = state and Theme.ToggleOn or Theme.ToggleOff})
						if o.Callback then o.Callback(state) end
					end

					b.MouseButton1Click:Connect(function()
						state = not state
						apply()
					end)

					apply()
					return {
						Set = function(v)
							state = v and true or false
							apply()
						end,
						Get = function()
							return state
						end,
					}
				end

				function sec:AddLabel(o)
					o = o or {}
					local text = o.Text or "Label"
					local bold = o.Bold or false
					local label = Instance.new("TextLabel")
					label.Name = "Label"
					label.Size = UDim2.new(1, -12, 0, 20)
					label.BackgroundTransparency = 1
					label.Text = text
					label.TextSize = 13
					label.TextXAlignment = "Left"
					label.Font = bold and "GothamBold" or "Gotham"
					label.TextColor3 = bold and Theme.Text or Theme.TextGray
					label.Parent = c

				if o.SubText then
					local sub = Instance.new("TextLabel")
					sub.Size = UDim2.new(1, -12, 0, 16)
					sub.Position = UDim2.new(0, 0, 0, 18)
					sub.BackgroundTransparency = 1
					sub.Text = resolveText(o.SubText)
					sub.TextColor3 = Theme.TextGray
					sub.Font = "GothamBold"
					sub.TextSize = 11
					sub.TextXAlignment = "Left"
					sub.Parent = c
					label.Size = UDim2.new(1, -12, 0, 18)
				end
					return label
				end

				function sec:AddParagraph(o)
					o = o or {}
					local text = o.Text or "Paragraph"
					local label = Instance.new("TextLabel")
					label.Name = "Paragraph"
					label.Size = UDim2.new(1, -12, 0, 0)
					label.AutomaticSize = "Y"
					label.BackgroundTransparency = 1
					label.TextWrapped = true
					label.Text = text
					label.TextSize = 12
					label.TextXAlignment = "Left"
					label.TextYAlignment = "Top"
					label.Font = "Gotham"
					label.TextColor3 = Theme.TextGray
					label.Parent = c
					return label
				end

				function sec:AddButton(o)
					o = o or {}
					local text = o.Text or "Button"
					local callback = o.Callback or function() end
					local button = Instance.new("TextButton")
					button.Name = "Button"
					button.Size = UDim2.new(0, 115, 0, 26)
					button.BackgroundColor3 = defaultTheme.SearchBackground
					button.Text = text
					button.TextSize = 13
					button.Font = "GothamSemibold"
					button.TextColor3 = Theme.Text
					button.AutoButtonColor = false
					button.Parent = c
					round(button, 4)
					button.MouseEnter:Connect(function()
						tween(button, 0.12, {BackgroundColor3 = Theme.PanelBG})
					end)
					button.MouseLeave:Connect(function()
						tween(button, 0.12, {BackgroundColor3 = defaultTheme.SearchBackground})
					end)
					button.MouseButton1Click:Connect(callback)
					return button
				end

				function sec:AddBind(o)
					o = o or {}
					local text = o.Text or "Bind"
					local key = o.DefaultKey or Enum.KeyCode.F
					local callback = o.Callback or function() end

					local row = Instance.new("Frame")
					row.Size = UDim2.new(1, 0, 0, 26)
					row.BackgroundTransparency = 1
					row.Parent = c

					local label = Instance.new("TextLabel")
					label.Text = text
					label.Size = UDim2.new(1, -85, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Theme.Text
					label.Font = "Gotham"
					label.TextSize = 13
					label.TextXAlignment = "Left"
					label.Parent = row

				if o.SubText then
					local sub = Instance.new("TextLabel")
					sub.Size = UDim2.new(1, -85, 0, 16)
					sub.Position = UDim2.new(0, 0, 0, 18)
					sub.BackgroundTransparency = 1
					sub.Text = resolveText(o.SubText)
					sub.TextColor3 = Theme.TextGray
					sub.Font = "GothamBold"
					sub.TextSize = 11
					sub.TextXAlignment = "Left"
					sub.Parent = row
					row.Size = UDim2.new(1, 0, 0, 34)
				end

					local btn = Instance.new("TextButton")
					btn.Size = UDim2.new(0, 60, 0, 20)
					btn.Position = UDim2.new(1, -65, 0.5, -10)
					btn.BackgroundColor3 = defaultTheme.SearchBackground
					btn.AutoButtonColor = false
					btn.Font = "GothamBold"
					btn.TextSize = 12
					btn.TextColor3 = Theme.Text
					btn.Text = key.Name
					btn.Parent = row
					round(btn, 4)

					local function resizeForText()
						local textLen = #btn.Text
						local w = math.clamp(40 + textLen * 6, 50, 110)
						btn.Size = UDim2.new(0, w, 0, 20)
						btn.Position = UDim2.new(1, -w, 0.5, -10)
					end
					resizeForText()

					btn.MouseEnter:Connect(function()
						tween(btn, 0.12, {BackgroundColor3 = Theme.PanelBG})
					end)
					btn.MouseLeave:Connect(function()
						tween(btn, 0.12, {BackgroundColor3 = defaultTheme.SearchBackground})
					end)

					local capturing = false
					local captureConn

					btn.MouseButton1Click:Connect(function()
						if capturing then return end
						capturing = true
						btn.Text = "..."
						resizeForText()
						if captureConn then captureConn:Disconnect() end
						captureConn = UserInputService.InputBegan:Connect(function(input, gp)
							if gp then return end
							if input.KeyCode == Enum.KeyCode.Escape then
								capturing = false
								btn.Text = key.Name
								resizeForText()
								captureConn:Disconnect()
								return
							end
							if input.KeyCode ~= Enum.KeyCode.Unknown then
								key = input.KeyCode
								btn.Text = key.Name
								resizeForText()
								capturing = false
								captureConn:Disconnect()
							end
						end)
					end)

					UserInputService.InputBegan:Connect(function(input, gp)
						if gp then return end
						if input.KeyCode == key then
							callback()
						end
					end)

					return {
						GetKey = function() return key end,
						SetKey = function(k) key = k btn.Text = key.Name end,
					}
				end

				function sec:AddTextBox(o)
					o = o or {}
					local text = o.Text or "TextBox"
					local placeholder = o.Placeholder or "Enter text..."
					local default = o.Default or ""
					local callback = o.Callback or function() end

					local r = Instance.new("Frame")
					r.Size = UDim2.new(1, 0, 0, 30)
					r.BackgroundTransparency = 1
					r.Parent = c

					local label = Instance.new("TextLabel")
					label.Text = text
					label.Size = UDim2.new(1, -120, 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Theme.Text
					label.Font = "Gotham"
					label.TextSize = 12
					label.TextXAlignment = "Left"
					label.Parent = r

					local box = Instance.new("TextBox")
					box.Size = UDim2.new(0, 115, 0, 20)
					box.Position = UDim2.new(1, -120, 0.5, -10)
					box.BackgroundColor3 = defaultTheme.SearchBackground
					box.ClearTextOnFocus = false
					box.Text = default
					box.PlaceholderText = placeholder
					box.PlaceholderColor3 = Theme.TextGray
					box.TextColor3 = Theme.Text
					box.Font = "Gotham"
					box.TextSize = 12
					box.TextXAlignment = "Left"
					box.Parent = r
					round(box, 4)

					box.FocusLost:Connect(function()
						callback(box.Text)
					end)

					return {
						Set = function(v)
							box.Text = tostring(v)
						end,
						Get = function()
							return box.Text
						end,
					}
				end

				return sec
			end

			return e
		end

		return win
	end

	return win
end

function MUILib:Notify(opts)
	opts = opts or {}
	local title = opts.Title or "Melonity"
	local text = opts.Text or "Notification"
	local duration = opts.Duration or 3

	local screen = Instance.new("ScreenGui")
	screen.Name = "MelonityNotify"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screen.Parent = CoreGui

	local frame = Instance.new("Frame")
	frame.Size = UDim2.fromOffset(280, 80)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.Position = UDim2.new(1, -20, 1, -20)
	frame.BackgroundColor3 = defaultTheme.PanelBackground
	frame.BorderSizePixel = 0
	frame.Parent = screen
	round(frame, 6)

	local stroke = Instance.new("UIStroke")
	stroke.Color = defaultTheme.Accent
	stroke.Thickness = 1
	stroke.Parent = frame

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(32, 32)
	logo.Position = UDim2.new(0, 10, 0, 10)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://75683973301629"
	logo.Parent = frame
	round(logo, 16)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -60, 0, 20)
	titleLabel.Position = UDim2.new(0, 52, 0, 10)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = "GothamBold"
	titleLabel.Text = title
	titleLabel.TextSize = 14
	titleLabel.TextColor3 = defaultTheme.TextPrimary
	titleLabel.TextXAlignment = "Left"
	titleLabel.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -60, 1, -52)
	textLabel.Position = UDim2.new(0, 52, 0, 32)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = "Gotham"
	textLabel.TextWrapped = true
	textLabel.Text = text
	textLabel.TextSize = 12
	textLabel.TextColor3 = defaultTheme.TextSecondary
	textLabel.TextXAlignment = "Left"
	textLabel.TextYAlignment = "Top"
	textLabel.Parent = frame

	local progress = Instance.new("Frame")
	progress.Size = UDim2.new(1, 0, 0, 3)
	progress.Position = UDim2.new(0, 0, 1, -3)
	progress.BackgroundColor3 = defaultTheme.Accent
	progress.BorderSizePixel = 0
	progress.Parent = frame
	round(progress, 2)

	frame.Size = UDim2.fromOffset(280, 72)
	frame.BackgroundTransparency = 1
	tween(frame, 0.3, {BackgroundTransparency = 0, Position = UDim2.new(1, -20, 1, -20)})

	local elapsed = 0
	local step = 0.03
	task.spawn(function()
		while elapsed < duration do
			task.wait(step)
			elapsed = elapsed + step
			progress.Size = UDim2.new(1 - (elapsed / duration), 0, 0, 3)
		end
	end)

	task.delay(duration, function()
		tween(frame, 0.3, {BackgroundTransparency = 1, Position = UDim2.new(1, -20, 1, 20)})
		task.delay(0.35, function()
			if screen then
				screen:Destroy()
			end
		end)
	end)
end

return MUILib
