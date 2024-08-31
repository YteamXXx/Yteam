-- Membuat GUI
local ScreenGui = Instance.new("ScreenGui")
local KillAuraButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
KillAuraButton.Parent = ScreenGui

KillAuraButton.Text = "Toggle Kill Aura"
KillAuraButton.Size = UDim2.new(0, 200, 0, 50)
KillAuraButton.Position = UDim2.new(0.5, -100, 0.5, -25)

local killAuraEnabled = false

-- Fungsi untuk mengaktifkan/menonaktifkan kill aura
KillAuraButton.MouseButton1Click:Connect(function()
    killAuraEnabled = not killAuraEnabled
    if killAuraEnabled then
        KillAuraButton.Text = "Kill Aura: ON"
    else
        KillAuraButton.Text = "Kill Aura: OFF"
    end
end)

-- Fungsi teleportasi dan kill aura
game:GetService("RunService").Stepped:Connect(function()
    if killAuraEnabled then
        for _, player in pairs(game.Players:GetPlayers()) do
            if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                local distance = (player.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude
                if distance < 50 then -- Jarak deteksi musuh
                    -- Teleportasi ke musuh
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) -- Terbang di atas musuh
                    wait(0.1) -- Tunggu sebentar sebelum mengaktifkan kill aura
                    player.Character.Humanoid.Health = 0
                end
            end
        end
    end
end)
