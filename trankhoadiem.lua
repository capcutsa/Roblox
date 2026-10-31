local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemHubAnime"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local function getExecutorName()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        return name .. " " .. tostring(ver)
    elseif syn then
        return "Synapse X"
    elseif KRNL_LOADED then
        return "KRNL"
    elseif Fluxus then
        return "Fluxus"
    elseif Delta then
        return "Delta"
    elseif Hydrogen then
        return "Hydrogen"
    else
        return "Unknown Executor"
    end
end

local function getDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Mobile / Tablet"
    elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        return "PC / Desktop"
    else
        return "Console / Other"
    end
end

local welcomeFrame = Instance.new("Frame")
welcomeFrame.Name = "WelcomeFrame"
welcomeFrame.Size = UDim2.new(0, 520, 0, 320)
welcomeFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
welcomeFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 30)
welcomeFrame.BackgroundTransparency = 1
welcomeFrame.BorderSizePixel = 0
welcomeFrame.Visible = true
welcomeFrame.Parent = ScreenGui

local welcomeCorner = Instance.new("UICorner")
welcomeCorner.CornerRadius = UDim.new(0, 14)
welcomeCorner.Parent = welcomeFrame

local welcomeStroke = Instance.new("UIStroke")
welcomeStroke.Color = Color3.fromRGB(255, 105, 180)
welcomeStroke.Thickness = 2.5
welcomeStroke.Transparency = 1
welcomeStroke.Parent = welcomeFrame

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 45)
welcomeTitle.Position = UDim2.new(0, 0, 0, 15)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "KHOADIEM HUB - ANIME EDITION V1.0"
welcomeTitle.TextColor3 = Color3.fromRGB(255, 150, 215)
welcomeTitle.TextSize = 20
welcomeTitle.Font = Enum.Font.Code
welcomeTitle.TextTransparency = 1
welcomeTitle.Parent = welcomeFrame

local welcomeSub = Instance.new("TextLabel")
welcomeSub.Size = UDim2.new(1, 0, 0, 25)
welcomeSub.Position = UDim2.new(0, 0, 0, 55)
welcomeSub.BackgroundTransparency = 1
welcomeSub.Text = "Welcome everyone, I am Tran Khoa Diem. This script is currently in beta development and not fully stable yet."
welcomeSub.TextColor3 = Color3.fromRGB(210, 170, 240)
welcomeSub.TextSize = 12
welcomeSub.Font = Enum.Font.Code
welcomeSub.TextTransparency = 1
welcomeSub.Parent = welcomeFrame

local infoBox = Instance.new("TextLabel")
infoBox.Size = UDim2.new(1, -40, 0, 180)
infoBox.Position = UDim2.new(0, 20, 0, 95)
infoBox.BackgroundColor3 = Color3.fromRGB(25, 14, 42)
infoBox.BackgroundTransparency = 1
infoBox.BorderSizePixel = 0
infoBox.TextColor3 = Color3.fromRGB(220, 200, 240)
infoBox.TextSize = 12
infoBox.Font = Enum.Font.Code
infoBox.TextXAlignment = Enum.TextXAlignment.Left
infoBox.TextYAlignment = Enum.TextYAlignment.Top
infoBox.TextWrapped = true
infoBox.TextTransparency = 1
infoBox.Parent = welcomeFrame

local infoBoxCorner = Instance.new("UICorner")
infoBoxCorner.CornerRadius = UDim.new(0, 8)
infoBoxCorner.Parent = infoBox

local infoBoxPadding = Instance.new("UIPadding")
infoBoxPadding.PaddingTop = UDim.new(0, 12)
infoBoxPadding.PaddingBottom = UDim.new(0, 12)
infoBoxPadding.PaddingLeft = UDim.new(0, 12)
infoBoxPadding.PaddingRight = UDim.new(0, 12)
infoBoxPadding.Parent = infoBox

local currentTime = os.date("%Y-%m-%d %H:%M:%S")
local currentPlaceId = game.PlaceId
local gameName = "Roblox Place " .. tostring(currentPlaceId)
pcall(function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local info = MarketplaceService:GetProductInfo(currentPlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local levelStr = "None"
pcall(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Data") then
        local data = LocalPlayer.Character.Data
        if data:FindFirstChild("Level") then
            levelStr = tostring(data.Level.Value)
        end
    elseif LocalPlayer:FindFirstChild("leaderstats") then
        local stats = LocalPlayer.leaderstats
        if stats:FindFirstChild("Level") then
            levelStr = tostring(stats.Level.Value)
        elseif stats:FindFirstChild("Lvl") then
            levelStr = tostring(stats.Lvl.Value)
        end
    end
end)

infoBox.Text = string.format(
    "Status: Beta development version, unstable under heavy execution.\nPlayer: %s (%s)\nCurrent Game: %s\nTimestamp: %s\nDevice: %s | Executor: %s\nLevel: %s\nDeveloper: Tran Khoa Diem | Telegram: @TranKhoaDiem",
    LocalPlayer.Name,
    LocalPlayer.DisplayName,
    gameName,
    currentTime,
    getDeviceType(),
    getExecutorName(),
    levelStr
)

TweenService:Create(welcomeFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
TweenService:Create(welcomeStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
TweenService:Create(welcomeTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(welcomeSub, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(infoBox, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0, TextTransparency = 0}):Play()

task.wait(3.5)

TweenService:Create(welcomeFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
TweenService:Create(welcomeStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
TweenService:Create(welcomeTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(welcomeSub, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(infoBox, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
task.wait(0.6)
welcomeFrame:Destroy()

local mainButton = Instance.new("TextButton")
mainButton.Name = "MainButton"
mainButton.Size = UDim2.new(0, 56, 0, 56)
mainButton.Position = UDim2.new(0, 30, 0, 30)
mainButton.BackgroundColor3 = Color3.fromRGB(22, 12, 38)
mainButton.BorderSizePixel = 0
mainButton.Text = "🌸"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextSize = 20
mainButton.Font = Enum.Font.Code
mainButton.Parent = ScreenGui

local mainBtnCorner = Instance.new("UICorner")
mainBtnCorner.CornerRadius = UDim.new(1, 0)
mainBtnCorner.Parent = mainButton

local mainBtnStroke = Instance.new("UIStroke")
mainBtnStroke.Color = Color3.fromRGB(255, 105, 180)
mainBtnStroke.Thickness = 2.5
mainBtnStroke.Parent = mainButton

local crosshair = Instance.new("Frame")
crosshair.Name = "AimCrosshair"
crosshair.Size = UDim2.new(0, 80, 0, 80)
crosshair.Position = UDim2.new(0.5, -40, 0.5, -40)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.Parent = ScreenGui

local circleStroke = Instance.new("UIStroke")
circleStroke.Color = Color3.fromRGB(255, 105, 180)
circleStroke.Thickness = 2
circleStroke.Parent = crosshair

local circleCorner = Instance.new("UICorner")
circleCorner.CornerRadius = UDim.new(1, 0)
circleCorner.Parent = crosshair

local centerDot = Instance.new("Frame")
centerDot.Size = UDim2.new(0, 6, 0, 6)
centerDot.Position = UDim2.new(0.5, -3, 0.5, -3)
centerDot.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
centerDot.BorderSizePixel = 0
centerDot.Parent = crosshair

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = centerDot

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 700, 0, 480)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 8, 25)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 12)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = Color3.fromRGB(255, 105, 180)
mainFrameStroke.Thickness = 2.5
mainFrameStroke.Transparency = 1
mainFrameStroke.Parent = mainFrame

mainButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(mainFrameStroke, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
        task.wait(0.3)
        mainFrame.Visible = false
    else
        mainFrame.Visible = true
        mainFrame.BackgroundTransparency = 1
        mainFrameStroke.Transparency = 1
        TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()
        TweenService:Create(mainFrameStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    end
end)

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 42)
topBar.BackgroundColor3 = Color3.fromRGB(22, 12, 38)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 12)
topBarCorner.Parent = topBar

local topBarTitle = Instance.new("TextLabel")
topBarTitle.Size = UDim2.new(1, -110, 1, 0)
topBarTitle.Position = UDim2.new(0, 18, 0, 0)
topBarTitle.BackgroundTransparency = 1
topBarTitle.Text = "KHOADIEM HUB - ANIME V1.0 | Dev: Tran Khoa Diem"
topBarTitle.TextColor3 = Color3.fromRGB(255, 180, 230)
topBarTitle.TextSize = 13
topBarTitle.Font = Enum.Font.Code
topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
topBarTitle.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 34, 0, 34)
closeButton.Position = UDim2.new(1, -40, 0, 4)
closeButton.BackgroundColor3 = Color3.fromRGB(40, 20, 65)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 120, 160)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.Code
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

local tabList = Instance.new("ScrollingFrame")
tabList.Name = "TabList"
tabList.Size = UDim2.new(0, 165, 1, -54)
tabList.Position = UDim2.new(0, 6, 0, 48)
tabList.BackgroundColor3 = Color3.fromRGB(12, 6, 20)
tabList.BorderSizePixel = 0
tabList.CanvasSize = UDim2.new(0, 0, 0, 420)
tabList.ScrollBarThickness = 3
tabList.Parent = mainFrame

local tabListCorner = Instance.new("UICorner")
tabListCorner.CornerRadius = UDim.new(0, 8)
tabListCorner.Parent = tabList

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 6)
tabListLayout.Parent = tabList

local containerFrame = Instance.new("Frame")
containerFrame.Name = "ContainerFrame"
containerFrame.Size = UDim2.new(1, -183, 1, -54)
containerFrame.Position = UDim2.new(0, 175, 0, 48)
containerFrame.BackgroundTransparency = 1
containerFrame.Parent = mainFrame

local function clearContainers()
    for _, child in ipairs(containerFrame:GetChildren()) do
        child.Visible = false
    end
end

local function createTabContent(name)
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = name .. "Content"
    scroller.Size = UDim2.new(1, 0, 1, 0)
    scroller.BackgroundTransparency = 1
    scroller.CanvasSize = UDim2.new(0, 0, 0, 1100)
    scroller.ScrollBarThickness = 4
    scroller.Visible = false
    scroller.Parent = containerFrame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scroller

    return scroller
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(25, 14, 45)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(240, 190, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.Code
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
    frame.Size = UDim2.new(1, -10, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(25, 14, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -55, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(240, 190, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local indicator = Instance.new("TextButton")
    indicator.Size = UDim2.new(0, 42, 0, 22)
    indicator.Position = UDim2.new(1, -50, 0.5, -11)
    indicator.BackgroundColor3 = state and Color3.fromRGB(200, 50, 150) or Color3.fromRGB(45, 25, 75)
    indicator.BorderSizePixel = 0
    indicator.Text = state and "ON" or "OFF"
    indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
    indicator.TextSize = 11
    indicator.Font = Enum.Font.Code
    indicator.Parent = frame

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 6)
    indCorner.Parent = indicator

    indicator.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(200, 50, 150) or Color3.fromRGB(45, 25, 75)
        indicator.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 56)
    frame.BackgroundColor3 = Color3.fromRGB(25, 14, 45)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -24, 0, 22)
    label.Position = UDim2.new(0, 12, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(240, 190, 255)
    label.TextSize = 13
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -24, 0, 12)
    sliderBg.Position = UDim2.new(0, 12, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 25, 75)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 105, 180)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 6)
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

local function createTabButton(name, scroller)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(25, 14, 45)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(240, 190, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.Code
    btn.Parent = tabList

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        clearContainers()
        scroller.Visible = true
    end)
end

local tabNames = {"Movement", "Combat & Aim", "ESP", "World & Shield", "Spectate & TP", "Visuals", "Other"}
local scrollers = {}

for i, name in ipairs(tabNames) do
    local scroller = createTabContent(name)
    scrollers[i] = scroller
    createTabButton(name, scroller)
end

scrollers[1].Visible = true

local movementTab = scrollers[1]
local combatTab = scrollers[2]
local espTab = scrollers[3]
local worldTab = scrollers[4]
local spectateTab = scrollers[5]
local visualsTab = scrollers[6]
local otherTab = scrollers[7]

local walkSpeedEnabled = false
local walkSpeedVal = 16
createToggle(movementTab, "Run / Fast Speed", false, function(state)
    walkSpeedEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(movementTab, "WalkSpeed Value", 16, 250, 16, function(val)
    walkSpeedVal = val
end)

local jumpPowerEnabled = false
local jumpPowerVal = 50
createToggle(movementTab, "High Jump", false, function(state)
    jumpPowerEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider(movementTab, "JumpPower Value", 50, 500, 50, function(val)
    jumpPowerVal = val
end)

local flyEnabled = false
local flySpeed = 50
createToggle(movementTab, "Fly Mode", false, function(state)
    flyEnabled = state
end)
createSlider(movementTab, "Fly Speed", 10, 200, 50, function(val)
    flySpeed = val
end)

local noclipEnabled = false
createToggle(movementTab, "Noclip / Walk Through Walls", false, function(state)
    noclipEnabled = state
end)

local stickyAimEnabled = false
createToggle(combatTab, "Sticky Center Crosshair Aim", false, function(state)
    stickyAimEnabled = state
    crosshair.Visible = state
end)

local selectedBodyPart = "Head"
local bodyPartsList = {"Head", "HumanoidRootPart", "UpperTorso"}
local bpIndex = 1
createButton(combatTab, "Target Part: Head", function()
    bpIndex = bpIndex % #bodyPartsList + 1
    selectedBodyPart = bodyPartsList[bpIndex]
end)

local triggerBot = false
createToggle(combatTab, "Triggerbot Auto Attack", false, function(state)
    triggerBot = state
end)

local espBoxEnabled = false
local espNameEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espLinesEnabled = false

createToggle(espTab, "ESP Box", false, function(state) espBoxEnabled = state end)
createToggle(espTab, "ESP Name", false, function(state) espNameEnabled = state end)
createToggle(espTab, "ESP Health", false, function(state) espHealthEnabled = state end)
createToggle(espTab, "ESP Distance", false, function(state) espDistanceEnabled = state end)
createToggle(espTab, "ESP Lines", false, function(state) espLinesEnabled = state end)

local espDrawingCache = {}
RunService.RenderStepped:Connect(function()
    for _, item in pairs(espDrawingCache) do
        if item and item.Remove then
            pcall(function() item:Remove() end)
        end
    end
    espDrawingCache = {}

    if not (espBoxEnabled or espNameEnabled or espHealthEnabled or espDistanceEnabled or espLinesEnabled) then
        return
    end

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
                    box.Color = Color3.fromRGB(255, 105, 180)
                    box.Thickness = 1.5
                    box.Filled = false
                    table.insert(espDrawingCache, box)
                end

                if espLinesEnabled then
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.fromRGB(255, 105, 180)
                    line.Thickness = 1
                    table.insert(espDrawingCache, line)
                end

                if espNameEnabled or espHealthEnabled or espDistanceEnabled then
                    local infoText = ""
                    if espNameEnabled then infoText = infoText .. p.Name .. " " end
                    if espHealthEnabled then infoText = infoText .. "[" .. math.floor(p.Character.Humanoid.Health) .. "HP] " end
                    if espDistanceEnabled then infoText = infoText .. "[" .. math.floor(dist) .. "m]" end

                    local txt = Drawing.new("Text")
                    txt.Visible = true
                    txt.Text = infoText
                    txt.Size = 13
                    txt.Color = Color3.fromRGB(255, 180, 230)
                    txt.Center = true
                    txt.Outline = true
                    txt.Position = Vector2.new(pos.X, topPos.Y - 18)
                    table.insert(espDrawingCache, txt)
                end
            end
        end
    end
end)

local godMode = false
createToggle(worldTab, "God Mode / Immortal", false, function(state)
    godMode = state
end)

local shieldEnabled = false
createToggle(worldTab, "Shield & Energy Aura", false, function(state)
    shieldEnabled = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if state then
            local fire = Instance.new("Fire")
            fire.Name = "HubShieldFire"
            fire.Size = 9
            fire.Color = Color3.fromRGB(255, 105, 180)
            fire.Parent = LocalPlayer.Character.HumanoidRootPart
            local part = Instance.new("Part")
            part.Name = "HubShieldBall"
            part.Size = Vector3.new(6, 6, 6)
            part.Shape = Enum.PartType.Ball
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 105, 180)
            part.Transparency = 0.5
            part.CanCollide = false
            part.Parent = LocalPlayer.Character
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = part
            weld.Part1 = LocalPlayer.Character.HumanoidRootPart
            weld.Parent = part
        else
            if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("HubShieldFire") then
                LocalPlayer.Character.HumanoidRootPart.HubShieldFire:Destroy()
            end
            if LocalPlayer.Character:FindFirstChild("HubShieldBall") then
                LocalPlayer.Character.HubShieldBall:Destroy()
            end
        end
    end
end)

local lavaImmune = false
createToggle(worldTab, "Lava & KillBrick Immunity", false, function(state)
    lavaImmune = state
end)

local waterWalk = false
createToggle(worldTab, "Water Walk", false, function(state)
    waterWalk = state
end)

local selectedTargetPlayer = nil
createButton(spectateTab, "Select Next Target Player", function()
    local players = Players:GetPlayers()
    for i, p in ipairs(players) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if selectedTargetPlayer == nil or selectedTargetPlayer == p then
                selectedTargetPlayer = players[(i % #players) + 1]
                if selectedTargetPlayer == LocalPlayer then
                    selectedTargetPlayer = players[((i + 1) % #players) + 1]
                end
                break
            end
        end
    end
end)

createButton(spectateTab, "Spectate Target Camera", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = selectedTargetPlayer.Character.Humanoid
    end
end)

createButton(spectateTab, "Reset Camera to Self", function()
    selectedTargetPlayer = nil
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

createButton(spectateTab, "Teleport to Target Player", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTargetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

local fullBright = false
createToggle(visualsTab, "Fullbright", false, function(state)
    fullBright = state
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

local xrayEnabled = false
createToggle(visualsTab, "X-Ray Wallhack", false, function(state)
    xrayEnabled = state
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:IsDescendantOf(LocalPlayer.Character) then
            if state then
                obj.LocalTransparencyModifier = 0.6
            else
                obj.LocalTransparencyModifier = 0
            end
        end
    end
end)

createButton(visualsTab, "FPS Boost / Fix Lag All", function()
    pcall(function()
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Material = Enum.Material.SmoothPlastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 999999
    end)
end)

local autoChatEnabled = false
local chatMessages = {"KhoaDiemHub Anime Edition on top!", "Tran Khoa Diem is the best developer", "Universal Roblox Hub"}
createToggle(otherTab, "Auto Chatting", false, function(state)
    autoChatEnabled = state
end)

createButton(otherTab, "Open Telegram: @TranKhoaDiem", function()
    pcall(function()
        if setclipboard then
            setclipboard("https://t.me/TranKhoaDiem")
        end
        if syn and syn.request then
            syn.request({Url = "https://t.me/TranKhoaDiem", Method = "GET"})
        elseif request then
            request({Url = "https://t.me/TranKhoaDiem", Method = "GET"})
        end
    end)
end)

createButton(otherTab, "About Developer Tran Khoa Diem", function()
    local aboutGui = Instance.new("Frame")
    aboutGui.Size = UDim2.new(0, 420, 0, 240)
    aboutGui.Position = UDim2.new(0.5, -210, 0.5, -120)
    aboutGui.BackgroundColor3 = Color3.fromRGB(18, 10, 30)
    aboutGui.BorderSizePixel = 0
    aboutGui.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = aboutGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 105, 180)
    stroke.Thickness = 2.5
    stroke.Parent = aboutGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -24, 1, -55)
    lbl.Position = UDim2.new(0, 12, 0, 12)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Hub Name: KhoaDiemHub (Anime Edition V1.0)\nDeveloper: Trần Khoa Điềm\nTelegram: @TranKhoaDiem\nStatus: Beta development version, unstable under heavy execution.\n\nDesigned with an anime aesthetic, sticky center crosshair locking, shield protection, and full universal game support."
    lbl.TextColor3 = Color3.fromRGB(240, 190, 255)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Parent = aboutGui

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 110, 0, 34)
    closeBtn.Position = UDim2.new(0.5, -55, 1, -42)
    closeBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 75)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Close / Đóng"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.Code
    closeBtn.Parent = aboutGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = aboutGui

    closeBtn.MouseButton1Click:Connect(function()
        aboutGui:Destroy()
    end)
end)

local currentLockedTarget = nil
RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local rootPart = char:FindFirstChild("HumanoidRootPart")

    if humanoid then
        if walkSpeedEnabled then
            humanoid.WalkSpeed = walkSpeedVal
        end
        if jumpPowerEnabled then
            humanoid.JumpPower = jumpPowerVal
        end
        if godMode then
            humanoid.Health = humanoid.MaxHealth
        end
    end

    if noclipEnabled and char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end

    if flyEnabled and rootPart then
        rootPart.Velocity = Vector3.new(0, 1, 0)
        local camVec = Camera.CFrame.LookVector
        local moveVec = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVec = moveVec + camVec end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVec = moveVec - camVec end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVec = moveVec - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Camera.CFrame.RightVector end
        rootPart.CFrame = rootPart.CFrame + (moveVec * (flySpeed * 0.05))
    end

    if stickyAimEnabled then
        local centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        if not currentLockedTarget or not currentLockedTarget.Parent or not currentLockedTarget.Parent:FindFirstChild("Humanoid") or currentLockedTarget.Parent.Humanoid.Health <= 0 then
            currentLockedTarget = nil
            local shortestDist = 80
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(selectedBodyPart) then
                    local targetPart = p.Character[selectedBodyPart]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            currentLockedTarget = targetPart
                        end
                    end
                end
            end
        else
            local screenPos, onScreen = Camera:WorldToViewportPoint(currentLockedTarget.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - centerScreen).Magnitude
                if dist > 120 then
                    currentLockedTarget = nil
                else
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, currentLockedTarget.Position)
                end
            else
                currentLockedTarget = nil
            end
        end
    else
        currentLockedTarget = nil
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

task.spawn(function()
    while true do
        task.wait(10)
        if autoChatEnabled then
            pcall(function()
                local textService = game:GetService("TextChatService")
                if textService.ChatInputBarConfiguration then
                    local channel = textService.TextChannels.RBXGeneral
                    if channel then
                        channel:SendAsync(chatMessages[math.random(1, #chatMessages)])
                    end
                else
                    game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents"):FindFirstChild("SayMessageRequest"):FireServer(chatMessages[math.random(1, #chatMessages)], "All")
                end
            end)
        end
    end
end)
