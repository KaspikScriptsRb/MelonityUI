local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MUILib = {}
MUILib.__index = MUILib
local Theme = {MainBG = Color3.fromRGB(24, 25, 32), SidebarBG = Color3.fromRGB(18, 19, 24), TopBarBG = Color3.fromRGB(20, 21, 27), PanelBG = Color3.fromRGB(30, 31, 38), Accent = Color3.fromRGB(255, 46, 105), Text = Color3.fromRGB(255, 255, 255), TextGray = Color3.fromRGB(130, 132, 142), Border = Color3.fromRGB(45, 46, 54), SearchBG = Color3.fromRGB(15, 16, 20)}
local function tween(o, t, p) TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end
local function round(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = p end
function MUILib:CreateWindow(opts)
	local win = {Tabs = {}, SideItems = {}, CurrentTab = nil, Lang = "Русский"}
	local screen = Instance.new("ScreenGui") screen.Name = "MelonityUI" screen.Parent = CoreGui
	local main = Instance.new("Frame") main.Size = UDim2.fromOffset(980, 620) main.Position = UDim2.new(0.5, 0, 0.5, 0) main.AnchorPoint = Vector2.new(0.5, 0.5) main.BackgroundColor3 = Theme.MainBG main.BorderSizePixel = 0 main.Parent = screen round(main, 6)
	local drag, start, pPos
	main.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pPos = main.Position end end)
	UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start main.Position = UDim2.new(pPos.X.Scale, pPos.X.Offset + d.X, pPos.Y.Scale, pPos.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
	local h = Instance.new("Frame") h.Size = UDim2.new(1, 0, 0, 45) h.BackgroundColor3 = Theme.TopBarBG h.Parent = main round(h, 6)
	local lg = Instance.new("ImageLabel") lg.Size = UDim2.fromOffset(24, 24) lg.Position = UDim2.new(0, 15, 0.5, -12) lg.BackgroundTransparency = 1 lg.Image = "rbxassetid://13000639907" lg.ImageColor3 = Theme.Accent lg.Parent = h
	local gs = Instance.new("Frame") gs.Size = UDim2.fromOffset(350, 28) gs.Position = UDim2.new(0, 50, 0.5, -14) gs.BackgroundColor3 = Theme.SearchBG gs.Parent = h round(gs, 4)
	local gInp = Instance.new("TextBox") gInp.Size = UDim2.new(1, -30, 1, 0) gInp.Position = UDim2.new(0, 30, 0, 0) gInp.BackgroundTransparency = 1 gInp.Text = "" gInp.PlaceholderText = "Search" gInp.PlaceholderColor3 = Theme.TextGray gInp.TextColor3 = Theme.Text gInp.TextSize = 13 gInp.Font = "GothamMedium" gInp.TextXAlignment = "Left" gInp.Parent = gs
	local sIco = Instance.new("ImageLabel") sIco.Size = UDim2.fromOffset(14, 14) sIco.Position = UDim2.new(0, 10, 0.5, -7) sIco.Image = "rbxassetid://6031154871" sIco.ImageColor3 = Theme.TextGray sIco.BackgroundTransparency = 1 sIco.Parent = gs
	local lBtn = Instance.new("TextButton") lBtn.Size = UDim2.new(0, 120, 0, 28) lBtn.Position = UDim2.new(1, -150, 0.5, -14) lBtn.BackgroundTransparency = 1 lBtn.Text = "🇷🇺 " .. win.Lang .. "  ▼" lBtn.TextColor3 = Theme.TextGray lBtn.Font = "GothamMedium" lBtn.TextSize = 12 lBtn.Parent = h
	local th = Instance.new("Frame") th.Size = UDim2.new(1, 0, 0, 40) th.Position = UDim2.new(0, 0, 0, 45) th.BackgroundColor3 = Theme.TopBarBG th.Parent = main
	local tl = Instance.new("UIListLayout") tl.FillDirection = "Horizontal" tl.Padding = UDim.new(0, 20) tl.VerticalAlignment = "Center" tl.Parent = th
	Instance.new("UIPadding", th).PaddingLeft = UDim.new(0, 20)
	local sb = Instance.new("Frame") sb.Size = UDim2.new(0, 220, 1, -85) sb.Position = UDim2.new(0, 0, 0, 85) sb.BackgroundColor3 = Theme.SidebarBG sb.Parent = main
	local st = Instance.new("TextLabel") st.Text = "Навигация" st.Size = UDim2.new(1, -30, 0, 40) st.Position = UDim2.new(0, 15, 0, 5) st.BackgroundTransparency = 1 st.TextColor3 = Theme.Text st.Font = "GothamBold" st.TextSize = 14 st.TextXAlignment = "Left" st.Parent = sb
	local ns = Instance.new("ScrollingFrame") ns.Size = UDim2.new(1, 0, 1, -100) ns.Position = UDim2.new(0, 0, 0, 45) ns.BackgroundTransparency = 1 ns.BorderSizePixel = 0 ns.ScrollBarThickness = 0 ns.Parent = sb
	Instance.new("UIListLayout", ns).Padding = UDim.new(0, 2)
	local prof = Instance.new("Frame") prof.Size = UDim2.new(1, 0, 0, 60) prof.Position = UDim2.new(0, 0, 1, -60) prof.BackgroundColor3 = Theme.SearchBG prof.Parent = sb
	local av = Instance.new("ImageLabel") av.Size = UDim2.fromOffset(36, 36) av.Position = UDim2.new(0, 15, 0.5, -18) av.Image = "rbxassetid://13000639907" av.Parent = prof round(av, 18)
	local uN = Instance.new("TextLabel") uN.Text = "User#0000" uN.Size = UDim2.new(1, -65, 0, 15) uN.Position = UDim2.new(0, 60, 0.5, -10) uN.BackgroundTransparency = 1 uN.TextColor3 = Theme.Text uN.Font = "GothamMedium" uN.TextSize = 13 uN.TextXAlignment = "Left" uN.Parent = prof
	local ct = Instance.new("Frame") ct.Size = UDim2.new(1, -220, 1, -85) ct.Position = UDim2.new(0, 220, 0, 85) ct.BackgroundTransparency = 1 ct.Parent = main
	gInp:GetPropertyChangedSignal("Text"):Connect(function() local q = gInp.Text:lower() for _, i in pairs(win.SideItems) do i.Visible = i.Name:lower():find(q) ~= nil end end)
	function win:AddTopTab(name, icon)
		local tab = {P = Instance.new("ScrollingFrame"), B = Instance.new("TextButton"), Items = {}}
		tab.P.Size = UDim2.new(1, -20, 1, -20) tab.P.Position = UDim2.new(0, 10, 0, 10) tab.P.BackgroundTransparency = 1 tab.P.BorderSizePixel = 0 tab.P.Visible = false tab.P.ScrollBarThickness = 0 tab.P.Parent = ct
		local gl = Instance.new("UIGridLayout") gl.CellPadding = UDim2.fromOffset(10, 10) gl.CellSize = UDim2.new(0.5, -5, 0, 10) gl.Parent = tab.P
		gl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() tab.P.CanvasSize = UDim2.fromOffset(0, gl.AbsoluteContentSize.Y) end)
		tab.B.Size = UDim2.new(0, 0, 1, 0) tab.B.AutomaticSize = "X" tab.B.BackgroundTransparency = 1 tab.B.Text = (icon and "   " or "") .. name:upper() tab.B.TextColor3 = Theme.TextGray tab.B.Font = "GothamBold" tab.B.TextSize = 11 tab.B.Parent = th
		if icon then local i = Instance.new("ImageLabel") i.Size = UDim2.fromOffset(14, 14) i.Position = UDim2.new(0, -16, 0.5, -7) i.Image = "rbxassetid://" .. icon i.BackgroundTransparency = 1 i.ImageColor3 = Theme.TextGray i.Parent = tab.B end
		tab.B.MouseButton1Click:Connect(function() for _, v in pairs(win.Tabs) do v.P.Visible = false v.B.TextColor3 = Theme.TextGray end tab.P.Visible = true tab.B.TextColor3 = Theme.Accent end)
		table.insert(win.Tabs, tab) if #win.Tabs == 1 then tab.P.Visible = true tab.B.TextColor3 = Theme.Accent end
		function tab:AddSideEntry(text, icon)
			local eb = Instance.new("TextButton") eb.Name = text eb.Size = UDim2.new(1, 0, 0, 32) eb.BackgroundTransparency = 1 eb.Text = "      " .. text eb.TextColor3 = Theme.TextGray eb.Font = "GothamMedium" eb.TextSize = 13 eb.TextXAlignment = "Left" eb.Parent = ns
			local ind = Instance.new("Frame") ind.Size = UDim2.fromOffset(4, 4) ind.Position = UDim2.new(0, 15, 0.5, -2) ind.BackgroundColor3 = Theme.TextGray ind.Parent = eb round(ind, 2)
			if icon then local i = Instance.new("ImageLabel") i.Size = UDim2.fromOffset(16, 16) i.Position = UDim2.new(0, 12, 0.5, -8) i.Image = "rbxassetid://" .. icon i.BackgroundTransparency = 1 i.Parent = eb ind.Visible = false end
			eb.MouseEnter:Connect(function() tween(eb, 0.2, {TextColor3 = Theme.Text}) tween(ind, 0.2, {BackgroundColor3 = Theme.Accent}) end)
			eb.MouseLeave:Connect(function() tween(eb, 0.2, {TextColor3 = Theme.TextGray}) tween(ind, 0.2, {BackgroundColor3 = Theme.TextGray}) end)
			table.insert(win.SideItems, eb) return eb
		end
		function tab:CreateSection(title)
			local sec = {Elements = {}}
			local s = Instance.new("Frame") s.BackgroundColor3 = Theme.PanelBG s.AutomaticSize = "Y" s.Parent = tab.P round(s, 4)
			local l = Instance.new("Frame") l.Size = UDim2.new(0, 3, 0, 18) l.Position = UDim2.new(0, 0, 0, 12) l.BackgroundColor3 = Theme.Accent l.Parent = s
			local st = Instance.new("TextLabel") st.Text = title st.Size = UDim2.new(1, -20, 0, 40) st.Position = UDim2.new(0, 15, 0, 0) st.BackgroundTransparency = 1 st.TextColor3 = Theme.Text st.Font = "GothamBold" st.TextSize = 13 st.TextXAlignment = "Left" st.Parent = s
			local c = Instance.new("Frame") c.Size = UDim2.new(1, -24, 0, 0) c.Position = UDim2.new(0, 12, 0, 40) c.AutomaticSize = "Y" c.BackgroundTransparency = 1 c.Parent = s
			Instance.new("UIListLayout", c).Padding = UDim.new(0, 8)
			function sec:AddToggle(opts)
				local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 26) r.BackgroundTransparency = 1 r.Parent = c
				local tl = Instance.new("TextLabel") tl.Text = opts.Text tl.Size = UDim2.new(1, -45, 1, 0) tl.BackgroundTransparency = 1 tl.TextColor3 = Theme.Text tl.Font = "Gotham" tl.TextSize = 12 tl.TextXAlignment = "Left" tl.Parent = r
				local bg = Instance.new("TextButton") bg.Size = UDim2.new(0, 32, 0, 16) bg.Position = UDim2.new(1, -32, 0.5, -8) bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55) bg.Text = "" bg.Parent = r round(bg, 8)
				local d = Instance.new("Frame") d.Size = UDim2.fromOffset(12, 12) d.Position = UDim2.new(0, 2, 0.5, -6) d.BackgroundColor3 = Theme.Text d.Parent = bg round(d, 6)
				local st = false
				local function set(v) st = v tween(bg, 0.2, {BackgroundColor3 = st and Theme.Accent or Color3.fromRGB(50, 50, 55)}) tween(d, 0.2, {Position = st and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}) if opts.Callback then opts.Callback(st) end end
				bg.MouseButton1Click:Connect(function() set(not st) end)
				local obj = {Set = set} table.insert(sec.Elements, obj) return obj
			end
			function sec:AddSlider(opts)
				local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 35) r.BackgroundTransparency = 1 r.Parent = c
				local tl = Instance.new("TextLabel") tl.Text = opts.Text tl.Size = UDim2.new(1, 0, 0, 15) tl.BackgroundTransparency = 1 tl.TextColor3 = Theme.Text tl.Font = "Gotham" tl.TextSize = 12 tl.TextXAlignment = "Left" tl.Parent = r
				local vL = Instance.new("TextLabel") vL.Text = tostring(opts.Default) vL.Size = UDim2.new(0, 40, 0, 15) vL.Position = UDim2.new(1, -40, 0, 0) vL.BackgroundTransparency = 1 vL.TextColor3 = Theme.TextGray vL.Font = "Gotham" vL.TextSize = 11 vL.Parent = r
				local sb = Instance.new("Frame") sb.Size = UDim2.new(1, 0, 0, 4) sb.Position = UDim2.new(0, 0, 0, 25) sb.BackgroundColor3 = Color3.fromRGB(45, 45, 50) sb.Parent = r round(sb, 2)
				local sf = Instance.new("Frame") sf.Size = UDim2.new((opts.Default-opts.Min)/(opts.Max-opts.Min), 0, 1, 0) sf.BackgroundColor3 = Theme.Accent sf.Parent = sb round(sf, 2)
				local h = Instance.new("Frame") h.Size = UDim2.fromOffset(10, 10) h.AnchorPoint = Vector2.new(0.5, 0.5) h.Position = UDim2.new(sf.Size.X.Scale, 0, 0.5, 0) h.BackgroundColor3 = Theme.Text h.Parent = sb round(h, 5)
				local drag = false
				local function up(i) local p = math.clamp((i.Position.X - sb.AbsolutePosition.X) / sb.AbsoluteSize.X, 0, 1) local v = math.floor(opts.Min + (opts.Max - opts.Min) * p) sf.Size = UDim2.new(p, 0, 1, 0) h.Position = UDim2.new(p, 0, 0.5, 0) vL.Text = tostring(v) if opts.Callback then opts.Callback(v) end end
				h.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true end end)
				UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
				UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then up(i) end end)
			end
			function sec:AddDropdown(opts)
				local d = {Open = false, Selected = {}, Items = {}}
				local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 45) r.BackgroundTransparency = 1 r.Parent = c
				local tl = Instance.new("TextLabel") tl.Text = opts.Text tl.Size = UDim2.new(1, 0, 0, 15) tl.BackgroundTransparency = 1 tl.TextColor3 = Theme.Text tl.Font = "Gotham" tl.TextSize = 12 tl.TextXAlignment = "Left" tl.Parent = r
				local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 0, 25) b.Position = UDim2.new(0, 0, 0, 20) b.BackgroundColor3 = Theme.SearchBG b.Text = "  Select..." b.TextColor3 = Theme.TextGray b.Font = "Gotham" b.TextSize = 12 b.TextXAlignment = "Left" b.Parent = r round(b, 4)
				local list = Instance.new("ScrollingFrame") list.Size = UDim2.new(1, 0, 0, 0) list.Position = UDim2.new(0, 0, 0, 50) list.BackgroundColor3 = Theme.SearchBG list.BorderSizePixel = 0 list.ClipsDescendants = true list.ZIndex = 5 list.ScrollBarThickness = 2 list.Parent = r round(list, 4)
				local ll = Instance.new("UIListLayout") ll.Parent = list
				b.MouseButton1Click:Connect(function() d.Open = not d.Open tween(list, 0.2, {Size = d.Open and UDim2.new(1, 0, 0, math.min(ll.AbsoluteContentSize.Y, 150)) or UDim2.new(1, 0, 0, 0)}) list.CanvasSize = UDim2.fromOffset(0, ll.AbsoluteContentSize.Y) end)
				local function refresh() b.Text = "  " .. (#d.Selected > 0 and table.concat(d.Selected, ", ") or "Select...") if opts.Callback then opts.Callback(opts.Multi and d.Selected or d.Selected[1]) end end
				for _, v in pairs(opts.Options) do
					local ob = Instance.new("TextButton") ob.Size = UDim2.new(1, 0, 0, 25) ob.BackgroundTransparency = 1 ob.Text = "  " .. v ob.TextColor3 = Theme.TextGray ob.Font = "Gotham" ob.TextSize = 12 ob.TextXAlignment = "Left" ob.Parent = list
					ob.MouseButton1Click:Connect(function() if opts.Multi then if table.find(d.Selected, v) then table.remove(d.Selected, table.find(d.Selected, v)) ob.TextColor3 = Theme.TextGray else table.insert(d.Selected, v) ob.TextColor3 = Theme.Accent end else d.Selected = {v} for _, x in pairs(list:GetChildren()) do if x:IsA("TextButton") then x.TextColor3 = Theme.TextGray end end ob.TextColor3 = Theme.Accent d.Open = false list.Size = UDim2.new(1, 0, 0, 0) end refresh() end)
					table.insert(d.Items, {Btn = ob, Val = v})
				end
				local obj = {
					EnableAll = function() d.Selected = {}; for _, i in pairs(d.Items) do table.insert(d.Selected, i.Val) i.Btn.TextColor3 = Theme.Accent end refresh() end,
					DisableAll = function() d.Selected = {}; for _, i in pairs(d.Items) do i.Btn.TextColor3 = Theme.TextGray end refresh() end
				}
				if opts.Default then if type(opts.Default) == "table" then for _, v in pairs(opts.Default) do table.insert(d.Selected, v) end else table.insert(d.Selected, opts.Default) end refresh() end
				return obj
			end
			function sec:AddKeybind(opts)
				local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 26) r.BackgroundTransparency = 1 r.Parent = c
				local tl = Instance.new("TextLabel") tl.Text = opts.Text tl.Size = UDim2.new(1, -60, 1, 0) tl.BackgroundTransparency = 1 tl.TextColor3 = Theme.Text tl.Font = "Gotham" tl.TextSize = 12 tl.TextXAlignment = "Left" tl.Parent = r
				local b = Instance.new("TextButton") b.Size = UDim2.new(0, 60, 0, 20) b.Position = UDim2.new(1, -60, 0.5, -10) b.BackgroundColor3 = Theme.SearchBG b.Text = opts.Default and opts.Default.Name or "None" b.TextColor3 = Theme.TextGray b.Font = "Gotham" b.TextSize = 11 b.Parent = r round(b, 4)
				local bind = opts.Default
				b.MouseButton1Click:Connect(function() b.Text = "..." local c; c = UserInputService.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.Keyboard then bind = i.KeyCode b.Text = i.KeyCode.Name c:Disconnect() if opts.Callback then opts.Callback(i.KeyCode) end end end) end)
			end
			function sec:AddButton(opts)
				local b = Instance.new("TextButton") b.Size = UDim2.new(1, 0, 0, 28) b.BackgroundColor3 = Color3.fromRGB(40, 40, 45) b.Text = opts.Text b.TextColor3 = Theme.Text b.Font = "GothamBold" b.TextSize = 12 b.Parent = c round(b, 4)
				b.MouseButton1Click:Connect(function() if opts.Callback then opts.Callback() end end)
				return b
			end
			return sec
		end
		return tab
	end
	return win
end
return MUILib
