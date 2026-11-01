local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- XÓA GUI CŨ NẾU TỒN TẠI
if CoreGui:FindFirstChild("KhoaDiemHubNeo") then
    CoreGui.KhoaDiemHubNeo:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemHubNeo"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- TẢI VÀ XỬ LÝ ANH AVATAR (HỖ TRỢ LINK TIKTOK & TỰ ĐỘNG BẢO VỆ NẾU DIE LINK)
local avatarImageUrl = "https://p16-common-sign.tiktokcdn.com/tos-maliva-avt-0068/a335fecb9a7f08c741fee6456d896364~tplv-tiktokx-cropcenter:1080:1080.jpeg?dr=14579&refresh_token=33b982b1&x-expires=1793674800&x-signature=iAN9qEpUwXTx5NIGhyi25ZQTgFg%3D&t=4d5b0474&ps=13740610&shp=a5d48078&shcp=81f88b70&idc=my2"
local finalImageAsset = "rbxassetid://6031091004" -- Icon SVG dự phòng chất lượng cao

pcall(function()
    if writefile and getcustomasset then
        local fileName = "khoadiem_avatar.jpeg"
        if not isfile or not isfile(fileName) then
            local requestFunc = (syn and syn.request) or (http and http.request) or request
            if requestFunc then
                local res = requestFunc({Url = avatarImageUrl, Method = "GET"})
                if res and res.StatusCode == 200 and res.Body then
                    writefile(fileName, res.Body)
                end
            end
        end
        if isfile and isfile(fileName) then
            finalImageAsset = getcustomasset(fileName)
        end
    end
end)

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

-- =======================================================
-- 1. MÀN HÌNH MỞ ĐẦU (INTRO SCREEN SANG TRỌNG CỰC ĐẸP)
-- =======================================================
local introFrame = Instance.new("Frame")
introFrame.Name = "IntroFrame"
introFrame.Size = UDim2.new(0, 480, 0, 260)
introFrame.Position = UDim2.new(0.5, -240, 0.5, -130)
introFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
introFrame.BackgroundTransparency = 1
introFrame.BorderSizePixel = 0
introFrame.Parent = ScreenGui

local introCorner = Instance.new("UICorner")
introCorner.CornerRadius = UDim.new(0, 24)
introCorner.Parent = introFrame

local introStroke = Instance.new("UIStroke")
introStroke.Color = Color3.fromRGB(255, 50, 150)
introStroke.Thickness = 2.5
introStroke.Transparency = 1
introStroke.Parent = introFrame

-- Avatar tròn ở Intro
local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 70, 0, 70)
avatarImg.Position = UDim2.new(0.5, -35, 0, 20)
avatarImg.BackgroundColor3 = Color3.fromRGB(25, 15, 35)
avatarImg.BorderSizePixel = 0
avatarImg.Image = finalImageAsset
avatarImg.ImageTransparency = 1
avatarImg.Parent = introFrame

local avatarCorner = Instance.new("UICorner")
avatarCorner.CornerRadius = UDim.new(1, 0)
avatarCorner.Parent = avatarImg

local avatarStroke = Instance.new("UIStroke")
avatarStroke.Color = Color3.fromRGB(255, 80, 180)
avatarStroke.Thickness = 2
avatarStroke.Transparency = 1
avatarStroke.Parent = avatarImg

local introTitle = Instance.new("TextLabel")
introTitle.Size = UDim2.new(1, 0, 0, 30)
introTitle.Position = UDim2.new(0, 0, 0, 98)
introTitle.BackgroundTransparency = 1
introTitle.Text = "KHOADIEMHUB NEO"
introTitle.TextColor3 = Color3.fromRGB(255, 120, 210)
introTitle.TextSize = 20
introTitle.Font = Enum.Font.GothamBold
introTitle.TextTransparency = 1
introTitle.Parent = introFrame

local introScroller = Instance.new("ScrollingFrame")
introScroller.Size = UDim2.new(1, -40, 0, 110)
introScroller.Position = UDim2.new(0, 20, 0, 132)
introScroller.BackgroundColor3 = Color3.fromRGB(22, 12, 36)
introScroller.BackgroundTransparency = 1
introScroller.BorderSizePixel = 0
introScroller.CanvasSize = UDim2.new(0, 0, 0, 200)
introScroller.ScrollBarThickness = 2
introScroller.Parent = introFrame

local introScrollerCorner = Instance.new("UICorner")
introScrollerCorner.CornerRadius = UDim.new(0, 12)
introScrollerCorner.Parent = introScroller

local introText = Instance.new("TextLabel")
introText.Size = UDim2.new(1, -16, 0, 190)
introText.Position = UDim2.new(0, 8, 0, 8)
introText.BackgroundTransparency = 1
introText.TextColor3 = Color3.fromRGB(235, 200, 235)
introText.TextSize = 12
introText.Font = Enum.Font.Gotham
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
    "Trạng thái: Khởi chạy thành công hệ thống NEO!\nTài khoản: %s (%s)\nGame: %s\nThời gian: %s\nThiết bị: %s | Executor: %s\nLevel: %s\nTác giả: Trần Khoa Điềm | Telegram: @TranKhoaDiem",
    LocalPlayer.Name, LocalPlayer.DisplayName, gameName, currentTime, getDeviceType(), getExecutorName(), levelStr
)

-- ANIMATION MỞ MÀN MỚI
TweenService:Create(introFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
TweenService:Create(introStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 0}):Play()
TweenService:Create(avatarImg, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {ImageTransparency = 0}):Play()
TweenService:Create(avatarStroke, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 0}):Play()
TweenService:Create(introTitle, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()
TweenService:Create(introScroller, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {BackgroundTransparency = 0.5}):Play()
TweenService:Create(introText, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {TextTransparency = 0}):Play()

task.wait(3.5)

TweenService:Create(introFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 1}):Play()
TweenService:Create(introStroke, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Transparency = 1}):Play()
TweenService:Create(avatarImg, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
TweenService:Create(introTitle, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
TweenService:Create(introText, TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {TextTransparency = 1}):Play()
task.wait(0.4)
introFrame:Destroy()

-- =======================================================
-- 2. NÚT MỞ MENU & GIAO DIỆN NEO MỚI HOÀN TOÀN
-- =======================================================
local mainButton = Instance.new("ImageButton")
mainButton.Name = "MainButtonNeo"
mainButton.Size = UDim2.new(0, 56, 0, 56)
mainButton.Position = UDim2.new(0, 25, 0, 25)
mainButton.BackgroundColor3 = Color3.fromRGB(20, 10, 30)
mainButton.BorderSizePixel = 0
mainButton.Image = finalImageAsset
mainButton.Parent = ScreenGui

local mainBtnCorner = Instance.new("UICorner")
mainBtnCorner.CornerRadius = UDim.new(1, 0)
mainBtnCorner.Parent = mainButton

local mainBtnStroke = Instance.new("UIStroke")
mainBtnStroke.Color = Color3.fromRGB(255, 50, 150)
mainBtnStroke.Thickness = 2.5
mainBtnStroke.Parent = mainButton

-- GIAO DIỆN CHÍNH (NEO GLASS STYLE)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 760, 0, 480)
mainFrame.Position = UDim2.new(0.5, -380, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(14, 9, 22)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = ScreenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 20)
mainFrameCorner.Parent = mainFrame

local mainFrameStroke = Instance.new("UIStroke")
mainFrameStroke.Color = Color3.fromRGB(255, 50, 150)
mainFrameStroke.Thickness = 2.5
mainFrameStroke.Transparency = 1
mainFrameStroke.Parent = mainFrame

mainButton.MouseButton1Click:Connect(function()
    if mainFrame.Visible then
        TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(mainFrameStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {Transparency = 1}):Play()
        task.wait(0.25)
        mainFrame.Visible = false
    else
        mainFrame.Visible = true
        mainFrame.BackgroundTransparency = 1
        mainFrameStroke.Transparency = 1
        TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0.05}):Play()
        TweenService:Create(mainFrameStroke, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    end
end)

-- TOPBAR
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 52)
topBar.BackgroundColor3 = Color3.fromRGB(22, 12, 36)
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 20)
topBarCorner.Parent = topBar

local topAvatar = Instance.new("ImageLabel")
topAvatar.Size = UDim2.new(0, 36, 0, 36)
topAvatar.Position = UDim2.new(0, 12, 0, 8)
topAvatar.BackgroundTransparency = 1
topAvatar.Image = finalImageAsset
topAvatar.Parent = topBar

local topAvatarCorner = Instance.new("UICorner")
topAvatarCorner.CornerRadius = UDim.new(1, 0)
topAvatarCorner.Parent = topAvatar

local topBarTitle = Instance.new("TextLabel")
topBarTitle.Size = UDim2.new(1, -120, 1, 0)
topBarTitle.Position = UDim2.new(0, 56, 0, 0)
topBarTitle.BackgroundTransparency = 1
topBarTitle.Text = "KhoaDiemHub Neo • Bản Đời Mới | Trần Khoa Điềm"
topBarTitle.TextColor3 = Color3.fromRGB(255, 140, 220)
topBarTitle.TextSize = 13
topBarTitle.Font = Enum.Font.GothamBold
topBarTitle.TextXAlignment = Enum.TextXAlignment.Left
topBarTitle.Parent = topBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 36, 0, 36)
closeButton.Position = UDim2.new(1, -44, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(60, 20, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "✕"
closeButton.TextColor3 = Color3.fromRGB(255, 120, 170)
closeButton.TextSize = 14
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = topBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 10)
closeCorner.Parent = closeButton

closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
end)

-- TAB NAVIGATION (CỘT BÊN TRÁI HÌNH CARD TRÒN)
local tabList = Instance.new("ScrollingFrame")
tabList.Name = "TabList"
tabList.Size = UDim2.new(0, 180, 1, -66)
tabList.Position = UDim2.new(0, 10, 0, 58)
tabList.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
tabList.BackgroundTransparency = 0.3
tabList.BorderSizePixel = 0
tabList.CanvasSize = UDim2.new(0, 0, 0, 420)
tabList.ScrollBarThickness = 2
tabList.Parent = mainFrame

local tabListCorner = Instance.new("UICorner")
tabListCorner.CornerRadius = UDim.new(0, 14)
tabListCorner.Parent = tabList

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 6)
tabListLayout.Parent = tabList

local containerFrame = Instance.new("Frame")
containerFrame.Name = "ContainerFrame"
containerFrame.Size = UDim2.new(1, -204, 1, -66)
containerFrame.Position = UDim2.new(0, 196, 0, 58)
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
    scroller.CanvasSize = UDim2.new(0, 0, 0, 1150)
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
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(24, 14, 42)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 185, 235)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, defaultState, callback)
    local state = defaultState
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(24, 14, 42)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -65, 1, 0)
    label.Position = UDim2.new(0, 14, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 185, 235)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local indicator = Instance.new("TextButton")
    indicator.Size = UDim2.new(0, 46, 0, 22)
    indicator.Position = UDim2.new(1, -54, 0.5, -11)
    indicator.BackgroundColor3 = state and Color3.fromRGB(255, 50, 150) or Color3.fromRGB(50, 20, 70)
    indicator.BorderSizePixel = 0
    indicator.Text = state and "BẬT" or "TẮT"
    indicator.TextColor3 = Color3.fromRGB(255, 255, 255)
    indicator.TextSize = 10
    indicator.Font = Enum.Font.GothamBold
    indicator.Parent = frame

    local indCorner = Instance.new("UICorner")
    indCorner.CornerRadius = UDim.new(0, 8)
    indCorner.Parent = indicator

    indicator.MouseButton1Click:Connect(function()
        state = not state
        indicator.BackgroundColor3 = state and Color3.fromRGB(255, 50, 150) or Color3.fromRGB(50, 20, 70)
        indicator.Text = state and "BẬT" or "TẮT"
        callback(state)
    end)

    return frame
end

local function createSlider(parent, text, min, max, default, callback)
    local value = default
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 58)
    frame.BackgroundColor3 = Color3.fromRGB(24, 14, 42)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -28, 0, 22)
    label.Position = UDim2.new(0, 14, 0, 6)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. tostring(value)
    label.TextColor3 = Color3.fromRGB(255, 185, 235)
    label.TextSize = 12
    label.Font = Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local sliderBg = Instance.new("TextButton")
    sliderBg.Size = UDim2.new(1, -28, 0, 10)
    sliderBg.Position = UDim2.new(0, 14, 0, 36)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 20, 70)
    sliderBg.BorderSizePixel = 0
    sliderBg.Text = ""
    sliderBg.Parent = frame

    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 5)
    sliderCorner.Parent = sliderBg

    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((value - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 150)
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
    btn.Size = UDim2.new(1, -12, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(24, 14, 42)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 185, 235)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
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

-- =======================================================
-- 3. KHỞI TẠO TÍNH NĂNG (AIM TẮT MẶC ĐỊNH FIX TRIỆT ĐỂ)
-- =======================================================
local walkSpeedEnabled = false
local walkSpeedVal = 16
createToggle(movementTab, "Tốc độ chạy", false, function(state)
    walkSpeedEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
createSlider(movementTab, "Mức độ tốc độ", 16, 250, 16, function(val) walkSpeedVal = val end)

local jumpPowerEnabled = false
local jumpPowerVal = 50
createToggle(movementTab, "Nhảy cao", false, function(state)
    jumpPowerEnabled = state
    if not state and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
createSlider(movementTab, "Mức độ nhảy cao", 50, 500, 50, function(val) jumpPowerVal = val end)

local flyEnabled = false
local flySpeed = 50
createToggle(movementTab, "Chế độ bay tự do", false, function(state) flyEnabled = state end)
createSlider(movementTab, "Tốc độ bay", 10, 200, 50, function(val) flySpeed = val end)

local noclipEnabled = false
createToggle(movementTab, "Đi xuyên tường (Noclip)", false, function(state) noclipEnabled = state end)

-- FIX AIM LỖI: ĐẢM BẢO BIẾN LUÔN BẰNG FALSE MẶC ĐỊNH
local smoothAimEnabled = false
local aimSmoothness = 6
createToggle(combatTab, "Tự động bám mượt (Smooth Aim)", false, function(state)
    smoothAimEnabled = state
end)
createSlider(combatTab, "Độ trễ mượt camera", 1, 20, 6, function(val)
    aimSmoothness = val
end)

local selectedBodyPart = "Head"
local bodyPartsList = {"Head", "HumanoidRootPart", "UpperTorso"}
local bpIndex = 1
createButton(combatTab, "Bộ phận ngắm: Đầu (Đổi)", function()
    bpIndex = bpIndex % #bodyPartsList + 1
    selectedBodyPart = bodyPartsList[bpIndex]
end)

-- ESP TÍNH NĂNG
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
                local topPos, _ = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1, 0))
                local bottomPos, _ = Camera:WorldToViewportPoint(root.Position - Vector3.new(0, 3, 0))
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height / 2

                if espBoxEnabled then
                    local box = Drawing.new("Square")
                    box.Visible = true
                    box.Size = Vector2.new(width, height)
                    box.Position = Vector2.new(pos.X - width / 2, topPos.Y)
                    box.Color = Color3.fromRGB(255, 50, 150)
                    box.Thickness = 1.5
                    box.Filled = false
                    table.insert(espDrawingCache, box)
                end

                if espLinesEnabled then
                    local line = Drawing.new("Line")
                    line.Visible = true
                    line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    line.To = Vector2.new(pos.X, pos.Y)
                    line.Color = Color3.fromRGB(255, 50, 150)
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
                    txt.Color = Color3.fromRGB(255, 185, 235)
                    txt.Center = true
                    txt.Outline = true
                    txt.Position = Vector2.new(pos.X, topPos.Y - 18)
                    table.insert(espDrawingCache, txt)
                end
            end
        end
    end
end)

-- THẾ GIỚI & DỊCH CHUYỂN
local godMode = false
createToggle(worldTab, "Bất tử hoàn toàn", false, function(state) godMode = state end)

local lavaImmune = false
createToggle(worldTab, "Kháng dung nham & Hố tử thần", false, function(state) lavaImmune = state end)

local waterWalk = false
createToggle(worldTab, "Đi trên mặt nước", false, function(state) waterWalk = state end)

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

-- ĐỒ HỌA
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

createButton(visualsTab, "Tăng FPS & Giảm lag toàn bộ", function()
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

createButton(otherTab, "Xem hướng dẫn sử dụng", function()
    local guideGui = Instance.new("Frame")
    guideGui.Size = UDim2.new(0, 440, 0, 260)
    guideGui.Position = UDim2.new(0.5, -220, 0.5, -130)
    guideGui.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
    guideGui.BorderSizePixel = 0
    guideGui.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = guideGui

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 50, 150)
    stroke.Thickness = 2
    stroke.Parent = guideGui

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -24, 1, -60)
    lbl.Position = UDim2.new(0, 12, 0, 12)
    lbl.BackgroundTransparency = 1
    lbl.Text = "HƯỚNG DẪN KHOADIEMHUB NEO:\n\n1. Di chuyển: Chỉnh tốc độ, nhảy cao, bay tự do và Noclip đi xuyên tường.\n2. Chiến đấu: Smooth Aim (Bám mượt ưu tiên gần nhất) ĐÃ ĐƯỢC FIX HOÀN TOÀN - Chỉ hoạt động khi bạn bấm BẬT.\n3. ESP & Đồ họa: Xuyên tường, soi HP và giảm lag tăng FPS.\n\nTác giả: Trần Khoa Điềm | Telegram: @TranKhoaDiem"
    lbl.TextColor3 = Color3.fromRGB(255, 185, 235)
    lbl.TextSize = 12
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextYAlignment = Enum.TextYAlignment.Top
    lbl.TextWrapped = true
    lbl.Parent = guideGui

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 120, 0, 36)
    closeBtn.Position = UDim2.new(0.5, -60, 1, -44)
    closeBtn.BackgroundColor3 = Color3.fromRGB(60, 20, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "Đóng"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Parent = guideGui

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 10)
    btnCorner.Parent = closeBtn

    closeBtn.MouseButton1Click:Connect(function() guideGui:Destroy() end)
end)

-- =======================================================
-- 4. VÒNG LẶP RENDERSTEPPED (ĐÃ ĐỐI CHIẾU FIX AIM RÕ RÀNG)
-- =======================================================
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

    -- CHỈ BÁM AIM KHI TÍNH NĂNG ĐÃ ĐƯỢC BẬT (CHẮC CHẮN 100%)
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
