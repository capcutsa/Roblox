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

if CoreGui:FindFirstChild("KhoaDiemAppleV8") then
    CoreGui.KhoaDiemAppleV8:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemAppleV8"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local appleIconAsset = "rbxassetid://13848386850"

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
mainButton.Name = "AppleMenuButton"
mainButton.Size = UDim2.new(0, 52, 0, 52)
mainButton.Position = UDim2.new(0, 25, 0, 25)
mainButton.BackgroundColor3 = Color3.fromRGB(15, 12, 22)
mainButton.BorderSizePixel = 0
mainButton.Image = appleIconAsset
mainButton.ImageColor3 = Color3.fromRGB(255, 90, 140)
mainButton.Parent = ScreenGui

makeDraggable(mainButton)

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = mainButton

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(255, 90, 140)
btnStroke.Thickness = 2.5
btnStroke.Parent = mainButton

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 720, 0, 460)
mainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 10, 18)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 18)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 90, 140)
mainStroke.Thickness = 2
mainStroke.Transparency = 1
mainStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundColor3 = Color3.fromRGB(20, 14, 30)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

makeDraggable(mainFrame, topBar)

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 18)
topCorner.Parent = topBar

local topAppleIcon = Instance.new("ImageLabel")
topAppleIcon.Size = UDim2.new(0, 26, 0, 26)
topAppleIcon.Position = UDim2.new(0, 16, 0, 11)
topAppleIcon.BackgroundTransparency = 1
topAppleIcon.Image = appleIconAsset
topAppleIcon.ImageColor3 = Color3.fromRGB(255, 90, 140)
topAppleIcon.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -120, 1, 0)
titleLabel.Position = UDim2.new(0, 52, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "KhoaDiemHub • Apple Pro Edition"
titleLabel.TextColor3 = Color3.fromRGB(255, 230, 240)
titleLabel.TextSize = 13
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0, 8)
closeBtn.BackgroundColor3 = Color3.fromRGB(45, 18, 30)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 140)
closeBtn.TextSize = 13
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
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
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
        TweenService:Create(mainStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    end
end)

local sidebar = Instance.new("ScrollingFrame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 170, 1, -60)
sidebar.Position = UDim2.new(0, 10, 0, 54)
sidebar.BackgroundColor3 = Color3.fromRGB(16, 12, 24)
sidebar.BorderSizePixel = 0
sidebar.CanvasSize = UDim2.new(0, 0, 0, 420)
sidebar.ScrollBarThickness = 2
sidebar.Parent = mainFrame

local sideCorner = Instance.new("UICorner")
sideCorner.CornerRadius = UDim.new(0, 12)
sideCorner.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Padding = UDim.new(0, 5)
sideLayout.Parent = sidebar

local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(1, -196, 1, -60)
container.Position = UDim2.new(0, 186, 0, 54)
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
    scroller.CanvasSize = UDim2.new(0, 0, 0, 1600)
    scroller.ScrollBarThickness = 3
    scroller.Visible = false
    scroller.Parent = container

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scroller

    return scroller
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 220, 245)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 220, 245)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local indicator = Instance.new("TextButton")
    indicator.Size = UDim2.new(0, 44, 0, 22)
    indicator.Position = UDim2.new(1, -50, 0.5, -11)
    indicator.BackgroundColor3 = state and Color3.fromRGB(255, 90, 140) or Color3.fromRGB(45, 25, 55)
    indicator.BorderSizePixel = 0
    indicator.Text = state and "ON" or "OFF"
    indicator.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 160, 200)
    indicator.TextSize = 10
    indicator.Font = Enum.Font.GothamBold
    indicator.Parent = frame

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 6)
    indCorner.Parent = indicator

    indicator.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(255, 90, 140) or Color3.fromRGB(45, 25, 55)
        indicator.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 160, 200)
        indicator.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 54)
    frame.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 4)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(240, 220, 245)
    label.TextSize = 11
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -20, 0, 8)
    sliderBg.Position = UDim2.new(0, 10, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 25, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 4)
    sliderCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 90, 140)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 4)
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
    frame.Size = UDim2.new(1, -12, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundTransparency = 1
    btn.Text = text .. ": Chọn..."
    btn.TextColor3 = Color3.fromRGB(240, 220, 245)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Position = UDim2.new(0, 10, 0, 0)
    btn.Parent = frame

    local opened = false
    local optionButtons = {}

    local function refreshOptions()
        for _, b in ipairs(optionButtons) do b:Destroy() end
        optionButtons = {}
        local optList = options()
        for i, optName in ipairs(optList) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, -20, 0, 28)
            optBtn.Position = UDim2.new(0, 10, 0, 38 + (i - 1) * 30)
            optBtn.BackgroundColor3 = Color3.fromRGB(36, 24, 50)
            optBtn.BorderSizePixel = 0
            optBtn.Text = optName
            optBtn.TextColor3 = Color3.fromRGB(210, 190, 230)
            optBtn.TextSize = 10
            optBtn.Font = Enum.Font.Gotham
            optBtn.Parent = frame

            local optCorner = Instance.new("UICorner")
            optCorner.CornerRadius = UDim.new(0, 6)
            optCorner.Parent = optBtn

            optBtn.MouseButton1Click:Connect(function()
                btn.Text = text .. ": " .. optName
                opened = false
                frame.Size = UDim2.new(1, -12, 0, 38)
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
            frame.Size = UDim2.new(1, -12, 0, 42 + #optList * 30)
        else
            frame.Size = UDim2.new(1, -12, 0, 38)
        end
    end)

    return frame
end

local function createTabButton(name, scroller)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(24, 16, 36)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 180, 220)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = sidebar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        clearContainers()
        scroller.Visible = true
    end)
end

local tabNames = {"Di chuyển", "Chiến đấu & Aim", "ESP Xuyên Tường", "Bay Theo Player", "Thế giới & Hack", "Dịch chuyển", "Đồ họa & Script"}
local scrollers = {}

for i, name in ipairs(tabNames) do
    local scroller = createTabContent(name)
    scrollers[i] = scroller
    createTabButton(name, scroller)
end

scrollers[1].Visible = true

local charTab = scrollers[1]
local combatTab = scrollers[2]
local espTab = scrollers[3]
local followTab = scrollers[4]
local worldTab = scrollers[5]
local tpTab = scrollers[6]
local extraTab = scrollers[7]

local walkSpeedEnabled = false
local walkSpeedVal = 16
createToggle(charTab, "1. Tốc độ chạy (WalkSpeed)", false, function(state)
    walkSpeedEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(charTab, "Chỉnh Tốc Độ", 16, 400, 16, function(val) walkSpeedVal = val end)

local jumpPowerEnabled = false
local jumpPowerVal = 50
createToggle(charTab, "2. Nhảy cao (JumpPower)", false, function(state)
    jumpPowerEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider(charTab, "Chỉnh Độ Nhảy", 50, 700, 50, function(val) jumpPowerVal = val end)

local flyEnabled = false
local flySpeed = 50
createToggle(charTab, "3. Bay tự do (Free Fly)", false, function(state) flyEnabled = state end)
createSlider(charTab, "Tốc Độ Bay", 10, 300, 50, function(val) flySpeed = val end)

local noclipEnabled = false
createToggle(charTab, "4. Đi xuyên tường (Noclip)", false, function(state) noclipEnabled = state end)

local infJumpEnabled = false
createToggle(charTab, "5. Nhảy vô hạn không trung", false, function(state) infJumpEnabled = state end)

-- FIX AIM CHUẨN 100%: Dùng tỷ lệ nội suy mượt, check kỹ player còn sống và target trực tiếp phần thân/đầu chính xác không lệch tâm
local smoothAimEnabled = false
local aimSmoothness = 5
createToggle(combatTab, "6. Smooth AimBot (Đã fix chuẩn xác)", false, function(state) smoothAimEnabled = state end)
createSlider(combatTab, "Độ Mượt Camera (Thấp = Nhanh)", 1, 20, 5, function(val) aimSmoothness = val end)

local selectedBodyPart = "Head"
local bodyPartsList = {"Head", "HumanoidRootPart", "UpperTorso"}
local bpIndex = 1
createButton(combatTab, "Bộ phận ngắm: Đầu (Bấm để đổi)", function()
    bpIndex = bpIndex % #bodyPartsList + 1
    selectedBodyPart = bodyPartsList[bpIndex]
end)

local triggerBot = false
createToggle(combatTab, "7. Tự động đánh (TriggerBot)", false, function(state) triggerBot = state end)

local autoClicker = false
createToggle(combatTab, "8. Auto Clicker nhanh", false, function(state) autoClicker = state end)
task.spawn(function()
    while true do
        task.wait(0.03)
        if autoClicker then pcall(function() mouse1click() end) end
    end
end)

local spinBotEnabled = false
local spinSpeed = 30
createToggle(combatTab, "9. SpinBot (Xoay nhân vật)", false, function(state) spinBotEnabled = state end)
createSlider(combatTab, "Tốc Độ Xoay", 10, 100, 30, function(val) spinSpeed = val end)

local autoEquipWeapon = false
createToggle(combatTab, "10. Auto Equip vũ khí khi cần", false, function(state) autoEquipWeapon = state end)

local espBoxEnabled = false
local espNameEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espTracersEnabled = false
local espChamsEnabled = false

createToggle(espTab, "11. ESP Box 2D", false, function(state) espBoxEnabled = state end)
createToggle(espTab, "12. ESP Tên người chơi", false, function(state) espNameEnabled = state end)
createToggle(espTab, "13. ESP Thanh Máu (HP Bar)", false, function(state) espHealthEnabled = state end)
createToggle(espTab, "14. ESP Khoảng cách (m)", false, function(state) espDistanceEnabled = state end)
createToggle(espTab, "15. ESP Đường kẻ chỉ hướng (Tracer)", false, function(state) espTracersEnabled = state end)
createToggle(espTab, "16. ESP Highlight Xuyên Tường (Chams)", false, function(state)
    espChamsEnabled = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if state then
                if not p.Character:FindFirstChild("AppleCham") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "AppleCham"
                    hl.FillColor = Color3.fromRGB(255, 90, 140)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                    hl.AlwaysOnTop = true
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("AppleCham") then p.Character.AppleCham:Destroy() end
            end
        end
    end
end)

local espCache = {}
RunService.RenderStepped:Connect(function()
    for _, item in pairs(espCache) do
        if item and item.Remove then pcall(function() item:Remove() end) end
    end
    espCache = {}

    if not (espBoxEnabled or espNameEnabled or espHealthEnabled or espDistanceEnabled or espTracersEnabled) then return end
    if not Drawing then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            local root = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head") or root
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                local topPos, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local bottomPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height / 2

                if espBoxEnabled then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width / 2, topPos.Y)
                    box.Color = Color3.fromRGB(255, 90, 140)
                    box.Thickness = 1
                    box.Filled = false
                    table.insert(espCache, box)
                end

                if espTracersEnabled then
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.fromRGB(255, 90, 140)
                    line.Thickness = 1
                    table.insert(espCache, line)
                end

                if espNameEnabled or espHealthEnabled or espDistanceEnabled then
                    local txtInfo = ""
                    if espNameEnabled then txtInfo = txtInfo .. p.Name .. " " end
                    if espHealthEnabled then txtInfo = txtInfo .. "[" .. math.floor(p.Character.Humanoid.Health) .. "HP] " end
                    if espDistanceEnabled then txtInfo = txtInfo .. "[" .. math.floor(dist) .. "m]" end

                    local txt = Drawing.new("Text")
                    txt.Visible = true
                    txt.Text = txtInfo
                    txt.Size = 11
                    txt.Color = Color3.fromRGB(255, 230, 240)
                    txt.Center = true
                    txt.Outline = true
                    txt.Position = Vector2.new(pos.X, topPos.Y - 16)
                    table.insert(espCache, txt)
                end
            end
        end
    end
end)

local targetFollowPlayer = nil
local followPlayerEnabled = false
local followDistance = 5

local function getPlayerList()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    return names
end

createDropdown(followTab, "17. Chọn Player trong Server", getPlayerList, function(selectedName)
    targetFollowPlayer = Players:FindFirstChild(selectedName)
end)

createToggle(followTab, "18. Bật Bay theo Player (Orbit/Fly Follow)", false, function(state)
    followPlayerEnabled = state
end)

createSlider(followTab, "19. Khoảng cách bám sát (Mét)", 2, 30, 5, function(val)
    followDistance = val
end)

createButton(followTab, "20. Xem góc nhìn Player (Spectate Cam)", function()
    if targetFollowPlayer and targetFollowPlayer.Character and targetFollowPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = targetFollowPlayer.Character.Humanoid
    end
end)

createButton(followTab, "Đặt lại Camera về bản thân", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

local godMode = false
createToggle(worldTab, "21. Bất tử hoàn toàn (God Mode)", false, function(state) godMode = state end)

local lavaImmune = false
createToggle(worldTab, "22. Kháng dung nham & Hố độc", false, function(state) lavaImmune = state end)

local waterWalk = false
createToggle(worldTab, "23. Đi trên mặt nước", false, function(state) waterWalk = state end)

local antiAFK = false
createToggle(worldTab, "24. Anti-AFK (Chống văng Game)", false, function(state) antiAFK = state end)
task.spawn(function()
    local bb = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if antiAFK then
            bb:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            bb:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

local invisibleLocal = false
createToggle(worldTab, "25. Ẩn thân cục bộ (Semi-Invisible)", false, function(state)
    invisibleLocal = state
    if LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Decal") then
                v.Transparency = state and 0.8 or 0
            end
        end
    end
end)

createButton(tpTab, "26. Dịch chuyển ngay đến Target Player", function()
    if targetFollowPlayer and targetFollowPlayer.Character and targetFollowPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetFollowPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

createButton(tpTab, "27. Lưu vị trí hiện tại (Save Pos)", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().AppleSavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end)
end)

createButton(tpTab, "28. Dịch chuyển về vị trí đã lưu (Load Pos)", function()
    pcall(function()
        if getgenv().AppleSavedPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().AppleSavedPos
        end
    end)
end)

createToggle(extraTab, "29. Fullbright (Sáng bản đồ)", false, function(state)
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

createButton(extraTab, "30. Tăng FPS & Giảm Lag tối đa", function()
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

createButton(extraTab, "31. Rejoin Server hiện tại", function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

createButton(extraTab, "32. Chuyển Server mới (Server Hop)", function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

createButton(extraTab, "33. Tải Lệnh Mở Rộng (Infinite Yield)", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end)

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

    if spinBotEnabled and rootPart then
        rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end

    if noclipEnabled and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end

    if flyEnabled and rootPart then
        rootPart.Velocity = Vector3.new(0, 1, 0)
        local camVec = Camera.CFrame.LookVector
        local moveVec = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camVec end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camVec end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Camera.CTrade.RightVector or moveVec + Camera.CFrame.RightVector end
        rootPart.CFrame = rootPart.CFrame + (moveVec * (flySpeed * 0.05))
    end

    if followPlayerEnabled and targetFollowPlayer and targetFollowPlayer.Character and targetFollowPlayer.Character:FindFirstChild("HumanoidRootPart") and rootPart then
        local targetRoot = targetFollowPlayer.Character.HumanoidRootPart
        local offsetPos = targetRoot.CFrame * Vector3.new(0, 2, followDistance)
        rootPart.CFrame = rootPart.CFrame:Lerp(CFrame.new(offsetPos, targetRoot.Position), 0.2)
    end

    -- FIX AIM CHUẨN XÁC HOÀN TOÀN: Tính khoảng cách gần tâm màn hình/chuột nhất và lock trực tiếp vào phần cơ thể chọn (Head/Torso)
    if smoothAimEnabled == true then
        local closestTarget = nil
        local shortestDist = math.huge
        local mousePos = UserInputService:GetMouseLocation()

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(selectedBodyPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local part = p.Character[selectedBodyPart]
                local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = part
                    end
                end
            end
        end

        if closestTarget then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / math.max(aimSmoothness, 1))
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
