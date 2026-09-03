-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Remote Events for client-server communication
local remotes = ReplicatedStorage:FindFirstChild("BridgeRemotes") or Instance.new("Folder", ReplicatedStorage)
remotes.Name = "BridgeRemotes"

local pickupEvent = remotes:FindFirstChild("PickupBlock") or Instance.new("RemoteEvent", remotes)
pickupEvent.Name = "PickupBlock"

local placeEvent = remotes:FindFirstChild("PlaceBlock") or Instance.new("RemoteEvent", remotes)
placeEvent.Name = "PlaceBlock"

-- Player inventory tracker (storing block counts per player)
local playerBlocks = {}

Players.PlayerAdded:Connect(function(player)
    playerBlocks[player.UserId] = 0
    
    -- Setup leaderstats to show block count
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local blocks = Instance.new("IntValue")
    blocks.Name = "Blocks"
    blocks.Value = 0
    blocks.Parent = leaderstats
end)

Players.PlayerRemoving:Connect(function(player)
    playerBlocks[player.UserId] = nil
end)

-- Handle block collection
pickupEvent.OnServerEvent:Connect(function(player, blockPart)
    if blockPart and blockPart:IsA("BasePart") and blockPart.Parent == workspace.BlockSpawners then
        -- Verify player distance to prevent exploiting
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - blockPart.Position).Magnitude
            if distance < 15 then
                blockPart:Destroy() -- Remove block from world
                
                playerBlocks[player.UserId] = (playerBlocks[player.UserId] or 0) + 1
                
                -- Update leaderstats
                if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Blocks") then
                    player.leaderstats.Blocks.Value = playerBlocks[player.UserId]
                end
            end
        end
    end
end)

-- Handle bridge building / block placement
placeEvent.OnServerEvent:Connect(function(player, bridgeSlot)
    local currentBlocks = playerBlocks[player.UserId] or 0
    
    if currentBlocks > 0 and bridgeSlot and bridgeSlot:IsA("BasePart") and not bridgeSlot:GetAttribute("Built") then
        -- Deduct block
        playerBlocks[player.UserId] = currentBlocks - 1
        
        if player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Blocks") then
            player.leaderstats.Blocks.Value = playerBlocks[player.UserId]
        end
        
        -- Mark bridge slot as built and change appearance to match team color
        bridgeSlot:SetAttribute("Built", true)
        bridgeSlot.Transparency = 0
        bridgeSlot.CanCollide = true
        
        -- Assign color based on player team (Assumes Team service is configured)
        if player.Team then
            bridgeSlot.BrickColor = player.Team.BrickColor
        end
    end
end)
