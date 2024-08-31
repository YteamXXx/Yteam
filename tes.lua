local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Mengakses RemoteInterface dan interactions
local RemoteInterface = ReplicatedStorage:WaitForChild("RemoteInterface", 5)
local interactions = Remoteinterface:WaitForChild("interactions", 5)

-- Remote Events
local shotHitPlayer = interactions:WaitForChild("shotHitPlayer")
local shotHitAi = interactions:WaitForChild("shotHitAi")
local objectHit = interactions:WaitForChild("objectHit")
local hitStructure = interactions:WaitForChild("hitStructure")
local shotStructure = interactions:WaitForChild("shotStructure")
local chop = interactions:WaitForChild("chop")
local buyRebirthPerk = interactions:WaitForChild("buyRebirthPerk")
local deleteStructure = interactions:WaitForChild("deleteStructure")
local eat = interactions:WaitForChild("eat")
local mine = interactions:WaitForChild("mine")
local meleeAl = interactions:WaitForChild("meleeAl")
local meleePlayer = interactions:WaitForChild("meleePlayer")
local rebirth = interactions:WaitForChild("rebirth")
local plant = interactions:WaitForChild("plant")
local removePath = interactions:WaitForChild("removePath")
local itemAlInterraction = interactions:WaitForChild("itemAlInterraction")

-- Membuat GUI
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
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.Parent = MainFrame
MinimizeButton.Text = "Minimize"
MinimizeButton.Size = UDim2.new(0, 75, 0, 25)
MinimizeButton.Position = UDim2.new(1, -130, 0, 5)
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

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

local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false

-- Fungsi untuk mengaktifkan/menonaktifkan ESP
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local nameLabel = Instance.new("BillboardGui")
                nameLabel.Parent = player.Character.HumanoidRootPart
                nameLabel.Adornee = player.Character.HumanoidRootPart
                nameLabel.Size = UDim2.new(0, 200, 0, 50)
                nameLabel.StudsOffset = Vector3.new(0, 3, 0)
                
                local textLabel = Instance.new("TextLabel")
                textLabel.Parent = nameLabel
                textLabel.Text = player.Name
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                textLabel.TextStrokeTransparency = 0.5
            end
        end
    else
        ESPButton.Text = "ESP: OFF"
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart:FindFirstChildOfClass("BillboardGui") then
                player.Character.HumanoidRootPart:FindFirstChildOfClass("BillboardGui"):Destroy()
            end
        end
    end
end)

-- Fungsi untuk mengaktifkan/menonaktifkan lari cepat
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "Speed: ON"
        Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    else
        SpeedButton.Text = "Speed: OFF"
        Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
end)

-- Fungsi untuk mengaktifkan/menonaktifkan kill aura
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        KillAuraButton.Text = "Kill Aura: ON"
        while killAuraEnabled do
            wait(0.1) -- Jeda singkat untuk meminimalisir beban server
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local distance = (player.Character.HumanoidRootPart.Position - Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance < 10 then
                        -- Menggunakan remote event untuk menyerang
                        meleePlayer:FireServer(player.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)
