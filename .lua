local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local MUILib = {}
MUILib.__index = MUILib
local Theme = {MainBG = Color3.fromRGB(24, 25, 32), SidebarBG = Color3.fromRGB(18, 19, 24), TopBarBG = Color3.fromRGB(20, 21, 27), PanelBG = Color3.fromRGB(30, 31, 38), Accent = Color3.fromRGB(255, 46, 105), Text = Color3.fromRGB(255, 255, 255), TextGray = Color3.fromRGB(130, 132, 142)}
local function tween(o, t, p) TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad), p):Play() end
local function round(p, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = p end
function MUILib:CreateWindow(opts)
	local s = Instance.new("ScreenGui") s.Name = "MUI_Lib" s.Parent = CoreGui
	local m = Instance.new("Frame") m.Name = "Main" m.Size = UDim2.fromOffset(960, 600) m.Position = UDim2.new(0.5, 0, 0.5, 0) m.AnchorPoint = Vector2.new(0.5, 0.5) m.BackgroundColor3 = Theme.MainBG m.BorderSizePixel = 0 m.Parent = s round(m, 6)
	local drag, start, pos
	m.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = true start = i.Position pos = m.Position end end)
	UserInputService.InputChanged:Connect(function(i) if drag and i.UserInputType == Enum.UserInputType.MouseMovement then local d = i.Position - start m.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y) end end)
	UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end end)
	local tb = Instance.new("Frame") tb.Size = UDim2.new(1, 0, 0, 45) tb.BackgroundColor3 = Theme.TopBarBG tb.Parent = m round(tb, 6)
	local th = Instance.new("Frame") th.Size = UDim2.new(1, 0, 0, 40) th.Position = UDim2.new(0, 0, 0, 45) th.BackgroundColor3 = Theme.TopBarBG th.Parent = m
	local tl = Instance.new("UIListLayout") tl.FillDirection = "Horizontal" tl.Padding = UDim.new(0, 20) tl.VerticalAlignment = "Center" tl.Parent = th
	Instance.new("UIPadding", th).PaddingLeft = UDim.new(0, 20)
	local sb = Instance.new("Frame") sb.Size = UDim2.new(0, 220, 1, -85) sb.Position = UDim2.new(0, 0, 0, 85) sb.BackgroundColor3 = Theme.SidebarBG sb.BorderSizePixel = 0 sb.Parent = m
	local st = Instance.new("TextLabel") st.Text = "Навигация" st.Size = UDim2.new(1, -30, 0, 40) st.Position = UDim2.new(0, 15, 0, 5) st.BackgroundTransparency = 1 st.TextColor3 = Theme.Text st.TextXAlignment = "Left" st.Font = "GothamBold" st.TextSize = 14 st.Parent = sb
	local ns = Instance.new("ScrollingFrame") ns.Size = UDim2.new(1, 0, 1, -50) ns.Position = UDim2.new(0, 0, 0, 45) ns.BackgroundTransparency = 1 ns.BorderSizePixel = 0 ns.ScrollBarThickness = 0 ns.Parent = sb
	Instance.new("UIListLayout", ns).Padding = UDim.new(0, 2)
	local ct = Instance.new("Frame") ct.Size = UDim2.new(1, -240, 1, -105) ct.Position = UDim2.new(0, 230, 0, 95) ct.BackgroundTransparency = 1 ct.Parent = m
	local window = setmetatable({Tabs = {}, Content = ct, TabHolder = th, Nav = ns}, MUILib)
	return window
end
function MUILib:AddTopTab(name)
	local b = Instance.new("TextButton") b.Size = UDim2.new(0, 0, 1, 0) b.AutomaticSize = "X" b.BackgroundTransparency = 1 b.Text = name:upper() b.TextColor3 = Theme.TextGray b.Font = "GothamBold" b.TextSize = 11 b.Parent = self.TabHolder
	local p = Instance.new("ScrollingFrame") p.Size = UDim2.new(1, 0, 1, 0) p.BackgroundTransparency = 1 p.Visible = false p.ScrollBarThickness = 0 p.BorderSizePixel = 0 p.Parent = self.Content
	local gl = Instance.new("UIGridLayout") gl.CellPadding = UDim2.fromOffset(10, 10) gl.CellSize = UDim2.new(0.5, -5, 0, 10) gl.Parent = p
	gl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() p.CanvasSize = UDim2.fromOffset(0, gl.AbsoluteContentSize.Y) end)
	local tab = {Page = p, Main = self}
	b.MouseButton1Click:Connect(function()
		for _, v in pairs(self.Main.Tabs) do v.Page.Visible = false v.Btn.TextColor3 = Theme.TextGray end
		p.Visible = true b.TextColor3 = Theme.Accent
	end)
	table.insert(self.Main.Tabs, {Page = p, Btn = b})
	if #self.Main.Tabs == 1 then p.Visible = true b.TextColor3 = Theme.Accent end
	function tab:AddSideEntry(text)
		local eb = Instance.new("TextButton") eb.Size = UDim2.new(1, 0, 0, 32) eb.BackgroundTransparency = 1 eb.Text = "      " .. text eb.TextColor3 = Theme.TextGray eb.TextXAlignment = "Left" eb.Font = "GothamMedium" eb.TextSize = 13 eb.Parent = self.Main.Nav
		local icon = Instance.new("Frame") icon.Size = UDim2.fromOffset(4, 4) icon.Position = UDim2.new(0, 15, 0.5, -2) icon.BackgroundColor3 = Theme.TextGray icon.Parent = eb round(icon, 2)
		eb.MouseEnter:Connect(function() tween(eb, 0.2, {TextColor3 = Theme.Text}) tween(icon, 0.2, {BackgroundColor3 = Theme.Accent}) end)
		eb.MouseLeave:Connect(function() tween(eb, 0.2, {TextColor3 = Theme.TextGray}) tween(icon, 0.2, {BackgroundColor3 = Theme.TextGray}) end)
		return eb
	end
	function tab:CreateSection(title)
		local s = Instance.new("Frame") s.BackgroundColor3 = Theme.PanelBG s.AutomaticSize = "Y" s.BorderSizePixel = 0 s.Parent = p round(s, 4)
		local l = Instance.new("Frame") l.Size = UDim2.new(0, 3, 0, 18) l.Position = UDim2.new(0, 0, 0, 12) l.BackgroundColor3 = Theme.Accent l.BorderSizePixel = 0 l.Parent = s
		local t = Instance.new("TextLabel") t.Text = title t.Size = UDim2.new(1, -20, 0, 40) t.Position = UDim2.new(0, 15, 0, 0) t.BackgroundTransparency = 1 t.TextColor3 = Theme.Text t.Font = "GothamBold" t.TextSize = 14 t.TextXAlignment = "Left" t.Parent = s
		local c = Instance.new("Frame") c.Size = UDim2.new(1, -24, 0, 0) c.Position = UDim2.new(0, 12, 0, 40) c.AutomaticSize = "Y" c.BackgroundTransparency = 1 c.Parent = s
		Instance.new("UIListLayout", c).Padding = UDim.new(0, 8)
		local sec = {}
		function sec:AddToggle(opts)
			local r = Instance.new("Frame") r.Size = UDim2.new(1, 0, 0, 26) r.BackgroundTransparency = 1 r.Parent = c
			local tl = Instance.new("TextLabel") tl.Text = opts.Text tl.Size = UDim2.new(1, -45, 1, 0) tl.BackgroundTransparency = 1 tl.TextColor3 = Theme.Text tl.Font = "Gotham" tl.TextSize = 13 tl.TextXAlignment = "Left" tl.Parent = r
			local bg = Instance.new("TextButton") bg.Size = UDim2.new(0, 34, 0, 18) bg.Position = UDim2.new(1, -34, 0.5, -9) bg.BackgroundColor3 = Color3.fromRGB(50, 50, 55) bg.Text = "" bg.AutoButtonColor = false bg.Parent = r round(bg, 9)
			local d = Instance.new("Frame") d.Size = UDim2.fromOffset(14, 14) d.Position = UDim2.new(0, 2, 0.5, -7) d.BackgroundColor3 = Theme.Text d.Parent = bg round(d, 7)
			local st = false
			bg.MouseButton1Click:Connect(function()
				st = not st
				tween(bg, 0.2, {BackgroundColor3 = st and Theme.Accent or Color3.fromRGB(50, 50, 55)})
				tween(d, 0.2, {Position = st and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)})
				if opts.Callback then opts.Callback(st) end
			end)
		end
		return sec
	end
	return tab
end
_G.MUILib = MUILib
return MUILib
