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

-- Variables
local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false

-- RemoteEvents
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteInterface = ReplicatedStorage:WaitForChild("RemoteInterface")
local Interactions = RemoteInterface:WaitForChild("Interactions")

local meleePlayer = Interactions:WaitForChild("meleePlayer")
local espRemote = Interactions:WaitForChild("espRemote")

-- Functions

-- Close GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize GUI
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Toggle ESP
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
        end
    else
        ESPButton.Text = "ESP: OFF"
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character:FindFirstChildOfClass("Highlight") then
                player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end
end)

-- Toggle Speed
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "Speed: ON"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        SpeedButton.Text = "Speed: OFF"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Toggle Kill Aura
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        KillAuraButton.Text = "Kill Aura: ON"
        while killAuraEnabled do
            wait(1) -- Adjust frequency as needed
            for _, player in pairs(game.Players:GetPlayers()) do
                if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance < 10 then
                        -- Perform the attack
                        meleePlayer:FireServer(player, 50) -- Adjust damage as needed
                    end
                end
            end
        end
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)

-- Automatically activate Kill Aura
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    killAuraEnabled = true
    KillAuraButton.Text = "Kill Aura: ON"
    while killAuraEnabled do
        wait(1) -- Adjust frequency as needed
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < 10 then
                    meleePlayer:FireServer(player, 50) -- Adjust damage as needed
                end
            end
        end
    end
end)
