local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local CoreGui           = game:GetService("CoreGui")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
--  UI FRAMEWORK
-- ============================================================
local UI = {}
UI.COLORS = {
    BG           = Color3.fromRGB(28, 28, 32),
    Sidebar      = Color3.fromRGB(34, 34, 40),
    Card         = Color3.fromRGB(38, 38, 44),
    Element      = Color3.fromRGB(44, 44, 50),
    ElementHover = Color3.fromRGB(52, 52, 58),
    Accent       = Color3.fromRGB(255, 140, 50),
    AccentDim    = Color3.fromRGB(180, 95, 30),
    Text         = Color3.fromRGB(235, 235, 240),
    TextDim      = Color3.fromRGB(160, 160, 170),
    Border       = Color3.fromRGB(55, 55, 62),
    Success      = Color3.fromRGB(90, 220, 120),
    Danger       = Color3.fromRGB(230, 80, 80),
}
UI.CONFIG = {
    Title       = "QuantomHub",
    LogoAsset   = "rbxassetid://8425069728",
    BgAsset     = "rbxassetid://1049060234",
    ToggleKey   = Enum.KeyCode.RightControl,
    Size        = UDim2.new(0, 640, 0, 470),
}

local old = CoreGui:FindFirstChild("QuantomHubUI") if old then old:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QuantomHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

local function corner(parent, r) local c = Instance.new("UICorner", parent) c.CornerRadius = UDim.new(0, r or 6) return c end
local function stroke(parent, col, th, tr) local s = Instance.new("UIStroke", parent) s.Color = col or UI.COLORS.Border s.Thickness = th or 1 s.Transparency = tr or 0 return s end
local function padding(parent, all) local p = Instance.new("UIPadding", parent) p.PaddingTop = UDim.new(0,all) p.PaddingBottom = UDim.new(0,all) p.PaddingLeft = UDim.new(0,all) p.PaddingRight = UDim.new(0,all) return p end

-- Root
local Root = Instance.new("Frame", ScreenGui)
Root.Name = "Root"
Root.Size = UI.CONFIG.Size
Root.Position = UDim2.new(0.5, -UI.CONFIG.Size.X.Offset/2, 0.5, -UI.CONFIG.Size.Y.Offset/2)
Root.BackgroundColor3 = UI.COLORS.BG
Root.BorderSizePixel = 0
Root.Active = true
corner(Root, 10)
stroke(Root, UI.COLORS.Border, 1)

-- Background image
local BgImage = Instance.new("ImageLabel", Root)
BgImage.Name = "BgImage"
BgImage.Size = UDim2.new(1, 0, 1, 0)
BgImage.BackgroundTransparency = 1
BgImage.Image = UI.CONFIG.BgAsset
BgImage.ImageTransparency = 0.55
BgImage.ScaleType = Enum.ScaleType.Crop
BgImage.ZIndex = 0
corner(BgImage, 10)

local BgTint = Instance.new("Frame", Root)
BgTint.Size = UDim2.new(1, 0, 1, 0)
BgTint.BackgroundColor3 = UI.COLORS.BG
BgTint.BackgroundTransparency = 0.3
BgTint.BorderSizePixel = 0
BgTint.ZIndex = 0
corner(BgTint, 10)

-- Drag
do
    local dragging, dragStart, startPos
    local dragBar = Instance.new("Frame", Root)
    dragBar.Name = "DragBar"
    dragBar.Size = UDim2.new(1, 0, 0, 32)
    dragBar.BackgroundTransparency = 1
    dragBar.ZIndex = 5
    dragBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = Root.Position
        end
    end)
    dragBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- Sidebar
local Sidebar = Instance.new("Frame", Root)
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 190, 1, -12)
Sidebar.Position = UDim2.new(0, 6, 0, 6)
Sidebar.BackgroundColor3 = UI.COLORS.Sidebar
Sidebar.BackgroundTransparency = 0.1
Sidebar.BorderSizePixel = 0
corner(Sidebar, 8)
stroke(Sidebar, UI.COLORS.Border, 1)

local Header = Instance.new("Frame", Sidebar)
Header.Size = UDim2.new(1, -16, 0, 44)
Header.Position = UDim2.new(0, 8, 0, 8)
Header.BackgroundTransparency = 1
local HeaderIcon = Instance.new("ImageLabel", Header)
HeaderIcon.Size = UDim2.new(0, 30, 0, 30)
HeaderIcon.Position = UDim2.new(0, 4, 0.5, -15)
HeaderIcon.BackgroundTransparency = 1
HeaderIcon.Image = UI.CONFIG.LogoAsset
local HeaderText = Instance.new("TextLabel", Header)
HeaderText.Size = UDim2.new(1, -44, 1, 0)
HeaderText.Position = UDim2.new(0, 44, 0, 0)
HeaderText.BackgroundTransparency = 1
HeaderText.Text = UI.CONFIG.Title
HeaderText.TextColor3 = UI.COLORS.Text
HeaderText.TextSize = 18
HeaderText.Font = Enum.Font.GothamBold
HeaderText.TextXAlignment = Enum.TextXAlignment.Left

local TabList = Instance.new("ScrollingFrame", Sidebar)
TabList.Size = UDim2.new(1, -12, 1, -140)
TabList.Position = UDim2.new(0, 6, 0, 58)
TabList.BackgroundTransparency = 1
TabList.BorderSizePixel = 0
TabList.ScrollBarThickness = 3
TabList.ScrollBarImageColor3 = UI.COLORS.Accent
TabList.CanvasSize = UDim2.new(0, 0, 0, 0)
TabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
local TabListLayout = Instance.new("UIListLayout", TabList)
TabListLayout.Padding = UDim.new(0, 4)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local UserCard = Instance.new("Frame", Sidebar)
UserCard.Size = UDim2.new(1, -16, 0, 68)
UserCard.Position = UDim2.new(0, 8, 1, -76)
UserCard.BackgroundColor3 = UI.COLORS.Element
UserCard.BorderSizePixel = 0
corner(UserCard, 6)
local Avatar = Instance.new("ImageLabel", UserCard)
Avatar.Size = UDim2.new(0, 44, 0, 44)
Avatar.Position = UDim2.new(0, 8, 0.5, -22)
Avatar.BackgroundColor3 = UI.COLORS.Card
Avatar.BorderSizePixel = 0
corner(Avatar, 6)
pcall(function()
    Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
end)
local UName = Instance.new("TextLabel", UserCard)
UName.Size = UDim2.new(1, -60, 0, 18) UName.Position = UDim2.new(0, 58, 0, 8)
UName.BackgroundTransparency = 1 UName.Text = LocalPlayer.DisplayName
UName.TextColor3 = UI.COLORS.Text UName.TextSize = 13
UName.Font = Enum.Font.GothamBold UName.TextXAlignment = Enum.TextXAlignment.Left
local UHandle = Instance.new("TextLabel", UserCard)
UHandle.Size = UDim2.new(1, -60, 0, 14) UHandle.Position = UDim2.new(0, 58, 0, 26)
UHandle.BackgroundTransparency = 1 UHandle.Text = "@" .. LocalPlayer.Name
UHandle.TextColor3 = UI.COLORS.TextDim UHandle.TextSize = 11
UHandle.Font = Enum.Font.Gotham UHandle.TextXAlignment = Enum.TextXAlignment.Left
local USession = Instance.new("TextLabel", UserCard)
USession.Size = UDim2.new(1, -60, 0, 14) USession.Position = UDim2.new(0, 58, 0, 44)
USession.BackgroundTransparency = 1 USession.TextColor3 = UI.COLORS.TextDim
USession.TextSize = 11 USession.Font = Enum.Font.Gotham USession.TextXAlignment = Enum.TextXAlignment.Left
do
    local start = tick()
    task.spawn(function()
        while USession.Parent do
            local e = tick() - start
            local h = math.floor(e / 3600)
            local m = math.floor((e % 3600) / 60)
            local s = math.floor(e % 60)
            USession.Text = string.format("Session: %02d:%02d:%02d", h, m, s)
            task.wait(1)
        end
    end)
end

-- Content
local Content = Instance.new("Frame", Root)
Content.Name = "Content"
Content.Size = UDim2.new(1, -214, 1, -12)
Content.Position = UDim2.new(0, 208, 0, 6)
Content.BackgroundColor3 = UI.COLORS.Card
Content.BackgroundTransparency = 0.05
Content.BorderSizePixel = 0
corner(Content, 8)
stroke(Content, UI.COLORS.Border, 1)

local CloseBtn = Instance.new("TextButton", Content)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Position = UDim2.new(1, -32, 0, 8)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "×"
CloseBtn.TextColor3 = UI.COLORS.TextDim
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 10
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = UI.COLORS.Danger end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = UI.COLORS.TextDim end)
CloseBtn.MouseButton1Click:Connect(function() Root.Visible = false end)

-- Tabs
local tabs = {}
local activeTab = nil

function UI:CreateTab(name, iconAsset)
    local tabBtn = Instance.new("TextButton", TabList)
    tabBtn.Size = UDim2.new(1, -4, 0, 36)
    tabBtn.BackgroundColor3 = UI.COLORS.Element
    tabBtn.BackgroundTransparency = 1
    tabBtn.Text = ""
    tabBtn.AutoButtonColor = false
    tabBtn.BorderSizePixel = 0
    corner(tabBtn, 6)

    local iconLbl = Instance.new("ImageLabel", tabBtn)
    iconLbl.Size = UDim2.new(0, 18, 0, 18)
    iconLbl.Position = UDim2.new(0, 12, 0.5, -9)
    iconLbl.BackgroundTransparency = 1
    iconLbl.Image = iconAsset or "rbxassetid://7734053426"
    iconLbl.ImageColor3 = UI.COLORS.TextDim

    local nameLbl = Instance.new("TextLabel", tabBtn)
    nameLbl.Size = UDim2.new(1, -40, 1, 0)
    nameLbl.Position = UDim2.new(0, 40, 0, 0)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = name
    nameLbl.TextColor3 = UI.COLORS.TextDim
    nameLbl.TextSize = 13
    nameLbl.Font = Enum.Font.GothamBold
    nameLbl.TextXAlignment = Enum.TextXAlignment.Left

    local page = Instance.new("ScrollingFrame", Content)
    page.Size = UDim2.new(1, -20, 1, -50)
    page.Position = UDim2.new(0, 10, 0, 40)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = UI.COLORS.Accent
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 8)
    pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    padding(page, 4)

    local titleBar = Instance.new("TextLabel", Content)
    titleBar.Size = UDim2.new(1, -60, 0, 30)
    titleBar.Position = UDim2.new(0, 14, 0, 8)
    titleBar.BackgroundTransparency = 1
    titleBar.Text = name
    titleBar.TextColor3 = UI.COLORS.Text
    titleBar.TextSize = 18
    titleBar.Font = Enum.Font.GothamBold
    titleBar.TextXAlignment = Enum.TextXAlignment.Left
    titleBar.Visible = false

    local tab = {name=name, btn=tabBtn, page=page, title=titleBar, icon=iconLbl, label=nameLbl}
    table.insert(tabs, tab)

    tabBtn.MouseButton1Click:Connect(function()
        if activeTab then
            activeTab.btn.BackgroundTransparency = 1
            activeTab.icon.ImageColor3 = UI.COLORS.TextDim
            activeTab.label.TextColor3 = UI.COLORS.TextDim
            activeTab.page.Visible = false
            activeTab.title.Visible = false
        end
        activeTab = tab
        tabBtn.BackgroundTransparency = 0
        tabBtn.BackgroundColor3 = UI.COLORS.Element
        iconLbl.ImageColor3 = UI.COLORS.Accent
        nameLbl.TextColor3 = UI.COLORS.Accent
        page.Visible = true
        titleBar.Visible = true
    end)

    local api = {}

    function api:Section(text)
        local h = Instance.new("Frame", page)
        h.Size = UDim2.new(1, 0, 0, 24)
        h.BackgroundTransparency = 1
        local lbl = Instance.new("TextLabel", h)
        lbl.Size = UDim2.new(1, 0, 1, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = UI.COLORS.Accent
        lbl.TextSize = 13
        lbl.Font = Enum.Font.GothamBold
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        return h
    end

    function api:Toggle(text, default, callback)
        local state = default and true or false
        local f = Instance.new("TextButton", page)
        f.Size = UDim2.new(1, 0, 0, 36)
        f.BackgroundColor3 = UI.COLORS.Element
        f.Text = ""
        f.AutoButtonColor = false
        f.BorderSizePixel = 0
        corner(f, 6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -60, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = UI.COLORS.Text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local sw = Instance.new("Frame", f)
        sw.Size = UDim2.new(0, 38, 0, 18)
        sw.Position = UDim2.new(1, -50, 0.5, -9)
        sw.BackgroundColor3 = state and UI.COLORS.Accent or UI.COLORS.Card
        sw.BorderSizePixel = 0
        corner(sw, 9)
        local knob = Instance.new("Frame", sw)
        knob.Size = UDim2.new(0, 14, 0, 14)
        knob.Position = UDim2.new(state and 1 or 0, state and -16 or 2, 0.5, -7)
        knob.BackgroundColor3 = UI.COLORS.Text
        knob.BorderSizePixel = 0
        corner(knob, 7)
        local function set(v)
            state = v
            TweenService:Create(sw, TweenInfo.new(0.15), {BackgroundColor3 = state and UI.COLORS.Accent or UI.COLORS.Card}):Play()
            TweenService:Create(knob, TweenInfo.new(0.15), {Position = UDim2.new(state and 1 or 0, state and -16 or 2, 0.5, -7)}):Play()
            if callback then task.spawn(callback, state) end
        end
        f.MouseButton1Click:Connect(function() set(not state) end)
        if default then task.spawn(function() if callback then callback(true) end end) end
        return {Set=set, Get=function() return state end}
    end

    function api:Slider(text, min, max, default, step, callback)
        step = step or 1
        local val = default or min
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 50)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BorderSizePixel = 0
        corner(f, 6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -80, 0, 22)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = UI.COLORS.Text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local valLbl = Instance.new("TextLabel", f)
        valLbl.Size = UDim2.new(0, 60, 0, 22)
        valLbl.Position = UDim2.new(1, -70, 0, 4)
        valLbl.BackgroundTransparency = 1
        valLbl.Text = tostring(val)
        valLbl.TextColor3 = UI.COLORS.Accent
        valLbl.TextSize = 13
        valLbl.Font = Enum.Font.GothamBold
        valLbl.TextXAlignment = Enum.TextXAlignment.Right
        local bar = Instance.new("Frame", f)
        bar.Size = UDim2.new(1, -24, 0, 6)
        bar.Position = UDim2.new(0, 12, 1, -16)
        bar.BackgroundColor3 = UI.COLORS.Card
        bar.BorderSizePixel = 0
        corner(bar, 3)
        local fill = Instance.new("Frame", bar)
        fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
        fill.BackgroundColor3 = UI.COLORS.Accent
        fill.BorderSizePixel = 0
        corner(fill, 3)
        local dragging = false
        local function update(input)
            local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            local raw = min + (max - min) * rel
            val = math.floor(raw / step + 0.5) * step
            val = math.clamp(val, min, max)
            fill.Size = UDim2.new((val - min)/(max - min), 0, 1, 0)
            valLbl.Text = tostring(val)
            if callback then task.spawn(callback, val) end
        end
        bar.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true update(i)
            end
        end)
        bar.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                update(i)
            end
        end)
        return {Set=function(v) val=math.clamp(v,min,max) fill.Size=UDim2.new((val-min)/(max-min),0,1,0) valLbl.Text=tostring(val) if callback then callback(val) end end, Get=function() return val end}
    end

    function api:Button(text, callback)
        local b = Instance.new("TextButton", page)
        b.Size = UDim2.new(1, 0, 0, 34)
        b.BackgroundColor3 = UI.COLORS.Accent
        b.Text = text
        b.TextColor3 = Color3.fromRGB(24,24,28)
        b.TextSize = 13
        b.Font = Enum.Font.GothamBold
        b.AutoButtonColor = false
        b.BorderSizePixel = 0
        corner(b, 6)
        b.MouseEnter:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = UI.COLORS.AccentDim}):Play() end)
        b.MouseLeave:Connect(function() TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = UI.COLORS.Accent}):Play() end)
        b.MouseButton1Click:Connect(function() if callback then task.spawn(callback) end end)
        return b
    end

    function api:Input(text, placeholder, default, callback)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 54)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BorderSizePixel = 0
        corner(f, 6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -20, 0, 18)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = UI.COLORS.TextDim
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local box = Instance.new("TextBox", f)
        box.Size = UDim2.new(1, -20, 0, 24)
        box.Position = UDim2.new(0, 10, 0, 24)
        box.BackgroundColor3 = UI.COLORS.Card
        box.PlaceholderText = placeholder or ""
        box.Text = default or ""
        box.TextColor3 = UI.COLORS.Text
        box.TextSize = 13
        box.Font = Enum.Font.Gotham
        box.ClearTextOnFocus = false
        box.BorderSizePixel = 0
        corner(box, 4)
        padding(box, 6)
        box.FocusLost:Connect(function() if callback then task.spawn(callback, box.Text) end end)
        return {Set=function(v) box.Text=v end, Get=function() return box.Text end}
    end

    function api:Dropdown(text, options, default, callback)
        local selected = default or (options[1] or "")
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 54)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BorderSizePixel = 0
        f.ClipsDescendants = true
        corner(f, 6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -20, 0, 18)
        lbl.Position = UDim2.new(0, 12, 0, 4)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = UI.COLORS.TextDim
        lbl.TextSize = 12
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(1, -20, 0, 24)
        btn.Position = UDim2.new(0, 10, 0, 24)
        btn.BackgroundColor3 = UI.COLORS.Card
        btn.Text = "  " .. tostring(selected)
        btn.TextColor3 = UI.COLORS.Text
        btn.TextSize = 13
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        corner(btn, 4)
        local arrow = Instance.new("TextLabel", btn)
        arrow.Size = UDim2.new(0, 20, 1, 0) arrow.Position = UDim2.new(1, -22, 0, 0)
        arrow.BackgroundTransparency = 1 arrow.Text = "▼"
        arrow.TextColor3 = UI.COLORS.Accent arrow.TextSize = 10 arrow.Font = Enum.Font.Gotham
        local list = Instance.new("Frame", f)
        list.Size = UDim2.new(1, -20, 0, 0)
        list.Position = UDim2.new(0, 10, 0, 50)
        list.BackgroundColor3 = UI.COLORS.Card
        list.BorderSizePixel = 0
        list.Visible = false
        list.ClipsDescendants = true
        corner(list, 4)
        local scroll = Instance.new("ScrollingFrame", list)
        scroll.Size = UDim2.new(1, 0, 1, 0)
        scroll.BackgroundTransparency = 1
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 3
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        local layout = Instance.new("UIListLayout", scroll)
        layout.Padding = UDim.new(0, 2)

        local open = false
        local function rebuild()
            for _, c in ipairs(scroll:GetChildren()) do
                if c:IsA("TextButton") then c:Destroy() end
            end
            for _, opt in ipairs(options) do
                local ob = Instance.new("TextButton", scroll)
                ob.Size = UDim2.new(1, -6, 0, 22)
                ob.BackgroundColor3 = UI.COLORS.Element
                ob.Text = "  " .. tostring(opt)
                ob.TextColor3 = UI.COLORS.Text
                ob.TextSize = 12
                ob.Font = Enum.Font.Gotham
                ob.TextXAlignment = Enum.TextXAlignment.Left
                ob.AutoButtonColor = false
                ob.BorderSizePixel = 0
                corner(ob, 3)
                ob.MouseEnter:Connect(function() ob.BackgroundColor3 = UI.COLORS.ElementHover end)
                ob.MouseLeave:Connect(function() ob.BackgroundColor3 = UI.COLORS.Element end)
                ob.MouseButton1Click:Connect(function()
                    selected = opt
                    btn.Text = "  " .. tostring(opt)
                    open = false
                    list.Visible = false
                    f.Size = UDim2.new(1, 0, 0, 54)
                    if callback then task.spawn(callback, opt) end
                end)
            end
        end
        rebuild()
        btn.MouseButton1Click:Connect(function()
            open = not open
            if open then
                local h = math.min(#options * 24 + 4, 140)
                list.Visible = true
                list.Size = UDim2.new(1, -20, 0, h)
                f.Size = UDim2.new(1, 0, 0, 54 + h + 6)
            else
                list.Visible = false
                f.Size = UDim2.new(1, 0, 0, 54)
            end
        end)
        return {
            Set=function(v) selected=v btn.Text="  "..tostring(v) if callback then callback(v) end end,
            Get=function() return selected end,
            Refresh=function(newList) options = newList rebuild() end,
        }
    end

    function api:Keybind(text, default, callback)
        local key = default or Enum.KeyCode.Unknown
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 36)
        f.BackgroundColor3 = UI.COLORS.Element
        f.BorderSizePixel = 0
        corner(f, 6)
        local lbl = Instance.new("TextLabel", f)
        lbl.Size = UDim2.new(1, -110, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = UI.COLORS.Text
        lbl.TextSize = 13
        lbl.Font = Enum.Font.Gotham
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        local btn = Instance.new("TextButton", f)
        btn.Size = UDim2.new(0, 90, 0, 24)
        btn.Position = UDim2.new(1, -102, 0.5, -12)
        btn.BackgroundColor3 = UI.COLORS.Card
        btn.Text = key.Name
        btn.TextColor3 = UI.COLORS.Accent
        btn.TextSize = 12
        btn.Font = Enum.Font.GothamBold
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        corner(btn, 4)
        local listening = false
        btn.MouseButton1Click:Connect(function()
            listening = true
            btn.Text = "..."
        end)
        UserInputService.InputBegan:Connect(function(input, gp)
            if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                key = input.KeyCode
                btn.Text = key.Name
                listening = false
                if callback then task.spawn(callback, key) end
            end
        end)
        return {Set=function(k) key=k btn.Text=k.Name end, Get=function() return key end}
    end

    return api
end

-- Notifications
local NotifRoot = Instance.new("Frame", ScreenGui)
NotifRoot.Size = UDim2.new(0, 300, 1, -20)
NotifRoot.Position = UDim2.new(1, -310, 0, 10)
NotifRoot.BackgroundTransparency = 1
local NotifLayout = Instance.new("UIListLayout", NotifRoot)
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top

function UI:Notify(title, content, dur)
    dur = dur or 3
    local card = Instance.new("Frame", NotifRoot)
    card.Size = UDim2.new(1, 0, 0, 50)
    card.BackgroundColor3 = UI.COLORS.Card
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    corner(card, 6)
    stroke(card, UI.COLORS.Accent, 1, 0.5)
    local bar = Instance.new("Frame", card)
    bar.Size = UDim2.new(0, 3, 1, -8) bar.Position = UDim2.new(0, 4, 0, 4)
    bar.BackgroundColor3 = UI.COLORS.Accent bar.BorderSizePixel = 0
    corner(bar, 2)
    local tl = Instance.new("TextLabel", card)
    tl.Size = UDim2.new(1, -20, 0, 18) tl.Position = UDim2.new(0, 14, 0, 6)
    tl.BackgroundTransparency = 1 tl.Text = title
    tl.TextColor3 = UI.COLORS.Text tl.TextSize = 13
    tl.Font = Enum.Font.GothamBold tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.TextTransparency = 1
    local cl = Instance.new("TextLabel", card)
    cl.Size = UDim2.new(1, -20, 0, 16) cl.Position = UDim2.new(0, 14, 0, 26)
    cl.BackgroundTransparency = 1 cl.Text = content or ""
    cl.TextColor3 = UI.COLORS.TextDim cl.TextSize = 11
    cl.Font = Enum.Font.Gotham cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.TextTransparency = 1
    TweenService:Create(card, TweenInfo.new(0.2), {BackgroundTransparency = 0.05}):Play()
    TweenService:Create(tl, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    TweenService:Create(cl, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    task.delay(dur, function()
        TweenService:Create(card, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(tl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(cl, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        task.wait(0.35) card:Destroy()
    end)
end

-- Toggle key
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == UI.CONFIG.ToggleKey then
        Root.Visible = not Root.Visible
    end
end)

function UI:SetToggleKey(k) UI.CONFIG.ToggleKey = k end
function UI:Destroy() ScreenGui:Destroy() end
function UI:Show() Root.Visible = true end
function UI:Hide() Root.Visible = false end

-- ============================================================
--  DEMO — remove everything below to use as pure framework
-- ============================================================
local demo = UI:CreateTab("Demo", "rbxassetid://7734053426")
demo:Section("All Elements")
demo:Toggle("Toggle Example", false, function(v) print("toggle", v) end)
demo:Slider("Slider Example", 0, 100, 50, 1, function(v) print("slider", v) end)
demo:Button("Button Example", function() UI:Notify("Clicked", "Button pressed", 3) end)
demo:Input("Input Example", "Type here...", "", function(v) print("input", v) end)
demo:Dropdown("Dropdown Example", {"One","Two","Three","Four"}, "One", function(v) print("dropdown", v) end)
demo:Keybind("Keybind Example", Enum.KeyCode.G, function(k) print("keybind", k.Name) end)

local second = UI:CreateTab("Second", "rbxassetid://7734056660")
second:Section("Another Tab")
second:Button("Notify", function() UI:Notify("Hello", "This is a notification", 4) end)

-- Activate first tab
if tabs[1] then
    tabs[1].btn.BackgroundTransparency = 0
    tabs[1].btn.BackgroundColor3 = UI.COLORS.Element
    tabs[1].icon.ImageColor3 = UI.COLORS.Accent
    tabs[1].label.TextColor3 = UI.COLORS.Accent
    tabs[1].page.Visible = true
    tabs[1].title.Visible = true
    activeTab = tabs[1]
end

return UI
