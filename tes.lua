local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local ESPButton = Instance.new("TextButton")
local SpeedButton = Instance.new("TextButton")
local KillAuraButton = Instance.new("TextButton")
local GodModeButton = Instance.new("TextButton")

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

GodModeButton.Parent = MainFrame
GodModeButton.Text = "Toggle God Mode"
GodModeButton.Size = UDim2.new(0, 100, 0, 50)
GodModeButton.Position = UDim2.new(0.5, -50, 0.5, 50)

local espEnabled = false
local speedEnabled = false
local killAuraEnabled = false
local godModeEnabled = false

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
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50 -- Kecepatan lari cepat yang aman
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
        -- Aktifkan Kill Aura
        spawn(function()
            while killAuraEnabled do
                wait(0.1) -- Tunggu 0.1 detik sebelum iterasi berikutnya
                for _, enemy in pairs(game.Players:GetPlayers()) do
                    if enemy ~= game.Players.LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (enemy.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                        if distance <= 10 then -- Jarak hitungan
                            -- Kurangi health musuh secara nyata
                            local humanoid = enemy.Character:FindFirstChild("Humanoid")
                            if humanoid then
                                humanoid.Health = humanoid.Health - 25 -- Beri damage 25
                                if humanoid.Health <= 0 then
                                    humanoid:TakeDamage(humanoid.Health) -- Pastikan musuh mati jika health <= 0
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)

-- Fungsi untuk mengaktifkan/menonaktifkan god mode
GodModeButton.MouseButton1Click:Connect(function()
    godModeEnabled = not godModeEnabled
    if godModeEnabled then
        GodModeButton.Text = "God Mode: ON"
        -- Tambahkan kode god mode di sini
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
    else
        GodModeButton.Text = "God Mode: OFF"
        -- Tambahkan kode untuk mematikan god mode di sini
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
    end
end)

-- Otomatis mengaktifkan kill aura saat masuk ke dalam game
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    killAuraEnabled = true
    KillAuraButton.Text = "Kill Aura: ON"
    spawn(function()
        while killAuraEnabled do
            wait(0.1)
            for _, enemy in pairs(game.Players:GetPlayers()) do
                if enemy ~= game.Players.LocalPlayer and enemy.Character and enemy.Character:FindFirstChild("HumanoidRootPart") then
                    local distance = (enemy.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                    if distance <= 10 then
                        local humanoid = enemy.Character:FindFirstChild("Humanoid")
                        if humanoid then
                            humanoid.Health = humanoid.Health - 25
                            if humanoid.Health <= 0 then
                                humanoid:TakeDamage(humanoid.Health)
                            end
                        end
                    end
                end
            end
        end
    end)
end)
