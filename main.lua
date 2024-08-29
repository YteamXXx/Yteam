local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local RunService = game:GetService("RunService")

-- Ensure the humanoid is valid and the player is in the game
if not humanoid then
    player.CharacterAdded:Wait()
    humanoid = player.Character:FindFirstChildOfClass("Humanoid")
end

-- GUI Elements
local yteamGUI = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local heading = Instance.new("TextLabel")
local bodyFrame = Instance.new("Frame")
local sidebarFrame = Instance.new("Frame")
local homeButton = Instance.new("TextButton")
local visualButton = Instance.new("TextButton")
local noClipButton = Instance.new("TextButton")
local closeButton = Instance.new("TextButton")
local minimizeButton = Instance.new("TextButton")
local homeFrame = Instance.new("Frame")
local visualFrame = Instance.new("Frame")
local espButton = Instance.new("TextButton")
local noClipFrame = Instance.new("Frame")
local speedButton = Instance.new("TextButton")

local espEnabled = false
local speedActive = false

local normalSpeed = 16
local fastSpeed = 70
local speedChangeRate = 0.5 -- Waktu dalam detik untuk transisi kecepatan



loadstring(game:HttpGet("https://raw.githubusercontent.com/YteamXXx/Yteam/main/GetItems.lua", true))()

-- Parent to PlayerGui
yteamGUI.Name = "yteamGUI"
yteamGUI.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Main Frame
mainFrame.Name = "mainFrame"
mainFrame.Parent = yteamGUI
mainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainFrame.Position = UDim2.new(0.3, 0, 0.3, 0)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Active = true
mainFrame.Draggable = true

-- Heading
heading.Name = "heading"
heading.Parent = mainFrame
heading.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
heading.Size = UDim2.new(1, 0, 0, 50)
heading.Font = Enum.Font.SourceSansBold
heading.Text = "yteam"
heading.TextColor3 = Color3.fromRGB(255, 255, 255)
heading.TextSize = 24.000
heading.TextStrokeTransparency = 0.1
heading.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
heading.TextColor3 = Color3.fromRGB(255, 85, 85) -- Gradient Color

-- Sidebar Frame
sidebarFrame.Name = "sidebarFrame"
sidebarFrame.Parent = mainFrame
sidebarFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
sidebarFrame.Size = UDim2.new(0, 150, 1, -50)
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

-- Home Frame
homeFrame.Name = "homeFrame"
homeFrame.Parent = bodyFrame
homeFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
homeFrame.Size = UDim2.new(1, 0, 1, 0)
homeFrame.Visible = true

-- Visual Frame
visualFrame.Name = "visualFrame"
visualFrame.Parent = bodyFrame
visualFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
visualFrame.Size = UDim2.new(1, 0, 1, 0)
visualFrame.Visible = false

-- No Clip Frame
noClipFrame.Name = "noClipFrame"
noClipFrame.Parent = bodyFrame
noClipFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
noClipFrame.Size = UDim2.new(1, 0, 1, 0)
noClipFrame.Visible = false

-- Body Frame
bodyFrame.Name = "bodyFrame"
bodyFrame.Parent = mainFrame
bodyFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
bodyFrame.Position = UDim2.new(0, 150, 0, 50)
bodyFrame.Size = UDim2.new(1, -150, 1, -50)

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
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.TextSize = 24.000


-- ESP Button
espButton.Name = "espButton"
espButton.Parent = visualFrame
espButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espButton.Position = UDim2.new(0.5, -75, 0, 20)
espButton.Size = UDim2.new(0, 150, 0, 50)
espButton.Font = Enum.Font.SourceSans
espButton.Text = "Toggle ESP"
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextSize = 20.000
-- Day/Night Toggle Button
local dayNightButton = Instance.new("TextButton")
dayNightButton.Name = "dayNightButton"
dayNightButton.Parent = visualFrame
dayNightButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
dayNightButton.Position = UDim2.new(0.5, -75, 0, 80)
dayNightButton.Size = UDim2.new(0, 150, 0, 50)
dayNightButton.Font = Enum.Font.SourceSans
dayNightButton.Text = "Alwways Monring"
dayNightButton.TextColor3 = Color3.fromRGB(255, 255, 255)
dayNightButton.TextSize = 20.000

-- lari cepat
speedButton.Name = "speedButton"
speedButton.Parent = noClipFrame
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.Position = UDim2.new(0.5, -75, 0, 20)
speedButton.Size = UDim2.new(0, 150, 0, 50)
speedButton.Font = Enum.Font.SourceSans
speedButton.Text = "Toggle Speed"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20.000

-- Toggle State
local minimized = false

-- Minimize Button Functionality
minimizeButton.MouseButton1Click:Connect(function()
    if minimized then
        sidebarFrame.Visible = true
        bodyFrame.Visible = true
        mainFrame.Size = UDim2.new(0, 600, 0, 400)
        minimized = false
    else
        sidebarFrame.Visible = false
        bodyFrame.Visible = false
        mainFrame.Size = UDim2.new(0, 250, 0, 50)
        minimized = true
    end
end)

-- Close Button Functionality
closeButton.MouseButton1Click:Connect(function()
    yteamGUI:Destroy()
end)

-- Sidebar Button Functionality
homeButton.MouseButton1Click:Connect(function()
    homeFrame.Visible = true
    visualFrame.Visible = false
    noClipFrame.Visible = false
end)

visualButton.MouseButton1Click:Connect(function()
    homeFrame.Visible = false
    visualFrame.Visible = true
    noClipFrame.Visible = false
end)

noClipButton.MouseButton1Click:Connect(function()
    homeFrame.Visible = false
    visualFrame.Visible = false
    noClipFrame.Visible = true
end)

-- Define kingdom colors
local kingdomColors = {
    Red = Color3.fromRGB(255, 0, 0),
    Orange = Color3.fromRGB(255, 165, 0),
    Yellow = Color3.fromRGB(255, 255, 0),
    Pink = Color3.fromRGB(255, 192, 203),
    DarkGreen = Color3.fromRGB(0, 100, 0),
    LightGreen = Color3.fromRGB(144, 238, 144),
    DarkBlue = Color3.fromRGB(0, 0, 139),
    LightBlue = Color3.fromRGB(173, 216, 230),
    Purple = Color3.fromRGB(128, 0, 128),
    Violet = Color3.fromRGB(238, 130, 238),
    Brown = Color3.fromRGB(139, 69, 19),
    White = Color3.fromRGB(255, 255, 255),
    Gray = Color3.fromRGB(128, 128, 128),
    Black = Color3.fromRGB(0, 0, 0),
    LightGray = Color3.fromRGB(211, 211, 211) -- Default color for unknown kingdoms
}

-- Function to get the color based on player team or custom property
local function getPlayerColor(player)
    -- Assuming player has a custom attribute 'KingdomColor'
    local kingdomColor = player:FindFirstChild("KingdomColor")
    if kingdomColor and kingdomColors[kingdomColor.Value] then
        return kingdomColors[kingdomColor.Value]
    end
    -- Fallback to default color if not set
    return kingdomColors.LightGray
end

-- Function to create a beam between two points
local function createBeam(startPoint, endPoint)
    local beam = Instance.new("Beam")
    beam.Parent = game.Workspace
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
    beam.Width0 = 0.2
    beam.Width1 = 0.2
    beam.Attachment0 = Instance.new("Attachment")
    beam.Attachment0.Parent = startPoint
    beam.Attachment0.Position = Vector3.new(0, 0, 0)
    beam.Attachment1 = Instance.new("Attachment")
    beam.Attachment1.Parent = endPoint
    beam.Attachment1.Position = Vector3.new(0, 0, 0)
    return beam
end

-- Update ESP Button Functionality
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        espButton.Text = "Disable ESP"
    else
        espButton.Text = "Enable ESP"
    end
    -- Update ESP functionality
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local espFrame = player.Character.HumanoidRootPart:FindFirstChild(player.Name .. "_ESP")
            if espEnabled then
                if not espFrame then
                    espFrame = Instance.new("BillboardGui")
                    espFrame.Name = player.Name .. "_ESP"
                    espFrame.Parent = player.Character.HumanoidRootPart
                    espFrame.Size = UDim2.new(0, 200, 0, 50)
                    espFrame.StudsOffset = Vector3.new(0, 3, 0)
                    espFrame.AlwaysOnTop = true

                    local infoLabel = Instance.new("TextLabel")
                    infoLabel.Name = "InfoLabel"
                    infoLabel.Parent = espFrame
                    infoLabel.BackgroundTransparency = 1
                    infoLabel.Size = UDim2.new(1, 0, 1, 0)
                    infoLabel.Position = UDim2.new(0, 0, 0, 0)
                    infoLabel.Font = Enum.Font.SourceSansBold

                    -- Set initial text and color
                    local color = getPlayerColor(player)
                    infoLabel.Text = player.Name .. ": " .. math.floor(player.Character.Humanoid.Health)
                    infoLabel.TextColor3 = color
                    infoLabel.TextSize = 20
                    infoLabel.TextStrokeTransparency = 0.5
                    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

                    -- Create marker on the body
                    local marker = Instance.new("Part")
                    marker.Name = player.Name .. "_Marker"
                    marker.Parent = player.Character
                    marker.Size = Vector3.new(1, 1, 1) -- Small size for the dot
                    marker.Position = player.Character.PrimaryPart.Position + Vector3.new(0, 3, 0)
                    marker.BrickColor = BrickColor.new("Bright red")
                    marker.Anchored = true
                    marker.CanCollide = false
                    marker.Transparency = 0.5
                    marker.Material = Enum.Material.SmoothPlastic

                    -- Create beam for each player
                    local beam = createBeam(game.Players.LocalPlayer.Character.HumanoidRootPart,
                        player.Character.HumanoidRootPart)

                    -- Update health continuously
                    player.Character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
                        infoLabel.Text = player.Name .. ": " .. math.floor(player.Character.Humanoid.Health)
                    end)
                end
            else
                if espFrame then
                    espFrame:Destroy()
                end

                local marker = player.Character:FindFirstChild(player.Name .. "_Marker")
                if marker then
                    marker:Destroy()
                end

                local beam = game.Workspace:FindFirstChild(player.Name .. "_Beam")
                if beam then
                    beam:Destroy()
                end
            end
        end
    end
end)

-- Constant Morning Environment
local lighting = game:GetService("Lighting")
lighting.TimeOfDay = "07:00:00"
lighting:GetPropertyChangedSignal("TimeOfDay"):Connect(function()
    lighting.TimeOfDay = "12:00:00"
end)

-- Fungsi untuk mengubah kecepatan secara bertahap
local function setSpeed(targetSpeed)
    local currentSpeed = humanoid.WalkSpeed
    local speedChangeStep = (targetSpeed - currentSpeed) * speedChangeRate

    while math.abs(currentSpeed - targetSpeed) > 0.1 do
        currentSpeed = currentSpeed + speedChangeStep
        humanoid.WalkSpeed = math.clamp(currentSpeed, 0, fastSpeed)
        RunService.RenderStepped:Wait()
    end

    humanoid.WalkSpeed = targetSpeed
end
local function toggleSpeed()
    speedActive = not speedActive
    setSpeed(speedActive and fastSpeed or normalSpeed)
end
-- Fungsi tombol kecepatan
speedButton.MouseButton1Click:Connect(function()
    toggleSpeed()
    speedButton.Text = speedActive and "Disable Speed" or "Enable Speed"
end)

-- Fungsi anti-deteksi: memastikan kecepatan konsisten
local function antiDetectionSpeed()
    while true do
        if humanoid then
            humanoid.WalkSpeed = speedActive and fastSpeed or normalSpeed
        end
        RunService.RenderStepped:Wait()
    end
end

-- Mulai loop anti-deteksi
RunService.Heartbeat:Connect(function()
    antiDetectionSpeed()
end)

-- Inisialisasi kecepatan
setSpeed(normalSpeed)
