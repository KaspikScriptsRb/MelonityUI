local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local MUILib = {}
MUILib.__index = MUILib
_G.MUILib = MUILib

local function tween(o, info, props)
	if not o then
		return
	end
	local t = TweenService:Create(o, info, props)
	t:Play()
	return t
end

local function createRound(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local defaultTheme = {
	Background = Color3.fromRGB(18, 20, 28),
	NavBackground = Color3.fromRGB(24, 26, 35),
	PanelBackground = Color3.fromRGB(30, 32, 42),
	PanelBorder = Color3.fromRGB(138, 178, 255),
	Accent = Color3.fromRGB(255, 73, 130),
	TextPrimary = Color3.fromRGB(235, 238, 255),
	TextSecondary = Color3.fromRGB(160, 170, 190),
	SearchBackground = Color3.fromRGB(26, 28, 38),
}

local WINDOW_SIZE = UDim2.fromOffset(960, 560)

---------------------------------------------------------------------
-- WINDOW
---------------------------------------------------------------------

function MUILib:CreateWindow(opts)
	opts = opts or {}
	local title = opts.Title or "M-UI"

	-- локализация
	local localized = {}
	local currentLang = "en"

	local function applyOne(obj)
		local info = localized[obj]
		if not info then
			return
		end
		local texts = info.Texts
		local upper = info.Upper
		local txt = texts[currentLang] or texts.en or texts.ru
		if not txt and next(texts) then
			local _, any = next(texts)
			txt = any
		end
		if type(txt) ~= "string" then
			return
		end
		if upper then
			txt = txt:upper()
		end
		obj.Text = txt
	end

	local function registerLabel(obj, texts, upper)
		if type(texts) ~= "table" then
			if type(texts) == "string" then
				obj.Text = upper and texts:upper() or texts
			end
			return
		end
		localized[obj] = {
			Texts = texts,
			Upper = upper and true or false,
		}
		applyOne(obj)
	end

	local function applyLanguage()
		for obj in pairs(localized) do
			if obj and obj.Parent then
				applyOne(obj)
			end
		end
	end

	local screen = Instance.new("ScreenGui")
	screen.Name = opts.Name or "MUILibrary"
	screen.ResetOnSpawn = false
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
	screen.Parent = game:GetService("CoreGui")

	local root = Instance.new("Frame")
	root.Name = "Root"
	root.Size = WINDOW_SIZE
	root.AnchorPoint = Vector2.new(0.5, 0.5)
	root.Position = UDim2.new(0.5, 0, 0.5, 0)
	root.BackgroundColor3 = defaultTheme.Background
	root.BorderSizePixel = 0
	root.Active = true
	root.ClipsDescendants = true
	root.Parent = screen
	createRound(root, 10)

	local rootStroke = Instance.new("UIStroke")
	rootStroke.Color = Color3.fromRGB(40, 42, 55)
	rootStroke.Thickness = 1
	rootStroke.Parent = root

	-- drag
	local dragging, dragStart, startPos
	root.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = root.Position
		end
	end)
	root.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart
			root.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-----------------------------------------------------------------
	-- TOP BAR
	-----------------------------------------------------------------
	local topBar = Instance.new("Frame")
	topBar.Name = "TopBar"
	topBar.Size = UDim2.new(1, 0, 0, 44)
	topBar.BackgroundColor3 = defaultTheme.NavBackground
	topBar.BorderSizePixel = 0
	topBar.Parent = root

	local topStroke = Instance.new("UIStroke")
	topStroke.Color = Color3.fromRGB(50, 54, 70)
	topStroke.Thickness = 1
	topStroke.Parent = topBar

	local topLayout = Instance.new("UIListLayout")
	topLayout.FillDirection = Enum.FillDirection.Horizontal
	topLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	topLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	topLayout.Padding = UDim.new(0, 8)
	topLayout.Parent = topBar

	local leftContainer = Instance.new("Frame")
	leftContainer.Size = UDim2.new(0, 220, 1, 0)
	leftContainer.BackgroundTransparency = 1
	leftContainer.Parent = topBar

	local midContainer = Instance.new("Frame")
	midContainer.Size = UDim2.new(1, -420, 1, 0)
	midContainer.BackgroundTransparency = 1
	midContainer.Parent = topBar

	local rightContainer = Instance.new("Frame")
	rightContainer.Size = UDim2.new(0, 200, 1, 0)
	rightContainer.BackgroundTransparency = 1
	rightContainer.Parent = topBar

	-----------------------------------------------------------------
	-- ICON + TITLE (LEFT)
	-----------------------------------------------------------------
	local icon = Instance.new("ImageLabel")
	icon.Name = "Logo"
	icon.Size = UDim2.fromOffset(28, 28)
	icon.Position = UDim2.new(0, 12, 0.5, -14)
	icon.BackgroundTransparency = 1
	icon.Image = "rbxassetid://75683973301629"
	icon.Parent = leftContainer

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Name = "Title"
	titleLabel.AnchorPoint = Vector2.new(0, 0.5)
	titleLabel.Position = UDim2.new(0, 50, 0.5, 0)
	titleLabel.Size = UDim2.new(1, -60, 0, 22)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Text = title
	titleLabel.TextColor3 = defaultTheme.TextPrimary
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = leftContainer

	-----------------------------------------------------------------
	-- SEARCH (CENTER)
	-----------------------------------------------------------------
	local searchHolder = Instance.new("Frame")
	searchHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	searchHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	searchHolder.Size = UDim2.new(0.85, 0, 0, 30)
	searchHolder.BackgroundColor3 = defaultTheme.SearchBackground
	searchHolder.BorderSizePixel = 0
	searchHolder.Parent = midContainer
	createRound(searchHolder, 8)

	local searchStroke = Instance.new("UIStroke")
	searchStroke.Color = Color3.fromRGB(55, 60, 80)
	searchStroke.Thickness = 1
	searchStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	searchStroke.Parent = searchHolder

	local searchIcon = Instance.new("ImageLabel")
	searchIcon.Size = UDim2.fromOffset(18, 18)
	searchIcon.Position = UDim2.new(0, 10, 0.5, -9)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Image = "rbxassetid://15999597350"
	searchIcon.ImageTransparency = 0.35
	searchIcon.Parent = searchHolder

	local searchBox = Instance.new("TextBox")
	searchBox.Name = "SearchBox"
	searchBox.Size = UDim2.new(1, -40, 1, 0)
	searchBox.Position = UDim2.new(0, 36, 0, 0)
	searchBox.BackgroundTransparency = 1
	searchBox.Font = Enum.Font.Gotham
	searchBox.PlaceholderText = "Search"
	searchBox.PlaceholderColor3 = defaultTheme.TextSecondary
	searchBox.Text = ""
	searchBox.TextColor3 = defaultTheme.TextPrimary
	searchBox.TextSize = 14
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.ClearTextOnFocus = false
	searchBox.Parent = searchHolder

	-----------------------------------------------------------------
	-- LANGUAGE DROPDOWN (RIGHT)
	-----------------------------------------------------------------
	local langButton = Instance.new("TextButton")
	langButton.Name = "LanguageButton"
	langButton.AnchorPoint = Vector2.new(1, 0.5)
	langButton.Position = UDim2.new(1, -10, 0.5, 0)
	langButton.Size = UDim2.new(0, 110, 0, 26)
	langButton.BackgroundColor3 = defaultTheme.SearchBackground
	langButton.AutoButtonColor = false
	langButton.Text = "English"
	langButton.Font = Enum.Font.Gotham
	langButton.TextSize = 13
	langButton.TextColor3 = defaultTheme.TextPrimary
	langButton.TextXAlignment = Enum.TextXAlignment.Center
	langButton.Parent = rightContainer
	createRound(langButton, 8)

	local dropIcon = Instance.new("ImageLabel")
	dropIcon.Size = UDim2.fromOffset(12, 12)
	dropIcon.AnchorPoint = Vector2.new(1, 0.5)
	dropIcon.Position = UDim2.new(1, -8, 0.5, 0)
	dropIcon.BackgroundTransparency = 1
	dropIcon.Image = "rbxassetid://6031090990"
	dropIcon.ImageColor3 = defaultTheme.TextSecondary
	dropIcon.Parent = langButton

	local langMenu = Instance.new("Frame")
	langMenu.Name = "LangMenu"
	langMenu.Visible = false
	langMenu.Size = UDim2.new(0, 110, 0, 56)
	langMenu.Position = UDim2.new(1, -10, 0, 40)
	langMenu.BackgroundColor3 = defaultTheme.NavBackground
	langMenu.BorderSizePixel = 0
	langMenu.Parent = rightContainer
	createRound(langMenu, 8)

	local lmStroke = Instance.new("UIStroke")
	lmStroke.Color = Color3.fromRGB(55, 60, 80)
	lmStroke.Thickness = 1
	lmStroke.Parent = langMenu

	local function createLangOption(text, order)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0.5, 0)
		btn.Position = UDim2.new(0, 0, (order - 1) * 0.5, 0)
		btn.BackgroundTransparency = 1
		btn.Text = text
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		btn.TextColor3 = defaultTheme.TextSecondary
		btn.AutoButtonColor = false
		btn.Parent = langMenu

		btn.MouseEnter:Connect(function()
			tween(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextColor3 = defaultTheme.TextPrimary
			})
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				TextColor3 = defaultTheme.TextSecondary
			})
		end)

		return btn
	end

	local ruBtn = createLangOption("Русский", 1)
	local enBtn = createLangOption("English", 2)

	local function setLang(code)
		currentLang = code
		if code == "ru" then
			langButton.Text = "Русский"
		else
			langButton.Text = "English"
		end
		applyLanguage()
	end

	langButton.MouseButton1Click:Connect(function()
		langMenu.Visible = not langMenu.Visible
		langMenu.ClipsDescendants = true

		if langMenu.Visible then
			langMenu.Size = UDim2.new(0, 110, 0, 0)
			tween(langMenu, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.new(0, 110, 0, 56)
			})
			tween(dropIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Rotation = 180
			})
		else
			tween(dropIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Rotation = 0
			})
		end
	end)

	ruBtn.MouseButton1Click:Connect(function()
		setLang("ru")
		langMenu.Visible = false
	end)
	enBtn.MouseButton1Click:Connect(function()
		setLang("en")
		langMenu.Visible = false
	end)

	-----------------------------------------------------------------
	-- TOP TABS BAR
	-----------------------------------------------------------------
	local topTabs = Instance.new("Frame")
	topTabs.Name = "TopTabs"
	topTabs.Size = UDim2.new(1, 0, 0, 34)
	topTabs.Position = UDim2.new(0, 0, 0, 44)
	topTabs.BackgroundColor3 = defaultTheme.NavBackground
	topTabs.BorderSizePixel = 0
	topTabs.Parent = root

	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.FillDirection = Enum.FillDirection.Horizontal
	tabsLayout.Padding = UDim.new(0, 12)
	tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	tabsLayout.Parent = topTabs

	local tabsPadding = Instance.new("UIPadding")
	tabsPadding.PaddingLeft = UDim.new(0, 16)
	tabsPadding.Parent = topTabs

	-----------------------------------------------------------------
	-- MAIN CONTENT AREA
	-----------------------------------------------------------------
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -16, 1, -44 - 34 - 12)
	content.Position = UDim2.new(0, 8, 0, 44 + 34 + 8)
	content.BackgroundColor3 = defaultTheme.Background
	content.BorderSizePixel = 0
	content.Parent = root

	local contentLayout = Instance.new("UIListLayout")
	contentLayout.FillDirection = Enum.FillDirection.Horizontal
	contentLayout.Padding = UDim.new(0, 8)
	contentLayout.Parent = content

	-----------------------------------------------------------------
	-- LEFT NAV PANEL
	-----------------------------------------------------------------
	local navPanel = Instance.new("Frame")
	navPanel.Name = "NavPanel"
	navPanel.Size = UDim2.new(0, 220, 1, 0)
	navPanel.BackgroundColor3 = defaultTheme.NavBackground
	navPanel.BorderSizePixel = 0
	navPanel.Parent = content
	createRound(navPanel, 8)

	local navStroke = Instance.new("UIStroke")
	navStroke.Color = Color3.fromRGB(36, 40, 54)
	navStroke.Thickness = 1
	navStroke.Parent = navPanel

	local navTitle = Instance.new("TextLabel")
	navTitle.Size = UDim2.new(1, -20, 0, 24)
	navTitle.Position = UDim2.new(0, 10, 0, 6)
	navTitle.BackgroundTransparency = 1
	navTitle.Font = Enum.Font.GothamSemibold
	navTitle.Text = "Навигация"
	navTitle.TextSize = 14
	navTitle.TextXAlignment = Enum.TextXAlignment.Left
	navTitle.TextColor3 = defaultTheme.TextSecondary
	navTitle.Parent = navPanel

	-- регистрируем для смены языка
	registerLabel(navTitle, {
		ru = "Навигация",
		en = "Navigation",
	}, false)

	local navSearch = searchHolder:Clone()
	navSearch.Parent = navPanel
	navSearch.Position = UDim2.new(0, 10, 0, 32)
	navSearch.Size = UDim2.new(1, -20, 0, 26)
	navSearch.SearchBox.PlaceholderText = "Search"

	local navListHolder = Instance.new("Frame")
	navListHolder.Size = UDim2.new(1, -8, 1, -70)
	navListHolder.Position = UDim2.new(0, 4, 0, 64)
	navListHolder.BackgroundTransparency = 1
	navListHolder.Parent = navPanel

	local navScroll = Instance.new("ScrollingFrame")
	navScroll.Size = UDim2.new(1, -4, 1, 0)
	navScroll.Position = UDim2.new(0, 2, 0, 0)
	navScroll.BackgroundTransparency = 1
	navScroll.BorderSizePixel = 0
	navScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 64, 80)
	navScroll.ScrollBarThickness = 4
	navScroll.Parent = navListHolder

	local navScrollLayout = Instance.new("UIListLayout")
	navScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
	navScrollLayout.Padding = UDim.new(0, 2)
	navScrollLayout.Parent = navScroll

	-- поиск по левому списку
	navSearch.SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = navSearch.SearchBox.Text:lower()
		for _, child in ipairs(navScroll:GetChildren()) do
			if child:IsA("TextButton") then
				local txt = child.Text or ""
				child.Visible = txt:lower():find(q, 1, true) ~= nil
			end
		end
	end)

	-----------------------------------------------------------------
	-- RIGHT CONTENT CONTAINER
	-----------------------------------------------------------------
	local rightContainerMain = Instance.new("Frame")
	rightContainerMain.Name = "RightContainer"
	rightContainerMain.Size = UDim2.new(1, -228, 1, 0)
	rightContainerMain.BackgroundTransparency = 1
	rightContainerMain.Parent = content

	-----------------------------------------------------------------
	-- PUBLIC WINDOW OBJECT
	-----------------------------------------------------------------
	local window = setmetatable({
		Screen = screen,
		Root = root,
		TopTabs = topTabs,
		Content = content,
		NavScroll = navScroll,
		RightContainer = rightContainerMain,
		Theme = defaultTheme,
		_tabs = {},
		_currentTab = nil,
	}, MUILib)

	function window:_registerLabel(obj, texts, upper)
		registerLabel(obj, texts, upper)
	end

	function window:SetLanguage(code)
		if code ~= "ru" and code ~= "en" then
			return
		end
		setLang(code)
	end

	-- язык по умолчанию
	setLang("en")

	return window
end

---------------------------------------------------------------------
-- TOP TABS
---------------------------------------------------------------------

function MUILib:AddTopTab(name)
	local displayText
	local upper = true

	if type(name) == "table" then
		displayText = name.en or name.ru or "TAB"
	else
		displayText = tostring(name)
	end

	local tabButton = Instance.new("TextButton")
	tabButton.Name = type(name) == "string" and name or "TopTab"
	tabButton.Size = UDim2.new(0, 0, 0, 24)
	tabButton.AutomaticSize = Enum.AutomaticSize.X
	tabButton.BackgroundTransparency = 1
	tabButton.Font = Enum.Font.GothamSemibold
	tabButton.TextSize = 13
	tabButton.TextColor3 = defaultTheme.TextSecondary
	tabButton.AutoButtonColor = false
	tabButton.Parent = self.TopTabs

	-- локализация текста вкладки
	if self._registerLabel and type(name) == "table" then
		self:_registerLabel(tabButton, name, true)
		-- applyOne уже поставит текст
	else
		tabButton.Text = displayText:upper()
	end

	local page = Instance.new("Frame")
	page.Name = "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = self.RightContainer

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, 10)
	layout.Parent = page

	local tab = {
		Name = displayText,
		Button = tabButton,
		Page = page,
		Layout = layout,
		Sections = {},
		Owner = self,
	}

	local function select()
		if self._currentTab and self._currentTab ~= tab then
			self._currentTab.Button.TextColor3 = defaultTheme.TextSecondary
			self._currentTab.Page.Visible = false
		end
		self._currentTab = tab
		tabButton.TextColor3 = defaultTheme.Accent
		page.Visible = true
	end

	tabButton.MouseButton1Click:Connect(select)

	if not self._currentTab then
		select()
	end

	table.insert(self._tabs, tab)

	function tab:AddSideEntry(text)
		local display = text
		if type(text) == "table" then
			display = text.en or text.ru or ""
		end

		local btn = Instance.new("TextButton")
		btn.Name = type(text) == "string" and text or "SideEntry"
		btn.Size = UDim2.new(1, -4, 0, 28)
		btn.BackgroundTransparency = 1
		btn.Text = display
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 13
		btn.TextColor3 = defaultTheme.TextSecondary
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.AutoButtonColor = false
		btn.Parent = self.Owner.NavScroll

		local padding = Instance.new("UIPadding")
		padding.PaddingLeft = UDim.new(0, 10)
		padding.Parent = btn

		if self.Owner._registerLabel and type(text) == "table" then
			self.Owner:_registerLabel(btn, text, false)
		end

		btn.MouseEnter:Connect(function()
			tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.9,
				BackgroundColor3 = defaultTheme.PanelBackground,
				TextColor3 = defaultTheme.TextPrimary,
			})
		end)

		btn.MouseLeave:Connect(function()
			tween(btn, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 1,
				TextColor3 = defaultTheme.TextSecondary,
			})
		end)

		return btn
	end

	function tab:CreateSection(title)
		local display = title
		if type(title) == "table" then
			display = title.en or title.ru or ""
		end

		local sectionFrame = Instance.new("Frame")
		sectionFrame.Name = "Section"
		sectionFrame.Size = UDim2.new(0.5, -6, 0, 0)
		sectionFrame.AutomaticSize = Enum.AutomaticSize.Y
		sectionFrame.BackgroundColor3 = defaultTheme.PanelBackground
		sectionFrame.BorderSizePixel = 0
		sectionFrame.Parent = page
		createRound(sectionFrame, 8)

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(50, 54, 70)
		stroke.Thickness = 1
		stroke.Parent = sectionFrame

		-- вертикальная округлая линия на всю высоту
		local accentLine = Instance.new("Frame")
		accentLine.Name = "AccentLine"
		accentLine.Size = UDim2.new(0, 3, 1, -16)
		accentLine.Position = UDim2.new(0, 0, 0, 8)
		accentLine.BackgroundColor3 = defaultTheme.Accent
		accentLine.BorderSizePixel = 0
		accentLine.Parent = sectionFrame
		createRound(accentLine, 3)

		local titleLabel = Instance.new("TextLabel")
		titleLabel.Name = "Title"
		titleLabel.Size = UDim2.new(1, -24, 0, 24)
		titleLabel.Position = UDim2.new(0, 12, 0, 6)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Font = Enum.Font.GothamBold
		titleLabel.Text = display
		titleLabel.TextSize = 14
		titleLabel.TextColor3 = defaultTheme.TextPrimary
		titleLabel.TextXAlignment = Enum.TextXAlignment.Left
		titleLabel.Parent = sectionFrame

		if self.Owner._registerLabel and type(title) == "table" then
			self.Owner:_registerLabel(titleLabel, title, false)
		end

		local body = Instance.new("Frame")
		body.Name = "Body"
		body.Size = UDim2.new(1, -16, 1, -40)
		body.Position = UDim2.new(0, 8, 0, 36)
		body.BackgroundTransparency = 1
		body.Parent = sectionFrame

		local bodyLayout = Instance.new("UIListLayout")
		bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
		bodyLayout.Padding = UDim.new(0, 6)
		bodyLayout.Parent = body

		local section = {
			Frame = sectionFrame,
			Body = body,
		}

		function section:AddToggle(opts)
			opts = opts or {}
			local text = opts.Text or "Toggle"
			local callback = opts.Callback or function() end

			local row = Instance.new("Frame")
			row.Name = "ToggleRow"
			row.Size = UDim2.new(1, 0, 0, 24)
			row.BackgroundTransparency = 1
			row.Parent = body

			local label = Instance.new("TextLabel")
			label.Name = "Label"
			label.Size = UDim2.new(1, -52, 1, 0)
			label.Position = UDim2.new(0, 0, 0, 0)
			label.BackgroundTransparency = 1
			label.Font = Enum.Font.Gotham
			label.Text = text
			label.TextSize = 13
			label.TextColor3 = defaultTheme.TextPrimary
			label.TextXAlignment = Enum.TextXAlignment.Left
			label.Parent = row

			if self.Owner and self.Owner._registerLabel and type(text) == "table" then
				self.Owner:_registerLabel(label, text, false)
			end

			local button = Instance.new("TextButton")
			button.Name = "Switch"
			button.Size = UDim2.new(0, 40, 0, 20)
			button.Position = UDim2.new(1, -40, 0.5, -10)
			button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			button.Text = ""
			button.AutoButtonColor = false
			button.Parent = row
			createRound(button, 10)

			local dot = Instance.new("Frame")
			dot.Name = "Dot"
			dot.Size = UDim2.new(0, 16, 0, 16)
			dot.Position = UDim2.new(0, 2, 0.5, -8)
			dot.BackgroundColor3 = defaultTheme.TextPrimary
			dot.Parent = button
			createRound(dot, 8)

			local state = false

			local function set(v)
				state = v
				if state then
					tween(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = defaultTheme.Accent
					})
					tween(dot, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(1, -18, 0.5, -8)
					})
				else
					tween(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						BackgroundColor3 = Color3.fromRGB(60, 60, 60)
					})
					tween(dot, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
						Position = UDim2.new(0, 2, 0.5, -8)
					})
				end
				callback(state)
			end

			button.MouseButton1Click:Connect(function()
				set(not state)
			end)

			return {
				Set = set,
				Get = function()
					return state
				end,
			}
		end

		table.insert(self.Sections, section)

		return section
	end

	return tab
end

return MUILib
