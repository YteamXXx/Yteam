-- Layanan yang diperlukan
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Mengatur kecepatan berjalan
local walkSpeed = 70 -- Kecepatan yang sangat tinggi

RunService.RenderStepped:Connect(function()
    humanoid.WalkSpeed = walkSpeed
end)

-- Kill Aura Setup
local function getRemote()
    return game:GetService("ReplicatedStorage").remoteInterface.interactions.meleeAI
end

local function attackNearbyEnemies(radius)
    local remote = getRemote()
    local position = character.HumanoidRootPart.Position

    for _, object in pairs(workspace:FindPartsInRegion3(Region3.new(position - Vector3.new(radius, radius, radius), position + Vector3.new(radius, radius, radius)), nil, math.huge)) do
        if object:IsA("Model") and object:FindFirstChild("Humanoid") and object.Humanoid.Health > 0 then
            -- Memanggil fungsi remote untuk menyerang
            remote:FireServer(object)
        end
    end
end

local killAuraActive = false

-- Menyusun fungsi toggle untuk Kill Aura
local function toggleKillAura()
    killAuraActive = not killAuraActive
    if killAuraActive then
        while killAuraActive do
            attackNearbyEnemies(20) -- Radius serangan
            wait(1) -- Interval antara serangan
        end
    end
end

-- Membuat tombol Kill Aura di GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local killAuraButton = Instance.new("TextButton", screenGui)
killAuraButton.Size = UDim2.new(0, 150, 0, 50)
killAuraButton.Position = UDim2.new(0.5, -75, 0, 200)
killAuraButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
killAuraButton.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraButton.Text = "Toggle Kill Aura"
killAuraButton.TextSize = 20

killAuraButton.MouseButton1Click:Connect(toggleKillAura)

-- Menangani sistem dari skrip raw
local function setupFiOne()
    local FiOne = {}
    FiOne.getfuncinfo = function(fn)
        assert(debug.info(fn, 'n') == 'wrapped', 'FiOne closure expected')
        local upvals = debug.getupvalues(fn)
        if type(upvals) == 'table' then
            return rawget(upvals, 1)
        end
    end

    FiOne.getconstants = function(fn)
        assert(debug.info(fn, 'n') == 'wrapped', 'FiOne closure expected')
        local funcinfo = FiOne.getfuncinfo(fn)
        return funcinfo and rawget(funcinfo, 'const')
    end

    FiOne.getupvalues = function(fn)
        assert(debug.info(fn, 'n') == 'wrapped', 'FiOne closure expected')
        local upvals = debug.getupvalues(fn)
        local funcinfo = FiOne.getfuncinfo(fn)
        local upval_list = upvals[4]
        local num_upval = funcinfo.num_upval

        local true_upvals = {}
        for i = 1, num_upval do
            local t = upval_list[i - 1]
            local store = rawget(t, 'store')
            local index = rawget(t, 'index')
            table.insert(true_upvals, rawget(store, index))
        end

        return true_upvals
    end

    do
        local ClientScript = player.PlayerGui:WaitForChild('client'):WaitForChild('client')
        local ClientScriptEnvironment = getsenv(ClientScript)
        local hitFunction

        for _, v in FiOne.getupvalues(ClientScriptEnvironment.scanForHit) do
            if type(v) == 'function' and table.find(FiOne.getconstants(v), 'hitAt') then
                hitFunction = v
                break
            end
        end

        local hitFunctionsUpvalues = FiOne.getupvalues(hitFunction)
        local hitFunctionsConstants = FiOne.getconstants(hitFunction)

        local fireServerFunctionName
        local remote_tables = {}

        local ignoreList = {
            'GetClientModelFromServerModel',
            'GetServerModelFromClientModel',
        }

        for i, v in pairs(hitFunctionsUpvalues) do
            if typeof(v) ~= "table" then
                continue
            end

            for i2, v2 in v do
                if table.find(ignoreList, i2) then
                    continue
                end

                if table.find(hitFunctionsConstants, i2) then
                    fireServerFunctionName = i2
                    table.insert(remote_tables, v)
                end
            end
        end

        local slotIdentifier = newproxy()
        local cfIdentitier = CFrame.identity

        local traceableArguments = {
            meleePlayer = {itemsModule.ITEM_TYPES.MELEE_WEAPON, slotIdentifier, {}, {hitObject = player, hitCF = cfIdentitier}},
            hitStructure = {itemsModule.ITEM_TYPES.MELEE_WEAPON, slotIdentifier, {}, {hitObject = game.Workspace.placedStructures:FindFirstChildWhichIsA('Model', true), hitCF = cfIdentitier}},
            chop = {itemsModule.ITEM_TYPES.AXE, slotIdentifier, {}, {hitObject = game.Workspace.worldResources.choppable:FindFirstChildWhichIsA('Model', true), hitCF = cfIdentitier}},
            mine = {itemsModule.ITEM_TYPES.PICKAXE, slotIdentifier, {}, {hitObject = game.Workspace.worldResources.mineable:FindFirstChildWhichIsA('Model', true), hitCF = cfIdentitier}},
        }

        local argumentOrders = {}
        local remotes = {}
        local currentRemote = nil
        local restoreFunctions = {}

        for i, v in remote_tables do
            local old = v[fireServerFunctionName]
            v[fireServerFunctionName] = function(self, ...)
                if (not remotes[currentRemote]) then
                    remotes[currentRemote] = v

                    local argumentOrder = {}
                    local args = {...}
                    argumentOrder.slot = table.find(args, slotIdentifier)
                    argumentOrder.instance = table.find(args, traceableArguments[currentRemote][4].hitObject)
                    argumentOrder.cframe = table.find(args, cfIdentitier)

                    argumentOrders[currentRemote] = argumentOrder
                    return
                end

                return old(self, ...)
            end

            table.insert(restoreFunctions, function() v[fireServerFunctionName] = old end)
        end

        for i, v in traceableArguments do
            currentRemote = i
            hitFunction(table.unpack(v))
        end

        for i, v in restoreFunctions do
            v()
        end

        getgenv().callRemote = function(remote, params)
            local argumentOrder = argumentOrders[remote]
            local realArguments = {}

            for i, v in argumentOrder do
                realArguments[v] = params[i]
            end

            remotes[remote][fireServerFunctionName](remotes[remote], table.unpack(realArguments))
        end
    end

    getgenv().remotes = {
        meleeAI = game:GetService("ReplicatedStorage").remoteInterface.interactions.meleeAI,
        take = game:GetService("ReplicatedStorage").remoteInterface.inventory.take,
        pickupItem = game:GetService("ReplicatedStorage").remoteInterface.inventory.pickupItem,
        plant = game:GetService("ReplicatedStorage").remoteInterface.interactions.plant,
        harvest = game:GetService("ReplicatedStorage").remoteInterface.interactions.harvest,
        eat = game:GetService("ReplicatedStorage").remoteInterface.interactions.eat,
        build = game:GetService("ReplicatedStorage").remoteInterface.interactions.build,
        deleteStructure = game:GetService("ReplicatedStorage").remoteInterface.interactions.deleteStructure
    }

    for i, v in pairs(player.PlayerGui.client.client:GetChildren()) do
        if i == 2 then
            v.Name = "meleePlayer"
        elseif i == 4 then
            v.Name = "chop"
        elseif i == 5 then
            v.Name = "mine"
        elseif i == 6 then
            v.Name = "hitStructure"
        end
    end

    function getFunctionName(Function)
        return debug.getinfo and debug.getinfo(Function).name or debug.info and debug.info(Function, "n")
    end

    function shallowClone(Table)
        local newTable = {}

        if not Table then
            return
        end

        for i, v in pairs(Table) do
            newTable[i] = v
        end

        return newTable
    end

    function getFiOneConstants(Function)
        local upvalues = debug.getupvalues(Function)
        local upvalue = upvalues[1]

        if type(upvalue) == "table" then
            local consts = rawget(upvalue, "const")

            if type(consts) == "table" then
                return consts
            end
        end
    end

    local function callRemote(remote, params)
        local funcInfo = getFiOneConstants(remote)
        local shallowTable = {}
        local remoteValues = {}

        for _, v in pairs(funcInfo) do
            if type(v) == "table" and remoteValues[v] == nil then
                remoteValues[v] = true
                table.insert(shallowTable, v)
            end
        end

        getgenv().callRemote(remote, shallowTable)
    end

    function sendCallRemote(remote, params)
        local funcInfo = getFiOneConstants(remote)
        local shallowTable = {}

        for _, v in pairs(funcInfo) do
            if type(v) == "table" then
                table.insert(shallowTable, v)
            end
        end

        getgenv().callRemote(remote, shallowTable)
    end
end

-- Menyusun tombol Kill Aura di GUI
local screenGui = Instance.new("ScreenGui", player.PlayerGui)
local killAuraButton = Instance.new("TextButton", screenGui)
killAuraButton.Size = U
