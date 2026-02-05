local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local MUILib = {}
MUILib.__index = MUILib

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

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(980, 640)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.MainBG
	main.BorderSizePixel = 0
	main.Parent = screen
	round(main, 4)

	local drag, start, pPos
	main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pPos = main.Position end end)
	UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1, 0, 0, 45)
	top.BackgroundColor3 = Theme.TopBarBG
	top.Parent = main
	round(top, 4)

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
	searchH.BackgroundColor3 = defaultTheme.SearchBackground
	searchH.Parent = top
	round(searchH, 4)

	local gInp = Instance.new("TextBox")
	gInp.Size = UDim2.new(1, -10, 1, 0)
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

	local lang = Instance.new("TextLabel")
	lang.Size = UDim2.new(0, 120, 1, 0)
	lang.Position = UDim2.new(1, -150, 0, 0)
	lang.BackgroundTransparency = 1
	lang.Text = "🇷🇺 Русский  ▼"
	lang.TextColor3 = Theme.TextGray
	lang.Font = "GothamMedium"
	lang.TextSize = 12
	lang.Parent = top

	local th = Instance.new("Frame")
	th.Size = UDim2.new(1, 0, 0, 40)
	th.Position = UDim2.new(0, 0, 0, 45)
	th.BackgroundColor3 = Theme.TopBarBG
	th.Parent = main
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

	local prof = Instance.new("Frame")
	prof.Size = UDim2.new(1, 0, 0, 60)
	prof.Position = UDim2.new(0, 0, 1, -60)
	prof.BackgroundColor3 = defaultTheme.SearchBackground
	prof.Parent = sb

	local av = Instance.new("ImageLabel")
	av.Size = UDim2.fromOffset(36, 36)
	av.Position = UDim2.new(0, 15, 0.5, -18)
	av.Image = "rbxassetid://13000639907"
	av.Parent = prof
	round(av, 18)

	local uN = Instance.new("TextLabel")
	uN.Text = "Naeldin#306783"
	uN.Size = UDim2.new(1, -65, 0, 15)
	uN.Position = UDim2.new(0, 60, 0.5, -10)
	uN.BackgroundTransparency = 1
	uN.TextColor3 = Theme.Text
	uN.Font = "GothamMedium"
	uN.TextSize = 13
	uN.TextXAlignment = "Left"
	uN.Parent = prof

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
		t.B.Text = (icon and "   " or "") .. name:upper()
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

			local function setSelected(sel)
				if sel then
					e.TextColor3 = Theme.Text
					ind.BackgroundTransparency = 0
				else
					e.TextColor3 = Theme.TextGray
					ind.BackgroundTransparency = 1
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
					win.CurrentSideEntry.TextColor3 = Theme.TextGray
				end
				win.CurrentSideEntry = e
				setSelected(true)
			end)

			-- первый элемент сразу выбран
			if not win.CurrentSideEntry then
				win.CurrentSideEntry = e
				setSelected(true)
			end

			return e
		end

		function t:CreateSection(title)
			local sec = {}
			local sf = Instance.new("Frame")
			sf.Size = UDim2.new(1, 0, 0, 0)
			sf.BackgroundColor3 = Theme.PanelBG
			sf.AutomaticSize = "Y"
			sf.Parent = t.P
			round(sf, 4)
			local l = Instance.new("Frame")
			l.Size = UDim2.new(0, 3, 0, 18)
			l.Position = UDim2.new(0, 0, 0, 12)
			l.BackgroundColor3 = Theme.Accent
			l.Parent = sf
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
			cl.Padding = UDim.new(0, 10)
			cl.Parent = c

			function sec:AddToggle(o)
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 26)
				r.BackgroundTransparency = 1
				r.Parent = c
				local label = Instance.new("TextLabel")
				label.Text = o.Text
				label.Size = UDim2.new(1, -45, 1, 0)
				label.BackgroundTransparency = 1
				label.TextColor3 = Theme.Text
				label.Font = "Gotham"
				label.TextSize = 12
				label.TextXAlignment = "Left"
				label.Parent = r
				local bg = Instance.new("TextButton")
				bg.Size = UDim2.new(0, 36, 0, 18)
				bg.Position = UDim2.new(1, -36, 0.5, -9)
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
			end

			function sec:AddItemToggle(o)
				if not c:FindFirstChild("Grid") then
					local g = Instance.new("Frame")
					g.Name = "Grid"
					g.Size = UDim2.new(1, 0, 0, 0)
					g.AutomaticSize = "Y"
					g.BackgroundTransparency = 1
					g.Parent = c
					local gl = Instance.new("UIGridLayout")
					gl.CellSize = UDim2.fromOffset(40, 40)
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
				img.Size = UDim2.new(0.7, 0, 0.7, 0)
				img.Position = UDim2.new(0.15, 0, 0.15, 0)
				img.BackgroundTransparency = 1
				img.Image = o.Icon or ""
				img.Parent = b
				local state = false
				b.MouseButton1Click:Connect(function()
					state = not state
					tween(s, 0.2, {Color = state and Theme.ToggleOn or Theme.ToggleOff})
					if o.Callback then o.Callback(state) end
				end)
			end

			function sec:AddLabel(o)
				o = o or {}
				local text = o.Text or "Label"
				local bold = o.Bold or false
				local label = Instance.new("TextLabel")
				label.Name = "Label"
				label.Size = UDim2.new(1, 0, 0, 20)
				label.BackgroundTransparency = 1
				label.Text = text
				label.TextSize = 13
				label.TextXAlignment = "Left"
				label.Font = bold and "GothamBold" or "Gotham"
				label.TextColor3 = bold and Theme.Text or Theme.TextGray
				label.Parent = c
				return label
			end

			function sec:AddParagraph(o)
				o = o or {}
				local text = o.Text or "Paragraph"
				local label = Instance.new("TextLabel")
				label.Name = "Paragraph"
				label.Size = UDim2.new(1, 0, 0, 0)
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
				button.Size = UDim2.new(0, 120, 0, 26)
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
				label.Size = UDim2.new(1, -80, 1, 0)
				label.BackgroundTransparency = 1
				label.Text = text
				label.TextSize = 13
				label.TextXAlignment = "Left"
				label.Font = "Gotham"
				label.TextColor3 = Theme.Text
				label.Parent = row

				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(0, 70, 0, 20)
				btn.Position = UDim2.new(1, -70, 0.5, -10)
				btn.BackgroundColor3 = defaultTheme.SearchBackground
				btn.AutoButtonColor = false
				btn.Font = "Gotham"
				btn.TextSize = 12
				btn.TextColor3 = Theme.Text
				btn.Text = key.Name
				btn.Parent = row
				round(btn, 4)

				local capturing = false

				btn.MouseButton1Click:Connect(function()
					if capturing then return end
					capturing = true
					btn.Text = "..."
					local conn
					conn = UserInputService.InputBegan:Connect(function(input, gp)
						if gp then return end
						if input.KeyCode ~= Enum.KeyCode.Unknown then
							key = input.KeyCode
							btn.Text = key.Name
							capturing = false
							conn:Disconnect()
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

			function sec:AddSlider(o)
				o = o or {}
				local min = typeof(o.Min) == "number" and o.Min or 0
				local max = typeof(o.Max) == "number" and o.Max or 100
				if max <= min then max = min + 1 end
				local value = typeof(o.Default) == "number" and o.Default or min
				value = math.clamp(value, min, max)

				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 40)
				r.BackgroundTransparency = 1
				r.Parent = c
				local tl = Instance.new("TextLabel")
				tl.Text = o.Text or "Slider"
				tl.Size = UDim2.new(1, 0, 0, 15)
				tl.BackgroundTransparency = 1
				tl.TextColor3 = Theme.Text
				tl.Font = "Gotham"
				tl.TextSize = 12
				tl.TextXAlignment = "Left"
				tl.Parent = r
				local vL = Instance.new("TextLabel")
				vL.Text = tostring(value)
				vL.Size = UDim2.new(0, 40, 0, 20)
				vL.Position = UDim2.new(1, -40, 0.5, 0)
				vL.BackgroundColor3 = Theme.MainBG
				vL.TextColor3 = Theme.Text
				vL.Font = "Gotham"
				vL.TextSize = 11
				vL.Parent = r
				round(vL, 4)
				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, -50, 0, 4)
				bar.Position = UDim2.new(0, 0, 0.7, 0)
				bar.BackgroundColor3 = Theme.MainBG
				bar.Parent = r
				round(bar, 2)
				local fill = Instance.new("Frame")
				local startAlpha = (value - min) / (max - min)
				fill.Size = UDim2.new(startAlpha, 0, 1, 0)
				fill.BackgroundColor3 = Theme.Accent
				fill.Parent = bar
				round(fill, 2)
				local h = Instance.new("Frame")
				h.Size = UDim2.fromOffset(12, 12)
				h.AnchorPoint = Vector2.new(0.5, 0.5)
				h.Position = UDim2.new(startAlpha, 0, 0.5, 0)
				h.BackgroundColor3 = Theme.Text
				h.Parent = bar
				round(h, 6)
				local drag = false

				local function setFromAlpha(a)
					a = math.clamp(a, 0, 1)
					local v = min + (max - min) * a
					v = math.floor(v + 0.5)
					fill.Size = UDim2.new(a, 0, 1, 0)
					h.Position = UDim2.new(a, 0, 0.5, 0)
					vL.Text = tostring(v)
					if o.Callback then o.Callback(v) end
				end

				local function up(i)
					local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					setFromAlpha(p)
				end

				h.InputBegan:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						drag = true
						-- отключаем скролл таба пока двигаем слайдер
						if t.P and t.P:IsA("ScrollingFrame") then
							t.P.ScrollingEnabled = false
						end
					end
				end)
				UserInputService.InputEnded:Connect(function(i)
					if i.UserInputType == Enum.UserInputType.MouseButton1 then
						drag = false
						if t.P and t.P:IsA("ScrollingFrame") then
							t.P.ScrollingEnabled = true
						end
					end
				end)
				UserInputService.InputChanged:Connect(function(i)
					if drag and i.UserInputType == Enum.UserInputType.MouseMovement then up(i) end
				end)
			end

			return sec
		end
		return t
	end
	return win
end
return MUILib
