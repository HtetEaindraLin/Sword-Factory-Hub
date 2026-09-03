-- ============================================================
--  ASCEND OR FALL HUB — Mobile Custom GUI
--  Adapted for Mobile Devices (Touch Enabled)
-- ============================================================

------------ Executor Stubs ------------
if not isfolder   then isfolder   = function() return false end end
if not isfile     then isfile     = function() return false end end
if not makefolder then makefolder = function() end end
if not writefile  then writefile  = function() end end
if not readfile   then readfile   = function() return "{}" end end
if not listfiles  then listfiles  = function() return {} end end
if not delfile    then delfile    = function() end end

------------ Services ------------
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local player           = Players.LocalPlayer

------------ Theme ------------
local Theme = {
    bg        = Color3.fromRGB(24, 26, 33),
    sidebar   = Color3.fromRGB(18, 20, 26),
    panel     = Color3.fromRGB(30, 33, 42),
    card      = Color3.fromRGB(38, 42, 54),
    border    = Color3.fromRGB(50, 56, 72),
    accent    = Color3.fromRGB(138, 43, 226), -- Cosmic Purple
    accentDim = Color3.fromRGB(90, 25, 150),
    green     = Color3.fromRGB(87, 242, 135),
    red       = Color3.fromRGB(237, 66, 69),
    yellow    = Color3.fromRGB(254, 231, 92),
    text      = Color3.fromRGB(220, 221, 222),
    textDim   = Color3.fromRGB(148, 155, 164),
    textMuted = Color3.fromRGB(96, 100, 108),
    white     = Color3.fromRGB(255, 255, 255),
}

------------ State Variables ------------
local autoClimbEnabled   = false
local autoRebirthEnabled = false
local speedEnabled       = false
local speedValue         = 32
local jumpEnabled        = false
local jumpValue          = 50
local infJumpEnabled     = false
local noClipEnabled      = false
local antiAFKEnabled     = true
local hudEnabled         = true
local hudSteps           = 0
local hudSecs            = 0

------------ GUI Root ------------
local AOFGui = Instance.new("ScreenGui")
AOFGui.Name = "AOF_Mobile_Hub"
AOFGui.ResetOnSpawn = false
AOFGui.DisplayOrder = 10
AOFGui.IgnoreGuiInset = true
pcall(function() AOFGui.Parent = CoreGui end)
if not AOFGui.Parent then AOFGui.Parent = player.PlayerGui end

------------ Mobile Open Toggle ------------
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "AOFToggle"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 10, 0.4, 0)
ToggleBtn.BackgroundColor3 = Theme.sidebar
ToggleBtn.TextColor3 = Theme.accent
ToggleBtn.Text = "🌌"
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.ZIndex = 300
ToggleBtn.Parent = AOFGui
local tCorner = Instance.new("UICorner", ToggleBtn)
tCorner.CornerRadius = UDim.new(0, 24)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Thickness = 2
tStroke.Color = Theme.accent

------------ Helpers ------------
local function new(cls, props, parent)
    local i = Instance.new(cls)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function corner(r, p) return new("UICorner", {CornerRadius = UDim.new(0, r)}, p) end
local function stroke(t, c2, p) return new("UIStroke", {Thickness = t, Color = c2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, p) end

------------ Notifications ------------
local notifHolder = new("Frame", {Size = UDim2.new(0, 250, 1, 0), Position = UDim2.new(1, -260, 0, 0), BackgroundTransparency = 1, ZIndex = 200}, AOFGui)
new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, VerticalAlignment = Enum.VerticalAlignment.Bottom, HorizontalAlignment = Enum.HorizontalAlignment.Right, Padding = UDim.new(0, 6)}, notifHolder)
new("UIPadding", {PaddingBottom = UDim.new(0, 12), PaddingRight = UDim.new(0, 8)}, notifHolder)
local _nc = 0
local function notify(title, body, color)
    _nc = _nc + 1
    local nc = new("Frame", {Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = Theme.card, Position = UDim2.new(1, 10, 0, 0), LayoutOrder = _nc, ZIndex = 201, ClipsDescendants = true}, notifHolder)
    corner(8, nc); stroke(1, Theme.border, nc)
    local bar = new("Frame", {Size = UDim2.new(0, 3, 0, 36), Position = UDim2.new(0, 8, 0, 9), BackgroundColor3 = color or Theme.accent, BorderSizePixel = 0, ZIndex = 202}, nc); corner(2, bar)
    new("TextLabel", {Text = title, TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 18, 0, 6), Size = UDim2.new(1, -24, 0, 16), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 202}, nc)
    new("TextLabel", {Text = body or "", TextSize = 10, Font = Enum.Font.Gotham, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(0, 18, 0, 24), Size = UDim2.new(1, -24, 0, 14), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 202}, nc)
    TweenService:Create(nc, TweenInfo.new(0.25), {Position = UDim2.new(0, 0, 0, 0)}):Play()
    task.delay(3.5, function()
        TweenService:Create(nc, TweenInfo.new(0.2), {Position = UDim2.new(1, 10, 0, 0)}):Play()
        task.wait(0.22); pcall(function() nc:Destroy() end)
    end)
end

------------ Window Frame ------------
local SIDEBAR_W = 130
local Window = new("Frame", {Name = "Window", Size = UDim2.new(0.85, 0, 0.75, 0), Position = UDim2.new(0.075, 0, 0.125, 0), BackgroundColor3 = Theme.bg, BorderSizePixel = 0, ClipsDescendants = true}, AOFGui)
corner(10, Window); stroke(1, Theme.border, Window)

local TitleBar = new("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = Theme.sidebar, BorderSizePixel = 0, ZIndex = 2}, Window)
new("TextLabel", {Text = "🌌  ASCEND OR FALL", TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0, 170, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, TitleBar)
new("TextLabel", {Text = "Hub", TextSize = 10, Font = Enum.Font.Gotham, TextColor3 = Theme.textMuted, BackgroundTransparency = 1, Position = UDim2.new(0, 155, 0, 0), Size = UDim2.new(0, 30, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, TitleBar)

local function winBtn(icon, xOffset, color)
    return new("TextButton", {Text = icon, TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(1, xOffset, 0, 0), Size = UDim2.new(0, 32, 1, 0), ZIndex = 3}, TitleBar)
end
local CloseBtn = winBtn("X", -32, Theme.red)
local MinBtn = winBtn("_", -64, Theme.yellow)

CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() AOFGui:Destroy() end)
end)

local hidden = false
local function toggleUI()
    hidden = not hidden
    Window.Visible = not hidden
end
MinBtn.MouseButton1Click:Connect(toggleUI)
ToggleBtn.MouseButton1Click:Connect(toggleUI)

-- Drag Functionality
do
    local drag, dStart, dPos = false, nil, nil
    TitleBar.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = true; dStart = inp.Position; dPos = Window.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if drag and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dStart
            Window.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)
end

local Sidebar = new("Frame", {Size = UDim2.new(0, SIDEBAR_W, 1, -38), Position = UDim2.new(0, 0, 0, 38), BackgroundColor3 = Theme.sidebar, BorderSizePixel = 0}, Window)
new("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Theme.border, BorderSizePixel = 0}, Sidebar)
local ContentArea = new("Frame", {Size = UDim2.new(1, -SIDEBAR_W, 1, -38), Position = UDim2.new(0, SIDEBAR_W, 0, 38), BackgroundColor3 = Theme.panel, BorderSizePixel = 0}, Window)

local tabs = {}
local activeTab = nil
local SidebarList = new("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 2, AutomaticCanvasSize = Enum.AutomaticSize.Y}, Sidebar)
new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)}, SidebarList)
new("UIPadding", {PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4), PaddingTop = UDim.new(0, 4)}, SidebarList)

local function selectTab(tab)
    for _, t in ipairs(tabs) do
        t.content.Visible = false; t.bar.Visible = false; t.btn.BackgroundTransparency = 1
        local l = t.btn:FindFirstChildOfClass("TextLabel"); if l then l.TextColor3 = Theme.textDim end
    end
    tab.content.Visible = true; tab.bar.Visible = true; tab.btn.BackgroundTransparency = 0.82
    local l = tab.btn:FindFirstChildOfClass("TextLabel"); if l then l.TextColor3 = Theme.accent end
    activeTab = tab
end

local function createTab(name, icon)
    local btn = new("TextButton", {Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = Theme.bg, BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, LayoutOrder = #tabs + 1}, SidebarList)
    corner(6, btn)
    local bar = new("Frame", {Size = UDim2.new(0, 3, 0, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.accent, BorderSizePixel = 0, Visible = false}, btn); corner(2, bar)
    new("TextLabel", {Text = icon.." "..name, TextSize = 11, Font = Enum.Font.GothamMedium, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -8, 1, 0), TextXAlignment = Enum.TextXAlignment.Left}, btn)
    local content = new("ScrollingFrame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = Theme.border, AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false}, ContentArea)
    new("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8)}, content)
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)}, content)
    local tab = {name = name, btn = btn, content = content, bar = bar}
    tabs[#tabs + 1] = tab
    btn.MouseButton1Click:Connect(function() selectTab(tab) end)
    return tab
end

local function addSection(tab, title)
    local f = new("Frame", {Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, LayoutOrder = #tab.content:GetChildren()}, tab.content)
    new("TextLabel", {Text = title:upper(), TextSize = 9, Font = Enum.Font.GothamBold, TextColor3 = Theme.textMuted, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left}, f)
    return f
end
local function addCard(tab, h)
    local c2 = new("Frame", {Size = UDim2.new(1, 0, 0, h or 40), BackgroundColor3 = Theme.card, BorderSizePixel = 0, LayoutOrder = #tab.content:GetChildren()}, tab.content)
    corner(6, c2); return c2
end
local function addDivider(tab)
    new("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.border, BorderSizePixel = 0, LayoutOrder = #tab.content:GetChildren()}, tab.content)
end
local function addToggle(tab, title, desc, default, callback)
    local card = addCard(tab, desc and 48 or 40)
    local state = default or false
    new("TextLabel", {Text = title, TextSize = 11, Font = Enum.Font.GothamMedium, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -60, 0, desc and 22 or 40), TextXAlignment = Enum.TextXAlignment.Left}, card)
    if desc then new("TextLabel", {Text = desc, TextSize = 9, Font = Enum.Font.Gotham, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 22), Size = UDim2.new(1, -60, 0, 18), TextXAlignment = Enum.TextXAlignment.Left}, card) end
    local track = new("Frame", {Size = UDim2.new(0, 36, 0, 18), Position = UDim2.new(1, -46, 0.5, -9), BackgroundColor3 = state and Theme.green or Theme.border, BorderSizePixel = 0}, card); corner(9, track)
    local knob = new("Frame", {Size = UDim2.new(0, 14, 0, 14), Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), BackgroundColor3 = Theme.white, BorderSizePixel = 0}, track); corner(7, knob)
    local function setState(v)
        state = v
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and Theme.green or Theme.border}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
        task.spawn(function() pcall(callback, state) end)
    end
    new("TextButton", {Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1}, card).MouseButton1Click:Connect(function() setState(not state) end)
    return {set = setState, get = function() return state end}
end
local function addSlider(tab, title, min, max, default, suffix, callback)
    local card = addCard(tab, 48)
    local val = math.clamp(default or min, min, max)
    new("TextLabel", {Text = title, TextSize = 11, Font = Enum.Font.GothamMedium, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 4), Size = UDim2.new(0.6, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Left}, card)
    local valLbl = new("TextLabel", {Text = tostring(val)..(suffix or ""), TextSize = 10, Font = Enum.Font.GothamBold, TextColor3 = Theme.accent, BackgroundTransparency = 1, Position = UDim2.new(1, -60, 0, 4), Size = UDim2.new(0, 52, 0, 16), TextXAlignment = Enum.TextXAlignment.Right}, card)
    local track = new("Frame", {Size = UDim2.new(1, -16, 0, 4), Position = UDim2.new(0, 8, 0, 28), BackgroundColor3 = Theme.border, BorderSizePixel = 0}, card); corner(2, track)
    local fill = new("Frame", {Size = UDim2.new((val - min) / (max - min), 0, 1, 0), BackgroundColor3 = Theme.accent, BorderSizePixel = 0}, track); corner(2, fill)
    local knob = new("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = UDim2.new((val - min) / (max - min), -6, 0.5, -6), BackgroundColor3 = Theme.white, BorderSizePixel = 0, ZIndex = 3}, track); corner(6, knob)
    local sliding = false
    local function update(x)
        local r = math.clamp((x - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
        val = math.floor(min + r * (max - min) + 0.5); r = (val - min) / (max - min)
        fill.Size = UDim2.new(r, 0, 1, 0); knob.Position = UDim2.new(r, -6, 0.5, -6)
        valLbl.Text = tostring(val)..(suffix or "")
        task.spawn(function() pcall(callback, val) end)
    end
    new("TextButton", {Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1, ZIndex = 2}, track).InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then sliding = true; update(inp.Position.X) end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if sliding and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then update(inp.Position.X) end
    end)
    UserInputService.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then sliding = false end
    end)
end
local function addButton(tab, title, desc, callback)
    local card = addCard(tab, desc and 48 or 40)
    new("TextLabel", {Text = title, TextSize = 11, Font = Enum.Font.GothamMedium, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -75, 0, desc and 22 or 40), TextXAlignment = Enum.TextXAlignment.Left}, card)
    if desc then new("TextLabel", {Text = desc, TextSize = 9, Font = Enum.Font.Gotham, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 22), Size = UDim2.new(1, -75, 0, 18), TextXAlignment = Enum.TextXAlignment.Left}, card) end
    local btn = new("TextButton", {Text = "Run", TextSize = 10, Font = Enum.Font.GothamBold, TextColor3 = Theme.white, BackgroundColor3 = Theme.accentDim, BorderSizePixel = 0, Position = UDim2.new(1, -64, 0.5, -12), Size = UDim2.new(0, 56, 0, 24), AutoButtonColor = false}, card); corner(5, btn)
    btn.MouseButton1Click:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.green}):Play()
        task.delay(0.4, function() TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Theme.accentDim}):Play() end)
        task.spawn(function() pcall(callback) end)
    end)
end

------------ Tabs Setup ------------
local tWelcome = createTab("Welcome", "🏠")
local tMain    = createTab("Auto Farm", "📈")
local tPlayerS = createTab("Player", "🏃")
local tSettings = createTab("Settings", "⚙")
selectTab(tWelcome)

-- WELCOME TAB
do
    local hero = new("Frame", {Size = UDim2.new(1, 0, 0, 90), BackgroundColor3 = Color3.fromRGB(36, 37, 43), BorderSizePixel = 0}, tWelcome.content)
    corner(8, hero); stroke(1, Theme.border, hero)
    new("TextLabel", {Text = "🌌 Ascend Or Fall Hub", TextSize = 16, Font = Enum.Font.GothamBold, TextColor3 = Theme.white, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 12), Size = UDim2.new(1, -24, 0, 24), TextXAlignment = Enum.TextXAlignment.Left}, hero)
    new("TextLabel", {Text = "Climb endlessly, gain aura, and scale stats automatically.", TextSize = 10, Font = Enum.Font.Gotham, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 38), Size = UDim2.new(1, -24, 0, 32), TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true}, hero)
    addDivider(tWelcome)
    addSection(tWelcome, "Info")
    addCard(tWelcome, 40)
    -- Safe info box label
    local infoCard = tWelcome.content:GetChildren()[#tWelcome.content:GetChildren()]
    new("TextLabel", {Text = "Touch-enabled UI loaded successfully.", TextSize = 10, Font = Enum.Font.GothamMedium, TextColor3 = Theme.accent, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 1, 0), TextXAlignment = Enum.TextXAlignment.Left}, infoCard)
end

-- AUTO FARM TAB (Ascend Or Fall Specific Automations)
do
    addSection(tMain, "Automation")
    addToggle(tMain, "Auto Step / Climb", "Simulates continuous climbing steps", false, function(v)
        autoClimbEnabled = v
        notify("Auto Climb", v and "Started climbing!" : "Stopped", v and Theme.green or Theme.textDim)
    end)
    addToggle(tMain, "Auto Rebirth", "Automatically triggers rebirths when possible", false, function(v)
        autoRebirthEnabled = v
        notify("Auto Rebirth", v and "Enabled" or "Disabled", v and Theme.green or Theme.textDim)
    end)
    addDivider(tMain)
    addButton(tMain, "Claim Free Rewards / Gamepasses", "Triggers prompts if available", function()
        notify("Rewards", "Attempting to claim available items...", Theme.yellow)
        -- Game-specific Remote or interaction hooks can be inserted here if identified
    end)
end

-- PLAYER TAB
do
    addSection(tPlayerS, "Movement Modifiers")
    addToggle(tPlayerS, "Custom WalkSpeed", nil, false, function(v)
        speedEnabled = v
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.WalkSpeed = v and speedValue or 16 end
    end)
    addSlider(tPlayerS, "Speed Value", 16, 200, 32, "", function(v)
        speedValue = v
        if speedEnabled then
   
