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

local function tween(o, t, p)
	TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end

local function resolveText(text)
	if type(text) == "table" then
		return text[currentLanguage] or text["en"] or text["ru"] or ""
	elseif type(text) == "string" then
		return text
	else
		return tostring(text)
	end
end

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

function tween(o, t, p)
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
	local searchEntries = {}
	local screen = Instance.new("ScreenGui")
	screen.Name = "MelonityUI"
	screen.Parent = CoreGui

	local draggingSlider = false

	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(1100, 640)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.MainBG
	main.BorderSizePixel = 0
	main.ClipsDescendants = true
	main.Parent = screen
	round(main, 4)


	local loadingScreen = Instance.new("Frame")
	loadingScreen.Name = "LoadingScreen"
	loadingScreen.Size = UDim2.new(1, 0, 1, 0)
	loadingScreen.Position = UDim2.new(0, 0, 0, 0)
	loadingScreen.BackgroundColor3 = Theme.MainBG
	loadingScreen.BorderSizePixel = 0
	loadingScreen.Parent = main
	loadingScreen.ZIndex = 100

	local loadingLogo = Instance.new("ImageLabel")
	loadingLogo.Size = UDim2.fromOffset(48, 48)
	loadingLogo.Position = UDim2.new(0.5, -24, 0.5, -60)
	loadingLogo.BackgroundTransparency = 1
	loadingLogo.Image = "rbxassetid://75683973301629"
	loadingLogo.Parent = loadingScreen
	loadingLogo.ZIndex = 101
	round(loadingLogo, 24)

	local loadingText = Instance.new("TextLabel")
	loadingText.Size = UDim2.new(1, 0, 0, 20)
	loadingText.Position = UDim2.new(0, 0, 0.5, 0)
	loadingText.BackgroundTransparency = 1
	loadingText.Text = "Загрузка..."
	loadingText.TextColor3 = Theme.Text
	loadingText.Font = "GothamBold"
	loadingText.TextSize = 14
	loadingText.Parent = loadingScreen
	loadingText.ZIndex = 101

	local progressBg = Instance.new("Frame")
	progressBg.Size = UDim2.new(0, 200, 0, 4)
	progressBg.Position = UDim2.new(0.5, -100, 0.5, 30)
	progressBg.BackgroundColor3 = Theme.MainBG
	progressBg.BorderSizePixel = 0
	progressBg.Parent = loadingScreen
	progressBg.ZIndex = 101
	round(progressBg, 2)

	local progressFill = Instance.new("Frame")
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	progressFill.BackgroundColor3 = Theme.Accent
	progressFill.BorderSizePixel = 0
	progressFill.Parent = progressBg
	progressFill.ZIndex = 102
	round(progressFill, 2)

	-- Simulate loading progress
	spawn(function()
		for i = 1, 100 do
			progressFill.Size = UDim2.new(i / 100, 0, 1, 0)
			loadingText.Text = "Загрузка... " .. i .. "%"
			task.wait(0.02)
		end
		-- Fade out loading screen
		tween(loadingScreen, 0.3, {BackgroundTransparency = 1})
		tween(loadingLogo, 0.3, {ImageTransparency = 1})
		tween(loadingText, 0.3, {TextTransparency = 1})
		tween(progressBg, 0.3, {BackgroundTransparency = 1})
		task.delay(0.3, function()
			loadingScreen:Destroy()
		end)
	end)

	local drag, start, pPos
	main.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Разрешаем перетаскивание только при клике в зоне верхней панели,
			-- чтобы слайдеры и другие элементы не двигали всё окно
			local topLimitY = main.AbsolutePosition.Y + 45
			if i.Position.Y > topLimitY then return end
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

	-- Светлая разделительная линия между верхним интерфейсом и вкладками
	local topSeparator = Instance.new("Frame")
	topSeparator.Size = UDim2.new(1, 0, 0, 3)
	topSeparator.Position = UDim2.new(0, 0, 0, 45)
	topSeparator.BackgroundColor3 = Theme.Border
	topSeparator.BorderSizePixel = 0
	topSeparator.BackgroundTransparency = 0
	topSeparator.Parent = main

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(24, 24)
	logo.Position = UDim2.new(0, 15, 0.5, -12)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://75683973301629"
	logo.Parent = top

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -20, 0, 18)
	titleLabel.Position = UDim2.new(0, 10, 0, 12)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = (opts and opts.Title) or "Melonity"
	titleLabel.TextColor3 = Theme.Text
	titleLabel.Font = "GothamBold"
	titleLabel.TextSize = 13
	titleLabel.TextXAlignment = "Left"
	titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
	titleLabel.Parent = top

	local searchH = Instance.new("Frame")
	searchH.Size = UDim2.fromOffset(380, 28)
	searchH.Position = UDim2.new(0.5, -190, 0.5, -14)
	searchH.BackgroundColor3 = defaultTheme.SearchBackground
	searchH.Parent = top
	round(searchH, 4)

	local searchIcon = Instance.new("ImageLabel")
	searchIcon.Size = UDim2.fromOffset(20, 20)
	searchIcon.Position = UDim2.new(0, 10, 0.5, -10)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Image = "rbxassetid://107760934824733"
	searchIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
	searchIcon.Parent = searchH

	local gInp = Instance.new("TextBox")
	gInp.Size = UDim2.new(1, -10, 1, 0)
	gInp.Position = UDim2.new(0, 30, 0, 0)
	gInp.BackgroundTransparency = 1
	gInp.Text = ""
	gInp.PlaceholderText = "Search sections"
	gInp.PlaceholderColor3 = Theme.TextGray
	gInp.TextColor3 = Theme.Text
	gInp.TextTransparency = 0
	gInp.Font = "GothamBold"
	gInp.TextSize = 13
	gInp.TextXAlignment = "Left"
	gInp.TextYAlignment = "Center"
	gInp.Parent = searchH
	gInp.ClearTextOnFocus = false

	-- Окно результатов поиска секций
	local searchResults = Instance.new("Frame")
	searchResults.Size = UDim2.new(1, 0, 0, 0)
	searchResults.Position = UDim2.new(0, 0, 1, 0)
	searchResults.BackgroundColor3 = defaultTheme.SearchBackground
	searchResults.ZIndex = 100
	searchResults.BorderSizePixel = 0
	searchResults.Visible = false
	searchResults.ClipsDescendants = true
	searchResults.Parent = searchH

	local resultsLayout = Instance.new("UIListLayout")
	resultsLayout.FillDirection = Enum.FillDirection.Vertical
	resultsLayout.Padding = UDim.new(0, 2)
	resultsLayout.Parent = searchResults

	local function clearResults()
		for _, child in ipairs(searchResults:GetChildren()) do
			if child ~= resultsLayout then
				child:Destroy()
			end
		end
	end

	local function updateSearchResults()
		local query = string.lower(gInp.Text or "")
		
		-- Скрываем окно результатов поиска
		searchResults.Visible = false
		searchResults.Size = UDim2.new(1, 0, 0, 0)
		
		-- Показываем/скрываем секции в текущем табе
		if win.CurrentTab then
			for _, entry in ipairs(searchEntries) do
				if entry.tab == win.CurrentTab and entry.sectionFrame then
					local title = string.lower(entry.sectionTitle or "")
					local matches = query == "" or title:find(query, 1, true)
					entry.sectionFrame.Visible = matches
				end
			end
		end
	end

	gInp:GetPropertyChangedSignal("Text"):Connect(updateSearchResults)

	local langButton = Instance.new("TextButton")
	langButton.Size = UDim2.new(0, 120, 0, 24)
	langButton.Position = UDim2.new(1, -150, 0, 10)
	langButton.BackgroundColor3 = defaultTheme.SearchBackground
	langButton.AutoButtonColor = false
	langButton.Text = ""
	langButton.Visible = false
	langButton.Parent = top
	local langCorner = Instance.new("UICorner")
	langCorner.CornerRadius = UDim.new(0, 4)
	langCorner.Parent = langButton

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
	langMenu.Position = UDim2.new(1, -150, 0, 34)
	langMenu.BackgroundColor3 = defaultTheme.SearchBackground
	langMenu.Visible = false
	langMenu.ZIndex = 3
	langMenu.Parent = top
	local menuCorner = Instance.new("UICorner")
	menuCorner.CornerRadius = UDim.new(0, 4)
	menuCorner.Parent = langMenu

	local langSeparator = Instance.new("Frame")
	langSeparator.Size = UDim2.new(1, 0, 0, 1)
	langSeparator.Position = UDim2.new(0, 0, 0, 0)
	langSeparator.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
	langSeparator.BorderSizePixel = 0
	langSeparator.BackgroundTransparency = 0.5
	langSeparator.Parent = langMenu

	langMenu.Size = UDim2.new(0, 120, 0, 0)
	langMenu.ClipsDescendants = true

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
		b.ZIndex = 4
		b.Parent = langMenu
		
		local sep = Instance.new("Frame")
		sep.Size = UDim2.new(1, -16, 0, 1)
		sep.Position = UDim2.new(0, 8, 1, -2)
		sep.BackgroundColor3 = Color3.fromRGB(90, 90, 100)
		sep.BorderSizePixel = 0
		sep.BackgroundTransparency = 0.5
		sep.Parent = b
		
		b.MouseButton1Click:Connect(function()
			currentLanguage = code
			updateLangLabel()
			if langMenu then
				tween(langMenu, 0.3, {Size = UDim2.new(0, 120, 0, 0)})
				task.delay(0.3, function()
					if langMenu then
						langMenu.Visible = false
					end
				end)
			end
		end)
	end

	createLangOption("🇷🇺 Русский", "ru")
	createLangOption("🇬🇧 English", "en")

	local menuOpen = false
	langButton.MouseButton1Click:Connect(function()
		if langMenu then
			if langMenu.Visible then
				tween(langMenu, 0.3, {Size = UDim2.new(0, 120, 0, 0)})
				task.delay(0.3, function()
					if langMenu then
						langMenu.Visible = false
					end
				end)
			else
				langMenu.Visible = true
				tween(langMenu, 0.3, {Size = UDim2.new(0, 120, 0, 56)})
			end
		end
	end)

	local th = Instance.new("Frame")
	th.Size = UDim2.new(1, 0, 0, 36)
	th.Position = UDim2.new(0, 0, 0, 48)
	th.BackgroundColor3 = Theme.TopBarBG
	th.Parent = main
	round(th, 0)
	local tl = Instance.new("UIListLayout")
	tl.FillDirection = "Horizontal"
	tl.Padding = UDim.new(0, 20)
	tl.VerticalAlignment = "Center"
	tl.Parent = th

	local sb = Instance.new("Frame")
	sb.Size = UDim2.new(0, 220, 1, -48)
	sb.Position = UDim2.new(0, 0, 0, 48)
	sb.BackgroundColor3 = Theme.MainBG
	sb.Parent = main
	round(sb, 4)

	local navLabel = Instance.new("TextLabel")
	navLabel.Size = UDim2.new(1, -16, 0, 18)
	navLabel.Position = UDim2.new(0, 8, 0, 8)
	navLabel.BackgroundTransparency = 1
	navLabel.Text = "Навигация"
	navLabel.TextColor3 = Theme.TextGray
	navLabel.Font = "GothamBold"
	navLabel.TextSize = 11
	navLabel.TextXAlignment = "Left"
	navLabel.Parent = sb

	local ns = Instance.new("ScrollingFrame")
	ns.Size = UDim2.new(1, 0, 1, -146)
	ns.Position = UDim2.new(0, 0, 0, 30)
	ns.BackgroundTransparency = 1
	ns.BorderSizePixel = 0
	ns.ScrollBarThickness = 8
	ns.ScrollBarImageTransparency = 0.3
	ns.ScrollingDirection = Enum.ScrollingDirection.Y
	ns.CanvasSize = UDim2.new(0, 0, 0, 0)
	ns.Parent = sb
	local nsLayout = Instance.new("UIListLayout", ns)
	nsLayout.Padding = UDim.new(0, 2)

	ns:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
		ns.CanvasSize = UDim2.new(0, 0, 0, nsLayout.AbsoluteContentSize.Y)
	end)

	-- поиск по подвкладкам (героям) в навигации
	local prof = Instance.new("Frame")
	prof.Size = UDim2.new(1, -16, 0, 58)
	prof.AnchorPoint = Vector2.new(0, 1)
	prof.Position = UDim2.new(0, 8, 1, -8)
	prof.BackgroundColor3 = Theme.PanelBG
	prof.Parent = sb
	round(prof, 4)

	local sideDivider = Instance.new("Frame")
	sideDivider.Size = UDim2.new(0, 1, 1, 0)
	sideDivider.Position = UDim2.new(1, 0, 0, 0)
	sideDivider.BackgroundColor3 = Theme.Border
	sideDivider.BorderSizePixel = 0
	sideDivider.BackgroundTransparency = 0
	sideDivider.Parent = sb

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
	uN.Font = "GothamBold"
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
	ct.Size = UDim2.new(1, -220, 1, -48)
	ct.Position = UDim2.new(0, 220, 0, 48)
	ct.BackgroundTransparency = 1
	ct.Parent = main

	function win:AddTopTab(name, icon)
		local t = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton"), Window = self, CurrentSideEntry = nil}
		t.TabName = name
		t.P.Size = UDim2.new(1, -30, 1, -32)
		t.P.Position = UDim2.new(0, 15, 0, 32)
		t.P.BackgroundTransparency = 1
		t.P.BorderSizePixel = 0
		t.P.Visible = false
		-- Скролл есть, но сам скроллбар невидим
		t.P.ScrollBarThickness = 4
		t.P.ScrollBarImageTransparency = 1
		t.P.Parent = ct
		local tLayout = Instance.new("UIListLayout")
		tLayout.Padding = UDim.new(0, 12)
		tLayout.Parent = t.P
		tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() t.P.CanvasSize = UDim2.fromOffset(0, tLayout.AbsoluteContentSize.Y + 20) end)
		
		t.B.Size = UDim2.new(0, 0, 1, 0)
		t.B.AutomaticSize = "X"
		t.B.BackgroundTransparency = 1
		t.B.BorderSizePixel = 0
		t.B.Text = (icon and "   " or "") .. name:upper()
		t.B.TextColor3 = Theme.TextGray
		t.B.Font = "GothamBold"
		t.B.TextSize = 13
		t.B.Parent = th
		
		local indicator = Instance.new("Frame")
		indicator.Name = "Indicator"
		indicator.Size = UDim2.new(0, 0, 0, 3)
		indicator.Position = UDim2.new(0.5, 0, 1, -3)
		indicator.AnchorPoint = Vector2.new(0.5, 0)
		indicator.BackgroundColor3 = Theme.Accent
		indicator.BorderSizePixel = 0
		indicator.Visible = false
		indicator.Parent = t.B
		local indCorner = Instance.new("UICorner")
		indCorner.CornerRadius = UDim.new(0, 1.5)
		indCorner.Parent = indicator
		
		t.B:GetPropertyChangedSignal("TextBounds"):Connect(function()
			local bounds = t.B.TextBounds
			indicator.Size = UDim2.fromOffset(bounds.X, 3)
		end)
		
		t.B.MouseButton1Click:Connect(function()
			for _, v in pairs(self.Tabs) do 
				if v.P.Visible then
					tween(v.P, 0.15, {BackgroundTransparency = 1})
					task.delay(0.15, function()
						v.P.Visible = false
					end)
				end
				v.B.TextColor3 = Theme.TextGray
				if v.B:FindFirstChild("Indicator") then
					v.B.Indicator.Visible = false
				end
			end
			t.P.BackgroundTransparency = 1
			t.P.Visible = true 
			tween(t.P, 0.15, {BackgroundTransparency = 0})
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
		e.Name = text
		e.Size = UDim2.new(1, -8, 0, 30)
		e.Position = UDim2.new(0, 4, 0, 0)
		e.BackgroundColor3 = Theme.PanelBG
		e.BackgroundTransparency = 1
		e.Text = ""
		e.AutoButtonColor = false
		e.Parent = ns

		-- фон выбранной подвкладки
		local bg = Instance.new("Frame")
		bg.Name = "Bg"
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.Position = UDim2.new(0, 0, 0, 0)
		bg.BackgroundColor3 = Theme.PanelBG
		bg.BackgroundTransparency = 1
		bg.BorderSizePixel = 0
		bg.Parent = e
		local bgCorner = Instance.new("UICorner")
		bgCorner.CornerRadius = UDim.new(0, 6)
		bgCorner.Parent = bg

		-- круглая точка слева
		local ind = Instance.new("Frame")
		ind.Name = "Dot"
		ind.Size = UDim2.new(0, 6, 0, 6)
		ind.Position = UDim2.new(0, 10, 0.5, -3)
		ind.BackgroundColor3 = Theme.Accent
		ind.BackgroundTransparency = 1
		ind.BorderSizePixel = 0
		ind.Parent = bg
		local indCorner = Instance.new("UICorner")
		indCorner.CornerRadius = UDim.new(1, 0)
		indCorner.Parent = ind

		-- текст подвкладки
		local label = Instance.new("TextLabel")
		label.Name = "Label"
		label.Size = UDim2.new(1, -30, 1, 0)
		label.Position = UDim2.new(0, 26, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = Theme.TextGray
		label.Font = "GothamBold"
		label.TextSize = 14
		label.TextXAlignment = "Left"
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.Parent = bg

			-- Create content frame for this hero
			local contentFrame = Instance.new("Frame")
			contentFrame.Name = "Content"
			contentFrame.Size = UDim2.new(1, 0, 0, 0)
			contentFrame.AutomaticSize = "Y"
			contentFrame.BackgroundTransparency = 1
			contentFrame.Visible = false
			contentFrame.Parent = t.P
			local cfLayout = Instance.new("UIListLayout")
			cfLayout.Padding = UDim.new(0, 8)
			cfLayout.Parent = contentFrame
			local cfPadding = Instance.new("UIPadding")
			cfPadding.PaddingTop = UDim.new(0, 20)
			cfPadding.Parent = contentFrame

			local sideEntry = {}

			local function setSelected(sel)
				if sel then
					label.TextColor3 = Theme.Text
					bg.BackgroundTransparency = 0
					ind.BackgroundTransparency = 0
					contentFrame.Visible = true
				else
					label.TextColor3 = Theme.TextGray
					bg.BackgroundTransparency = 1
					ind.BackgroundTransparency = 1
					contentFrame.Visible = false
				end
			end

			e.MouseEnter:Connect(function()
				if t.CurrentSideEntry ~= e then
					tween(label, 0.15, {TextColor3 = Theme.Text})
					tween(ind, 0.15, {BackgroundTransparency = 0.5})
				end
			end)

			e.MouseLeave:Connect(function()
				if t.CurrentSideEntry ~= e then
					tween(label, 0.15, {TextColor3 = Theme.TextGray})
					tween(ind, 0.15, {BackgroundTransparency = 1})
				end
			end)

			e.MouseButton1Click:Connect(function()
				-- Сбросить старую выбранную подвкладку внутри этого таба
				if t.CurrentSideEntry and t.CurrentSideEntry ~= e then
					local oldBg = t.CurrentSideEntry:FindFirstChild("Bg")
					local oldInd = oldBg and oldBg:FindFirstChild("Dot")
					local oldLabel = oldBg and oldBg:FindFirstChild("Label")
					if oldLabel then
						tween(oldLabel, 0.15, {TextColor3 = Theme.TextGray})
					end
					if oldBg then
						tween(oldBg, 0.15, {BackgroundTransparency = 1})
					end
					if oldInd then
						tween(oldInd, 0.15, {BackgroundTransparency = 1})
					end
					local oldContent = t.CurrentSideEntry:FindFirstChild("Content")
					if oldContent then
						tween(oldContent, 0.15, {BackgroundTransparency = 1})
						task.delay(0.15, function()
							oldContent.Visible = false
						end)
					end
				end

				-- Скрыть все Content-фреймы этого таба (на случай, если что-то осталось видимым)
				for _, child in ipairs(t.P:GetChildren()) do
					if child:IsA("Frame") and child.Name == "Content" then
						child.Visible = false
					end
				end

				t.CurrentSideEntry = e
				contentFrame.BackgroundTransparency = 1
				contentFrame.Visible = true
				tween(label, 0.15, {TextColor3 = Theme.Text})
				tween(bg, 0.15, {BackgroundTransparency = 0})
				tween(ind, 0.15, {BackgroundTransparency = 0})
			end)
			if not t.CurrentSideEntry then
				for _, child in ipairs(t.P:GetChildren()) do
					if child:IsA("Frame") and child.Name == "Content" then
						child.Visible = false
					end
				end
				t.CurrentSideEntry = e
				setSelected(true)
			end
			function sideEntry:CreateSection(title)
				local sec = {}
				local sf = Instance.new("Frame")
				sf.Size = UDim2.new(1, -24, 0, 0)
				sf.AutomaticSize = "Y"
				sf.BackgroundColor3 = Theme.PanelBG
				sf.BackgroundTransparency = 0
				sf.Parent = contentFrame
				round(sf, 6)
				local l = Instance.new("Frame")
				l.Size = UDim2.new(0, 3, 1, 0)
				l.Position = UDim2.new(0, 0, 0, 0)
				l.BackgroundColor3 = Theme.Accent
				l.BorderSizePixel = 0
				l.Parent = sf
				local corner = Instance.new("UICorner")
				corner.CornerRadius = UDim.new(0, 6)
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
				lt.TextTruncate = Enum.TextTruncate.AtEnd
				lt.Parent = sf
				-- Зарегистрировать секцию в поисковом индексе
				table.insert(searchEntries, {
					tab = t,
					sectionFrame = sf,
					sectionTitle = title,
					path = string.format("%s - %s", tostring(t.TabName or ""), tostring(e.Name or "Hero"))
				})
				local c = Instance.new("Frame")
				c.Size = UDim2.new(1, -24, 0, 0)
				c.Position = UDim2.new(0, 12, 0, 40)
				c.AutomaticSize = "Y"
				c.BackgroundTransparency = 1
				c.Parent = sf
				local cl = Instance.new("UIListLayout")
				cl.Padding = UDim.new(0, 12)
				cl.Parent = c
				local cp = Instance.new("UIPadding")
				cp.PaddingTop = UDim.new(0, 8)
				cp.PaddingBottom = UDim.new(0, 12)
				cp.Parent = c

				local RIGHT_COLUMN_WIDTH = 120
				local RIGHT_COLUMN_MARGIN = 5

				function sec:AddToggle(o)
					o = o or {}
					local r = Instance.new("Frame")
					r.Size = UDim2.new(1, 0, 0, 26)
					r.BackgroundTransparency = 1
					r.Parent = c

					local label = Instance.new("TextLabel")
					label.Text = o.Text or "Toggle"
					label.Size = UDim2.new(1, -(RIGHT_COLUMN_WIDTH + RIGHT_COLUMN_MARGIN), 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Theme.Text
					label.Font = "GothamBold"
					label.TextSize = 12
					label.TextXAlignment = "Left"
					label.TextTruncate = Enum.TextTruncate.AtEnd
					label.Parent = r

					if o.SubText then
						local sub = Instance.new("TextLabel")
						sub.Size = UDim2.new(1, -(RIGHT_COLUMN_WIDTH + RIGHT_COLUMN_MARGIN), 0, 16)
						sub.Position = UDim2.new(0, 0, 0, 24)
						sub.BackgroundTransparency = 1
						sub.Text = resolveText(o.SubText)
						sub.TextColor3 = Theme.TextGray
						sub.Font = "GothamBold"
						sub.TextSize = 11
						sub.TextXAlignment = "Left"
						sub.Parent = r
						r.Size = UDim2.new(1, 0, 0, 40)
					end

					local bg = Instance.new("TextButton")
					bg.Size = UDim2.new(0, 36, 0, 18)
					bg.Position = UDim2.new(1, -(36 + RIGHT_COLUMN_MARGIN), 0.5, -9)
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

					bg.MouseButton1Click:Connect(function()
						state = not state
						update()
					end)

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

				function sec:AddCheckBox(o)
					o = o or {}
					local text = o.Text or "CheckBox"
					local default = o.Default or false
					local callback = o.Callback or function() end

					local row = Instance.new("Frame")
					row.Size = UDim2.new(1, 0, 0, 22)
					row.BackgroundTransparency = 1
					row.Parent = c

					local box = Instance.new("TextButton")
					box.Size = UDim2.fromOffset(12, 12)
					box.Position = UDim2.new(0, 0, 0.5, -6)
					box.BackgroundColor3 = Theme.MainBG
					box.AutoButtonColor = false
					box.Text = ""
					box.Parent = row
					round(box, 3)

					local stroke = addStroke(box, Theme.ToggleOff, 1.5)

					local label = Instance.new("TextLabel")
					label.Text = text
					label.Size = UDim2.new(1, -20, 1, 0)
					label.Position = UDim2.new(0, 20, 0, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Theme.Text
					label.Font = "GothamBold"
					label.TextSize = 12
					label.TextXAlignment = "Left"
					label.TextTruncate = Enum.TextTruncate.AtEnd
					label.Parent = row

					local state = default

					local function apply()
						tween(box, 0.2, {BackgroundColor3 = state and Theme.Accent or Theme.MainBG})
						tween(stroke, 0.2, {Color = state and Theme.ToggleOn or Theme.ToggleOff})
						if callback then
							callback(state)
						end
					end

					box.MouseButton1Click:Connect(function()
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

				function sec:AddSlider(o)
					o = o or {}
					local text = o.Text or "Slider"
					local min = o.Min or 0
					local max = o.Max or 100
					local default = math.clamp(o.Default or min, min, max)
					local callback = o.Callback or function() end

					local r = Instance.new("Frame")
					r.Size = UDim2.new(1, 0, 0, 30)
					r.BackgroundTransparency = 1
					r.Parent = c

					local label = Instance.new("TextLabel")
					label.Text = text
					label.Size = UDim2.new(1, -(RIGHT_COLUMN_WIDTH + RIGHT_COLUMN_MARGIN), 1, 0)
					label.BackgroundTransparency = 1
					label.TextColor3 = Theme.Text
					label.Font = "GothamBold"
					label.TextSize = 12
					label.TextXAlignment = "Left"
					label.TextTruncate = Enum.TextTruncate.AtEnd
					label.Parent = r

					local valueBg = Instance.new("Frame")
					valueBg.Size = UDim2.new(0, 40, 0, 20)
					valueBg.Position = UDim2.new(1, -10, 0.5, -10)
					valueBg.AnchorPoint = Vector2.new(1, 0)
					valueBg.BackgroundColor3 = Theme.MainBG
					valueBg.BorderSizePixel = 0
					valueBg.Parent = r
					round(valueBg, 4)

					local valueLabel = Instance.new("TextLabel")
					valueLabel.Size = UDim2.new(1, 0, 1, 0)
					valueLabel.BackgroundTransparency = 1
					valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
					valueLabel.Font = "GothamBold"
					valueLabel.TextSize = 12
					valueLabel.TextXAlignment = "Center"
					valueLabel.TextYAlignment = "Center"
					valueLabel.Parent = valueBg
					
					valueLabel:GetPropertyChangedSignal("TextBounds"):Connect(function()
						local bounds = valueLabel.TextBounds
						valueBg.Size = UDim2.fromOffset(math.max(bounds.X + 12, 40), 20)
					end)

					local bar = Instance.new("Frame")
					bar.Size = UDim2.new(1, -(RIGHT_COLUMN_WIDTH + RIGHT_COLUMN_MARGIN), 0, 4)
					bar.Position = UDim2.new(0, 0, 1, -6)
					bar.BackgroundColor3 = Theme.MainBG
					bar.BorderSizePixel = 0
					bar.Parent = r
					round(bar, 2)

					local fill = Instance.new("Frame")
					fill.Size = UDim2.new(0, 0, 1, 0)
					fill.BackgroundColor3 = Theme.Accent
					fill.BorderSizePixel = 0
					fill.Parent = bar
					round(fill, 2)

					local knob = Instance.new("Frame")
					knob.Size = UDim2.fromOffset(10, 10)
					knob.AnchorPoint = Vector2.new(0.5, 0.5)
					knob.Position = UDim2.new(0, 0, 0.5, 0)
					knob.BackgroundColor3 = Theme.Text
					knob.BorderSizePixel = 0
					knob.Parent = bar
					round(knob, 5)

					local current = default
					local draggingSlider = false

					local function setVisual(v)
						local alpha = (v - min) / (max - min)
						alpha = math.clamp(alpha, 0, 1)
						fill.Size = UDim2.new(alpha, 0, 1, 0)
						knob.Position = UDim2.new(alpha, 0, 0.5, 0)
						valueLabel.Text = tostring(math.floor(v))
					end

					local function setValueFromX(x)
						local rel = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
						local v = min + (max - min) * rel
						current = v
						setVisual(v)
						callback(v)
					end

					local function beginDrag(input)
						draggingSlider = true
						setValueFromX(input.Position.X)
					end

					local function endDrag()
						draggingSlider = false
					end

					bar.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							beginDrag(input)
						end
					end)

					knob.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							beginDrag(input)
						end
					end)

					UserInputService.InputChanged:Connect(function(input)
						if draggingSlider and input.UserInputType == Enum.UserInputType.MouseMovement then
							setValueFromX(input.Position.X)
						end
					end)

					UserInputService.InputEnded:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							endDrag()
						end
					end)

					setVisual(current)
					callback(current)

					return {
						Set = function(v)
							current = math.clamp(v, min, max)
							setVisual(current)
							callback(current)
						end,
						Get = function()
							return current
						end,
					}
				end

				function sec:AddItemToggle(o)
					o = o or {}
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
					label.Font = "GothamBold"
					label.TextColor3 = Theme.Text
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
					label.Font = "GothamBold"
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
					button.Size = UDim2.new(0, 115, 0, 28)
					button.BackgroundColor3 = Theme.Accent
					button.Text = text
					button.TextSize = 13
					button.Font = "GothamBold"
					button.TextColor3 = Color3.fromRGB(255, 255, 255)
					button.AutoButtonColor = false
					button.TextWrapped = true
					button.TextTruncate = "AtEnd"
					button.Parent = c
					round(button, 6)
					button.MouseEnter:Connect(function()
						tween(button, 0.2, {BackgroundColor3 = Color3.fromRGB(255, 100, 150), Size = UDim2.new(0, 120, 0, 30)})
					end)
					button.MouseLeave:Connect(function()
						tween(button, 0.2, {BackgroundColor3 = Theme.Accent, Size = UDim2.new(0, 115, 0, 28)})
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
					label.Font = "GothamBold"
					label.TextSize = 13
					label.TextXAlignment = "Left"
					label.Parent = row

					if o.SubText then
						local sub = Instance.new("TextLabel")
						sub.Size = UDim2.new(1, -(RIGHT_COLUMN_WIDTH + RIGHT_COLUMN_MARGIN), 0, 16)
						sub.Position = UDim2.new(0, 0, 0, 24)
						sub.BackgroundTransparency = 1
						sub.Text = resolveText(o.SubText)
						sub.TextColor3 = Theme.TextGray
						sub.Font = "GothamBold"
						sub.TextSize = 11
						sub.TextXAlignment = "Left"
						sub.Parent = row
						row.Size = UDim2.new(1, 0, 0, 40)
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

					local capturing = false
					local captureConn

					btn.MouseButton1Click:Connect(function()
						if capturing then
							capturing = false
							if captureConn then captureConn:Disconnect() end
							btn.Text = key and key.Name or "None"
							resizeForText()
							return
						end
						capturing = true
						btn.Text = "..."
						resizeForText()
						if captureConn then captureConn:Disconnect() end
						captureConn = UserInputService.InputBegan:Connect(function(input, gp)
							if gp then return end
							if input.KeyCode == Enum.KeyCode.Escape then
								capturing = false
								key = nil
								btn.Text = "None"
								resizeForText()
								captureConn:Disconnect()
								return
							end
							if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode ~= Enum.KeyCode.Unknown then
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
						if key and input.KeyCode == key then
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
					label.Font = "GothamBold"
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
					box.Font = "GothamBold"
					box.TextSize = 12
					box.TextXAlignment = "Center"
					box.TextYAlignment = "Center"
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

			return sideEntry
		end

		return t
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
	frame.Size = UDim2.fromOffset(320, 90)
	frame.AnchorPoint = Vector2.new(1, 1)
	frame.Position = UDim2.new(1, -20, 1, -20)
	frame.BackgroundColor3 = defaultTheme.PanelBackground
	frame.BorderSizePixel = 0
	frame.Parent = screen
	round(frame, 12)

	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(1, 6, 1, 6)
	shadow.Position = UDim2.new(0, -3, 0, -3)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.85
	shadow.BorderSizePixel = 0
	shadow.ZIndex = -1
	shadow.Parent = frame
	round(shadow, 12)

	local accentBar = Instance.new("Frame")
	accentBar.Size = UDim2.new(0, 0, 0, 0)
	accentBar.Position = UDim2.new(0, 0, 0, 0)
	accentBar.BackgroundColor3 = defaultTheme.Accent
	accentBar.BorderSizePixel = 0
	accentBar.Parent = frame
	round(accentBar, 2)

	local logo = Instance.new("ImageLabel")
	logo.Size = UDim2.fromOffset(40, 40)
	logo.Position = UDim2.new(0, 16, 0.5, -20)
	logo.BackgroundTransparency = 1
	logo.Image = "rbxassetid://75683973301629"
	logo.Parent = frame
	round(logo, 20)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -72, 0, 22)
	titleLabel.Position = UDim2.new(0, 68, 0, 16)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = "GothamBold"
	titleLabel.Text = title
	titleLabel.TextSize = 15
	titleLabel.TextColor3 = defaultTheme.TextPrimary
	titleLabel.TextXAlignment = "Left"
	titleLabel.TextTruncate = "AtEnd"
	titleLabel.Parent = frame

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, -72, 1, -42)
	textLabel.Position = UDim2.new(0, 68, 0, 40)
	textLabel.BackgroundTransparency = 1
	textLabel.Font = "Gotham"
	textLabel.TextWrapped = true
	textLabel.Text = text
	textLabel.TextSize = 13
	textLabel.TextColor3 = defaultTheme.TextSecondary
	textLabel.TextXAlignment = "Left"
	textLabel.TextYAlignment = "Top"
	textLabel.TextTruncate = "AtEnd"
	textLabel.Parent = frame

	local progress = Instance.new("Frame")
	progress.Size = UDim2.new(1, -20, 0, 4)
	progress.Position = UDim2.new(0, 10, 1, -10)
	progress.BackgroundColor3 = defaultTheme.Accent
	progress.BorderSizePixel = 0
	progress.Parent = frame
	round(progress, 2)

	frame.Size = UDim2.fromOffset(320, 90)
	frame.BackgroundTransparency = 1
	frame.Size = UDim2.fromOffset(0, 90)
	tween(frame, 0.4, {Size = UDim2.fromOffset(320, 90), BackgroundTransparency = 0, Position = UDim2.new(1, -20, 1, -20)})

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
		tween(frame, 0.4, {Size = UDim2.fromOffset(0, 90), BackgroundTransparency = 1, Position = UDim2.new(1, -20, 1, 20)})
		tween(shadow, 0.4, {BackgroundTransparency = 1})
		tween(accentBar, 0.4, {BackgroundTransparency = 1})
		tween(logo, 0.4, {ImageTransparency = 1})
		tween(titleLabel, 0.4, {TextTransparency = 1})
		tween(textLabel, 0.4, {TextTransparency = 1})
		tween(progress, 0.4, {BackgroundTransparency = 1})
		task.delay(0.45, function()
			if screen then
				screen:Destroy()
			end
		end)
	end)
end

return MUILib 
