local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MUILib = {
	Language = "RU",
	Labels = {},
	Themes = {
		MainBG = Color3.fromRGB(24, 25, 33),
		SidebarBG = Color3.fromRGB(18, 19, 25),
		TopBarBG = Color3.fromRGB(20, 21, 28),
		PanelBG = Color3.fromRGB(30, 31, 40),
		Accent = Color3.fromRGB(255, 46, 105),
		ToggleOn = Color3.fromRGB(46, 255, 113),
		ToggleOff = Color3.fromRGB(255, 46, 69),
		Text = Color3.fromRGB(255, 255, 255),
		TextGray = Color3.fromRGB(130, 132, 142)
	}
}
MUILib.__index = MUILib
local function tween(o, t, p) TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end
local function round(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = p end
local function stroke(p, c, t) local s = Instance.new("UIStroke") s.Color = c s.Thickness = t s.ApplyStrokeMode = "Border" s.Parent = p return s end
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
	local win = {Tabs = {}, SidebarEntries = {}, CurrentTab = nil}
	local screen = Instance.new("ScreenGui") screen.Name = "MelonityUI" screen.Parent = CoreGui
	local main = Instance.new("Frame") main.Size = UDim2.fromOffset(980, 640) main.Position = UDim2.new(0.5, 0, 0.5, 0) main.AnchorPoint = Vector2.new(0.5, 0.5) main.BackgroundColor3 = self.Themes.MainBG main.BorderSizePixel = 0 main.Parent = screen round(main, 6)
	local drag, start, pPos
	main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pPos = main.Position end end)
	UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
	local top = Instance.new("Frame") top.Size = UDim2.new(1, 0, 0, 45) top.BackgroundColor3 = self.Themes.TopBarBG top.Parent = main round(top, 6)
	local logo = Instance.new("ImageLabel") logo.Size = UDim2.fromOffset(24, 24) logo.Position = UDim2.new(0, 15, 0.5, -12) logo.BackgroundTransparency = 1 logo.Image = "rbxassetid://13000639907" logo.ImageColor3 = self.Themes.Accent logo.Parent = top
	local searchH = Instance.new("Frame") searchH.Size = UDim2.fromOffset(380, 28) searchH.Position = UDim2.new(0, 50, 0.5, -14) searchH.BackgroundColor3 = Color3.fromRGB(15, 16, 22) searchH.Parent = top round(searchH, 4)
	local gInp = Instance.new("TextBox") gInp.Size = UDim2.new(1, -40, 1, 0) gInp.Position = UDim2.new(0, 30, 0, 0) gInp.BackgroundTransparency = 1 gInp.Text = "" gInp.PlaceholderText = "Search" gInp.PlaceholderColor3 = self.Themes.TextGray gInp.TextColor3 = self.Themes.Text gInp.Font = "GothamMedium" gInp.TextSize = 13 gInp.TextXAlignment = "Left" gInp.Parent = searchH
	local langBtn = Instance.new("TextButton") langBtn.Size = UDim2.new(0, 120, 0, 28) langBtn.Position = UDim2.new(1, -150, 0.5, -14) langBtn.BackgroundColor3 = Color3.fromRGB(15, 16, 22) langBtn.Text = "🇷🇺 RU" langBtn.TextColor3 = self.Themes.TextGray langBtn.Font = "GothamMedium" langBtn.TextSize = 12 langBtn.Parent = top round(langBtn, 4)
	langBtn.MouseButton1Click:Connect(function() local new = self.Language == "RU" and "EN" or "RU" self:SetLanguage(new) langBtn.Text = new == "RU" and "🇷🇺 RU" or "🇺🇸 EN" end)
	local th = Instance.new("Frame") th.Size = UDim2.new(1, 0, 0, 40) th.Position = UDim2.new(0, 0, 0, 45) th.BackgroundColor3 = self.Themes.TopBarBG th.Parent = main
	Instance.new("UIListLayout", th).FillDirection = "Horizontal" th.UIListLayout.Padding = UDim.new(0, 20) th.UIListLayout.VerticalAlignment = "Center" Instance.new("UIPadding", th).PaddingLeft = UDim.new(0, 20)
	local sb = Instance.new("Frame") sb.Size = UDim2.new(0, 220, 1, -85) sb.Position = UDim2.new(0, 0, 0, 85) sb.BackgroundColor3 = self.Themes.SidebarBG sb.Parent = main
	local ns = Instance.new("ScrollingFrame") ns.Size = UDim2.new(1, 0, 1, -100) ns.Position = UDim2.new(0, 0, 0, 45) ns.BackgroundTransparency = 1 ns.BorderSizePixel = 0 ns.ScrollBarThickness = 0 ns.Parent = sb Instance.new("UIListLayout", ns).Padding = UDim.new(0, 2)
	local ct = Instance.new("Frame") ct.Size = UDim2.new(1, -240, 1, -105) ct.Position = UDim2.new(0, 230, 0, 95) ct.BackgroundTransparency = 1 ct.Parent = main
	function win:AddTopTab(names, icon)
		local t = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton")}
		t.P.Size = UDim2.new(1, 0, 1, 0) t.P.BackgroundTransparency = 1 t.P.BorderSizePixel = 0 t.P.Visible = false t.P.ScrollBarThickness = 0 t.P.Parent = ct
		local tLayout = Instance.new("UIListLayout") tLayout.Padding = UDim.new(0, 15) tLayout.Parent = t.P
		tLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() t.P.CanvasSize = UDim2.fromOffset(0, tLayout.AbsoluteContentSize.Y) end)
		MUILib:RegisterLabel(t.B, names) t.B.Size = UDim2.new(0, 0, 1, 0) t.B.AutomaticSize = "X" t.B.BackgroundTransparency = 1 t.B.TextColor3 = MUILib.Themes.TextGray t.B.Font = "GothamBold" t.B.TextSize = 11 t.B.Parent = th
		t.B.MouseButton1Click:Connect(function() for _, v in pairs(win.Tabs) do v.P.Visible = false v.B.TextColor3 = MUILib.Themes.TextGray end t.P.Visible = true t.B.TextColor3 = MUILib.Themes.Accent end)
		table.insert(win.Tabs, t) if #win.Tabs == 1 then t.P.Visible = true t.B.TextColor3 = MUILib.Themes.Accent end
		function t:AddSideEntry(names)
			local e = Instance.new("TextButton") e.Size = UDim2.new(1, 0, 0, 32) e.BackgroundTransparency = 1 e.TextColor3 = MUILib.Themes.TextGray e.Font = "GothamMedium" e.TextSize = 13 e.TextXAlignment = "Left" e.Parent = ns
			MUILib:RegisterLabel(e, names) local ind = Instance.new("Frame") ind.Size = UDim2.fromOffset(4, 4) ind.Position = UDim2.new(0, 12, 0.5, -2) ind.BackgroundColor3 = MUILib.Themes.TextGray ind.Parent = e round(ind, 2)
			e.MouseEnter:Connect(function() tween(e, 0.2, {TextColor3 = MUILib.Themes.Text}) tween(ind, 0.2, {BackgroundColor3 = MUILib.Themes.Accent}) end)
			e.MouseLeave:Connect(function() tween(e, 0.2, {TextColor3 = MUILib.Themes.TextGray}) tween(ind, 0.2, {BackgroundColor3 = MUILib.Themes.TextGray}) end)
			return e
		end
		function t:CreateSection(names)
			local sec = {} local sf = Instance.new("Frame") sf.Size = UDim2.new(1, 0, 0, 0) sf.BackgroundColor3 = MUILib.Themes.PanelBG sf.AutomaticSize = "Y" sf.Parent = t.P round(sf, 4)
			local line = Instance.new("Frame") line.Size = UDim2.new(0, 3, 1, 0) line.BackgroundColor3 = MUILib.Themes.Accent line.BorderSizePixel = 0 line.Parent = sf round(line, 4)
			local lt = Instance.new("TextLabel") MUILib:RegisterLabel(lt, names) lt.Size = UDim2.new(1, -30, 0, 40) lt.Position = UDim2.new(0, 15, 0, 0) lt.BackgroundTransparency = 1 lt.TextColor3 = MUILib.Themes.Text lt.Font = "GothamBold" lt.TextSize = 13 lt.TextXAlignment = "Left" lt.Parent = sf
			local c = Instance.new("Frame") c.Size = UDim2.new(1, -30, 0, 0) c.Position = UDim2.new(0, 20, 0, 40) c.AutomaticSize = "Y" c.BackgroundTransparency = 1 c.Parent = sf Instance.new("UIListLayout", c).Padding = UDim.new(0, 10)
			function sec:AddToggle(names, default, callback)
				local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 26) r.BackgroundTransparency = 1 r.Parent = c
				local tl = Instance.new("TextLabel") MUILib:RegisterLabel(tl, names) tl.Size = UDim2.new(1, -45, 1, 0) tl.BackgroundTransparency = 1 tl.TextColor3 = MUILib.Themes.Text tl.Font = "Gotham" tl.TextSize = 12 tl.TextXAlignment = "Left" tl.Parent = r
				local bg = Instance.new("TextButton") bg.Size = UDim2.new(0, 34, 0, 18) bg.Position = UDim2.new(1, -34, 0.5, -9) bg.BackgroundColor3 = MUILib.Themes.MainBG bg.Text = "" bg.Parent = r round(bg, 9)
				local d = Instance.new("Frame") d.Size = UDim2.fromOffset(14, 14) d.Position = UDim2.new(0, 2, 0.5, -7) d.BackgroundColor3 = MUILib.Themes.TextGray d.Parent = bg round(d, 7)
				local st = default or false
				local function up() tween(bg, 0.2, {BackgroundColor3 = st and MUILib.Themes.Accent or MUILib.Themes.MainBG}) tween(d, 0.2, {Position = st and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}) if callback then callback(st) end end
				bg.MouseButton1Click:Connect(function() st = not st up() end) up()
			end
			function sec:AddSlider(names, min, max, default, callback)
				local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 40) r.BackgroundTransparency = 1 r.Parent = c
				local tl = Instance.new("TextLabel") MUILib:RegisterLabel(tl, names) tl.Size = UDim2.new(1, 0, 0, 15) tl.BackgroundTransparency = 1 tl.TextColor3 = MUILib.Themes.Text tl.Font = "Gotham" tl.TextSize = 12 tl.TextXAlignment = "Left" tl.Parent = r
				local vL = Instance.new("TextLabel") vL.Text = tostring(default) vL.Size = UDim2.new(0, 40, 0, 20) vL.Position = UDim2.new(1, -40, 0.5, 0) vL.BackgroundColor3 = MUILib.Themes.MainBG vL.TextColor3 = MUILib.Themes.Text vL.Parent = r round(vL, 4)
				local bar = Instance.new("Frame") bar.Size = UDim2.new(1, -50, 0, 4) bar.Position = UDim2.new(0, 0, 0.75, 0) bar.BackgroundColor3 = MUILib.Themes.MainBG bar.Parent = r round(bar, 2)
				local fill = Instance.new("Frame") fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0) fill.BackgroundColor3 = MUILib.Themes.Accent fill.Parent = bar round(fill, 2)
				local h = Instance.new("Frame") h.Size = UDim2.fromOffset(12, 12) h.AnchorPoint = Vector2.new(0.5, 0.5) h.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0) h.BackgroundColor3 = MUILib.Themes.Text h.Parent = bar round(h, 6)
				local drag = false
				local function move(i) local p = math.clamp((i.Position.X-bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1) local v = math.floor(min+(max-min)*p) fill.Size = UDim2.new(p,0,1,0) h.Position = UDim2.new(p,0,0.5,0) vL.Text = v if callback then callback(v) end end
				h.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
				UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then move(i) end end)
			end
			function sec:AddItemToggle(names, icon, callback)
				if not c:FindFirstChild("Grid") then local g = Instance.new("Frame") g.Name = "Grid" g.Size = UDim2.new(1, 0, 0, 0) g.AutomaticSize = "Y" g.BackgroundTransparency = 1 g.Parent = c Instance.new("UIGridLayout", g).CellSize = UDim2.fromOffset(40,40) g.UIGridLayout.CellPadding = UDim2.fromOffset(6,6) end
				local b = Instance.new("TextButton") b.BackgroundColor3 = MUILib.Themes.MainBG b.Text = "" b.Parent = c.Grid round(b, 4) local s = stroke(b, MUILib.Themes.ToggleOff, 1.5)
				local img = Instance.new("ImageLabel") img.Size = UDim2.new(0.7,0,0.7,0) img.Position = UDim2.new(0.15,0,0.15,0) img.BackgroundTransparency = 1 img.Image = icon or "" img.Parent = b
				local st = false b.MouseButton1Click:Connect(function() st = not st tween(s, 0.2, {Color = st and MUILib.Themes.ToggleOn or MUILib.Themes.ToggleOff}) if callback then callback(st) end end)
			end
			return sec
		end
		return t
	end
	return win
end
return MUILib
