-- Ambil modul dan remote dari URL yang diberikan
local HttpService = game:GetService("HttpService")
local GetRemotesURL = "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Get_Remotes"
local RetrieveRemotesURL = "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Retrive_Remotes"
local ReturnRemotesURL = "https://raw.githubusercontent.com/YteamXXx/Yteam/main/Return_Remotes"

local function fetchScript(url)
    local success, response = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        return loadstring(response)()
    else
        warn("Failed to fetch script from URL:", url)
    end
end

local GetRemotes = fetchScript(GetRemotesURL)
local RetrieveRemotes = fetchScript(RetrieveRemotesURL)
local ReturnRemotes = fetchScript(ReturnRemotesURL)

-- GUI sederhana
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KillAuraGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
frame.Parent = screenGui

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 60, 0, 30)
minimizeButton.Position = UDim2.new(0, 0, 0, 0)
minimizeButton.Text = "_"
minimizeButton.Parent = frame
minimizeButton.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 60, 0, 30)
closeButton.Position = UDim2.new(0, 140, 0, 0)
closeButton.Text = "X"
closeButton.Parent = frame
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Kill Aura
local function applyKillAura()
    local function getRemoteFunctions()
        local remotes = {}
        local gc = getgc(true)
        for _, v in ipairs(gc) do
            if type(v) == "table" then
                for _, v2 in pairs(v) do
                    if type(v2) == "function" then
                        local consts, upvalues = getFiOneConstants(v2)
                        if consts and (table.find(consts, "FireServer") or table.find(consts, "InvokeServer")) then
                            local remote = findInFiOne(upvalues, "Instance")
                            if remote then
                                local shallowTable = shallowClone(v)
                                shallowTable.FireServer = v2
                                table.remove(shallowTable, table.find(shallowTable, v2))
                                remotes[tostring(remote)] = shallowTable
                            end
                        end
                    end
                end
            end
        end
        return remotes
    end

    local remotes = getRemoteFunctions()

    local function killAuraFunction()
        local function callRemote(remote, params)
            local remoteTable = remotes[tostring(remote)]
            if remoteTable then
                local fireServerFunction = remoteTable.FireServer
                if fireServerFunction then
                    fireServerFunction(remoteTable, table.unpack(params))
                end
            end
        end

        local function onPlayerHit(targetPlayer)
            local targetCharacter = targetPlayer.Character
            if targetCharacter then
                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    -- Example of how to apply damage to the target character
                    humanoid:TakeDamage(humanoid.Health)
                end
            end
        end

        -- Set up your kill aura parameters and trigger the function
        -- Example: Trigger kill aura on all players within a certain range
        local players = game:GetService("Players"):GetPlayers()
        for _, player in pairs(players) do
            if player ~= game.Players.LocalPlayer then
                onPlayerHit(player)
            end
        end
    end

    -- Call kill aura function
    killAuraFunction()
end

applyKillAura()
