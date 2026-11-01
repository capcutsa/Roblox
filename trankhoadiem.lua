local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("KhoaDiemHubUltimateV4") then
    CoreGui.KhoaDiemHubUltimateV4:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemHubUltimateV4"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local defaultSvgIcon = "rbxassetid://6031091000"

local function getExecutorName()
    if identifyexecutor then
        local name, ver = identifyexecutor()
        return name .. " " .. tostring(ver)
    elseif syn then return "Synapse X"
    elseif KRNL_LOADED then return "KRNL"
    elseif Fluxus then return "Fluxus"
    elseif Delta then return "Delta"
    elseif Hydrogen then return "Hydrogen"
    else return "Unknown Executor"
    end
end

local function getDeviceType()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
        return "Điện thoại / Tablet"
    elseif UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
        return "Máy tính (PC)"
    else
        return "Khác / Console"
    end
end

local function makeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging = false
    local dragInput, dragStart, startPos

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = guiObject.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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
            guiObject.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

local introFrame = Instance.new("Frame")
introFrame.Name = "IntroFrame"
introFrame.Size = UDim2.new(0, 460, 0, 260)
introFrame.Position = UDim2.new(0.5, -230, 0.5, -130)
introFrame.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
introFrame.BackgroundTransparency = 1
introFrame.BorderSizePixel = 0
introFrame.Parent = ScreenGui

local introCorner = Instance.new("UICorner")
introCorner.CornerRadius = UDim.new(0, 20)
introCorner.Parent = introFrame

local introStroke = Instance.new("UIStroke")
introStroke.Color = Color3.fromRGB(140, 80, 255)
introStroke.Thickness = 2.5
introStroke.Transparency = 1
introStroke.Parent = introFrame

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 40)
introTitle.Position = UDim2.new(0, 0, 0, 20)
introTitle.BackgroundTransparency = 1
introTitle.Text = "KHOADIEMHUB ULTIMATE V4"
introTitle.TextColor3 = Color3.fromRGB(180, 120, 255)
introTitle.TextSize = 20
introTitle.Font = Enum.Font.GothamBold
introTitle.TextTransparency = 1
introTitle.Parent = introFrame

local introScroller = Instance.new("ScrollingFrame")
introScroller.Size = UDim2.new(1, -44, 0, 150)
introScroller.Position = UDim2.new(0, 22, 0, 75)
introScroller.BackgroundColor3 = Color3.fromRGB(26, 16, 40)
introScroller.BackgroundTransparency = 1
introScroller.BorderSizePixel = 0
introScroller.CanvasSize = UDim2.new(0, 0, 0, 220)
introScroller.ScrollBarThickness = 2
introScroller.Parent = introFrame

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, -14, 0, 200)
introText.Position = UDim2.new(0, 7, 0, 7)
introText.BackgroundTransparency = 1
introText.TextColor3 = Color3.fromRGB(220, 200, 240)
introText.TextSize = 12
introText.Font = Enum.Font.GothamMedium
introText.TextXAlignment = Enum.TextXAlignment.Left
introText.TextYAlignment = Enum.TextYAlignment.Top
introText.TextWrapped = true
introText.TextTransparency = 1
introText.Parent = introScroller

local currentTime = os.date("%d/%m/%Y %H:%M:%S")
local currentPlaceId = game.PlaceId
local gameName = "Roblox Place " .. tostring(currentPlaceId)
pcall(function()
    local MarketplaceService = game:GetService("MarketplaceService")
    local info = MarketplaceService:GetProductInfo(currentPlaceId)
    if info and info.Name then gameName = info.Name end
end)

local levelStr = "Không có"
pcall(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Data") and LocalPlayer.Character.Data:FindFirstChild("Level") then
        levelStr = tostring(LocalPlayer.Character.Data.Level.Value)
    elseif LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Level") then
        levelStr = tostring(LocalPlayer.leaderstats.Level.Value)
    end
end)

introText.Text = string.format(
    "Trạng thái: Tải hệ thống Ultimate V4 thành công!\nTài khoản: %s (%s)\nGame: %s\nThời gian: %s\nThiết bị: %s | Executor: %s\nLevel: %s\nTác giả: Trần Khoa Điềm | Telegram: @TranKhoaDiem",
    LocalPlayer.Name, LocalPlayer.DisplayName, gameName, currentTime, getDeviceType(), getExecutorName(), levelStr
)

TweenService:Create(introFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
TweenService:Create(introStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
TweenService:Create(introTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(introScroller, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.4}):Play()
TweenService:Create(introText, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

task.wait(3.2)

TweenService:Create(introFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
TweenService:Create(introStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
TweenService:Create(introTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(introText, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
task.wait(0.4)
introFrame:Destroy()

local mainButton = Instance.new("ImageButton")
mainButton.Name = "MainButtonUltimate"
mainButton.Size = UDim2.new(0, 52, 0, 52)
mainButton.Position = UDim2.new(0, 25, 0, 25)
mainButton.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
mainButton.BorderSizePixel = 0
mainButton.Image = defaultSvgIcon
mainButton.ImageColor3 = Color3.fromRGB(160, 100, 255)
mainButton.Parent = ScreenGui

makeDraggable(mainButton)

local mainBtnCorner = Instance.new("UICorner")
mainBtnCorner.CornerRadius = UDim.new(1, 0)
mainBtnCorner.Parent = mainButton

local mainBtnStroke = Instance.new("UIStroke")
mainBtnStroke.Color = Color3.fromRGB(140, 80, 255)
mainBtnStroke.Thickness = 2.5
mainBtnStroke.Parent = mainButton

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 720, 0, 460)
mainFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 20)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 18)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = Color3.fromRGB(140, 80, 255)
mainFrameStroke.Thickness = 2.5
mainFrameStroke.Transparency = 1
mainFrameStroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 50)
topBar.BackgroundColor3 = Color3.fromRGB(22, 14, 36)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

makeDraggable(mainFrame, topBar)

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 18)
topBarCorner.Parent = topBar

local topIcon = Instance.new("ImageLabel")
topIcon.Size = UDim2.new(0, 28, 0, 28)
topIcon.Position = UDim2.new(0, 16, 0, 11)
topIcon.BackgroundTransparency = 1
topIcon.Image = defaultSvgIcon
topIcon.ImageColor3 = Color3.fromRGB(160, 100, 255)
topIcon.Parent = topBar

local topBarTitle = Instance.new("TextLabel")
topBarTitle.Size = UDim2.new(1, -120, 1, 0)
topBarTitle.Position = UDim2.new(0, 54, 0, 0)
topBarTitle.BackgroundTransparency = 1
topBarTitle.Text = "KhoaDiemHub Ultimate V4 • Purple Matrix"
topBarTitle.TextColor3 = Color3.fromRGB(240, 230, 255)
topBarTitle.TextSize = 13
topBarTitle.Font = Enum.Font.GothamBold
topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
topBarTitle.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 34, 0, 34)
closeButton.Position = UDim2.new(1, -42, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(50, 20, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 120, 180)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

mainButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(mainFrameStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
        task.wait(0.25)
        mainFrame.Visible = false
    else
        mainFrame.Visible = true
        mainFrame.BackgroundTransparency = 1
        mainFrameStroke.Transparency = 1
        TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02}):Play()
        TweenService:Create(mainFrameStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    end
end)

local tabList = Instance.new("ScrollingFrame")
tabList.Name = "TabList"
tabList.Size = UDim2.new(0, 175, 1, -64)
tabList.Position = UDim2.new(0, 12, 0, 58)
tabList.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
tabList.BackgroundTransparency = 0.3
tabList.BorderSizePixel = 0
tabList.CanvasSize = UDim2.new(0, 0, 0, 440)
tabList.ScrollBarThickness = 2
tabList.Parent = mainFrame

local tabListCorner = Instance.new("UICorner")
tabListCorner.CornerRadius = UDim.new(0, 14)
tabListCorner.Parent = tabList

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 5)
tabListLayout.Parent = tabList

local containerFrame = Instance.new("Frame")
containerFrame.Name = "ContainerFrame"
containerFrame.Size = UDim2.new(1, -202, 1, -64)
containerFrame.Position = UDim2.new(0, 198, 0, 58)
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
    scroller.CanvasSize = UDim2.new(0, 0, 0, 1400)
    scroller.ScrollBarThickness = 3
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
    btn.Size = UDim2.new(1, -12, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(24, 15, 40)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(235, 215, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
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
    frame.Size = UDim2.new(1, -12, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(24, 15, 40)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(235, 215, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local indicator = Instance.new("TextButton")
    indicator.Size = UDim2.new(0, 48, 0, 24)
    indicator.Position = UDim2.new(1, -56, 0.5, -12)
    indicator.BackgroundColor3 = state and Color3.fromRGB(140, 80, 255) or Color3.fromRGB(45, 25, 75)
    indicator.BorderSizePixel = 0
    indicator.Text = state and "ON" or "OFF"
    indicator.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 160, 210)
    indicator.TextSize = 11
    indicator.Font = Enum.Font.GothamBold
    indicator.Parent = frame

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 8)
    indCorner.Parent = indicator

    indicator.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(140, 80, 255) or Color3.fromRGB(45, 25, 75)
        indicator.TextColor3 = state and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(180, 160, 210)
        indicator.Text = state and "ON" or "OFF"
        callback(state)
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -12, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(24, 15, 40)
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
    label.TextColor3 = Color3.fromRGB(235, 215, 255)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -28, 0, 10)
    sliderBg.Position = UDim2.new(0, 14, 0, 36)
    sliderBg.BackgroundColor3 = Color3.fromRGB(45, 25, 75)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 5)
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
    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(24, 15, 40)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(215, 195, 245)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = tabList

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(function()
        clearContainers()
        scroller.Visible = true
    end)
end

local tabNames = {"Nhân vật & Di chuyển", "Chiến đấu & Aim", "Xuyên tường ESP", "Thế giới & Môi trường", "Dịch chuyển (Teleport)", "Đồ họa & Tiện ích", "Thông tin & Hướng dẫn"}
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
local worldTab = scrollers[4]
local tpTab = scrollers[5]
local visualsTab = scrollers[6]
local otherTab = scrollers[7]

local walkSpeedEnabled = false
local walkSpeedVal = 16
createToggle(charTab, "Tốc độ chạy siêu tốc", false, function(state)
    walkSpeedEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(charTab, "Mức độ tốc độ", 16, 350, 16, function(val) walkSpeedVal = val end)

local jumpPowerEnabled = false
local jumpPowerVal = 50
createToggle(charTab, "Nhảy cao đặc biệt", false, function(state)
    jumpPowerEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider(charTab, "Mức độ nhảy cao", 50, 700, 50, function(val) jumpPowerVal = val end)

local flyEnabled = false
local flySpeed = 50
createToggle(charTab, "Chế độ bay tự do (Fly)", false, function(state) flyEnabled = state end)
createSlider(charTab, "Tốc độ bay", 10, 300, 50, function(val) flySpeed = val end)

local noclipEnabled = false
createToggle(charTab, "Đi xuyên mọi tường (Noclip)", false, function(state) noclipEnabled = state end)

local infJumpEnabled = false
createToggle(charTab, "Nhảy vô hạn giữa không trung", false, function(state) infJumpEnabled = state end)

local bnitSpeed = false
createToggle(charTab, "Tự động lướt (Bunny Hop)", false, function(state) bnitSpeed = state end)

local smoothAimEnabled = false
local aimSmoothness = 6
createToggle(combatTab, "Tự động bám mượt (Smooth Aim)", false, function(state)
    smoothAimEnabled = state
end)
createSlider(combatTab, "Độ trễ mượt camera", 1, 20, 6, function(val) aimSmoothness = val end)

local selectedBodyPart = "Head"
local bodyPartsList = {"Head", "HumanoidRootPart", "UpperTorso"}
local bpIndex = 1
createButton(combatTab, "Bộ phận ngắm: Đầu (Ấn để đổi)", function()
    bpIndex = bpIndex % #bodyPartsList + 1
    selectedBodyPart = bodyPartsList[bpIndex]
end)

local triggerBotEnabled = false
createToggle(combatTab, "Tự động bắn/đánh mục tiêu (Triggerbot)", false, function(state) triggerBotEnabled = state end)

local fovCircleEnabled = false
local fovRadius = 120
createToggle(combatTab, "Vòng tròn tầm nhìn (FOV Circle)", false, function(state) fovCircleEnabled = state end)
createSlider(combatTab, "Bán kính vòng FOV", 40, 400, 120, function(val) fovRadius = val end)

local espBoxEnabled = false
local espNameEnabled = false
local espHealthEnabled = false
local espDistanceEnabled = false
local espLinesEnabled = false
local espChamsEnabled = false

createToggle(espTab, "Khung ESP 2D (Box)", false, function(state) espBoxEnabled = state end)
createToggle(espTab, "Hiển thị tên người chơi", false, function(state) espNameEnabled = state end)
createToggle(espTab, "Hiển thị thanh HP", false, function(state) espHealthEnabled = state end)
createToggle(espTab, "Hiển thị khoảng cách (Mét)", false, function(state) espDistanceEnabled = state end)
createToggle(espTab, "Đường chỉ hướng (Tracer Line)", false, function(state) espLinesEnabled = state end)
createToggle(espTab, "Highlight xuyên tường (Chams)", false, function(state)
    espChamsEnabled = state
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if state then
                if not p.Character:FindFirstChild("HubChamsUltimate") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "HubChamsUltimate"
                    hl.FillColor = Color3.fromRGB(140, 80, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                    hl.AlwaysOnTop = true
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("HubChamsUltimate") then
                    p.Character.HubChamsUltimate:Destroy()
                end
            end
        end
    end
end)

local espDrawingCache = {}
RunService.RenderStepped:Connect(function()
    for _, item in pairs(espDrawingCache) do
        if item and item.Remove then pcall(function() item:Remove() end) end
    end
    espDrawingCache = {}

    if not (espBoxEnabled or espNameEnabled or espHealthEnabled or espDistanceEnabled or espLinesEnabled) then return end
    if not Drawing then return end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChild("Humanoid") then
            local root = p.Character.HumanoidRootPart
            local head = p.Character:FindFirstChild("Head") or root
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
            if onScreen then
                local dist = (Camera.CFrame.Position - root.Position).Magnitude
                local topPos, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                local bottomPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height / 1.8

                if espBoxEnabled then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width / 2, topPos.Y)
                    box.Color = Color3.fromRGB(140, 80, 255)
                    box.Thickness = 1.5
                    box.Filled = false
                    table.insert(espDrawingCache, box)
                end

                if espLinesEnabled then
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.fromRGB(140, 80, 255)
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
                    txt.Size = 11
                    txt.Color = Color3.fromRGB(220, 190, 255)
                    txt.Center = true
                    txt.Outline = true
                    txt.Position = Vector2.new(pos.X, topPos.Y - 16)
                    table.insert(espDrawingCache, txt)
                end
            end
        end
    end
end)

local godMode = false
createToggle(worldTab, "Bất tử hoàn toàn (Godmode)", false, function(state) godMode = state end)

local lavaImmune = false
createToggle(worldTab, "Kháng dung nham & Hố tử thần", false, function(state) lavaImmune = state end)

local waterWalk = false
createToggle(worldTab, "Đi trên mặt nước (Water Walk)", false, function(state) waterWalk = state end)

local autoClicker = false
createToggle(worldTab, "Tự động Click chuột liên tục", false, function(state) autoClicker = state end)
task.spawn(function()
    while true do
        task.wait(0.04)
        if autoClicker then
            pcall(function() mouse1click() end)
        end
    end
end)

local selectedTargetPlayer = nil
createButton(tpTab, "Chọn mục tiêu tiếp theo", function()
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

createButton(tpTab, "Theo dõi Camera người chơi", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = selectedTargetPlayer.Character.Humanoid
    end
end)

createButton(tpTab, "Đặt lại Camera về bản thân", function()
    selectedTargetPlayer = nil
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

createButton(tpTab, "Dịch chuyển tức thời đến người chơi", function()
    if selectedTargetPlayer and selectedTargetPlayer.Character and selectedTargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTargetPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
        end
    end
end)

createButton(tpTab, "Lưu vị trí hiện tại (Save Pos)", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().SavedHubPosition = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end)
end)

createButton(tpTab, "Quay lại vị trí đã lưu (Load Pos)", function()
    pcall(function()
        if getgenv().SavedHubPosition and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().SavedHubPosition
        end
    end)
end)

createToggle(visualsTab, "Sáng toàn bản đồ (Fullbright)", false, function(state)
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

createButton(visualsTab, "Tăng FPS & Xóa hiệu ứng lag", function()
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

createButton(otherTab, "Xem hướng dẫn sử dụng chi tiết", function()
    local guideGui = Instance.new("Frame")
    guideGui.Size = UDim2.new(0, 440, 0, 280)
    guideGui.Position = UDim2.new(0.5, -220, 0.5, -140)
    guideGui.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
    guideGui.BorderSizePixel = 0
    guideGui.Parent = ScreenGui

    makeDraggable(guideGui)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = guideGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(140, 80, 255)
    stroke.Thickness = 2
    stroke.Parent = guideGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -28, 1, -64)
    lbl.Position = UDim2.new(0, 14, 0, 14)
    lbl.BackgroundTransparency = 1
    lbl.Text = "HƯỚNG DẪN KHOADIEMHUB ULTIMATE V4:\n\n1. Nhân vật: Tốc độ chạy siêu tốc, bay tự do, nhảy vô hạn, b-hop và noclip.\n2. Chiến đấu & Aim: Smooth Aim mượt mà, chỉ bám khi bạn BẬT.\n3. Xuyên tường ESP: Box, Tracer, HP bar & Chams Highlight.\n4. Thế giới & Khác: Godmode, kháng dung nham, tự động click.\n5. Dịch chuyển: Teleport người chơi, lưu và tải vị trí tiện lợi.\n\nTác giả: Trần Khoa Điềm | Telegram: @TranKhoaDiem"
    lbl.TextColor3 = Color3.fromRGB(230, 210, 250)
    lbl.TextSize = 11
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Parent = guideGui

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 36)
    closeBtn.Position = UDim2.new(0.5, -60, 1, -44)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 20, 60)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Đóng bảng"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = guideGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function() guideGui:Destroy() end)
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
        if bnitSpeed and humanoid.MoveDirection.Magnitude > 0 then
            rootPart.Velocity = Vector3.new(humanoid.MoveDirection.X * walkSpeedVal, rootPart.Velocity.Y, humanoid.MoveDirection.Z * walkSpeedVal)
        end
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
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVec = moveVec + Camera.CFrame.RightVector end
        rootPart.CFrame = rootPart.CFrame + (moveVec * (flySpeed * 0.05))
    end

    if smoothAimEnabled == true then
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

    if triggerBotEnabled then
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                local enemyPlayer = Players:GetPlayerFromCharacter(target.Parent)
                if enemyPlayer and enemyPlayer ~= LocalPlayer then
                    mouse1click()
                end
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
