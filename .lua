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
    SearchBG = Color3.fromRGB(15, 16, 20),
    Border = Color3.fromRGB(45, 46, 54)
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

function MUILib:CreateWindow(options)
    local win = {
        Tabs = {},
        SidebarEntries = {},
        CurrentTab = nil,
        SelectedLanguage = "Русский"
    }

    local screen = Instance.new("ScreenGui")
    screen.Name = "MelonityUI_Final"
    screen.Parent = CoreGui

    local main = Instance.new("Frame")
    main.Size = UDim2.fromOffset(980, 620)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.BackgroundColor3 = Theme.MainBG
    main.BorderSizePixel = 0
    main.Parent = screen
    makeRound(main, 6)

    -- Dragging
    local dragging, dragStart, startPos
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

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Theme.TopBarBG
    header.Parent = main
    makeRound(header, 6)

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.fromOffset(24, 24)
    logo.Position = UDim2.new(0, 15, 0.5, -12)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://13000639907"
    logo.ImageColor3 = Theme.Accent
    logo.Parent = header

    local searchBoxFrame = Instance.new("Frame")
    searchBoxFrame.Size = UDim2.fromOffset(350, 28)
    searchBoxFrame.Position = UDim2.new(0, 50, 0.5, -14)
    searchBoxFrame.BackgroundColor3 = Theme.SearchBG
    searchBoxFrame.Parent = header
    makeRound(searchBoxFrame, 4)

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.fromOffset(14, 14)
    searchIcon.Position = UDim2.new(0, 10, 0.5, -7)
    searchIcon.Image = "rbxassetid://6031154871"
    searchIcon.ImageColor3 = Theme.TextGray
    searchIcon.BackgroundTransparency = 1
    searchIcon.Parent = searchBoxFrame

    local searchInput = Instance.new("TextBox")
    searchInput.Size = UDim2.new(1, -40, 1, 0)
    searchInput.Position = UDim2.new(0, 30, 0, 0)
    searchInput.BackgroundTransparency = 1
    searchInput.Text = ""
    searchInput.PlaceholderText = "Search"
    searchInput.PlaceholderColor3 = Theme.TextGray
    searchInput.TextColor3 = Theme.Text
    searchInput.Font = Enum.Font.GothamMedium
    searchInput.TextSize = 13
    searchInput.TextXAlignment = Enum.TextXAlignment.Left
    searchInput.Parent = searchBoxFrame

    local langBtn = Instance.new("TextButton")
    langBtn.Size = UDim2.new(0, 120, 0, 28)
    langBtn.Position = UDim2.new(1, -150, 0.5, -14)
    langBtn.BackgroundTransparency = 1
    langBtn.Text = "🇷🇺 Русский  ▼"
    langBtn.TextColor3 = Theme.TextGray
    langBtn.Font = Enum.Font.GothamMedium
    langBtn.TextSize = 12
    langBtn.Parent = header

    local tabHeader = Instance.new("Frame")
    tabHeader.Size = UDim2.new(1, 0, 0, 40)
    tabHeader.Position = UDim2.new(0, 0, 0, 45)
    tabHeader.BackgroundColor3 = Theme.TopBarBG
    tabHeader.Parent = main

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 25)
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Parent = tabHeader

    Instance.new("UIPadding", tabHeader).PaddingLeft = UDim.new(0, 20)

    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, -85)
    sidebar.Position = UDim2.new(0, 0, 0, 85)
    sidebar.BackgroundColor3 = Theme.SidebarBG
    sidebar.Parent = main

    local navLabel = Instance.new("TextLabel")
    navLabel.Text = "Навигация"
    navLabel.Size = UDim2.new(1, -30, 0, 40)
    navLabel.Position = UDim2.new(0, 15, 0, 5)
    navLabel.BackgroundTransparency = 1
    navLabel.TextColor3 = Theme.Text
    navLabel.Font = Enum.Font.GothamBold
    navLabel.TextSize = 14
    navLabel.TextXAlignment = Enum.TextXAlignment.Left
    navLabel.Parent = sidebar

    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -100)
    navScroll.Position = UDim2.new(0, 0, 0, 45)
    navScroll.BackgroundTransparency = 1
    navScroll.BorderSizePixel = 0
    navScroll.ScrollBarThickness = 0
    navScroll.Parent = sidebar

    local navLayout = Instance.new("UIListLayout")
    navLayout.Padding = UDim.new(0, 2)
    navLayout.Parent = navScroll

    local profileFrame = Instance.new("Frame")
    profileFrame.Size = UDim2.new(1, 0, 0, 60)
    profileFrame.Position = UDim2.new(0, 0, 1, -60)
    profileFrame.BackgroundColor3 = Theme.SearchBG
    profileFrame.Parent = sidebar

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -220, 1, -85)
    container.Position = UDim2.new(0, 220, 0, 85)
    container.BackgroundTransparency = 1
    container.Parent = main

    -- Search Logic
    searchInput:GetPropertyChangedSignal("Text"):Connect(function()
        local query = searchInput.Text:lower()
        for _, item in pairs(win.SidebarEntries) do
            item.Visible = item.Name:lower():find(query) ~= nil
        end
    end)

    function win:AddTopTab(name, iconId)
        local tab = {
            Page = Instance.new("ScrollingFrame"),
            Button = Instance.new("TextButton")
        }

        tab.Page.Size = UDim2.new(1, -20, 1, -20)
        tab.Page.Position = UDim2.new(0, 10, 0, 10)
        tab.Page.BackgroundTransparency = 1
        tab.Page.BorderSizePixel = 0
        tab.Page.Visible = false
        tab.Page.ScrollBarThickness = 0
        tab.Page.Parent = container

        local grid = Instance.new("UIGridLayout")
        grid.CellPadding = UDim2.fromOffset(10, 10)
        grid.CellSize = UDim2.new(0.5, -5, 0, 10)
        grid.Parent = tab.Page

        grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tab.Page.CanvasSize = UDim2.fromOffset(0, grid.AbsoluteContentSize.Y)
        end)

        tab.Button.Size = UDim2.new(0, 0, 1, 0)
        tab.Button.AutomaticSize = Enum.AutomaticSize.X
        tab.Button.BackgroundTransparency = 1
        tab.Button.Text = (iconId and "   " or "") .. name:upper()
        tab.Button.TextColor3 = Theme.TextGray
        tab.Button.Font = Enum.Font.GothamBold
        tab.Button.TextSize = 11
        tab.Button.Parent = tabHeader

        if iconId then
            local icon = Instance.new("ImageLabel")
            icon.Size = UDim2.fromOffset(14, 14)
            icon.Position = UDim2.new(0, -16, 0.5, -7)
            icon.Image = "rbxassetid://" .. tostring(iconId)
            icon.BackgroundTransparency = 1
            icon.ImageColor3 = Theme.TextGray
            icon.Parent = tab.Button
        end

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

        function tab:AddSideEntry(text, iconId)
            local entry = Instance.new("TextButton")
            entry.Name = text
            entry.Size = UDim2.new(1, 0, 0, 32)
            entry.BackgroundTransparency = 1
            entry.Text = "      " .. text
            entry.TextColor3 = Theme.TextGray
            entry.Font = Enum.Font.GothamMedium
            entry.TextSize = 13
            entry.TextXAlignment = Enum.TextXAlignment.Left
            entry.Parent = navScroll

            local indicator = Instance.new("Frame")
            indicator.Size = UDim2.fromOffset(4, 4)
            indicator.Position = UDim2.new(0, 15, 0.5, -2)
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

            table.insert(win.SidebarEntries, entry)
            return entry
        end

        function tab:CreateSection(title)
            local section = {}
            local sFrame = Instance.new("Frame")
            sFrame.BackgroundColor3 = Theme.PanelBG
            sFrame.AutomaticSize = Enum.AutomaticSize.Y
            sFrame.Parent = tab.Page
            makeRound(sFrame, 4)

            local pinkLine = Instance.new("Frame")
            pinkLine.Size = UDim2.new(0, 3, 0, 18)
            pinkLine.Position = UDim2.new(0, 0, 0, 12)
            pinkLine.BackgroundColor3 = Theme.Accent
            pinkLine.BorderSizePixel = 0
            pinkLine.Parent = sFrame

            local sTitle = Instance.new("TextLabel")
            sTitle.Text = title
            sTitle.Size = UDim2.new(1, -20, 0, 40)
            sTitle.Position = UDim2.new(0, 15, 0, 0)
            sTitle.BackgroundTransparency = 1
            sTitle.TextColor3 = Theme.Text
            sTitle.Font = Enum.Font.GothamBold
            sTitle.TextSize = 13
            sTitle.TextXAlignment = Enum.TextXAlignment.Left
            sTitle.Parent = sFrame

            local contentList = Instance.new("Frame")
            contentList.Size = UDim2.new(1, -24, 0, 0)
            contentList.Position = UDim2.new(0, 12, 0, 40)
            contentList.AutomaticSize = Enum.AutomaticSize.Y
            contentList.BackgroundTransparency = 1
            contentList.Parent = sFrame

            local layout = Instance.new("UIListLayout")
            layout.Padding = UDim.new(0, 8)
            layout.Parent = contentList

            function section:AddToggle(opts)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 26)
                row.BackgroundTransparency = 1
                row.Parent = contentList

                local label = Instance.new("TextLabel")
                label.Text = opts.Text
                label.Size = UDim2.new(1, -45, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local toggleBg = Instance.new("TextButton")
                toggleBg.Size = UDim2.new(0, 32, 0, 16)
                toggleBg.Position = UDim2.new(1, -32, 0.5, -8)
                toggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
                toggleBg.Text = ""
                toggleBg.Parent = row
                makeRound(toggleBg, 8)

                local dot = Instance.new("Frame")
                dot.Size = UDim2.fromOffset(12, 12)
                dot.Position = UDim2.new(0, 2, 0.5, -6)
                dot.BackgroundColor3 = Theme.Text
                dot.Parent = toggleBg
                makeRound(dot, 6)

                local state = opts.Default or false
                local function update()
                    tween(toggleBg, 0.2, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 55)})
                    tween(dot, 0.2, {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
                    if opts.Callback then opts.Callback(state) end
                end

                toggleBg.MouseButton1Click:Connect(function()
                    state = not state
                    update()
                end)
                update()
            end

            function section:AddSlider(opts)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 35)
                row.BackgroundTransparency = 1
                row.Parent = contentList

                local label = Instance.new("TextLabel")
                label.Text = opts.Text
                label.Size = UDim2.new(1, 0, 0, 15)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local valLabel = Instance.new("TextLabel")
                valLabel.Text = tostring(opts.Default or opts.Min)
                valLabel.Size = UDim2.new(0, 40, 0, 15)
                valLabel.Position = UDim2.new(1, -40, 0, 0)
                valLabel.BackgroundTransparency = 1
                valLabel.TextColor3 = Theme.TextGray
                valLabel.Font = Enum.Font.Gotham
                valLabel.TextSize = 11
                valLabel.Parent = row

                local sliderBar = Instance.new("Frame")
                sliderBar.Size = UDim2.new(1, 0, 0, 4)
                sliderBar.Position = UDim2.new(0, 0, 0, 25)
                sliderBar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
                sliderBar.Parent = row
                makeRound(sliderBar, 2)

                local sliderFill = Instance.new("Frame")
                sliderFill.Size = UDim2.new(0, 0, 1, 0)
                sliderFill.BackgroundColor3 = Theme.Accent
                sliderFill.Parent = sliderBar
                makeRound(sliderFill, 2)

                local handle = Instance.new("Frame")
                handle.Size = UDim2.fromOffset(10, 10)
                handle.AnchorPoint = Vector2.new(0.5, 0.5)
                handle.Position = UDim2.new(0, 0, 0.5, 0)
                handle.BackgroundColor3 = Theme.Text
                handle.Parent = sliderBar
                makeRound(handle, 5)

                local dragging = false
                local function move(input)
                    local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
                    local value = math.floor(opts.Min + (opts.Max - opts.Min) * pos)
                    sliderFill.Size = UDim2.new(pos, 0, 1, 0)
                    handle.Position = UDim2.new(pos, 0, 0.5, 0)
                    valLabel.Text = tostring(value)
                    if opts.Callback then opts.Callback(value) end
                end

                handle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
                UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then move(i) end end)
            end

            function section:AddDropdown(opts)
                local drop = {Open = false, Selected = {}, Items = {}}
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 45)
                row.BackgroundTransparency = 1
                row.Parent = contentList

                local label = Instance.new("TextLabel")
                label.Text = opts.Text
                label.Size = UDim2.new(1, 0, 0, 15)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local mainBtn = Instance.new("TextButton")
                mainBtn.Size = UDim2.new(1, 0, 0, 25)
                mainBtn.Position = UDim2.new(0, 0, 0, 20)
                mainBtn.BackgroundColor3 = Theme.SearchBG
                mainBtn.Text = "  Select..."
                mainBtn.TextColor3 = Theme.TextGray
                mainBtn.Font = Enum.Font.Gotham
                mainBtn.TextSize = 12
                mainBtn.TextXAlignment = Enum.TextXAlignment.Left
                mainBtn.Parent = row
                makeRound(mainBtn, 4)

                local listFrame = Instance.new("ScrollingFrame")
                listFrame.Size = UDim2.new(1, 0, 0, 0)
                listFrame.Position = UDim2.new(0, 0, 0, 50)
                listFrame.BackgroundColor3 = Theme.SearchBG
                listFrame.ZIndex = 10
                listFrame.ClipsDescendants = true
                listFrame.ScrollBarThickness = 2
                listFrame.Parent = row
                makeRound(listFrame, 4)

                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = listFrame

                mainBtn.MouseButton1Click:Connect(function()
                    drop.Open = not drop.Open
                    tween(listFrame, 0.2, {Size = drop.Open and UDim2.new(1, 0, 0, math.min(listLayout.AbsoluteContentSize.Y, 150)) or UDim2.new(1, 0, 0, 0)})
                    listFrame.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y)
                end)

                local function refresh()
                    mainBtn.Text = "  " .. (#drop.Selected > 0 and table.concat(drop.Selected, ", ") or "Select...")
                    if opts.Callback then opts.Callback(opts.Multi and drop.Selected or drop.Selected[1]) end
                end

                for _, val in pairs(opts.Options) do
                    local optBtn = Instance.new("TextButton")
                    optBtn.Size = UDim2.new(1, 0, 0, 25)
                    optBtn.BackgroundTransparency = 1
                    optBtn.Text = "  " .. val
                    optBtn.TextColor3 = Theme.TextGray
                    optBtn.Font = Enum.Font.Gotham
                    optBtn.TextSize = 12
                    optBtn.TextXAlignment = Enum.TextXAlignment.Left
                    optBtn.Parent = listFrame

                    optBtn.MouseButton1Click:Connect(function()
                        if opts.Multi then
                            if table.find(drop.Selected, val) then
                                table.remove(drop.Selected, table.find(drop.Selected, val))
                                optBtn.TextColor3 = Theme.TextGray
                            else
                                table.insert(drop.Selected, val)
                                optBtn.TextColor3 = Theme.Accent
                            end
                        else
                            drop.Selected = {val}
                            for _, v in pairs(drop.Items) do v.TextColor3 = Theme.TextGray end
                            optBtn.TextColor3 = Theme.Accent
                            drop.Open = false
                            listFrame.Size = UDim2.new(1, 0, 0, 0)
                        end
                        refresh()
                    end)
                    table.insert(drop.Items, optBtn)
                end

                return {
                    EnableAll = function()
                        drop.Selected = {}
                        for _, v in pairs(opts.Options) do table.insert(drop.Selected, v) end
                        for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.Accent end
                        refresh()
                    end,
                    DisableAll = function()
                        drop.Selected = {}
                        for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.TextGray end
                        refresh()
                    end
                }
            end

            function section:AddKeybind(opts)
                local row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 26)
                row.BackgroundTransparency = 1
                row.Parent = contentList

                local label = Instance.new("TextLabel")
                label.Text = opts.Text
                label.Size = UDim2.new(1, -70, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Theme.Text
                label.Font = Enum.Font.Gotham
                label.TextSize = 12
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Parent = row

                local bindBtn = Instance.new("TextButton")
                bindBtn.Size = UDim2.new(0, 60, 0, 20)
                bindBtn.Position = UDim2.new(1, -60, 0.5, -10)
                bindBtn.BackgroundColor3 = Theme.SearchBG
                bindBtn.Text = opts.Default and opts.Default.Name or "None"
                bindBtn.TextColor3 = Theme.TextGray
                bindBtn.Font = Enum.Font.Gotham
                bindBtn.TextSize = 11
                bindBtn.Parent = row
                makeRound(bindBtn, 4)

                bindBtn.MouseButton1Click:Connect(function()
                    bindBtn.Text = "..."
                    local connection
                    connection = UserInputService.InputBegan:Connect(function(i)
                        if i.UserInputType == Enum.UserInputType.Keyboard then
                            bindBtn.Text = i.KeyCode.Name
                            connection:Disconnect()
                            if opts.Callback then opts.Callback(i.KeyCode) end
                        end
                    end)
                end)
            end

            function section:AddButton(opts)
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, 0, 0, 28)
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                btn.Text = opts.Text
                btn.TextColor3 = Theme.Text
                btn.Font = Enum.Font.GothamBold
                btn.TextSize = 12
                btn.Parent = contentList
                makeRound(btn, 4)
                btn.MouseButton1Click:Connect(function() if opts.Callback then opts.Callback() end end)
            end

            return section
        end
        return tab
    end
    return win
end

_G.MUILib = MUILib
return MUILib
