-- mui_library.lua
-- Дизайн на основе предоставленного скриншота

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
    Accent = Color3.fromRGB(255, 46, 105), -- Тот самый розовый
    TextFull = Color3.fromRGB(255, 255, 255),
    TextGray = Color3.fromRGB(130, 132, 142),
    Border = Color3.fromRGB(40, 42, 50),
    Font = Enum.Font.GothamMedium
}

local function tween(o, info, props)
    local t = TweenService:Create(o, info, props)
    t:Play()
    return t
end

local function createCorner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
end

function MUILib:CreateWindow(title)
    local screen = Instance.new("ScreenGui")
    screen.Name = "MUI_Interface"
    screen.ZIndexBehavior = Enum.ZIndexBehavior.Global
    screen.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(980, 620)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Theme.MainBG
    main.BorderSizePixel = 0
    main.Parent = screen
    createCorner(main, 6)

    -- Dragging logic
    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    -------------------------------------------------------
    -- TOP BAR
    -------------------------------------------------------
    local topBar = Instance.new("Frame")
    topBar.Size = UDim2.new(1, 0, 0, 45)
    topBar.BackgroundColor3 = Theme.TopBarBG
    topBar.BorderSizePixel = 0
    topBar.Parent = main
    createCorner(topBar, 6)

    -- Logo
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.fromOffset(24, 24)
    logo.Position = UDim2.new(0, 15, 0.5, -12)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://13000639907" -- Placeholder logo
    logo.ImageColor3 = Theme.Accent
    logo.Parent = topBar

    -- Global Search
    local gSearch = Instance.new("Frame")
    gSearch.Size = UDim2.fromOffset(350, 28)
    gSearch.Position = UDim2.new(0, 50, 0.5, -14)
    gSearch.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    gSearch.Parent = topBar
    createCorner(gSearch, 4)

    local gIcon = Instance.new("ImageLabel")
    gIcon.Size = UDim2.fromOffset(14, 14)
    gIcon.Position = UDim2.new(0, 10, 0.5, -7)
    gIcon.Image = "rbxassetid://6031154871"
    gIcon.ImageColor3 = Theme.TextGray
    gIcon.BackgroundTransparency = 1
    gIcon.Parent = gSearch

    local gInput = Instance.new("TextBox")
    gInput.Size = UDim2.new(1, -35, 1, 0)
    gInput.Position = UDim2.new(0, 30, 0, 0)
    gInput.BackgroundTransparency = 1
    gInput.Text = ""
    gInput.PlaceholderText = "Search"
    gInput.PlaceholderColor3 = Theme.TextGray
    gInput.TextColor3 = Theme.TextFull
    gInput.TextSize = 13
    gInput.Font = Theme.Font
    gInput.TextXAlignment = Enum.TextXAlignment.Left
    gInput.Parent = gSearch

    -- Right Controls (Lang, Cloud, Settings)
    local controls = Instance.new("Frame")
    controls.Size = UDim2.new(0, 200, 1, 0)
    controls.Position = UDim2.new(1, -210, 0, 0)
    controls.BackgroundTransparency = 1
    controls.Parent = topBar

    local lang = Instance.new("TextLabel")
    lang.Size = UDim2.new(0, 80, 1, 0)
    lang.Position = UDim2.new(1, -100, 0, 0)
    lang.Text = "🇷🇺 Русский  ▼"
    lang.TextColor3 = Theme.TextGray
    lang.TextSize = 12
    lang.Font = Theme.Font
    lang.BackgroundTransparency = 1
    lang.Parent = controls

    -------------------------------------------------------
    -- TABS BAR (Horizontal)
    -------------------------------------------------------
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Size = UDim2.new(1, 0, 0, 40)
    tabsContainer.Position = UDim2.new(0, 0, 0, 45)
    tabsContainer.BackgroundColor3 = Theme.TopBarBG
    tabsContainer.BorderSizePixel = 0
    tabsContainer.Parent = main

    local tabsLayout = Instance.new("UIListLayout")
    tabsLayout.FillDirection = Enum.FillDirection.Horizontal
    tabsLayout.Padding = UDim.new(0, 20)
    tabsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    tabsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabsLayout.Parent = tabsContainer

    local tabsPad = Instance.new("UIPadding")
    tabsPad.PaddingLeft = UDim.new(0, 15)
    tabsPad.Parent = tabsContainer

    -------------------------------------------------------
    -- SIDEBAR (Navigation)
    -------------------------------------------------------
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, -85)
    sidebar.Position = UDim2.new(0, 0, 0, 85)
    sidebar.BackgroundColor3 = Theme.SidebarBG
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main

    local sideTitle = Instance.new("TextLabel")
    sideTitle.Text = "Навигация"
    sideTitle.Size = UDim2.new(1, -30, 0, 30)
    sideTitle.Position = UDim2.new(0, 15, 0, 10)
    sideTitle.BackgroundTransparency = 1
    sideTitle.TextColor3 = Theme.TextFull
    sideTitle.TextSize = 15
    sideTitle.Font = Enum.Font.GothamBold
    sideTitle.TextXAlignment = Enum.TextXAlignment.Left
    sideTitle.Parent = sidebar

    local sideSearch = gSearch:Clone()
    sideSearch.Size = UDim2.new(1, -30, 0, 26)
    sideSearch.Position = UDim2.new(0, 15, 0, 45)
    sideSearch.Parent = sidebar

    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -150)
    navScroll.Position = UDim2.new(0, 0, 0, 80)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 2
    navScroll.ScrollBarImageColor3 = Theme.Accent
    navScroll.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 2)
    navLayout.Parent = navScroll

    -- Profile section
    local profile = Instance.new("Frame")
    profile.Size = UDim2.new(1, 0, 0, 60)
    profile.Position = UDim2.new(0, 0, 1, -60)
    profile.BackgroundColor3 = Color3.fromRGB(15, 16, 20)
    profile.Parent = sidebar

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(36, 36)
    avatar.Position = UDim2.new(0, 15, 0.5, -18)
    avatar.Image = "rbxassetid://13000639907"
    avatar.Parent = profile
    createCorner(avatar, 18)

    local userName = Instance.new("TextLabel")
    userName.Text = "Naeldin#306783"
    userName.Size = UDim2.new(1, -65, 0, 15)
    userName.Position = UDim2.new(0, 60, 0.5, -10)
    userName.BackgroundTransparency = 1
    userName.TextColor3 = Theme.TextFull
    userName.TextSize = 13
    userName.Font = Theme.Font
    userName.TextXAlignment = Enum.TextXAlignment.Left
    userName.Parent = profile

    -------------------------------------------------------
    -- CONTENT AREA
    -------------------------------------------------------
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -220, 1, -85)
    content.Position = UDim2.new(0, 220, 0, 85)
    content.BackgroundTransparency = 1
    content.Parent = main

    local contentScroll = Instance.new("ScrollingFrame")
    contentScroll.Size = UDim2.new(1, -20, 1, -20)
    contentScroll.Position = UDim2.new(0, 10, 0, 10)
    contentScroll.BackgroundTransparency = 1
    contentScroll.BorderSizePixel = 0
    contentScroll.CanvasSize = UDim2.new(0, 0, 2, 0)
    contentScroll.ScrollBarThickness = 0
    contentScroll.Parent = content

    local mainLayout = Instance.new("UIGridLayout")
    mainLayout.CellPadding = UDim2.fromOffset(10, 10)
    mainLayout.CellSize = UDim2.new(0.5, -5, 0, 300)
    mainLayout.Parent = contentScroll

    local window = { CurrentTab = nil, Pages = {} }

    function window:CreateTab(name, iconId)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 1, 0)
        btn.AutomaticSize = Enum.AutomaticSize.X
        btn.BackgroundTransparency = 1
        btn.Text = "   " .. name:upper()
        btn.TextColor3 = Theme.TextGray
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.Parent = tabsContainer

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.fromOffset(14, 14)
        icon.Position = UDim2.new(0, -5, 0.5, -7)
        icon.Image = "rbxassetid://" .. (iconId or "0")
        icon.BackgroundTransparency = 1
        icon.ImageColor3 = Theme.TextGray
        icon.Parent = btn

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = contentScroll

        local grid = Instance.new("UIGridLayout")
        grid.CellPadding = UDim2.fromOffset(10, 10)
        grid.CellSize = UDim2.new(0.5, -5, 0, 10)
        grid.FillDirection = Enum.FillDirection.Vertical
        grid.Parent = page

        btn.MouseButton1Click:Connect(function()
            for _, p in pairs(window.Pages) do p.Visible = false end
            page.Visible = true
            -- Update colors
            tween(btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextFull})
        end)

        table.insert(window.Pages, page)
        if #window.Pages == 1 then page.Visible = true btn.TextColor3 = Theme.TextFull end

        local tabObj = {}

        function tabObj:CreateSection(title)
            local section = Instance.new("Frame")
            section.BackgroundColor3 = Theme.PanelBG
            section.BorderSizePixel = 0
            section.AutomaticSize = Enum.AutomaticSize.Y
            section.Parent = page
            createCorner(section, 4)

            local pinkLine = Instance.new("Frame")
            pinkLine.Size = UDim2.new(0, 3, 0, 18)
            pinkLine.Position = UDim2.new(0, 0, 0, 12)
            pinkLine.BackgroundColor3 = Theme.Accent
            pinkLine.BorderSizePixel = 0
            pinkLine.Parent = section

            local sTitle = Instance.new("TextLabel")
            sTitle.Text = title
            sTitle.Size = UDim2.new(1, -20, 0, 40)
            sTitle.Position = UDim2.new(0, 12, 0, 0)
            sTitle.BackgroundTransparency = 1
            sTitle.TextColor3 = Theme.TextFull
            sTitle.TextSize = 14
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            sTitle.Parent = section

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -24, 0, 0)
            container.Position = UDim2.new(0, 12, 0, 40)
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BackgroundTransparency = 1
            container.Parent = section

            local cLayout = Instance.new("UIListLayout")
            cLayout.Padding = UDim.new(0, 8)
            cLayout.Parent = container

            local secObj = {}

            function secObj:AddToggle(text, callback)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 26)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Size = UDim2.new(1, -50, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.TextFull
                label.TextSize = 13
                label.Font = Theme.Font
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local bg = Instance.new("Frame")
                bg.Size = UDim2.new(0, 34, 0, 18)
                bg.Position = UDim2.new(1, -34, 0.5, -9)
                bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                bg.Parent = row
                createCorner(bg, 9)

                local dot = Instance.new("Frame")
                dot.Size = UDim2.fromOffset(14, 14)
                dot.Position = UDim2.new(0, 2, 0.5, -7)
                dot.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
                dot.Parent = bg
                createCorner(dot, 7)

                local state = false
                bg.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        state = not state
                        tween(bg, TweenInfo.new(0.2), {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 55)})
                        tween(dot, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                        callback(state)
                    end
                end)
            end

            function secObj:AddSlider(text, min, max, default, callback)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 45)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Text = text
                label.Size = UDim2.new(1, 0, 0, 20)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.TextFull
                label.TextSize = 13
                label.Font = Theme.Font
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local valLabel = Instance.new("TextLabel")
                valLabel.Text = tostring(default)
                valLabel.Size = UDim2.new(0, 30, 0, 20)
                valLabel.Position = UDim2.new(1, -30, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.TextColor3 = Theme.TextGray
                valLabel.TextSize = 13
                valLabel.Font = Theme.Font
                valLabel.Parent = row

                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(1, 0, 0, 4)
                bar.Position = UDim2.new(0, 0, 0, 30)
                bar.BackgroundColor3 = Color3.fromRGB(45, 46, 52)
                bar.Parent = row
                createCorner(bar, 2)

                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
                fill.BackgroundColor3 = Theme.Accent
                fill.Parent = bar
                createCorner(fill, 2)

                local handle = Instance.new("Frame")
                handle.Size = UDim2.fromOffset(12, 12)
                handle.AnchorPoint = Vector2.new(0.5, 0.5)
                handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
                handle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                handle.Parent = bar
                createCorner(handle, 6)

                local dragging = false
                local function update(input)
                    local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local val = math.floor(min + (max - min) * pos)
                    fill.Size = UDim2.new(pos, 0, 1, 0)
                    handle.Position = UDim2.new(pos, 0, 0.5, 0)
                    valLabel.Text = tostring(val)
                    callback(val)
                end

                handle.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        update(input)
                    end
                end)
            end

            return secObj
        end

        return tabObj
    end

    return window
end

-- ИСПОЛЬЗОВАНИЕ (Пример):

local Window = MUILib:CreateWindow("Melonity Roblox")

local Tab1 = Window:CreateTab("Heroes", 13000639907)
local Section1 = Tab1:CreateSection("Abaddon")

Section1:AddToggle("Авто-хил Death Coil", function(v)
    print("Toggle:", v)
end)

Section1:AddSlider("%ХП Союзника", 0, 100, 30, function(v)
    print("Slider value:", v)
end)

local Section2 = Tab1:CreateSection("Дополнительно")
Section2:AddToggle("Наносить удар из инвиза", function() end)
Section2:AddToggle("Hit & Run", function() end)

return MUILib
