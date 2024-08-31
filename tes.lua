-- Setup
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local RemoteInterface = ReplicatedStorage:WaitForChild("RemoteInterface", 5)
local Interactions = RemoteInterface and RemoteInterface:WaitForChild("Interactions", 5)

if not Interactions then
    warn("Interactions tidak ditemukan dalam waktu 5 detik.")
    return
end

-- GUI Setup
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local KillAuraButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 300, 0, 300)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MainFrame.Active = true
MainFrame.Draggable = true

CloseButton.Parent = MainFrame
CloseButton.Text = "Close"
CloseButton.Size = UDim2.new(0, 50, 0, 25)
CloseButton.Position = UDim2.new(1, -55, 0, 5)

MinimizeButton.Parent = MainFrame
MinimizeButton.Text = "Minimize"
MinimizeButton.Size = UDim2.new(0, 75, 0, 25)
MinimizeButton.Position = UDim2.new(1, -130, 0, 5)

ESPButton.Parent = MainFrame
ESPButton.Text = "Toggle ESP"
ESPButton.Size = UDim2.new(0, 100, 0, 50)
ESPButton.Position = UDim2.new(0.5, -50, 0.5, -100)

SpeedButton.Parent = MainFrame
SpeedButton.Text = "Toggle Speed"
SpeedButton.Size = UDim2.new(0, 100, 0, 50)
SpeedButton.Position = UDim2.new(0.5, -50, 0.5, -50)

KillAuraButton.Parent = MainFrame
KillAuraButton.Text = "Toggle Kill Aura"
KillAuraButton.Size = UDim2.new(0, 100, 0, 50)
KillAuraButton.Position = UDim2.new(0.5, -50, 0.5, 0)

-- Initial States
local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false

-- Button Functions
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESPButton.Text = espEnabled and "ESP: ON" or "ESP: OFF"
    -- Implement ESP functionality here
    if espEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- Create ESP for each player
                local espPart = Instance.new("BillboardGui")
                espPart.Parent = player.Character.HumanoidRootPart
                espPart.Size = UDim2.new(0, 200, 0, 50)
                espPart.StudsOffset = Vector3.new(0, 3, 0)
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = espPart
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.Text = player.Name
                textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                textLabel.TextStrokeTransparency = 0.5
            end
        end
    else
        -- Remove ESP
        for _, player in pairs(Players:GetPlayers()) do
            local espPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChildOfClass("BillboardGui")
            if espPart then
                espPart:Destroy()
            end
        end
    end
end)

SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    SpeedButton.Text = speedEnabled and "Speed: ON" or "Speed: OFF"
    LocalPlayer.Character.Humanoid.WalkSpeed = speedEnabled and 50 or 16
end)

KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    KillAuraButton.Text = killAuraEnabled and "Kill Aura: ON" or "Kill Aura: OFF"
end)

-- Kill Aura Logic
RunService.RenderStepped:Connect(function()
    if killAuraEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < 10 then
                    -- Perform attack
                    local remoteEvent = Interactions:FindFirstChild("meleePlayer")
                    if remoteEvent then
                        remoteEvent:FireServer(player.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    end
end)
