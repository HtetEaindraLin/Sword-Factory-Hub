-- ============================================================
--  ASCEND OR FALL HUB — Fixed Mobile UI & Execution
-- ============================================================

local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local player           = Players.LocalPlayer

-- Clean up old instances if they exist
pcall(function()
    if CoreGui:FindFirstChild("AOF_Mobile_Hub") then
        CoreGui.AOF_Mobile_Hub:Destroy()
    end
    if player.PlayerGui:FindFirstChild("AOF_Mobile_Hub") then
        player.PlayerGui.AOF_Mobile_Hub:Destroy()
    end
end)

local Theme = {
    bg        = Color3.fromRGB(24, 26, 33),
    sidebar   = Color3.fromRGB(18, 20, 26),
    panel     = Color3.fromRGB(30, 33, 42),
    card      = Color3.fromRGB(38, 42, 54),
    border    = Color3.fromRGB(50, 56, 72),
    accent    = Color3.fromRGB(138, 43, 226),
    accentDim = Color3.fromRGB(90, 25, 150),
    green     = Color3.fromRGB(87, 242, 135),
    red       = Color3.fromRGB(237, 66, 69),
    yellow    = Color3.fromRGB(254, 231, 92),
    text      = Color3.fromRGB(220, 221, 222),
    textDim   = Color3.fromRGB(148, 155, 164),
    textMuted = Color3.fromRGB(96, 100, 108),
    white     = Color3.fromRGB(255, 255, 255),
}

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

local AOFGui = Instance.new("ScreenGui")
AOFGui.Name = "AOF_Mobile_Hub"
AOFGui.ResetOnSpawn = false
AOFGui.DisplayOrder = 999999
AOFGui.IgnoreGuiInset = true

local successParent = pcall(function()
    AOFGui.Parent = CoreGui
end)
if not successParent then
    AOFGui.Parent = player:WaitForChild("PlayerGui")
end

-- Floating Toggle Button (Draggable & Clickable)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "AOFToggle"
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Theme.sidebar
ToggleBtn.TextColor3 = Theme.accent
ToggleBtn.Text = "🌌"
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.ZIndex = 300
ToggleBtn.Parent = AOFGui

local tCorner = Instance.new("UICorner", ToggleBtn)
tCorner.CornerRadius = UDim.new(0, 25)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Thickness = 2
tStroke.Color = Theme.accent

local function new(cls, props, parent)
    local i = Instance.new(cls)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function corner(r, p) return new("UICorner", {CornerRadius = UDim.new(0, r)}, p) end
local function stroke(t, c2, p) return new("UIStroke", {Thickness = t, Color = c2, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, p) end

-- Notification System
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

-- Main Window
local SIDEBAR_W = 120
local Window = new("Frame", {Name = "Window", Size = UDim2.new(0, 420, 0, 260), Position = UDim2.new(0.5, -210, 0.5, -130), BackgroundColor3 = Theme.bg, BorderSizePixel = 0, ClipsDescendants = true, Active = true, Draggable = true}, AOFGui)
corner(10, Window); stroke(1, Theme.border, Window)

local TitleBar = new("Frame", {Size = UDim2.new(1, 0, 0, 36), BackgroundColor3 = Theme.sidebar, BorderSizePixel = 0, ZIndex = 2}, Window)
new("TextLabel", {Text = "🌌  ASCEND OR FALL", TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(0, 170, 1, 0), TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3}, TitleBar)

local function winBtn(icon, xOffset)
    return new("TextButton", {Text = icon, TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(1, xOffset, 0, 0), Size = UDim2.new(0, 32, 1, 0), ZIndex = 3}, TitleBar)
end
local CloseBtn = winBtn("X", -32)
local MinBtn = winBtn("_", -64)

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

local Sidebar = new("Frame", {Size = UDim2.new(0, SIDEBAR_W, 1, -36), Position = UDim2.new(0, 0, 0, 36), BackgroundColor3 = Theme.sidebar, BorderSizePixel = 0}, Window)
new("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Theme.border, BorderSizePixel = 0}, Sidebar)
local ContentArea = new("Frame", {Size = UDim2.new(1, -SIDEBAR_W, 1, -36), Position = UDim2.new(0, SIDEBAR_W, 0, 36), BackgroundColor3 = Theme.panel, BorderSizePixel = 0}, Window)

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
    local f = new("Frame", {Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = #tab.content:GetChildren()}, tab.content)
    new("TextLabel", {Text = title:upper(), TextSize = 8, Font = Enum.Font.GothamBold, TextColor3 = Theme.textMuted, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), TextXAlignment = Enum.TextXAlignment.Left}, f)
    return f
end
local function addCard(tab, h)
    local c2 = new("Frame", {Size = UDim2.new(1, 0, 0, h or 36), BackgroundColor3 = Theme.card, BorderSizePixel = 0, LayoutOrder = #tab.content:GetChildren()}, tab.content)
    corner(6, c2); return c2
end
local function addDivider(tab)
    new("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.border, BorderSizePixel = 0, LayoutOrder = #tab.content:GetChildren()}, tab.content)
end
local function addToggle(tab, title, desc, default, callback)
    local card = addCard(tab, desc and 44 = 36)
    local state = default or false
    new("TextLabel", {Text = title, TextSize = 10, Font = Enum.Font.GothamMedium, TextColor3 = Theme.text, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -55, 0, desc and 20 = 36), TextXAlignment = Enum.TextXAlignment.Left}, card)
    if desc then new("TextLabel", {Text = desc, TextSize = 8, Font = Enum.Font.Gotham, TextColor3 = Theme.textDim, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 20), Size = UDim2.new(1, -55, 0, 16), TextXAlignment = Enum.TextXAlignment.Left}, card) end
    local track = new("Frame", {Size = UDim2.new(0, 32, 0, 16), Position = UDim2.new(1, -40, 0.5, -8), BackgroundColor3 = state and Theme.green or Theme.border, BorderSizePixel = 0}, card); corner(8, track)
    local knob = new("Frame", {Size = UDim2.new(0, 12, 0, 12), Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6), BackgroundColor3 = Theme.white, BorderSizePixel = 0}, track); corner(6, knob)
    local function setState(v)
        state = v
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and Theme.green or Theme.border}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        task.spawn(function() pcall(callback, state) end)
    end
    new("TextButton", {Size = UDim2.new(1, 0, 1, 0), Text = "", BackgroundTransparency = 1}, card).MouseButton1Click:Connect(function() setState(not state) end)
end

-- Tabs Setup
local tMain    = createTab("Main", "📈")
local tPlayerS = createTab("Player", "🏃")
local tSettings = createTab("Settings", "⚙")
selectTab(tMain)

-- MAIN TAB
do
    addSection(tMain, "Automation")
    addToggle(tMain, "Auto Climb / Step", "Simulates continuous jumping/steps", false, function(v)
        autoClimbEnabled = v
        notify("Auto Climb", v and "Started!" or "Stopped", v and Theme.green or Theme.textDim)
    end)
    addToggle(tMain, "Auto Rebirth", "Automatically triggers rebirths", false, function(v)
        autoRebirthEnabled = v
        notify("Auto Rebirth", v and "Enabled" or "Disabled", v and Theme.green or Theme.textDim)
    end)
end

-- PLAYER TAB
do
    addSection(tPlayerS, "Movement")
    addToggle(tPlayerS, "Infinite Jump", "Jump anywhere mid-air", false, function(v) infJumpEnabled = v end)
    addToggle(tPlayerS, "NoClip", "Walk through obstacles", false, function(v) noClipEnabled = v end)
end

-- SETTINGS TAB
do
    addSection(tSettings, "Controls")
    addToggle(tSettings, "Anti-AFK", "Prevents disconnection", true, function(v) antiAFKEnabled = v end)
end

-- Loop Routines
task.spawn(function()
    while true do
        task.wait(0.15)
        if autoClimbEnabled then
            hudSteps = hudSteps + 1
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

RunService.Stepped:Connect(function()
    if noClipEnabled then
        local char = player.Character
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end
end)

notify("🌌 Ascend Or Fall", "Loaded successfully!", Theme.accent)
