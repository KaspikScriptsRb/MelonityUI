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

local function tween(object, time, properties)
    local info = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(object, info, properties):Play()
end

local function makeRound(gui, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = gui
end

local function getTranslatedText(input)
    if type(input) == "table" then
        return input[MUILib.Language] or input["EN"] or "No Text"
    end
    return tostring(input)
end

function MUILib:UpdateAllLabels()
    for _, data in pairs(self.Labels) do
        local newText = getTranslatedText(data.Source)
        if data.Upper then
            data.Obj.Text = newText:upper()
        else
            data.Obj.Text = newText
        end
    end
end

function MUILib:RegisterLabel(obj, source, isUpper)
    table.insert(self.Labels, {Obj = obj, Source = source, Upper = isUpper})
    local text = getTranslatedText(source)
    obj.Text = isUpper and text:upper() or text
end

function MUILib:CreateWindow(opts)
    local win = {Tabs = {}}
    
    local screen = Instance.new("ScreenGui")
    screen.Name = "MelonityUI_Professional"
    screen.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(980, 640)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Theme.MainBG
    main.BorderSizePixel = 0
    main.ClipsDescendants = true -- Это исправляет вылет фреймов за края
    main.Parent = screen
    makeRound(main, 6)

    local drag, start, pPos
    main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            drag = true
            start = input.Position
            pPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - start
            main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + delta.X, pPos.Y.Scale, pPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
    end)

    local topHeader = Instance.new("Frame")
    topHeader.Size = UDim2.new(1, 0, 0, 45)
    topHeader.BackgroundColor3 = Theme.TopBarBG
    topHeader.BorderSizePixel = 0
    topHeader.Parent = main

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.fromOffset(24, 24)
    logo.Position = UDim2.new(0, 15, 0.5, -12)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://13000639907"
    logo.ImageColor3 = Theme.Accent
    logo.Parent = topHeader

    local langBtn = Instance.new("TextButton")
    langBtn.Size = UDim2.new(0, 100, 0, 26)
    langBtn.Position = UDim2.new(1, -115, 0.5, -13)
    langBtn.BackgroundColor3 = Theme.SearchBG
    langBtn.Text = "🇷🇺 RU"
    langBtn.TextColor3 = Theme.TextGray
    langBtn.Font = Enum.Font.GothamMedium
    langBtn.TextSize = 12
    langBtn.Parent = topHeader
    makeRound(langBtn, 4)

    langBtn.MouseButton1Click:Connect(function()
        self.Language = (self.Language == "RU") and "EN" or "RU"
        langBtn.Text = (self.Language == "RU") and "🇷🇺 RU" or "🇺🇸 EN"
        self:UpdateAllLabels()
    end)

    local tabListFrame = Instance.new("Frame")
    tabListFrame.Size = UDim2.new(1, 0, 0, 40)
    tabListFrame.Position = UDim2.new(0, 0, 0, 45)
    tabListFrame.BackgroundColor3 = Theme.TopBarBG
    tabListFrame.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 20)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabListFrame

    Instance.new("UIPadding", tabListFrame).PaddingLeft = UDim.new(0, 20)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, -85)
    sidebar.Position = UDim2.new(0, 0, 0, 85)
    sidebar.BackgroundColor3 = Theme.SidebarBG
    sidebar.BorderSizePixel = 0
    sidebar.Parent = main
    -- Закругляем только левый нижний угол через костыль или ClipsDescendants
    
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -100)
    navScroll.Position = UDim2.new(0, 0, 0, 45)
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
    makeRound(profile, 6)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -240, 1, -105)
    contentFrame.Position = UDim2.new(0, 230, 0, 95)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = main

    function win:AddTopTab(nameData)
        local tab = {Page = Instance.new("ScrollingFrame"), Button = Instance.new("TextButton")}
        
        tab.Page.Size = UDim2.new(1, 0, 1, 0)
        tab.Page.BackgroundTransparency = 1
        tab.Page.BorderSizePixel = 0
        tab.Page.Visible = false
        tab.Page.ScrollBarThickness = 0
        tab.Page.Parent = contentFrame

        local pageLayout = Instance.new("UIListLayout")
        pageLayout.Padding = UDim.new(0, 15)
        pageLayout.Parent = tab.Page
        pageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Page.CanvasSize = UDim2.fromOffset(0, pageLayout.AbsoluteContentSize.Y)
        end)

        tab.Button.Size = UDim2.new(0, 0, 1, 0)
        tab.Button.AutomaticSize = Enum.AutomaticSize.X
        tab.Button.BackgroundTransparency = 1
        tab.Button.TextColor3 = Theme.TextGray
        tab.Button.Font = Enum.Font.GothamBold
        tab.Button.TextSize = 11
        tab.Button.Parent = tabListFrame

        MUILib:RegisterLabel(tab.Button, nameData, true)

        tab.Button.MouseButton1Click:Connect(function()
            for _, v in pairs(win.Tabs) do
                v.Page.Visible = false
                v.Button.TextColor3 = Theme.TextGray
            end
            tab.Page.Visible = true
            tab.Button.TextColor3 = Theme.Accent
        end)

        table.insert(win.Tabs, tab)
        if #win.Tabs == 1 then
            tab.Page.Visible = true
            tab.Button.TextColor3 = Theme.Accent
        end

        function tab:AddSideEntry(sideNameData)
            local entry = Instance.new("TextButton")
            entry.Size = UDim2.new(1, 0, 0, 32)
            entry.BackgroundTransparency = 1
            entry.TextColor3 = Theme.TextGray
            entry.Font = Enum.Font.GothamMedium
            entry.TextSize = 13
            entry.TextXAlignment = Enum.TextXAlignment.Left
            entry.Parent = navScroll

            MUILib:RegisterLabel(entry, sideNameData, false)

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.fromOffset(4, 4)
            indicator.Position = UDim2.new(0, 12, 0.5, -2)
            indicator.BackgroundColor3 = Theme.TextGray
            indicator.Parent = entry
            makeRound(indicator, 2)

            entry.MouseEnter:Connect(function()
                tween(entry, 0.2, {TextColor3 = Theme.Text})
                tween(indicator, 0.2, {BackgroundColor3 = Theme.Accent})
            end)
            entry.MouseLeave:Connect(function()
                tween(entry, 0.2, {TextColor3 = Theme.TextGray})
                tween(indicator, 0.2, {BackgroundColor3 = Theme.TextGray})
            end)
            return entry
        end

        function tab:CreateSection(secNameData)
            local section = {}
            local sFrame = Instance.new("Frame")
            sFrame.Size = UDim2.new(1, 0, 0, 0)
            sFrame.BackgroundColor3 = Theme.PanelBG
            sFrame.AutomaticSize = Enum.AutomaticSize.Y
            sFrame.Parent = tab.Page
            makeRound(sFrame, 4)

            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, 3, 1, 0) -- Линия на всю высоту
            line.BackgroundColor3 = Theme.Accent
            line.BorderSizePixel = 0
            line.Parent = sFrame
            makeRound(line, 4) -- Закругленная линия

            local sTitle = Instance.new("TextLabel")
            sTitle.Size = UDim2.new(1, -30, 0, 40)
            sTitle.Position = UDim2.new(0, 15, 0, 0)
            sTitle.BackgroundTransparency = 1
            sTitle.TextColor3 = Theme.Text
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 13
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            sTitle.Parent = sFrame

            MUILib:RegisterLabel(sTitle, secNameData, false)

            local container = Instance.new("Frame")
            container.Size = UDim2.new(1, -30, 0, 0)
            container.Position = UDim2.new(0, 20, 0, 40)
            container.AutomaticSize = Enum.AutomaticSize.Y
            container.BackgroundTransparency = 1
            container.Parent = sFrame
            Instance.new("UIListLayout", container).Padding = UDim.new(0, 10)

            function section:AddToggle(toggleNameData, default, callback)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 26)
                row.BackgroundTransparency = 1
                row.Parent = container

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, -45, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row
                MUILib:RegisterLabel(label, toggleNameData, false)

                local bg = Instance.new("TextButton")
                bg.Size = UDim2.fromOffset(34, 18)
                bg.Position = UDim2.new(1, -34, 0.5, -9)
                bg.BackgroundColor3 = Theme.MainBG
                bg.Text = ""
                bg.Parent = row
                makeRound(bg, 9)

                local dot = Instance.new("Frame")
                dot.Size = UDim2.fromOffset(14, 14)
                dot.Position = UDim2.new(0, 2, 0.5, -7)
                dot.BackgroundColor3 = Theme.TextGray
                dot.Parent = bg
                makeRound(dot, 7)

                local state = default or false
                local function update()
                    tween(bg, 0.2, {BackgroundColor3 = state and Theme.Accent or Theme.MainBG})
                    tween(dot, 0.2, {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                    if callback then callback(state) end
                end
                bg.MouseButton1Click:Connect(function() state = not state update() end)
                update()
            end

            return section
        end

        return tab
    end

    return win
end

return MUILib
