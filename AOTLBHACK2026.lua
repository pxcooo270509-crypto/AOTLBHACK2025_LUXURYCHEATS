-- KEY SYSTEM LUXURY - Versión FINAL para Solara V3 (persistencia con ReplicatedStorage)
local CorrectKey = "LUXURY-AOT:LB"

-- Marcador de validación en PlayerGui (sobrevive SIEMPRE al cambiar de misión)
local function getValidationMarker()
    local player = game.Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")
    local marker = playerGui:FindFirstChild("LUXURY_KEY_VALIDATED")
    if not marker then
        marker = Instance.new("BoolValue")
        marker.Name = "LUXURY_KEY_VALIDATED"
        marker.Value = false
        marker.Parent = playerGui
    end
    return marker
end

local validationMarker = getValidationMarker()

-- Si ya está validada, saltamos todo el key system
if validationMarker.Value then
    print("Key validada detectada (PlayerGui) - Auto Farm cargado automáticamente")
else
    -- === KEY SYSTEM COMPLETO ===
    local sg = Instance.new("ScreenGui", game.CoreGui)
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0,400,0,200)
    frame.Position = UDim2.new(0.5,-200,0.5,-100)
    frame.BackgroundColor3 = Color3.fromRGB(30,30,40)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1,0,0,30)
    title.Text = "LUXURY CHEATS KEY"
    title.TextColor3 = Color3.fromRGB(255,255,100)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBlack
    title.BackgroundTransparency = 1

    local statusLabel = Instance.new("TextLabel", frame)
    statusLabel.Size = UDim2.new(0.9, 0, 0, 40)
    statusLabel.Position = UDim2.new(0.05, 0, 0.16, 0)
    statusLabel.Text = ""
    statusLabel.TextColor3 = Color3.fromRGB(255, 255, 120)
    statusLabel.TextScaled = true
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamBlack

    local box = Instance.new("TextBox", frame)
    box.Size = UDim2.new(0.8,0,0,50)
    box.Position = UDim2.new(0.1,0,0.4,0)
    box.PlaceholderText = "Pega tu key aquí"
    box.TextColor3 = Color3.new(1,1,1)
    box.BackgroundColor3 = Color3.fromRGB(50,50,60)
    Instance.new("UICorner", box)

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.8,0,0,50)
    btn.Position = UDim2.new(0.1,0,0.7,0)
    btn.Text = "VERIFY KEY"
    btn.BackgroundColor3 = Color3.fromRGB(40,200,40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBlack
    btn.Visible = false
    Instance.new("UICorner", btn)

    local CopyLinkButton = Instance.new("TextButton", frame)
    CopyLinkButton.Size = UDim2.new(0.8,0,0,50)
    CopyLinkButton.Position = UDim2.new(0.1,0,0.7,0)
    CopyLinkButton.Text = "KEY LINK!"
    CopyLinkButton.TextColor3 = Color3.new(1,1,1)
    CopyLinkButton.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    CopyLinkButton.Font = Enum.Font.GothamBold
    CopyLinkButton.TextScaled = true
    Instance.new("UICorner", CopyLinkButton).CornerRadius = UDim.new(0, 12)

    local TuLinkWorkInk = "https://work.ink/2bOb/autofarm-inmortal-aotlastbreath-roblox-2026"

    CopyLinkButton.MouseButton1Click:Connect(function()
        setclipboard(TuLinkWorkInk)
        CopyLinkButton.Text = "¡COPIADO!"
        CopyLinkButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        statusLabel.Text = "PEGA EL LINK COPIADO EN TU NAVEGADOR Y COMPLETA WORK.INK PARA OBTENER LA KEY"
        task.wait(12)
        CopyLinkButton.Visible = false
        btn.Visible = true
    end)

    btn.MouseButton1Click:Connect(function()
        if box.Text == CorrectKey then
            validationMarker.Value = true
            sg:Destroy()
            print("Key correcta - Validación guardada permanentemente")
        else
            box.PlaceholderText = "Incorrect Key"
            box.Text = ""
        end
    end)

    -- Espera hasta que valide
    repeat task.wait() until validationMarker.Value
end

-- ==== AUTOFARM (se carga siempre después de validar) ====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- INMORTALIDAD
local immortalConnections = {}
local function enableImmortal()
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    humanoid.BreakJointsOnDeath = false
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    humanoid.MaxHealth = math.huge
    humanoid.Health = humanoid.MaxHealth
    table.insert(immortalConnections, humanoid.HealthChanged:Connect(function(hp)
        if hp <= 0 then humanoid.Health = humanoid.MaxHealth end
    end))
    table.insert(immortalConnections, humanoid.StateChanged:Connect(function(_, state)
        if state == Enum.HumanoidStateType.Dead then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            humanoid.Health = humanoid.MaxHealth
        end
    end))
end

local function disableImmortal()
    for _, c in ipairs(immortalConnections) do pcall(function() c:Disconnect() end) end
    immortalConnections = {}
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        local humanoid = char.Humanoid
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        humanoid.MaxHealth = 100
        humanoid.Health = math.clamp(humanoid.Health, 1, 100)
    end
end

local function getRoot()
    local char = player.Character or player.CharacterAdded:Wait()
    return char:WaitForChild("HumanoidRootPart")
end

-- GUI DEL AUTOFARM
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AutoFarmAOTLBv1"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local UserInputService = game:GetService("UserInputService")
local guiVisible = true
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.Insert then
        guiVisible = not guiVisible
        screenGui.Enabled = guiVisible
    end
end)

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 270)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(255,80,80)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.Text = "AUTO FARM AOTLB v1"
title.TextColor3 = Color3.fromRGB(255,255,120)
title.TextScaled = true
title.Font = Enum.Font.GothamBlack
title.BackgroundTransparency = 1

local byLabel = Instance.new("TextLabel", frame)
byLabel.Size = UDim2.new(1,0,0,25)
byLabel.Position = UDim2.new(0,0,0,50)
byLabel.Text = "By LUXURY CHEATS"
byLabel.TextColor3 = Color3.fromRGB(255,100,100)
byLabel.TextScaled = true
byLabel.Font = Enum.Font.GothamBold
byLabel.BackgroundTransparency = 1

local giantBtn = Instance.new("TextButton", frame)
giantBtn.Size = UDim2.new(1,-40,0,50)
giantBtn.Position = UDim2.new(0,20,0,80)
giantBtn.Text = "GIANT NAPE OFF"
giantBtn.BackgroundColor3 = Color3.fromRGB(200,40,40)
Instance.new("UICorner", giantBtn).CornerRadius = UDim.new(0,12)

local autoBtn = Instance.new("TextButton", frame)
autoBtn.Size = UDim2.new(1,-40,0,50)
autoBtn.Position = UDim2.new(0,20,0,140)
autoBtn.Text = "AUTO FARM OFF"
autoBtn.BackgroundColor3 = Color3.fromRGB(40,140,200)
Instance.new("UICorner", autoBtn).CornerRadius = UDim.new(0,12)

local status = Instance.new("TextLabel", frame)
status.Size = UDim2.new(1,-40,0,50)
status.Position = UDim2.new(0,20,1,-60)
status.Text = "Success"
status.TextColor3 = Color3.fromRGB(200,200,200)
status.TextScaled = true
status.BackgroundTransparency = 1

-- DRAGGABLE
local dragging, dragInput, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
frame.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- VARIABLES Y SETUP
local giantOn = false
local autoOn = false
local currentTarget = nil
local antiFallConnection = nil
local autoAttackActive = false
local autoKey1 = false
local key1Delay = 0.10
local cooldownConnection = nil

task.wait(5)
status.Text = "Loading...."
local titansFolder = Workspace:WaitForChild("Titans", 10)
if not titansFolder then status.Text = "[-] UNDETECTED TITANS" return end
status.Text = "[+] TITANS DETECTED | AUTO FARM READY"

local function isAlive(model)
    local main = model:FindFirstChild("Main")
    if not main then return false end
    local died = main:FindFirstChild("Died")
    return died and died:IsA("BoolValue") and not died.Value
end

local function startZeroCooldown()
    if cooldownConnection then return end
    cooldownConnection = RunService.Heartbeat:Connect(function()
        local rs = game:GetService("ReplicatedStorage")
        local moves = rs:FindFirstChild("Moves")
        if not moves then return end
        local ankle = moves:FindFirstChild("Ankle Cut")
        if not ankle then return end
        local cd = ankle:FindFirstChild("cooldown")
        if cd and cd.Value ~= 0 then cd.Value = 0 end
    end)
end

local function stopZeroCooldown()
    if cooldownConnection then cooldownConnection:Disconnect() cooldownConnection = nil end
end

task.spawn(function()
    while true do
        task.wait(key1Delay)
        if autoKey1 then
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.One, false, game)
            task.wait(0.005)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.One, false, game)
        end
    end
end)

-- GIANT NAPE FUNCTIONS
local function makeGiant()
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if titan:IsA("Model") then
            local nape = titan:FindFirstChild("Nape")
            if nape then
                nape.Size = Vector3.new(15,10,60)
                nape.Material = Enum.Material.Neon
                nape.Color = Color3.fromRGB(255,50,50)
                nape.Transparency = 0
                nape.Anchored = false
                nape.CanCollide = false
            end
        end
    end
end

local function modifyCrawlerNape()
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if titan.Name == "CrawlerTitan" then
            local nape = titan:FindFirstChild("Nape")
            if nape then
                nape.Size = Vector3.new(20, 50, 80)
                nape.Transparency = 0
                nape.Anchored = false
                nape.CanCollide = false
            end
        end
    end
end

local function modifyCrawlerGodNape()
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if titan.Name == "CrawlerGodTitan" then
            local nape = titan:FindFirstChild("Nape")
            if nape then
                nape.Size = Vector3.new(10, 10, 60)
                nape.Transparency = 0
                nape.CanCollide = false
            end
        end
    end
end

local function modifyAbnormalGodNape()
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if titan.Name == "AbnormalGodTitan" then
            local nape = titan:FindFirstChild("Nape")
            if nape then
                nape.Size = Vector3.new(30, 50, 60)
                nape.Transparency = 1
                nape.CanCollide = false
            end
        end
    end
end

giantBtn.Activated:Connect(function()
    giantOn = not giantOn
    giantBtn.Text = giantOn and "GIANT NAPE ON" or "GIANT NAPE OFF"
    giantBtn.BackgroundColor3 = giantOn and Color3.fromRGB(40,200,40) or Color3.fromRGB(200,40,40)
    if giantOn then
        makeGiant()
        modifyCrawlerNape()
        modifyCrawlerGodNape()
        modifyAbnormalGodNape()
        task.spawn(function()
            while giantOn do
                makeGiant()
                modifyCrawlerNape()
                modifyCrawlerGodNape()
                modifyAbnormalGodNape()
                task.wait(0.5)
            end
        end)
    end
end)

-- ANTIFALL & AUTOATTACK
local function enableAntiFall()
    if antiFallConnection then antiFallConnection:Disconnect() end
    antiFallConnection = RunService.Heartbeat:Connect(function()
        if currentTarget and currentTarget.Parent and isAlive(currentTarget) then
            local nape = currentTarget:FindFirstChild("Nape")
            local root = getRoot()
            if nape and root then
                local back = nape.CFrame.LookVector * -22
                local safePos = nape.Position + back + Vector3.new(0, 1, 0)
                root.CFrame = CFrame.new(safePos, nape.Position)
            end
        end
    end)
end

local function disableAntiFall()
    if antiFallConnection then antiFallConnection:Disconnect() antiFallConnection = nil end
end

task.spawn(function()
    while true do
        task.wait(0.035)
        if autoAttackActive and currentTarget and currentTarget.Parent and isAlive(currentTarget) then
            VirtualInputManager:SendMouseButtonEvent(0,0,0,true,game,0)
            task.wait(0.02)
            VirtualInputManager:SendMouseButtonEvent(0,0,0,false,game,0)
        end
    end
end)

local function startAutoAttack() autoAttackActive = true end
local function stopAutoAttack() autoAttackActive = false end

local function tpTo(nape)
    local root = getRoot()
    if not root or not nape then return end
    local back = nape.CFrame.LookVector * -22
    local pos = nape.Position + back + Vector3.new(0,1,0)
    TweenService:Create(root, TweenInfo.new(0.05), {CFrame = CFrame.new(pos, nape.Position)}):Play()
    task.wait(0.05)
    enableAntiFall()
    startAutoAttack()
end

local function findNextTarget()
    local root = getRoot()
    if not root then return nil end
    local best, bestDist = nil, math.huge
    for _, titan in ipairs(titansFolder:GetChildren()) do
        if titan:IsA("Model") and isAlive(titan) then
            local nape = titan:FindFirstChild("Nape")
            if nape then
                local dist = (root.Position - nape.Position).Magnitude
                if dist < bestDist then
                    bestDist = dist
                    best = titan
                end
            end
        end
    end
    return best
end

task.spawn(function()
    while true do
        task.wait(0.20)
        if not autoOn then disableAntiFall() stopAutoAttack() continue end
        if not currentTarget or not currentTarget.Parent or not isAlive(currentTarget) then
            stopAutoAttack()
            currentTarget = findNextTarget()
            if currentTarget then
                local nape = currentTarget:FindFirstChild("Nape")
                if nape then
                    status.Text = "Farming → " .. currentTarget.Name
                    tpTo(nape)
                end
            else
                status.Text = "All dead | Waiting for new ones..."
                disableAntiFall()
            end
        end
    end
end)

titansFolder.ChildAdded:Connect(function(titan)
    task.spawn(function()
        local main = titan:WaitForChild("Main", 8)
        if main then
            local died = main:WaitForChild("Died", 8)
            if died then
                died:GetPropertyChangedSignal("Value"):Connect(function()
                    if died.Value and currentTarget == titan then
                        status.Text = titan.Name .. " muerto → Siguiente!"
                        currentTarget = nil
                        stopAutoAttack()
                    end
                end)
            end
        end
    end)
end)

autoBtn.Activated:Connect(function()
    autoOn = not autoOn
    autoBtn.Text = autoOn and "AUTO FARM ON" or "AUTO FARM OFF"
    autoBtn.BackgroundColor3 = autoOn and Color3.fromRGB(40,200,40) or Color3.fromRGB(40,140,200)
    if autoOn then
        enableImmortal()
        startZeroCooldown()
        autoKey1 = true
        status.Text = "AUTO FARM ON - Fast TP + Automatic Cut-Off"
        currentTarget = nil
        for _, titan in ipairs(titansFolder:GetChildren()) do
            if titan:IsA("Model") then
                local parts = {"RightHand","LeftHand","LowerMouth","LeftFoot","RightFoot","LowerTeeth"}
                for _, p in ipairs(parts) do
                    local part = titan:FindFirstChild(p)
                    if part then part:Destroy() end
                end
            end
        end
    else
        status.Text = "Auto Farm OFF"
        currentTarget = nil
        disableAntiFall()
        stopAutoAttack()
        autoKey1 = false
        stopZeroCooldown()
    end
end)

titansFolder.ChildAdded:Connect(function(titan)
    if autoOn and titan:IsA("Model") then
        task.wait(0.5)
        local parts = {"RightHand","LeftHand","LowerMouth","LeftFoot","RightFoot","LowerTeeth"}
        for _, p in ipairs(parts) do
            local part = titan:FindFirstChild(p)
            if part then part:Destroy() end
        end
    end
end)

print("AUTO FARM AOTLB v1 by LUXURY CHEATS - CARGADO Y ROMPIENDO TODO")
