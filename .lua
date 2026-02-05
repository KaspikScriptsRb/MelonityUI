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
    SearchBG = Color3.fromRGB(15, 16, 22),
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
local function stroke(p, c, t)
    local s = Instance.new("UIStroke")
    s.Color = c
    s.Thickness = t
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end
function MUILib:SetLanguage(lang)
    self.Language = lang
    for _, data in pairs(self.Labels) do
        data.Obj.Text = data.Langs[lang] or data.Obj.Text
    end
end
function MUILib:RegisterLabel(obj, langTable)
    table.insert(self.Labels, {Obj = obj, Langs = langTable})
    obj.Text = langTable[self.Language]
end
function MUILib:CreateWindow(opts)
    local window = setmetatable({}, MUILib)
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
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 45)
    header.BackgroundColor3 = Theme.TopBarBG
    header.Parent = main
    round(header, 4)
    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.fromOffset(24, 24)
    logo.Position = UDim2.new(0, 15, 0.5, -12)
    logo.BackgroundTransparency = 1
    logo.Image = "rbxassetid://13000639907"
    logo.ImageColor3 = Theme.Accent
    logo.Parent = header
    local searchBar = Instance.new("Frame")
    searchBar.Size = UDim2.fromOffset(380, 28)
    searchBar.Position = UDim2.new(0, 50, 0.5, -14)
    searchBar.BackgroundColor3 = Theme.SearchBG
    searchBar.Parent = header
    round(searchBar, 4)
    local sIcon = Instance.new("ImageLabel")
    sIcon.Size = UDim2.fromOffset(14, 14)
    sIcon.Position = UDim2.new(0, 10, 0.5, -7)
    sIcon.Image = "rbxassetid://6031154871"
    sIcon.ImageColor3 = Theme.TextGray
    sIcon.BackgroundTransparency = 1
    sIcon.Parent = searchBar
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
    gInp.Parent = searchBar
    local langBtn = Instance.new("TextButton")
    langBtn.Size = UDim2.new(0, 100, 0, 26)
    langBtn.Position = UDim2.new(1, -140, 0.5, -13)
    langBtn.BackgroundColor3 = Theme.SearchBG
    langBtn.Text = "🇷🇺 RU"
    langBtn.TextColor3 = Theme.TextGray
    langBtn.Font = "GothamMedium"
    langBtn.TextSize = 12
    langBtn.Parent = header
    round(langBtn, 4)
    langBtn.MouseButton1Click:Connect(function()
        local nextL = self.Language == "RU" and "EN" or "RU"
        self:SetLanguage(nextL)
        langBtn.Text = nextL == "RU" and "🇷🇺 RU" or "🇺🇸 EN"
    end)
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(1, 0, 0, 40)
    tabContainer.Position = UDim2.new(0, 0, 0, 45)
    tabContainer.BackgroundColor3 = Theme.TopBarBG
    tabContainer.Parent = main
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = "Horizontal"
    tabLayout.Padding = UDim.new(0, 25)
    tabLayout.VerticalAlignment = "Center"
    tabLayout.Parent = tabContainer
    Instance.new("UIPadding", tabContainer).PaddingLeft = UDim.new(0, 20)
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 220, 1, -85)
    sidebar.Position = UDim2.new(0, 0, 0, 85)
    sidebar.BackgroundColor3 = Theme.SidebarBG
    sidebar.Parent = main
    local navTitle = Instance.new("TextLabel")
    navTitle.Text = "Навигация"
    navTitle.Size = UDim2.new(1, -30, 0, 40)
    navTitle.Position = UDim2.new(0, 15, 0, 5)
    navTitle.BackgroundTransparency = 1
    navTitle.TextColor3 = Theme.Text
    navTitle.Font = "GothamBold"
    navTitle.TextSize = 14
    navTitle.TextXAlignment = "Left"
    navTitle.Parent = sidebar
    local sideSearch = searchBar:Clone()
    sideSearch.Size = UDim2.new(1, -30, 0, 26)
    sideSearch.Position = UDim2.new(0, 15, 0, 45)
    sideSearch.Parent = sidebar
    local navScroll = Instance.new("ScrollingFrame")
    navScroll.Size = UDim2.new(1, 0, 1, -150)
    navScroll.Position = UDim2.new(0, 0, 0, 85)
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
    uName.Font = "GothamMedium"
    uName.TextSize = 13
    uName.TextXAlignment = "Left"
    uName.Parent = profile
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -240, 1, -105)
    content.Position = UDim2.new(0, 230, 0, 95)
    content.BackgroundTransparency = 1
    content.Parent = main
    sideSearch.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
        local q = sideSearch.TextBox.Text:lower()
        for _, v in pairs(self.SidebarEntries) do
            v.Visible = v.Name:lower():find(q) ~= nil
        end
    end)
    function window:AddTopTab(names, icon)
        local t = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton")}
        t.P.Size = UDim2.new(1, 0, 1, 0)
        t.P.BackgroundTransparency = 1
        t.P.BorderSizePixel = 0
        t.P.Visible = false
        t.P.ScrollBarThickness = 0
        t.P.Parent = content
        local tLayout = Instance.new("UIListLayout")
        tLayout.Padding = UDim.new(0, 15)
        tLayout.Parent = t.P
        tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() t.P.CanvasSize = UDim2.fromOffset(0, tLayout.AbsoluteContentSize.Y) end)
        self:RegisterLabel(t.B, names)
        t.B.Size = UDim2.new(0, 0, 1, 0)
        t.B.AutomaticSize = "X"
        t.B.BackgroundTransparency = 1
        t.B.TextColor3 = Theme.TextGray
        t.B.Font = "GothamBold"
        t.B.TextSize = 11
        t.B.Parent = tabContainer
        t.B.MouseButton1Click:Connect(function()
            for _, v in pairs(self.Tabs) do v.P.Visible = false v.B.TextColor3 = Theme.TextGray end
            t.P.Visible = true t.B.TextColor3 = Theme.Accent
        end)
        table.insert(self.Tabs, t)
        if #self.Tabs == 1 then t.P.Visible = true t.B.TextColor3 = Theme.Accent end
        function t:AddSideEntry(names)
            local e = Instance.new("TextButton")
            e.Name = names.EN
            e.Size = UDim2.new(1, 0, 0, 32)
            e.BackgroundTransparency = 1
            e.TextColor3 = Theme.TextGray
            e.Font = "GothamMedium"
            e.TextSize = 13
            e.TextXAlignment = "Left"
            e.Parent = navScroll
            MUILib:RegisterLabel(e, names)
            local ind = Instance.new("Frame")
            ind.Size = UDim2.fromOffset(4, 4)
            ind.Position = UDim2.new(0, 12, 0.5, -2)
            ind.BackgroundColor3 = Theme.TextGray
            ind.Parent = e
            round(ind, 2)
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
            round(sf, 4)
            local line = Instance.new("Frame")
            line.Size = UDim2.new(0, 3, 1, 0)
            line.BackgroundColor3 = Theme.Accent
            line.BorderSizePixel = 0
            line.Parent = sf
            round(line, 4)
            local lt = Instance.new("TextLabel")
            MUILib:RegisterLabel(lt, names)
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
                MUILib:RegisterLabel(tl, names)
                tl.Size = UDim2.new(1, -45, 1, 0)
                tl.BackgroundTransparency = 1
                tl.TextColor3 = Theme.Text
                tl.Font = "Gotham"
                tl.TextSize = 12
                tl.TextXAlignment = "Left"
                tl.Parent = r
                local b_bg = Instance.new("TextButton")
                b_bg.Size = UDim2.new(0, 34, 0, 18)
                b_bg.Position = UDim2.new(1, -34, 0.5, -9)
                b_bg.BackgroundColor3 = Theme.MainBG
                b_bg.Text = ""
                b_bg.Parent = r
                round(b_bg, 9)
                local d = Instance.new("Frame")
                d.Size = UDim2.fromOffset(14, 14)
                d.Position = UDim2.new(0, 2, 0.5, -7)
                d.BackgroundColor3 = Theme.TextGray
                d.Parent = b_bg
                round(d, 7)
                local st = default or false
                local function up()
                    tween(b_bg, 0.2, {BackgroundColor3 = st and Theme.Accent or Theme.MainBG})
                    tween(d, 0.2, {Position = st and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
                    if callback then callback(st) end
                end
                b_bg.MouseButton1Click:Connect(function() st = not st up() end)
                up()
            end
            function sec:AddItemToggle(icon, callback)
                if not c:FindFirstChild("Grid") then
                    local g = Instance.new("Frame")
                    g.Name = "Grid"
                    g.Size = UDim2.new(1, 0, 0, 0)
                    g.AutomaticSize = "Y"
                    g.BackgroundTransparency = 1
                    g.Parent = c
                    local gl = Instance.new("UIGridLayout")
                    gl.CellSize = UDim2.fromOffset(42, 42)
                    gl.CellPadding = UDim2.fromOffset(6, 6)
                    gl.Parent = g
                end
                local b = Instance.new("TextButton")
                b.BackgroundColor3 = Theme.MainBG
                b.Text = ""
                b.Parent = c.Grid
                round(b, 4)
                local s = stroke(b, Theme.ToggleOff, 1.5)
                local img = Instance.new("ImageLabel")
                img.Size = UDim2.new(0.7, 0, 0.7, 0)
                img.Position = UDim2.new(0.15, 0, 0.15, 0)
                img.BackgroundTransparency = 1
                img.Image = icon or ""
                img.Parent = b
                local st = false
                b.MouseButton1Click:Connect(function()
                    st = not st
                    tween(s, 0.2, {Color = st and Theme.ToggleOn or Theme.ToggleOff})
                    if callback then callback(st) end
                end)
            end
            function sec:AddSlider(names, min, max, default, callback)
                local r = Instance.new("Frame")
                r.Size = UDim2.new(1, 0, 0, 40)
                r.BackgroundTransparency = 1
                r.Parent = c
                local tl = Instance.new("TextLabel")
                MUILib:RegisterLabel(tl, names)
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
                round(vL, 4)
                local bar = Instance.new("Frame")
                bar.Size = UDim2.new(1, -50, 0, 4)
                bar.Position = UDim2.new(0, 0, 0.75, 0)
                bar.BackgroundColor3 = Theme.MainBG
                bar.Parent = r
                round(bar, 2)
                local fill = Instance.new("Frame")
                fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
                fill.BackgroundColor3 = Theme.Accent
                fill.Parent = bar
                round(fill, 2)
                local handle = Instance.new("Frame")
                handle.Size = UDim2.fromOffset(12, 12)
                handle.AnchorPoint = Vector2.new(0.5, 0.5)
                handle.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
                handle.BackgroundColor3 = Theme.Text
                handle.Parent = bar
                round(handle, 6)
                local drag = false
                local function move(i)
                    local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(min + (max - min) * p)
                    fill.Size = UDim2.new(p, 0, 1, 0)
                    handle.Position = UDim2.new(p, 0, 0.5, 0)
                    vL.Text = tostring(v)
                    if callback then callback(v) end
                end
                handle.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
                UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then move(i) end end)
            end
            function sec:AddDropdown(names, options, multi, callback)
                local drop = {Open = false, Selected = {}, Items = {}}
                local r = Instance.new("Frame")
                r.Size = UDim2.new(1, 0, 0, 45)
                r.BackgroundTransparency = 1
                r.Parent = c
                local b = Instance.new("TextButton")
                b.Size = UDim2.new(1, 0, 0, 25)
                b.Position = UDim2.new(0, 0, 0, 20)
                b.BackgroundColor3 = Theme.SearchBG
                b.Text = "  Select..."
                b.TextColor3 = Theme.TextGray
                b.Font = "Gotham"
                b.TextSize = 12
                b.TextXAlignment = "Left"
                b.Parent = r
                round(b, 4)
                local list = Instance.new("ScrollingFrame")
                list.Size = UDim2.new(1, 0, 0, 0)
                list.Position = UDim2.new(0, 0, 0, 50)
                list.BackgroundColor3 = Theme.SearchBG
                list.ZIndex = 10
                list.ClipsDescendants = true
                list.ScrollBarThickness = 2
                list.Parent = r
                round(list, 4)
                local ll = Instance.new("UIListLayout")
                ll.Parent = list
                b.MouseButton1Click:Connect(function()
                    drop.Open = not drop.Open
                    tween(list, 0.2, {Size = drop.Open and UDim2.new(1, 0, 0, math.min(ll.AbsoluteContentSize.Y, 150)) or UDim2.new(1, 0, 0, 0)})
                    list.CanvasSize = UDim2.fromOffset(0, ll.AbsoluteContentSize.Y)
                end)
                local function refresh()
                    b.Text = "  " .. (#drop.Selected > 0 and table.concat(drop.Selected, ", ") or "Select...")
                    if callback then callback(multi and drop.Selected or drop.Selected[1]) end
                end
                for _, val in pairs(options) do
                    local ob = Instance.new("TextButton")
                    ob.Size = UDim2.new(1, 0, 0, 25)
                    ob.BackgroundTransparency = 1
                    ob.Text = "  " .. val
                    ob.TextColor3 = Theme.TextGray
                    ob.Font = "Gotham"
                    ob.TextSize = 12
                    ob.TextXAlignment = "Left"
                    ob.Parent = list
                    ob.MouseButton1Click:Connect(function()
                        if multi then
                            if table.find(drop.Selected, val) then
                                table.remove(drop.Selected, table.find(drop.Selected, val))
                                ob.TextColor3 = Theme.TextGray
                            else
                                table.insert(drop.Selected, val)
                                ob.TextColor3 = Theme.Accent
                            end
                        else
                            drop.Selected = {val}
                            for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.TextGray end
                            ob.TextColor3 = Theme.Accent
                            drop.Open = false
                            list.Size = UDim2.new(1, 0, 0, 0)
                        end
                        refresh()
                    end)
                    table.insert(drop.Items, ob)
                end
                local d_obj = {
                    EnableAll = function()
                        drop.Selected = {}
                        for _, v in pairs(options) do table.insert(drop.Selected, v) end
                        for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.Accent end
                        refresh()
                    end,
                    DisableAll = function()
                        drop.Selected = {}
                        for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.TextGray end
                        refresh()
                    end
                }
                return d_obj
            end
            return sec
        end
        return t
    end
    return window
end
return MUILib
