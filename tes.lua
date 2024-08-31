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
MainFrame.Size = UDim2.new(0, 300, 0, 250)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -125)
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
ESPButton.Position = UDim2.new(0.5, -50, 0.5, -75)

SpeedButton.Parent = MainFrame
SpeedButton.Text = "Toggle Speed"
SpeedButton.Size = UDim2.new(0, 100, 0, 50)
SpeedButton.Position = UDim2.new(0.5, -50, 0.5, -25)

KillAuraButton.Parent = MainFrame
KillAuraButton.Text = "Toggle Kill Aura"
KillAuraButton.Size = UDim2.new(0, 100, 0, 50)
KillAuraButton.Position = UDim2.new(0.5, -50, 0.5, 25)

local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false

-- Fungsi untuk menutup GUI
CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Fungsi untuk minimize GUI
MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Fungsi untuk mengaktifkan/menonaktifkan ESP
ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    if espEnabled then
        ESPButton.Text = "ESP: ON"
        -- Tambahkan kode ESP di sini
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
        -- Tambahkan kode untuk mematikan ESP di sini
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character:FindFirstChildOfClass("Highlight") then
                player.Character:FindFirstChildOfClass("Highlight"):Destroy()
            end
        end
    end
end)

-- Fungsi untuk mengaktifkan/menonaktifkan lari cepat
SpeedButton.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        SpeedButton.Text = "Speed: ON"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 100 -- Kecepatan lari cepat
    else
        SpeedButton.Text = "Speed: OFF"
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Kecepatan normal
    end
end)

-- Fungsi untuk mengaktifkan/menonaktifkan kill aura
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        KillAuraButton.Text = "Kill Aura: ON"
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)

-- Fungsi teleportasi dan kill aura dengan randomisasi dan throttle
local lastExecution = tick()

game:GetService("RunService").Stepped:Connect(function()
    if killAuraEnabled and (tick() - lastExecution) > math.random(0.1, 0.5) then
        lastExecution = tick()
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < 100 then -- Jarak deteksi musuh
                    -- Teleportasi ke musuh
                    local targetPosition = player.Character.HumanoidRootPart.Position
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition.X, targetPosition.Y + 50, targetPosition.Z) -- Terbang di atas musuh
                    wait(0.1) -- Tunggu sebentar sebelum turun
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(targetPosition.X, targetPosition.Y - 5, targetPosition.Z) -- Muncul dari bawah
                    wait(math.random(0.1, 0.3)) -- Tunggu sebentar sebelum mengaktifkan kill aura
                    player.Character.Humanoid.Health = 0 -- Mengalahkan musuh
                end
            end
        end
    end
end)
