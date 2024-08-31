-- Load remote scripts
local success, errorMessage = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes"))()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes"))()
end)

if not success then
    warn("Failed to load remote scripts: " .. errorMessage)
end

-- Function to activate Kill Aura
local function activateKillAura()
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    local humanoids = {}

    -- Get all humanoids in the workspace within range
    local region = workspace:FindPartsInRegion3(workspace.CurrentCamera.CFrame:ToWorldSpace(character.PrimaryPart.CFrame).CFrame:ToWorldSpace(CFrame.new(0, 0, -50)), nil, math.huge)
    for _, v in pairs(region) do
        if v and v.Parent and v.Parent:FindFirstChildOfClass("Humanoid") then
            table.insert(humanoids, v.Parent)
        end
    end

    -- Attack each humanoid found
    for _, enemy in pairs(humanoids) do
        if enemy ~= character then
            -- Use the melee AI remote to attack
            local success, attackError = pcall(function()
                remotes.meleeAI:FireServer({
                    hitObject = enemy,
                    hitCF = enemy.PrimaryPart.CFrame
                })
            end)
            if not success then
                warn("Failed to activate Kill Aura: " .. attackError)
            end
        end
    end
end

-- Function to set speed without rollback
local function setSpeed(speed)
    local player = game.Players.LocalPlayer
    local character = player.Character
    if not character then return end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

-- Function to activate Kill Aura and speed boost
local function activateKillAuraWithSpeed(speed)
    -- Set speed first
    setSpeed(speed)

    -- Activate Kill Aura
    activateKillAura()
end

-- GUI Setup
local yteamGUI = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local heading = Instance.new("TextLabel")
local bodyFrame = Instance.new("Frame")
local sidebarFrame = Instance.new("Frame")
local homeButton = Instance.new("TextButton")
local visualButton = Instance.new("TextButton")
local noClipButton = Instance.new("TextButton")
local killAuraButton = Instance.new("TextButton")
local speedButton = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")
local minimizeButton = Instance.new("TextButton")

-- Parent to PlayerGui
yteamGUI.Name = "yteamGUI"
yteamGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
mainFrame.Name = "mainFrame"
mainFrame.Parent = yteamGUI
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Active = true
mainFrame.Draggable = true

-- Heading
heading.Name = "heading"
heading.Parent = mainFrame
heading.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
heading.Size = UDim2.new(1, 0, 0, 50)
heading.Font = Enum.Font.SourceSansBold
heading.Text = "yteam"
heading.TextColor3 = Color3.fromRGB(255, 85, 85) -- Top Gradient Color
heading.TextSize = 24.000
heading.TextStrokeTransparency = 0.1
heading.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

-- Sidebar Frame
sidebarFrame.Name = "sidebarFrame"
sidebarFrame.Parent = mainFrame
sidebarFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sidebarFrame.Size = UDim2.new(0, 100, 1, -50)
sidebarFrame.Position = UDim2.new(0, 0, 0, 50)

-- Home Button
homeButton.Name = "homeButton"
homeButton.Parent = sidebarFrame
homeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
homeButton.Position = UDim2.new(0, 0, 0, 0)
homeButton.Size = UDim2.new(1, 0, 0, 50)
homeButton.Font = Enum.Font.SourceSans
homeButton.Text = "Home"
homeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
homeButton.TextSize = 20.000

-- Visual Button
visualButton.Name = "visualButton"
visualButton.Parent = sidebarFrame
visualButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
visualButton.Position = UDim2.new(0, 0, 0, 60)
visualButton.Size = UDim2.new(1, 0, 0, 50)
visualButton.Font = Enum.Font.SourceSans
visualButton.Text = "Visual"
visualButton.TextColor3 = Color3.fromRGB(255, 255, 255)
visualButton.TextSize = 20.000

-- No Clip Button
noClipButton.Name = "noClipButton"
noClipButton.Parent = sidebarFrame
noClipButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
noClipButton.Position = UDim2.new(0, 0, 0, 120)
noClipButton.Size = UDim2.new(1, 0, 0, 50)
noClipButton.Font = Enum.Font.SourceSans
noClipButton.Text = "No Clip"
noClipButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noClipButton.TextSize = 20.000

-- Kill Aura Button
killAuraButton.Name = "killAuraButton"
killAuraButton.Parent = sidebarFrame
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Position = UDim2.new(0, 0, 0, 180)
killAuraButton.Size = UDim2.new(1, 0, 0, 50)
killAuraButton.Font = Enum.Font.SourceSans
killAuraButton.Text = "Kill Aura"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.TextSize = 20.000

-- Speed Button
speedButton.Name = "speedButton"
speedButton.Parent = sidebarFrame
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.Position = UDim2.new(0, 0, 0, 240)
speedButton.Size = UDim2.new(1, 0, 0, 50)
speedButton.Font = Enum.Font.SourceSans
speedButton.Text = "Speed: 70"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20.000

-- Body Frame
bodyFrame.Name = "bodyFrame"
bodyFrame.Parent = mainFrame
bodyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
bodyFrame.Position = UDim2.new(0, 100, 0, 50)
bodyFrame.Size = UDim2.new(1, -100, 1, -50)

-- Close Button
closeButton.Name = "closeButton"
closeButton.Parent = mainFrame
closeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
closeButton.Position = UDim2.new(0.9, 0, 0, 5)
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 24.000

-- Minimize Button
minimizeButton.Name = "minimizeButton"
minimizeButton.Parent = mainFrame
minimizeButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeButton.Position = UDim2.new(0.8, 0, 0, 5)
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 24.000

-- Minimize Button Functionality
minimizeButton.MouseButton1Click:Connect(function()
    bodyFrame.Visible = not bodyFrame.Visible
    minimizeButton.Text = bodyFrame.Visible and "-" or "+"
end)

-- Close Button Functionality
closeButton.MouseButton1Click:Connect(function()
    yteamGUI:Destroy()
end)

-- Speed Button Functionality
speedButton.MouseButton1Click:Connect(function()
    setSpeed(70)
    speedButton.Text = "Speed: 70"
end)

-- Kill Aura Button Functionality
killAuraButton.MouseButton1Click:Connect(function()
    activateKillAuraWithSpeed(70)
end)
