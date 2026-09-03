-- ============================================================
--  ASCEND OR FALL — Ultimate Universal Mobile Script
-- ============================================================

local CoreGui          = game:GetService("CoreGui")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local player           = Players.LocalPlayer

-- Clean up any existing instances safely
pcall(function()
    if CoreGui:FindFirstChild("AOF_Universal_Hub") then
        CoreGui.AOF_Universal_Hub:Destroy()
    end
    if player.PlayerGui:FindFirstChild("AOF_Universal_Hub") then
        player.PlayerGui.AOF_Universal_Hub:Destroy()
    end
end)

local Theme = {
    bg        = Color3.fromRGB(20, 22, 30),
    sidebar   = Color3.fromRGB(14, 16, 22),
    panel     = Color3.fromRGB(26, 29, 38),
    card      = Color3.fromRGB(34, 38, 50),
    border    = Color3.fromRGB(48, 54, 70),
    accent    = Color3.fromRGB(140, 60, 255),
    green     = Color3.fromRGB(87, 242, 135),
    red       = Color3.fromRGB(237, 66, 69),
    text      = Color3.fromRGB(230, 230, 235),
    textDim   = Color3.fromRGB(140, 145, 160),
    white     = Color3.fromRGB(255, 255, 255),
}

-- Features Toggle States
local autoClimb   = false
local autoRoll    = false
local infJump     = false
local noClip      = false
local antiAfk     = true

-- Create UI Root
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AOF_Universal_Hub"
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true

local successParent = pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not successParent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- Floating Toggle Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "AOFToggle"
ToggleBtn.Size = UDim2.new(0, 48, 0, 48)
ToggleBtn.Position = UDim2.new(0, 15, 0.4, 0)
ToggleBtn.BackgroundColor3 = Theme.sidebar
ToggleBtn.TextColor3 = Theme.accent
ToggleBtn.Text = "🌌"
ToggleBtn.TextSize = 22
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Active = true
ToggleBtn.Draggable = true
ToggleBtn.ZIndex = 500
ToggleBtn.Parent = ScreenGui

local tCorner = Instance.new("UICorner", ToggleBtn)
tCorner.CornerRadius = UDim.new(1, 0)
local tStroke = Instance.new("UIStroke", ToggleBtn)
tStroke.Thickness = 2
tStroke.Color = Theme.accent

-- Main Window Frame
local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.new(0, 400, 0, 240)
Window.Position = UDim2.new(0.5, -200, 0.5, -120)
Window.BackgroundColor3 = Theme.bg
Window.BorderSizePixel = 0
Window.Active = true
Window.Draggable = true
Window.ClipsDescendants = true
Window.Parent = ScreenGui

local wCorner = Instance.new("UICorner", Window)
wCorner.CornerRadius = UDim.new(0, 10)
local wStroke = Instance.new("UIStroke", Window)
wStroke.Thickness = 1
wStroke.Color = Theme.border

-- Title Bar
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 36)
TitleBar.BackgroundColor3 = Theme.sidebar
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 2
TitleBar.Parent = Window

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "🌌  ASCEND OR FALL HUB"
TitleLabel.TextColor3 = Theme.text
TitleLabel.TextSize = 11
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 3
TitleLabel.Parent = TitleBar

-- Window Close / Minimize Controls
local function makeWinBtn(text, xOffset)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 32, 1, 0)
    btn.Position = UDim2.new(1, xOffset, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Theme.textDim
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.ZIndex = 3
    btn.Parent = TitleBar
    return btn
end

local CloseBtn = makeWinBtn("X", -32)
local MinBtn = makeWinBtn("_", -64)

CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() ScreenGui:Destroy() end)
end)

local hidden = false
local function toggleUI()
    hidden = not hidden
    Window.Visible = not hidden
end
MinBtn.MouseButton1Click:Connect(toggleUI)
ToggleBtn.MouseButton1Click:Connect(toggleUI)

-- Sidebar & Content Setup
local SIDEBAR_W = 110
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, SIDEBAR_W, 1, -36)
Sidebar.Position = UDim2.new(0, 0, 0, 36)
Sidebar.BackgroundColor3 = Theme.sidebar
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Window

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -SIDEBAR_W, 1, -36)
ContentArea.Position = UDim2.new(0, SIDEBAR_W, 0, 36)
ContentArea.BackgroundColor3 = Theme.panel
ContentArea.BorderSizePixel = 0
ContentArea.Parent = Window

local SidebarList = Instance.new("ScrollingFrame")
SidebarList.Size = UDim2.new(1, 0, 1, 0)
SidebarList.BackgroundTransparency = 1
SidebarList.BorderSizePixel = 0
SidebarList.ScrollBarThickness = 2
SidebarList.AutomaticCanvasSize = Enum.AutomaticSize.Y
SidebarList.Parent = Sidebar

local sLayout = Instance.new("UIListLayout", SidebarList)
sLayout.SortOrder = Enum.SortOrder.LayoutOrder
sLayout.Padding = UDim.new(0, 2)
local sPad = Instance.new("UIPadding", SidebarList)
sPad.PaddingLeft = UDim.new(0, 4)
sPad.PaddingRight = UDim.new(0, 4)
sPad.PaddingTop = UDim.new(0, 4)

local tabs = {}
local activeTab = nil

local function selectTab(tab)
    for _, t in ipairs(tabs) do
        t.content.Visible = false
        t.bar.Visible = false
        t.btn.BackgroundTransparency = 1
        local lbl = t.btn:FindFirstChildOfClass("TextLabel")
        if lbl then lbl.TextColor3 = Theme.textDim end
    end
    tab.content.Visible = true
    tab.bar.Visible = true
    tab.btn.BackgroundTransparency = 0.82
    local lbl = tab.btn:FindFirstChildOfClass("TextLabel")
    if lbl then lbl.TextColor3 = Theme.accent end
    activeTab = tab
end

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.LayoutOrder = #tabs + 1
    btn.Parent = SidebarList

    local bCorner = Instance.new("UICorner", btn)
    bCorner.CornerRadius = UDim.new(0, 6)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 0, 16)
    bar.Position = UDim2.new(0, 0, 0.5, -8)
    bar.BackgroundColor3 = Theme.accent
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.Parent = btn
    local barCorner = Instance.new("UICorner", bar)
    barCorner.CornerRadius = UDim.new(0, 2)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 1, 0)
    lbl.Position = UDim2.new(0, 8, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = icon .. " " .. name
    lbl.TextColor3 = Theme.textDim
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = btn

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = Theme.border
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.Visible = false
    content.Parent = ContentArea

    local cPad = Instance.new("UIPadding", content)
    cPad.PaddingLeft = UDim.new(0, 8)
    cPad.PaddingRight = UDim.new(0, 8)
    cPad.PaddingTop = UDim.new(0, 8)
    cPad.PaddingBottom = UDim.new(0, 8)

    local cLayout = Instance.new("UIListLayout", content)
    cLayout.SortOrder = Enum.SortOrder.LayoutOrder
    cLayout.Padding = UDim.new(0, 5)

    local tab = {name = name, btn = btn, content = content, bar = bar}
    tabs[#tabs + 1] = tab
    btn.MouseButton1Click:Connect(function() selectTab(tab) end)
    return tab
end

local function addSection(tab, title)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, 0, 0, 16)
    f.BackgroundTransparency = 1
    f.LayoutOrder = #tab.content:GetChildren()
    f.Parent = tab.content

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = title:upper()
    l.TextColor3 = Theme.textDim
    l.TextSize = 8
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f
end

local function addToggle(tab, title, desc, default, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, desc and 44 or 36)
    card.BackgroundColor3 = Theme.card
    card.BorderSizePixel = 0
    card.LayoutOrder = #tab.content:GetChildren()
    card.Parent = tab.content

    local cCorner = Instance.new("UICorner", card)
    cCorner.CornerRadius = UDim.new(0, 6)

    local tLbl = Instance.new("TextLabel")
    tLbl.Size = UDim2.new(1, -55, 0, desc and 20 or 36)
    tLbl.Position = UDim2.new(0, 8, 0, 0)
    tLbl.BackgroundTransparency = 1
    tLbl.Text = title
    tLbl.TextColor3 = Theme.text
    tLbl.TextSize = 10
    tLbl.Font = Enum.Font.GothamMedium
    tLbl.TextXAlignment = Enum.TextXAlignment.Left
    tLbl.Parent = card

    if desc then
        local dLbl = Instance.new("TextLabel")
        dLbl.Size = UDim2.new(1, -55, 0, 16)
        dLbl.Position = UDim2.new(0, 8, 0, 20)
        dLbl.BackgroundTransparency = 1
        dLbl.Text = desc
        dLbl.TextColor3 = Theme.textDim
        dLbl.TextSize = 8
        dLbl.Font = Enum.Font.Gotham
        dLbl.TextXAlignment = Enum.TextXAlignment.Left
        dLbl.Parent = card
    end

    local track = Instance.new("Frame")
    track.Size = UDim2.new(0, 32, 0, 16)
    track.Position = UDim2.new(1, -40, 0.5, -8)
    track.BackgroundColor3 = default and Theme.green or Theme.border
    track.BorderSizePixel = 0
    track.Parent = card
    local tCorner = Instance.new("UICorner", track)
    tCorner.CornerRadius = UDim.new(0, 8)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = default and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = Theme.white
    knob.BorderSizePixel = 0
    knob.Parent = track
    local kCorner = Instance.new("UICorner", knob)
    kCorner.CornerRadius = UDim.new(0, 6)

    local state = default or false
    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = card

    clickBtn.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(track, TweenInfo.new(0.15), {BackgroundColor3 = state and Theme.green or Theme.border}):Play()
        TweenService:Create(knob, TweenInfo.new(0.15), {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        task.spawn(function() pcall(callback, state) end)
    end)
end

-- Setup Tabs
local tMain     = createTab("Main", "📈")
local tPlayer   = createTab("Player", "🏃")
local tSettings = createTab("Misc", "⚙")
selectTab(tMain)

-- Populate Main Tab
addSection(tMain, "Automation")
addToggle(tMain, "Auto Climb / Step", "Continuously triggers jumping/steps", false, function(v)
    autoClimb = v
end)

addToggle(tMain, "Auto Roll / Spin", "Continuously fires spin loops", false, function(v)
    autoRoll = v
end)

-- Populate Player Tab
addSection(tPlayer, "Movement")
addToggle(tPlayer, "Infinite Jump", "Jump mid-air anywhere", false, function(v)
    infJump = v
end)

addToggle(tPlayer, "NoClip", "Walk through all obstacles", false, function(v)
    noClip = v
end)

-- Populate Settings Tab
addSection(tSettings, "Security")
addToggle(tSettings, "Anti-AFK", "Keeps your connection active", true, function(v)
    antiAfk = v
end)

-- Core Execution Loops
task.spawn(function()
    while true do
        task.wait(0.15)
        if autoClimb then
            pcall(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
        if autoRoll then
            pcall(function()
                -- Safe generic remote search for roll/spin functionalities in RNG games
                for _, obj in ipairs(game:GetDescendants()) do
                    if obj:IsA("RemoteEvent") and (string.lower(obj.Name):find("roll") or string.lower(obj.Name):find("spin") or string.lower(obj.Name):find("aura")) then
                        obj:FireServer()
                    end
                end
            end)
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if infJump then
        pcall(function()
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if noClip then
        pcall(function()
            local char = player.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then
                        p.CanCollide = false
                    end
                end
            end
        end)
    end
end)

-- Anti-AFK connection
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfk then
        pcall(function()
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
    end
end)

print("Ascend Or Fall Universal Hub Loaded successfully!")
