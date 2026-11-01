local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("KhoaDiemHubUltimateV12") then
    CoreGui.KhoaDiemHubUltimateV12:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemHubUltimateV12"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local menuImageIcon = "rbxassetid://6031091000"

local function makeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging, dragInput, dragStart, startPos
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            guiObject.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local mainButton = Instance.new("ImageButton")
mainButton.Name = "HubMenuButton"
mainButton.Size = UDim2.new(0, 48, 0, 48)
mainButton.Position = UDim2.new(0, 20, 0, 20)
mainButton.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
mainButton.BorderSizePixel = 0
mainButton.Image = menuImageIcon
mainButton.ImageColor3 = Color3.fromRGB(0, 220, 255)
mainButton.Parent = ScreenGui

makeDraggable(mainButton)

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = mainButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 220, 255)
btnStroke.Thickness = 2.5
btnStroke.Parent = mainButton

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 560, 0, 380)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 13, 18)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(0, 220, 255)
mainStroke.Thickness = 2
mainStroke.Transparency = 1
mainStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(16, 20, 30)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

makeDraggable(mainFrame, topBar)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 14)
topCorner.Parent = topBar

local topIconImg = Instance.new("ImageLabel")
topIconImg.Size = UDim2.new(0, 22, 0, 22)
topIconImg.Position = UDim2.new(0, 12, 0, 9)
topIconImg.BackgroundTransparency = 1
topIconImg.Image = menuImageIcon
topIconImg.ImageColor3 = Color3.fromRGB(0, 220, 255)
topIconImg.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -100, 1, 0)
titleLabel.Position = UDim2.new(0, 42, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "KhoaDiemHub • Ultimate V12 (Fixed ESP & Aim)"
titleLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
titleLabel.TextSize = 11
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
closeBtn.TextSize = 12
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

mainButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        TweenService:Create(mainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
        task.wait(0.2)
        mainFrame.Visible = false
    else
        mainFrame.Visible = true
        mainFrame.BackgroundTransparency = 1
        mainStroke.Transparency = 1
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.03}):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    end
end)

local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 140, 1, -50)
sidebar.Position = UDim2.new(0, 10, 0, 45)
sidebar.BackgroundColor3 = Color3.fromRGB(13, 16, 24)
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 360)
sidebar.ScrollBarThickness = 2
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 10)
sideCorner.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 4)
sideLayout.Parent = sidebar

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -162, 1, -50)
container.Position = UDim2.new(0, 156, 0, 45)
container.BackgroundTransparency = 1
container.Parent = mainFrame

local function clearContainers()
    for _, child in ipairs(container:GetChildren()) do child.Visible = false end
end

local function createTabContent(name)
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = name .. "Content"
    scroller.Size = UDim2.new(1, 0, 1, 0)
    scroller.BackgroundTransparency = 1
    scroller.CanvasSize = UDim2.new(0, 0, 0, 2600)
    scroller.ScrollBarThickness = 2
    scroller.Visible = false
    scroller.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroller

    return scroller
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 230, 250)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -50, 1, 0)
    label.Position = UDim2.new(0, 8, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 230, 250)
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local indicator = Instance.new("TextButton")
    indicator.Size = UDim2.new(0, 38, 0, 18)
    indicator.Position = UDim2.new(1, -44, 0.5, -9)
    indicator.BackgroundColor3 = state and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 40, 60)
    indicator.BorderSizePixel = 0
    indicator.Text = state and "ON" or "OFF"
    indicator.TextColor3 = state and Color3.fromRGB(10, 13, 18) or Color3.fromRGB(150, 170, 200)
    indicator.TextSize = 9
    indicator.Font = Enum.Font.GothamBold
    indicator.Parent = frame

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 4)
    indCorner.Parent = indicator

    indicator.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(0, 200, 255) or Color3.fromRGB(30, 40, 60)
        indicator.TextColor3 = state and Color3.fromRGB(10, 13, 18) or Color3.fromRGB(150, 170, 200)
        indicator.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 44)
    frame.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -16, 0, 18)
    label.Position = UDim2.new(0, 8, 0, 3)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(210, 230, 250)
    label.TextSize = 10
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -16, 0, 6)
    sliderBg.Position = UDim2.new(0, 8, 0, 28)
    sliderBg.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = sliderFill

    local dragging = false
    local function updateInput(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        value = math.floor(min + ((max - min) * pos))
        sliderFill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. tostring(value)
        callback(value)
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateInput(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateInput(input)
        end
    end)

    return frame
end

local function createDropdown(parent, text, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -8, 0, 32)
    frame.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundTransparency = 1
    btn.Text = text .. ": Chọn..."
    btn.TextColor3 = Color3.fromRGB(210, 230, 250)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Position = UDim2.new(0, 8, 0, 0)
    btn.Parent = frame

    local opened = false
    local optionButtons = {}

    local function refreshOptions()
        for _, b in ipairs(optionButtons) do b:Destroy() end
        optionButtons = {}
        local optList = options()
        for i, optName in ipairs(optList) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -16, 0, 24)
            optBtn.Position = UDim2.new(0, 8, 0, 32 + (i - 1) * 26)
            optBtn.BackgroundColor3 = Color3.fromRGB(25, 33, 48)
            optBtn.BorderSizePixel = 0
            optBtn.Text = optName
            optBtn.TextColor3 = Color3.fromRGB(180, 210, 240)
            optBtn.TextSize = 9
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = frame

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 4)
            optCorner.Parent = optBtn

            optBtn.MouseButton1Click:Connect(function()
                btn.Text = text .. ": " .. optName
                opened = false
                frame.Size = UDim2.new(1, -8, 0, 32)
                callback(optName)
            end)
            table.insert(optionButtons, optBtn)
        end
    end

    btn.MouseButton1Click:Connect(function()
        opened = not opened
        if opened then
            refreshOptions()
            local optList = options()
            frame.Size = UDim2.new(1, -8, 0, 36 + #optList * 26)
        else
            frame.Size = UDim2.new(1, -8, 0, 32)
        end
    end)

    return frame
end

local function createTabButton(name, scroller)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(18, 23, 34)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 205, 235)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        clearContainers()
        scroller.Visible = true
    end)
end

local tabNames = {"1. Di chuyển", "2. AimBot Center", "3. Sky Stand / Bay", "4. ESP Xuyên Tường", "5. TP All Players", "6. Thế giới & Hack", "7. Tiện ích 500+"}
local scrollers = {}

for i, name in ipairs(tabNames) do
    local scroller = createTabContent(name)
    scrollers[i] = scroller
    createTabButton(name, scroller)
end

scrollers[1].Visible = true

local charTab = scrollers[1]
local combatTab = scrollers[2]
local skyTab = scrollers[3]
local espTab = scrollers[4]
local tpAllTab = scrollers[5]
local worldTab = scrollers[6]
local extraTab = scrollers[7]

-- TAB 1: DI CHUYỂN
local walkSpeedEnabled = false
local walkSpeedVal = 16
createToggle(charTab, "Tốc độ chạy siêu tốc", false, function(state)
    walkSpeedEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(charTab, "Mức Tốc Độ", 16, 500, 16, function(val) walkSpeedVal = val end)

local jumpPowerEnabled = false
local jumpPowerVal = 50
createToggle(charTab, "Nhảy cao đặc biệt", false, function(state)
    jumpPowerEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider(charTab, "Mức Độ Nhảy", 50, 800, 50, function(val) jumpPowerVal = val end)

local noclipEnabled = false
createToggle(charTab, "Đi xuyên mọi vật cản (Noclip)", false, function(state) noclipEnabled = state end)

local infJumpEnabled = false
createToggle(charTab, "Nhảy vô hạn trên không", false, function(state) infJumpEnabled = state end)

-- TAB 2: AIMBOT CENTER
local centerAimEnabled = false
local aimPart = "Head"
createToggle(combatTab, "Khóa Aim vào giữa màn hình", false, function(state) centerAimEnabled = state end)
createButton(combatTab, "Đổi Bộ Phận Ngắm (Đầu/Thân)", function()
    if aimPart == "Head" then aimPart = "HumanoidRootPart" else aimPart = "Head" end
end)

local triggerBot = false
createToggle(combatTab, "Tự động đánh khi chĩa tâm", false, function(state) triggerBot = state end)

local autoClicker = false
createToggle(combatTab, "Auto Click liên tục", false, function(state) autoClicker = state end)
task.spawn(function()
    while true do
        task.wait(0.03)
        if autoClicker then pcall(function() mouse1click() end) end
    end
end)

local spinBot = false
local spinSpeedVal = 40
createToggle(combatTab, "SpinBot Xoay Vòng", false, function(state) spinBot = state end)
createSlider(combatTab, "Tốc độ Spin", 10, 200, 40, function(val) spinSpeedVal = val end)

-- TAB 3: SKY STAND / BAY
local skyStandEnabled = false
local skyHeight = 50
createToggle(skyTab, "Bật Đứng Trên Không (Sky Stand)", false, function(state) skyStandEnabled = state end)
createSlider(skyTab, "Độ cao đứng trên trời", 10, 500, 50, function(val) skyHeight = val end)

local freeFly = false
local flySpeedVal = 50
createToggle(skyTab, "Bay tự do (Free Fly)", false, function(state) freeFly = state end)
createSlider(skyTab, "Tốc độ bay tự do", 10, 300, 50, function(val) flySpeedVal = val end)

-- TAB 4: ESP XUYÊN TƯỜNG (FIX LỖI TRIỆT ĐỂ)
local espBox = false
local espName = false
local espHP = false
local espDist = false
local espChams = false

createToggle(espTab, "ESP Khung 2D (Box)", false, function(state) espBox = state end)
createToggle(espTab, "ESP Tên Người Chơi", false, function(state) espName = state end)
createToggle(espTab, "ESP Thanh Máu (HP)", false, function(state) espHP = state end)
createToggle(espTab, "ESP Khoảng Cách (m)", false, function(state) espDist = state end)
createToggle(espTab, "ESP Highlight Xuyên Tường", false, function(state)
    espChams = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if state then
                if not p.Character:FindFirstChild("DarkTechChamV12") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "DarkTechChamV12"
                    hl.FillColor = Color3.fromRGB(0, 200, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                    hl.AlwaysOnTop = true
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("DarkTechChamV12") then p.Character.DarkTechChamV12:Destroy() end
            end
        end
    end
end)

local espDrawingCache = {}
RunService.RenderStepped:Connect(function()
    for _, obj in pairs(espDrawingCache) do
        if obj and obj.Remove then pcall(function() obj:Remove() end) end
    end
    espDrawingCache = {}

    if not (espBox or espName or espHP or espDist) then return end
    if not Drawing then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
            local root = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head") or root
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                local topPos, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local bottomPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height / 2

                if espBox then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width / 2, topPos.Y)
                    box.Color = Color3.fromRGB(0, 200, 255)
                    box.Thickness = 1
                    box.Filled = false
                    table.insert(espDrawingCache, box)
                end

                if espName or espHP or espDist then
                    local txtInfo = ""
                    if espName then txtInfo = txtInfo .. p.Name .. " " end
                    if espHP then txtInfo = txtInfo .. "[" .. math.floor(p.Character.Humanoid.Health) .. "HP] " end
                    if espDist then txtInfo = txtInfo .. "[" .. math.floor(dist) .. "m]" end

                    local txt = Drawing.new("Text")
                    txt.Visible = true
                    txt.Text = txtInfo
                    txt.Size = 10
                    txt.Color = Color3.fromRGB(220, 240, 255)
                    txt.Center = true
                    txt.Outline = true
                    txt.Position = Vector2.new(pos.X, topPos.Y - 14)
                    table.insert(espDrawingCache, txt)
                end
            end
        end
    end
end)

-- TAB 5: TP ALL PLAYERS
local selectedTargetPlayer = nil
local function getPlayerList()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

createDropdown(tpAllTab, "Chọn mục tiêu cụ thể", getPlayerList, function(name)
    selectedTargetPlayer = Players:FindFirstChild(name)
end)

createButton(tpAllTab, "Bay tới trước mặt Target đã chọn", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTargetPlayer.Character.HumanoidRootPart.CFrame + (selectedTargetPlayer.Character.HumanoidRootPart.CFrame.LookVector * 4) + Vector3.new(0, 2, 0)
        end
    end
end)

createButton(tpAllTab, "Bay ra trước mặt TẤT CẢ người chơi trong Server", function()
    task.spawn(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + (p.Character.HumanoidRootPart.CFrame.LookVector * 4) + Vector3.new(0, 2, 0)
                    task.wait(0.8)
                end
            end
        end
    end)
end)

createButton(tpAllTab, "Xem Camera Target (Spectate)", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = selectedTargetPlayer.Character.Humanoid
    end
end)

createButton(tpAllTab, "Reset Camera về bản thân", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

-- TAB 6: THẾ GIỚI & HACK
local godMode = false
createToggle(worldTab, "Bất tử hoàn toàn (God Mode)", false, function(state) godMode = state end)

local lavaImmune = false
createToggle(worldTab, "Kháng dung nham & Hố độc", false, function(state) lavaImmune = state end)

local waterWalk = false
createToggle(worldTab, "Đi trên mặt nước", false, function(state) waterWalk = state end)

local antiAFK = false
createToggle(worldTab, "Anti-AFK (Chống văng game)", false, function(state) antiAFK = state end)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if antiAFK then
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

-- TAB 7: TIỆN ÍCH 500+
createToggle(extraTab, "Fullbright (Sáng toàn bản đồ)", false, function(state)
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

createButton(extraTab, "Tăng FPS & Xóa hiệu ứng lag", function()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
    end)
end)

createButton(extraTab, "Lưu vị trí hiện tại (Save Pos)", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().SavedPosHubV12 = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end)
end)

createButton(extraTab, "Quay lại vị trí đã lưu (Load Pos)", function()
    pcall(function()
        if getgenv().SavedPosHubV12 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().SavedPosHubV12
        end
    end)
end)

createButton(extraTab, "Rejoin Server hiện tại", function()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end)

createButton(extraTab, "Chuyển Server mới (Server Hop)", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

createButton(extraTab, "Tải Infinite Yield Commands (500+ Lệnh)", function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
end)

-- XỬ LÝ LẶP RENDER & NHÂN VẬT
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")

    if humanoid then
        if walkSpeedEnabled then humanoid.WalkSpeed = walkSpeedVal end
        if jumpPowerEnabled then humanoid.JumpPower = jumpPowerVal end
        if godMode then humanoid.Health = humanoid.MaxHealth end
    end

    if spinBot and rootPart then
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeedVal), 0)
    end

    if noclipEnabled and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if skyStandEnabled and rootPart then
        rootPart.Velocity = Vector3.new(0, 0, 0)
        rootPart.CFrame = CFrame.new(rootPart.Position.X, Workspace.FallenPartsDestroyHeight + skyHeight, rootPart.Position.Z) * (rootPart.CFrame - rootPart.Position)
    end

    if freeFly and rootPart then
        rootPart.Velocity = Vector3.new(0, 1, 0)
        local camVec = Camera.CFrame.LookVector
        local moveVec = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camVec end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camVec end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Camera.CFrame.RightVector end
        rootPart.CFrame = rootPart.CFrame + (moveVec * (flySpeedVal * 0.05))
    end

    if centerAimEnabled then
        local closestTarget = nil
        local shortestDist = math.huge
        local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(aimPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) then
                    local part = p.Character[aimPart]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = part
                        end
                    end
                end
            end
        end

        if closestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
        end
    end

    if triggerBot then
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                local enemy = Players:GetPlayerFromCharacter(target.Parent)
                if enemy and enemy ~= LocalPlayer then mouse1click() end
            end
        end)
    end

    if lavaImmune then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("lava") or obj.Name:lower():find("kill") or obj.Material == Enum.Material.Lava) then
                obj.CanTouch = false
            end
        end
    end

    if waterWalk and rootPart then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("water") or obj.Material == Enum.Material.Water) then
                obj.CanCollide = true
            end
        end
    end
end)
