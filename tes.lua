-- Load remote scripts
local function loadRemoteScripts()
    local remoteScripts = {
        "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes",
        "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes",
        "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes"
    }

    for _, url in ipairs(remoteScripts) do
        local remoteScript, err = game:HttpGet(url)
        if not remoteScript then
            warn("Error fetching remote script from " .. url .. ": " .. err)
            return
        end

        local func, loadError = loadstring(remoteScript)
        if func then
            func()
        else
            warn("Error loading remote script from " .. url .. ": " .. loadError)
            return
        end
    end
end

loadRemoteScripts()

-- Create GUI elements
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomGUI"
screenGui.Parent = playerGui

-- Button for Kill Aura
local killAuraButton = Instance.new("TextButton")
killAuraButton.Name = "KillAuraButton"
killAuraButton.Parent = screenGui
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 20)
killAuraButton.Size = UDim2.new(0, 150, 0, 50)
killAuraButton.Font = Enum.Font.SourceSans
killAuraButton.Text = "Kill Aura V1"
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.TextSize = 20

-- Button for Speed Toggle
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Parent = screenGui
speedButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedButton.Position = UDim2.new(0.5, -75, 0, 80)
speedButton.Size = UDim2.new(0, 150, 0, 50)
speedButton.Font = Enum.Font.SourceSans
speedButton.Text = "Speed: 70"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextSize = 20

-- Variable to track if Kill Aura is enabled
local killAuraEnabled = false

-- Toggle Kill Aura function
local function toggleKillAura()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        killAuraButton.Text = "Kill Aura: ON"
        activateKillAura() -- Call the Kill Aura function
    else
        killAuraButton.Text = "Kill Aura: OFF"
        -- You might want to add functionality to deactivate Kill Aura here
    end
end

-- Speed Toggle function
local function toggleSpeed()
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if humanoid.WalkSpeed == 70 then
            humanoid.WalkSpeed = 16
            speedButton.Text = "Speed: 16"
        else
            humanoid.WalkSpeed = 70
            speedButton.Text = "Speed: 70"
        end
    end
end

-- Connect buttons to functions
killAuraButton.MouseButton1Click:Connect(toggleKillAura)
speedButton.MouseButton1Click:Connect(toggleSpeed)
