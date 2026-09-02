-- Ascend Auto Rebirth/Ascend Mobile Script
-- Compatible with most mobile executors (Delta, Arceus X, CodeX, etc.)

local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({Name = "Ascend Mobile Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "AscendHub"})

local Tab = Window:MakeTab({
    Name = "Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

getgenv().AutoAscend = false

Tab:AddToggle({
    Name = "Auto Ascend / Rebirth",
    Default = false,
    Callback = function(Value)
        getgenv().AutoAscend = Value
        
        task.spawn(function()
            while getgenv().AutoAscend do
                pcall(function()
                    local player = game:GetService("Players").LocalPlayer
                    local ability = player:WaitForChild("Data"):WaitForChild("Ability")
                    
                    local args = {
                        [1] = ability.Value
                    }
                    game:GetService("ReplicatedStorage")
                        :WaitForChild("ReplicatedModules")
                        :WaitForChild("KnitPackage")
                        :WaitForChild("Knit")
                        :WaitForChild("Services")
                        :WaitForChild("LevelService")
                        :WaitForChild("RF")
                        :WaitForChild("AscendAbility")
                        :InvokeServer(unpack(args))
                end)
                task.wait(1)
            end
        end)
    end
})

OrionLib:Init()
