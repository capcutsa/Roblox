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
ScreenGui.Name = "KhoaDiemHub"
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
        return "Điện thoại / Máy tính bảng"
    elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        return "Máy tính cá nhân (PC)"
    else
        return "Khác / Console"
    end
end

-- MÀN HÌNH CHÀO MỪNG (LOG GIỚI THIỆU - KHÔNG HIỆN TÊN Ở TIÊU ĐỀ, CHỈ CÓ TRONG GIỚI THIỆU)
local welcomeFrame = Instance.new("Frame")
welcomeFrame.Name = "WelcomeFrame"
welcomeFrame.Size = UDim2.new(0, 520, 0, 320)
welcomeFrame.Position = UDim2.new(0.5, -260, 0.5, -160)
welcomeFrame.BackgroundColor3 = Color3.fromRGB(18, 10, 24)
welcomeFrame.BackgroundTransparency = 1
welcomeFrame.BorderSizePixel = 0
welcomeFrame.Visible = true
welcomeFrame.Parent = ScreenGui

local welcomeCorner = Instance.new("UICorner")
welcomeCorner.CornerRadius = UDim.new(0, 16)
welcomeCorner.Parent = welcomeFrame

local welcomeStroke = Instance.new("UIStroke")
welcomeStroke.Color = Color3.fromRGB(255, 40, 130)
welcomeStroke.Thickness = 2.5
welcomeStroke.Transparency = 1
welcomeStroke.Parent = welcomeFrame

local welcomeTitle = Instance.new("TextLabel")
welcomeTitle.Size = UDim2.new(1, 0, 0, 40)
welcomeTitle.Position = UDim2.new(0, 0, 0, 15)
welcomeTitle.BackgroundTransparency = 1
welcomeTitle.Text = "KHOADIEMHUB - PRO EDITION"
welcomeTitle.TextColor3 = Color3.fromRGB(255, 100, 180)
welcomeTitle.TextSize = 19
welcomeTitle.Font = Enum.Font.Code
welcomeTitle.TextTransparency = 1
welcomeTitle.Parent = welcomeFrame

local welcomeSub = Instance.new("TextLabel")
welcomeSub.Size = UDim2.new(1, 0, 0, 25)
welcomeSub.Position = UDim2.new(0, 0, 0, 52)
welcomeSub.BackgroundTransparency = 1
welcomeSub.Text = "Xin chào mọi người!"
welcomeSub.TextColor3 = Color3.fromRGB(220, 160, 200)
welcomeSub.TextSize = 13
welcomeSub.Font = Enum.Font.Code
welcomeSub.TextTransparency = 1
welcomeSub.Parent = welcomeFrame

-- SCROLLING FRAME ĐỂ KHÔNG BỊ TRÀN CHỮ
local infoScroller = Instance.new("ScrollingFrame")
infoScroller.Size = UDim2.new(1, -40, 0, 180)
infoScroller.Position = UDim2.new(0, 20, 0, 85)
infoScroller.BackgroundColor3 = Color3.fromRGB(28, 14, 36)
infoScroller.BackgroundTransparency = 1
infoScroller.BorderSizePixel = 0
infoScroller.CanvasSize = UDim2.new(0, 0, 0, 270)
infoScroller.ScrollBarThickness = 4
infoScroller.Parent = welcomeFrame

local infoScrollerCorner = Instance.new("UICorner")
infoScrollerCorner.CornerRadius = UDim.new(0, 10)
infoScrollerCorner.Parent = infoScroller

local infoBox = Instance.new("TextLabel")
infoBox.Size = UDim2.new(1, -15, 0, 250)
infoBox.Position = UDim2.new(0, 10, 0, 10)
infoBox.BackgroundTransparency = 1
infoBox.BorderSizePixel = 0
infoBox.TextColor3 = Color3.fromRGB(235, 190, 220)
infoBox.TextSize = 12
infoBox.Font = Enum.Font.Code
infoBox.TextXAlignment = Enum.TextXAlignment.Left
infoBox.TextYAlignment = Enum.TextYAlignment.Top
infoBox.TextWrapped = true
infoBox.TextTransparency = 1
infoBox.Parent = infoScroller

local currentTime = os.date("%d/%m/%Y %H:%M:%S")
local currentPlaceId = game.PlaceId
local gameName = "Roblox Place " .. tostring(currentPlaceId)
pcall(function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local info = MarketplaceService:GetProductInfo(currentPlaceId)
    if info and info.Name then
        gameName = info.Name
    end
end)

local levelStr = "Không có"
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
    "Trạng thái: Phiên bản Beta đang phát triển, chưa hoạt động ổn định.\nTài khoản: %s (%s)\nTrò chơi đang chơi: %s\nThời gian: %s\nThiết bị: %s | Executor: %s\nLevel: %s\nGiới thiệu: Script được phát triển bởi Trần Khoa Điềm\nLiên hệ Telegram: @TranKhoaDiem",
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
TweenService:Create(infoScroller, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0}):Play()

task.wait(4.0)

TweenService:Create(welcomeFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
TweenService:Create(welcomeStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
TweenService:Create(welcomeTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(welcomeSub, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(infoBox, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
TweenService:Create(infoScroller, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
task.wait(0.6)
welcomeFrame:Destroy()

-- NÚT MENU DÙNG ẢNH khoadiem.jpeg
local mainButton = Instance.new("ImageButton")
mainButton.Name = "MainButtonImg"
mainButton.Size = UDim2.new(0, 60, 0, 60)
mainButton.Position = UDim2.new(0, 25, 0, 25)
mainButton.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
mainButton.BorderSizePixel = 0

pcall(function()
    if getcustomasset and isfile and isfile("khoadiem.jpeg") then
        mainButton.Image = getcustomasset("khoadiem.jpeg")
    else
        mainButton.Image = "rbxassetid://6031091004"
    end
end)
if mainButton.Image == "" then
    mainButton.Image = "rbxassetid://6031091004"
end

mainButton.Parent = ScreenGui

local mainBtnCorner = Instance.new("UICorner")
mainBtnCorner.CornerRadius = UDim.new(1, 0)
mainBtnCorner.Parent = mainButton

local mainBtnStroke = Instance.new("UIStroke")
mainBtnStroke.Color = Color3.fromRGB(255, 40, 130)
mainBtnStroke.Thickness = 3
mainBtnStroke.Parent = mainButton

-- GIAO DIỆN CHÍNH MỚI (PHONG CÁCH FLOATING CARD HIỆN ĐẠI, BO TRÒN SANG TRỌNG)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 740, 0, 490)
mainFrame.Position = UDim2.new(0.5, -370, 0.5, -245)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 8, 20)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 18)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = Color3.fromRGB(255, 40, 130)
mainFrameStroke.Thickness = 3
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

-- THANH TIÊU ĐỀ TRÊN CÙNG
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 48)
topBar.BackgroundColor3 = Color3.fromRGB(25, 12, 38)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 18)
topBarCorner.Parent = topBar

local topBarTitle = Instance.new("TextLabel")
topBarTitle.Size = UDim2.new(1, -120, 1, 0)
topBarTitle.Position = UDim2.new(0, 20, 0, 0)
topBarTitle.BackgroundTransparency = 1
topBarTitle.Text = "KhoaDiemHub - Giao Diện Mới | Tác giả: Trần Khoa Điềm"
topBarTitle.TextColor3 = Color3.fromRGB(255, 130, 200)
topBarTitle.TextSize = 13
topBarTitle.Font = Enum.Font.Code
topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
topBarTitle.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 36, 0, 36)
closeButton.Position = UDim2.new(1, -44, 0, 6)
closeButton.BackgroundColor3 = Color3.fromRGB(55, 18, 40)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 120, 160)
closeButton.TextSize = 15
closeButton.Font = Enum.Font.Code
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- DANH SÁCH TAB BÊN TRÁI
local tabList = Instance.new("ScrollingFrame")
tabList.Name = "TabList"
tabList.Size = UDim2.new(0, 185, 1, -62)
tabList.Position = UDim2.new(0, 8, 0, 54)
tabList.BackgroundColor3 = Color3.fromRGB(10, 5, 15)
tabList.BorderSizePixel = 0
tabList.CanvasSize = UDim2.new(0, 0, 0, 480)
tabList.ScrollBarThickness = 3
tabList.Parent = mainFrame

local tabListCorner = Instance.new("UICorner")
tabListCorner.CornerRadius = UDim.new(0, 12)
tabListCorner.Parent = tabList

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 6)
tabListLayout.Parent = tabList

local containerFrame = Instance.new("Frame")
containerFrame.Name = "ContainerFrame"
containerFrame.Size = UDim2.new(1, -203, 1, -62)
containerFrame.Position = UDim2.new(0, 197, 0, 54)
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
    scroller.CanvasSize = UDim2.new(0, 0, 0, 1250)
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
    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(25, 12, 38)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 170, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.Code
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 38)
    frame.BackgroundColor3 = Color3.fromRGB(25, 12, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 170, 220)
    label.TextSize = 12
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local indicator = Instance.new("TextButton")
    indicator.Size = UDim2.new(0, 46, 0, 22)
    indicator.Position = UDim2.new(1, -54, 0.5, -11)
    indicator.BackgroundColor3 = state and Color3.fromRGB(255, 40, 130) or Color3.fromRGB(50, 20, 65)
    indicator.BorderSizePixel = 0
    indicator.Text = state and "BẬT" or "TẮT"
    indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
    indicator.TextSize = 11
    indicator.Font = Enum.Font.Code
    indicator.Parent = frame

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 6)
    indCorner.Parent = indicator

    indicator.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(255, 40, 130) or Color3.fromRGB(50, 20, 65)
        indicator.Text = state and "BẬT" or "TẮT"
        callback(state)
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(25, 12, 38)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -28, 0, 22)
    label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(255, 170, 220)
    label.TextSize = 12
    label.Font = Enum.Font.Code
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -28, 0, 12)
    sliderBg.Position = UDim2.new(0, 14, 0, 36)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 20, 65)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 6)
    sliderCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 40, 130)
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
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(25, 12, 38)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 170, 220)
    btn.TextSize = 12
    btn.Font = Enum.Font.Code
    btn.Parent = tabList

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        clearContainers()
        scroller.Visible = true
    end)
end

local tabNames = {"Di chuyển", "Chiến đấu", "Xuyên tường (ESP)", "Thế giới", "Dịch chuyển & Cam", "Đồ họa & FPS", "Khác & Hướng dẫn"}
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

-- 1. DI CHUYỂN
local walkSpeedEnabled = false
local walkSpeedVal = 16
createToggle(movementTab, "Tốc độ chạy", false, function(state)
    walkSpeedEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(movementTab, "Mức độ tốc độ", 16, 250, 16, function(val)
    walkSpeedVal = val
end)

local jumpPowerEnabled = false
local jumpPowerVal = 50
createToggle(movementTab, "Nhảy cao", false, function(state)
    jumpPowerEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider(movementTab, "Mức độ nhảy cao", 50, 500, 50, function(val)
    jumpPowerVal = val
end)

local flyEnabled = false
local flySpeed = 50
createToggle(movementTab, "Chế độ bay tự do", false, function(state)
    flyEnabled = state
end)
createSlider(movementTab, "Tốc độ bay", 10, 200, 50, function(val)
    flySpeed = val
end)

local noclipEnabled = false
createToggle(movementTab, "Đi xuyên tường (Noclip)", false, function(state)
    noclipEnabled = state
end)

-- 2. CHIẾN ĐẤU (SMOOTH AIM MƯỢT ƯU TIÊN GẦN NHẤT)
local smoothAimEnabled = false
local aimSmoothness = 6
createToggle(combatTab, "Tự động bám mượt (Smooth Aim)", false, function(state)
    smoothAimEnabled = state
end)
createSlider(combatTab, "Độ trễ mượt camera (Càng cao càng mượt)", 1, 20, 6, function(val)
    aimSmoothness = val
end)

local selectedBodyPart = "Head"
local bodyPartsList = {"Head", "HumanoidRootPart", "UpperTorso"}
local bpIndex = 1
createButton(combatTab, "Bộ phận ngắm: Đầu (Đổi)", function()
    bpIndex = bpIndex % #bodyPartsList + 1
    selectedBodyPart = bodyPartsList[bpIndex]
end)

local triggerBot = false
createToggle(combatTab, "Tự động tấn công (Triggerbot)", false, function(state)
    triggerBot = state
end)

-- 3. ESP
local espBoxEnabled = false
local espNameEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espLinesEnabled = false

createToggle(espTab, "Khung ESP quanh người", false, function(state) espBoxEnabled = state end)
createToggle(espTab, "Hiển thị tên người chơi", false, function(state) espNameEnabled = state end)
createToggle(espTab, "Hiển thị thanh máu (HP)", false, function(state) espHealthEnabled = state end)
createToggle(espTab, "Hiển thị khoảng cách (Mét)", false, function(state) espDistanceEnabled = state end)
createToggle(espTab, "Kẻ đường chỉ hướng (Tracer)", false, function(state) espLinesEnabled = state end)

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
                    box.Color = Color3.fromRGB(255, 40, 130)
                    box.Thickness = 1.5
                    box.Filled = false
                    table.insert(espDrawingCache, box)
                end

                if espLinesEnabled then
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.fromRGB(255, 40, 130)
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
                    txt.Size = 12
                    txt.Color = Color3.fromRGB(255, 175, 220)
                    txt.Center = true
                    txt.Outline = true
                    txt.Position = Vector2.new(pos.X, topPos.Y - 18)
                    table.insert(espDrawingCache, txt)
                end
            end
        end
    end
end)

-- 4. THẾ GIỚI
local godMode = false
createToggle(worldTab, "Bất tử hoàn toàn", false, function(state)
    godMode = state
end)

local shieldEnabled = false
createToggle(worldTab, "Lá chắn bảo vệ & Hào quang lửa", false, function(state)
    shieldEnabled = state
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if state then
            local fire = Instance.new("Fire")
            fire.Name = "HubShieldFire"
            fire.Size = 9
            fire.Color = Color3.fromRGB(255, 40, 130)
            fire.Parent = LocalPlayer.Character.HumanoidRootPart
            local part = Instance.new("Part")
            part.Name = "HubShieldBall"
            part.Size = Vector3.new(6, 6, 6)
            part.Shape = Enum.PartType.Ball
            part.Material = Enum.Material.Neon
            part.Color = Color3.fromRGB(255, 40, 130)
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
createToggle(worldTab, "Kháng dung nham & Hố tử thần", false, function(state)
    lavaImmune = state
end)

local waterWalk = false
createToggle(worldTab, "Đi trên mặt nước", false, function(state)
    waterWalk = state
end)

-- 5. DỊCH CHUYỂN & CAM
local selectedTargetPlayer = nil
createButton(spectateTab, "Chọn người chơi tiếp theo", function()
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

createButton(spectateTab, "Theo dõi camera người chơi", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = selectedTargetPlayer.Character.Humanoid
    end
end)

createButton(spectateTab, "Đặt lại camera về bản thân", function()
    selectedTargetPlayer = nil
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

createButton(spectateTab, "Dịch chuyển đến người chơi", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTargetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

-- 6. ĐỒ HỌA & FPS
local fullBright = false
createToggle(visualsTab, "Sáng toàn bản đồ (Fullbright)", false, function(state)
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
createToggle(visualsTab, "Nhìn xuyên tường (X-Ray)", false, function(state)
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

createButton(visualsTab, "Tăng FPS & Giảm lag toàn bộ", function()
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

-- 7. KHÁC & HƯỚNG DẪN
local autoChatEnabled = false
local chatMessages = {"KhoaDiemHub Pro đang hoạt động!", "Trần Khoa Điềm là lập trình viên xuất sắc nhất", "Universal Roblox Hub"}
createToggle(otherTab, "Tự động nhắn tin kênh chung", false, function(state)
    autoChatEnabled = state
end)

createButton(otherTab, "Mở Telegram: @TranKhoaDiem", function()
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

createButton(otherTab, "Xem hướng dẫn sử dụng", function()
    local guideGui = Instance.new("Frame")
    guideGui.Size = UDim2.new(0, 460, 0, 280)
    guideGui.Position = UDim2.new(0.5, -230, 0.5, -140)
    guideGui.BackgroundColor3 = Color3.fromRGB(14, 8, 20)
    guideGui.BorderSizePixel = 0
    guideGui.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = guideGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 40, 130)
    stroke.Thickness = 2.5
    stroke.Parent = guideGui

    local scroller = Instance.new("ScrollingFrame")
    scroller.Size = UDim2.new(1, -28, 1, -80)
    scroller.Position = UDim2.new(0, 14, 0, 14)
    scroller.BackgroundTransparency = 1
    scroller.CanvasSize = UDim2.new(0, 0, 0, 360)
    scroller.ScrollBarThickness = 3
    scroller.Parent = guideGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -10, 0, 340)
    lbl.Position = UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "HƯỚNG DẪN SỬ DỤNG KHOADIEMHUB:\n\n1. Di chuyển: Điều chỉnh tốc độ chạy, bật nhảy cao, bay tự do và bật Noclip để đi xuyên tường dễ dàng.\n2. Chiến đấu: Kích hoạt Tự động bám mượt (Smooth Aim) ưu tiên mục tiêu gần nhất. Giúp lia góc nhìn tự nhiên, dễ dàng đổi mục tiêu khi cần thiết.\n3. Xuyên tường (ESP): Hiển thị khung hộp, tên, HP và khoảng cách của người chơi.\n4. Thế giới: Bật bất tử, khiên bảo vệ và kháng dung nham.\n5. Dịch chuyển & Cam: Theo dõi camera hoặc dịch chuyển đến người chơi.\n6. Đồ họa: Sáng màn hình, X-Ray và tăng FPS giảm lag.\n\nTác giả: Trần Khoa Điềm | Telegram: @TranKhoaDiem"
    lbl.TextColor3 = Color3.fromRGB(255, 180, 225)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Parent = scroller

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 130, 0, 38)
    closeBtn.Position = UDim2.new(0.5, -65, 1, -48)
    closeBtn.BackgroundColor3 = Color3.fromRGB(55, 18, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Đóng hướng dẫn"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.Code
    closeBtn.Parent = guideGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        guideGui:Destroy()
    end)
end)

createButton(otherTab, "Thông tin tác giả", function()
    local aboutGui = Instance.new("Frame")
    aboutGui.Size = UDim2.new(0, 440, 0, 250)
    aboutGui.Position = UDim2.new(0.5, -220, 0.5, -125)
    aboutGui.BackgroundColor3 = Color3.fromRGB(14, 8, 20)
    aboutGui.BorderSizePixel = 0
    aboutGui.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = aboutGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 40, 130)
    stroke.Thickness = 2.5
    stroke.Parent = aboutGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -28, 1, -60)
    lbl.Position = UDim2.new(0, 14, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = "Tên Script: KhoaDiemHub\nTác giả / Lập trình viên: Trần Khoa Điềm\nLiên hệ Telegram: @TranKhoaDiem\nTrạng thái: Phiên bản Beta đang phát triển.\n\nGiao diện độc quyền thiết kế riêng theo phong cách hiện đại đen hồng, hỗ trợ đầy đủ tiếng Việt có dấu, ảnh logo cục bộ khoadiem.jpeg và Smooth Aim thông minh."
    lbl.TextColor3 = Color3.fromRGB(255, 180, 225)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Code
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Parent = aboutGui

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 36)
    closeBtn.Position = UDim2.new(0.5, -60, 1, -44)
    closeBtn.BackgroundColor3 = Color3.fromRGB(55, 18, 40)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Đóng"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.Font = Enum.Font.Code
    closeBtn.Parent = aboutGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function()
        aboutGui:Destroy()
    end)
end)

-- VÒNG LẶP XỬ LÝ TÍNH NĂNG (MOVEMENT, NOCLIP, AIM, LAVA, WATER)
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

    if smoothAimEnabled then
        local closestTarget = nil
        local shortestDist = math.huge
        local mousePos = UserInputService:GetMouseLocation()

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(selectedBodyPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local targetPart = p.Character[selectedBodyPart]
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestTarget = targetPart
                    end
                end
            end
        end

        if closestTarget then
            local targetCFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
            Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1 / math.max(aimSmoothness, 1))
        end
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
