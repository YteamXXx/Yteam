-- LocalScript: GUI Setup and Functionality
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer
local PlayerGui = localPlayer.PlayerGui

-- Remote Setup
local interactions = ReplicatedStorage:WaitForChild("remoteInterface"):WaitForChild("interactions")
local inventory = ReplicatedStorage:WaitForChild("remoteInterface"):WaitForChild("inventory")

-- Menetapkan remotes tanpa duplikasi
getgenv().remotes = {
    meleeAI = interactions:WaitForChild("meleeAI"),
    take = inventory:WaitForChild("take"),
    pickupItem = inventory:WaitForChild("pickupItem"),
    plant = interactions:WaitForChild("plant"),
    harvest = interactions:WaitForChild("harvest"),
    eat = interactions:WaitForChild("eat"),
    build = interactions:WaitForChild("build"),
    deleteStructure = interactions:WaitForChild("deleteStructure"),
    shotHitPlayer = interactions:WaitForChild("shotHitPlayer"),
    objectHit = interactions:WaitForChild("objectHit"),
    hitStructure = interactions:WaitForChild("hitStructure"),
    shotHitStructure = interactions:WaitForChild("shotHitStructure"),
    chop = interactions:WaitForChild("chop"),
    buyRebirthPerk = interactions:WaitForChild("buyRebirthPerk"),
    mine = interactions:WaitForChild("mine"),
    meleePlayer = interactions:WaitForChild("meleePlayer"),
    rebirth = interactions:WaitForChild("rebirth"),
    removePath = interactions:WaitForChild("removePath"),
}

-- Setup GUI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.Name = "CustomGUI"

local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 200, 0, 250)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = true

local titleLabel = Instance.new("TextLabel", mainFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleLabel.Text = "Custom Script"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.TextStrokeTransparency = 0.5
titleLabel.TextWrapped = true

local closeButton = Instance.new("TextButton", mainFrame)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 20

local minimizeButton = Instance.new("TextButton", mainFrame)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 20

local espButton = Instance.new("TextButton", mainFrame)
espButton.Size = UDim2.new(1, -20, 0, 50)
espButton.Position = UDim2.new(0, 10, 0, 40)
espButton.BackgroundColor3 = Color3.fromRGB(0, 0, 255)
espButton.Text = "Toggle ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 20

local speedButton = Instance.new("TextButton", mainFrame)
speedButton.Size = UDim2.new(1, -20, 0, 50)
speedButton.Position = UDim2.new(0, 10, 0, 100)
speedButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
speedButton.Text = "Toggle Speed"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20

local killAuraButton = Instance.new("TextButton", mainFrame)
killAuraButton.Size = UDim2.new(1, -20, 0, 50)
killAuraButton.Position = UDim2.new(0, 10, 0, 160)
killAuraButton.BackgroundColor3 = Color3.fromRGB(255, 0, 255)
killAuraButton.Text = "Toggle Kill Aura"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.TextSize = 20

-- State Management
local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false
local walkSpeed = 100
local attackRadius = 50

-- Fungsi ESP
local function enableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local espLabel = player.Character:FindFirstChild("ESPLabel")
            if not espLabel then
                espLabel = Instance.new("BillboardGui", player.Character.Head)
                espLabel.Name = "ESPLabel"
                espLabel.Size = UDim2.new(0, 200, 0, 50)
                espLabel.AlwaysOnTop = true
                espLabel.Adornee = player.Character.Head
                local textLabel = Instance.new("TextLabel", espLabel)
                textLabel.Size = UDim2.new(1, 0, 1, 0)
                textLabel.BackgroundTransparency = 1
                textLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
                textLabel.TextSize = 20
                textLabel.Text = player.Name .. " | Health: " .. player.Character.Humanoid.Health
                textLabel.TextStrokeTransparency = 0.5
            end
        end
    end
end

local function disableESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local espLabel = player.Character:FindFirstChild("ESPLabel")
            if espLabel then
                espLabel:Destroy()
            end
        end
    end
end

-- Fungsi untuk mengatur kecepatan lari
local function setWalkSpeed(speed)
    localPlayer.Character.Humanoid.WalkSpeed = speed
end

-- Fungsi Kill Aura
local function killAura()
    local nearestPlayer = nil
    local shortestDistance = attackRadius

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - localPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                nearestPlayer = player
                shortestDistance = distance
            end
        end
    end

    if nearestPlayer then
        -- Auto aim ke target
        localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(localPlayer.Character.HumanoidRootPart.Position, nearestPlayer.Character.HumanoidRootPart.Position)
        -- Serang target
        remotes.meleePlayer:FireServer(nearestPlayer)
    end
end

-- Event Handlers
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        enableESP()
        espButton.Text = "Disable ESP"
    else
        disableESP()
        espButton.Text = "Enable ESP"
    end
end)

speedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        setWalkSpeed(walkSpeed)
        speedButton.Text = "Disable Speed"
    else
        setWalkSpeed(16)  -- Set default walk speed
        speedButton.Text = "Enable Speed"
    end
end)

killAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        killAuraButton.Text = "Disable Kill Aura"
    else
        killAuraButton.Text = "Enable Kill Aura"
    end
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    minimizeButton.Text = mainFrame.Visible and "-" or "+"
end)

-- Loop untuk menjalankan Kill Aura dan ESP
RunService.RenderStepped:Connect(function()
    if killAuraEnabled then
        killAura()
    end
end)
