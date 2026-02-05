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
	Border = Color3.fromRGB(45, 46, 54),
	SearchBG = Color3.fromRGB(15, 16, 20)
}
local function tween(o, t, p)
	TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play()
end
local function round(p, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = p
end
function MUILib:CreateWindow(opts)
	local win = {Tabs = {}, SidebarEntries = {}, CurrentTab = nil}
	local screen = Instance.new("ScreenGui")
	screen.Name = "MelonityUI"
	screen.Parent = CoreGui
	local main = Instance.new("Frame")
	main.Size = UDim2.fromOffset(980, 620)
	main.Position = UDim2.new(0.5, 0, 0.5, 0)
	main.AnchorPoint = Vector2.new(0.5, 0.5)
	main.BackgroundColor3 = Theme.MainBG
	main.BorderSizePixel = 0
	main.Parent = screen
	round(main, 6)
	local drag, start, pPos
	main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pPos = main.Position end end)
	UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
	local h = Instance.new("Frame")
	h.Size = UDim2.new(1, 0, 0, 45)
	h.BackgroundColor3 = Theme.TopBarBG
	h.Parent = main
	round(h, 6)
	local lg = Instance.new("ImageLabel")
	lg.Size = UDim2.fromOffset(24, 24)
	lg.Position = UDim2.new(0, 15, 0.5, -12)
	lg.BackgroundTransparency = 1
	lg.Image = "rbxassetid://13000639907"
	lg.ImageColor3 = Theme.Accent
	lg.Parent = h
	local gs = Instance.new("Frame")
	gs.Size = UDim2.fromOffset(350, 28)
	gs.Position = UDim2.new(0, 50, 0.5, -14)
	gs.BackgroundColor3 = Theme.SearchBG
	gs.Parent = h
	round(gs, 4)
	local gInp = Instance.new("TextBox")
	gInp.Size = UDim2.new(1, -30, 1, 0)
	gInp.Position = UDim2.new(0, 30, 0, 0)
	gInp.BackgroundTransparency = 1
	gInp.Text = ""
	gInp.PlaceholderText = "Search"
	gInp.PlaceholderColor3 = Theme.TextGray
	gInp.TextColor3 = Theme.Text
	gInp.Font = "GothamMedium"
	gInp.TextSize = 13
	gInp.TextXAlignment = "Left"
	gInp.Parent = gs
	local lang = Instance.new("TextLabel")
	lang.Size = UDim2.new(0, 100, 1, 0)
	lang.Position = UDim2.new(1, -150, 0, 0)
	lang.BackgroundTransparency = 1
	lang.Text = "🇷🇺 Русский  ▼"
	lang.TextColor3 = Theme.TextGray
	lang.Font = "GothamMedium"
	lang.TextSize = 12
	lang.Parent = h
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
	local st = Instance.new("TextLabel")
	st.Text = "Навигация"
	st.Size = UDim2.new(1, -30, 0, 40)
	st.Position = UDim2.new(0, 15, 0, 5)
	st.BackgroundTransparency = 1
	st.TextColor3 = Theme.Text
	st.Font = "GothamBold"
	st.TextSize = 14
	st.TextXAlignment = "Left"
	st.Parent = sb
	local ss = gs:Clone()
	ss.Size = UDim2.new(1, -30, 0, 26)
	ss.Position = UDim2.new(0, 15, 0, 45)
	ss.Parent = sb
	local ns = Instance.new("ScrollingFrame")
	ns.Size = UDim2.new(1, 0, 1, -150)
	ns.Position = UDim2.new(0, 0, 0, 80)
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
	ss.TextBox:GetPropertyChangedSignal("Text"):Connect(function()
		local q = ss.TextBox.Text:lower()
		for _, v in pairs(win.SidebarEntries) do v.Visible = v.Name:lower():find(q) ~= nil end
	end)
	function win:AddTopTab(name, icon)
		local t = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton"), Window = self}
		t.P.Size = UDim2.new(1, -20, 1, -20)
		t.P.Position = UDim2.new(0, 10, 0, 10)
		t.P.BackgroundTransparency = 1
		t.P.BorderSizePixel = 0
		t.P.Visible = false
		t.P.ScrollBarThickness = 0
		t.P.Parent = ct
		local gl = Instance.new("UIGridLayout")
		gl.CellPadding = UDim2.fromOffset(10, 10)
		gl.CellSize = UDim2.new(0.5, -5, 0, 10)
		gl.Parent = t.P
		gl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() t.P.CanvasSize = UDim2.fromOffset(0, gl.AbsoluteContentSize.Y) end)
		t.B.Size = UDim2.new(0, 0, 1, 0)
		t.B.AutomaticSize = "X"
		t.B.BackgroundTransparency = 1
		t.B.Text = (icon and "   " or "") .. name:upper()
		t.B.TextColor3 = Theme.TextGray
		t.B.Font = "GothamBold"
		t.B.TextSize = 11
		t.B.Parent = th
		if icon then
			local i = Instance.new("ImageLabel")
			i.Size = UDim2.fromOffset(14, 14)
			i.Position = UDim2.new(0, -16, 0.5, -7)
			i.Image = "rbxassetid://" .. icon
			i.BackgroundTransparency = 1
			i.ImageColor3 = Theme.TextGray
			i.Parent = t.B
		end
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
			ind.Size = UDim2.fromOffset(4, 4)
			ind.Position = UDim2.new(0, 15, 0.5, -2)
			ind.BackgroundColor3 = Theme.TextGray
			ind.Parent = e
			round(ind, 2)
			e.MouseEnter:Connect(function() tween(e, 0.2, {TextColor3 = Theme.Text}) tween(ind, 0.2, {BackgroundColor3 = Theme.Accent}) end)
			e.MouseLeave:Connect(function() tween(e, 0.2, {TextColor3 = Theme.TextGray}) tween(ind, 0.2, {BackgroundColor3 = Theme.TextGray}) end)
			table.insert(self.Window.SidebarEntries, e)
			return e
		end
		function t:CreateSection(title)
			local sec = {}
			local sf = Instance.new("Frame")
			sf.BackgroundColor3 = Theme.PanelBG
			sf.AutomaticSize = "Y"
			sf.Parent = t.Page or t.P
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
			Instance.new("UIListLayout", c).Padding = UDim.new(0, 8)
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
				bg.Size = UDim2.new(0, 32, 0, 16)
				bg.Position = UDim2.new(1, -32, 0.5, -8)
				bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
				bg.Text = ""
				bg.Parent = r
				round(bg, 8)
				local d = Instance.new("Frame")
				d.Size = UDim2.fromOffset(12, 12)
				d.Position = UDim2.new(0, 2, 0.5, -6)
				d.BackgroundColor3 = Theme.Text
				d.Parent = bg
				round(d, 6)
				local state = o.Default or false
				local function update()
					tween(bg, 0.2, {BackgroundColor3 = state and Theme.Accent or Color3.fromRGB(50, 50, 55)})
					tween(d, 0.2, {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
					if o.Callback then o.Callback(state) end
				end
				bg.MouseButton1Click:Connect(function() state = not state update() end)
				update()
			end
			function sec:AddSlider(o)
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 35)
				r.BackgroundTransparency = 1
				r.Parent = c
				local tl = Instance.new("TextLabel")
				tl.Text = o.Text
				tl.Size = UDim2.new(1, 0, 0, 15)
				tl.BackgroundTransparency = 1
				tl.TextColor3 = Theme.Text
				tl.Font = "Gotham"
				tl.TextSize = 12
				tl.TextXAlignment = "Left"
				tl.Parent = r
				local vL = Instance.new("TextLabel")
				vL.Text = tostring(o.Default or o.Min)
				vL.Size = UDim2.new(0, 40, 0, 15)
				vL.Position = UDim2.new(1, -40, 0, 0)
				vL.BackgroundTransparency = 1
				vL.TextColor3 = Theme.TextGray
				vL.Font = "Gotham"
				vL.TextSize = 11
				vL.Parent = r
				local bar = Instance.new("Frame")
				bar.Size = UDim2.new(1, 0, 0, 4)
				bar.Position = UDim2.new(0, 0, 0, 25)
				bar.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
				bar.Parent = r
				round(bar, 2)
				local fill = Instance.new("Frame")
				fill.Size = UDim2.new((o.Default-o.Min)/(o.Max-o.Min), 0, 1, 0)
				fill.BackgroundColor3 = Theme.Accent
				fill.Parent = bar
				round(fill, 2)
				local h = Instance.new("Frame")
				h.Size = UDim2.fromOffset(10, 10)
				h.AnchorPoint = Vector2.new(0.5, 0.5)
				h.Position = UDim2.new(fill.Size.X.Scale, 0, 0.5, 0)
				h.BackgroundColor3 = Theme.Text
				h.Parent = bar
				round(h, 5)
				local dragging = false
				local function up(i)
					local p = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					local v = math.floor(o.Min + (o.Max - o.Min) * p)
					fill.Size = UDim2.new(p, 0, 1, 0)
					h.Position = UDim2.new(p, 0, 0.5, 0)
					vL.Text = tostring(v)
					if o.Callback then o.Callback(v) end
				end
				h.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
				UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then up(i) end end)
			end
			function sec:AddDropdown(o)
				local drop = {Open = false, Selected = {}, Items = {}}
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 45)
				r.BackgroundTransparency = 1
				r.Parent = c
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, 0, 0, 25)
				b.Position = UDim2.new(0, 0, 0, 20)
				b.BackgroundColor3 = Theme.SearchBG
				b.Text = "  " .. o.Text .. "..."
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
				for _, val in pairs(o.Options) do
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
						if o.Multi then
							if table.find(drop.Selected, val) then
								table.remove(drop.Selected, table.find(drop.Selected, val))
								ob.TextColor3 = Theme.TextGray
							else
								table.insert(drop.Selected, val)
								ob.TextColor3 = Theme.Accent
							end
							b.Text = "  " .. table.concat(drop.Selected, ", ")
						else
							b.Text = "  " .. val
							drop.Open = false
							list.Size = UDim2.new(1, 0, 0, 0)
						end
						if o.Callback then o.Callback(o.Multi and drop.Selected or val) end
					end)
					table.insert(drop.Items, ob)
				end
				return {
					EnableAll = function()
						drop.Selected = {}
						for _, v in pairs(o.Options) do table.insert(drop.Selected, v) end
						for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.Accent end
						b.Text = "  " .. table.concat(drop.Selected, ", ")
					end,
					DisableAll = function()
						drop.Selected = {}
						for _, btn in pairs(drop.Items) do btn.TextColor3 = Theme.TextGray end
						b.Text = "  Select..."
					end
				}
			end
			function sec:AddKeybind(o)
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 26)
				r.BackgroundTransparency = 1
				r.Parent = c
				local tl = Instance.new("TextLabel")
				tl.Text = o.Text
				tl.Size = UDim2.new(1, -70, 1, 0)
				tl.BackgroundTransparency = 1
				tl.TextColor3 = Theme.Text
				tl.Font = "Gotham"
				tl.TextSize = 12
				tl.TextXAlignment = "Left"
				tl.Parent = r
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(0, 60, 0, 20)
				b.Position = UDim2.new(1, -60, 0.5, -10)
				b.BackgroundColor3 = Theme.SearchBG
				b.Text = o.Default and o.Default.Name or "None"
				b.TextColor3 = Theme.TextGray
				b.Font = "Gotham"
				b.TextSize = 11
				b.Parent = r
				round(b, 4)
				b.MouseButton1Click:Connect(function()
					b.Text = "..."
					local conn
					conn = UserInputService.InputBegan:Connect(function(i)
						if i.UserInputType == Enum.UserInputType.Keyboard then
							b.Text = i.KeyCode.Name
							conn:Disconnect()
							if o.Callback then o.Callback(i.KeyCode) end
						end
					end)
				end)
			end
			function sec:AddButton(o)
				local b = Instance.new("TextButton")
				b.Size = UDim2.new(1, 0, 0, 28)
				b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
				b.Text = o.Text
				b.TextColor3 = Theme.Text
				b.Font = "GothamBold"
				b.TextSize = 12
				b.Parent = c
				round(b, 4)
				b.MouseButton1Click:Connect(function() if o.Callback then o.Callback() end end)
			end
			return sec
		end
		return t
	end
	return win
end
return MUILib
