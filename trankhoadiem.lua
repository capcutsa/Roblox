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

if CoreGui:FindFirstChild("KhoaDiemPureCustomV13") then
    CoreGui.KhoaDiemPureCustomV13:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemPureCustomV13"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local customMenuIcon = "rbxassetid://6031091000"

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

local floatingBtn = Instance.new("ImageButton")
floatingBtn.Name = "CustomMenuButton"
floatingBtn.Size = UDim2.new(0, 46, 0, 46)
floatingBtn.Position = UDim2.new(0, 25, 0, 25)
floatingBtn.BackgroundColor3 = Color3.fromRGB(12, 14, 20)
floatingBtn.BorderSizePixel = 0
floatingBtn.Image = customMenuIcon
floatingBtn.ImageColor3 = Color3.fromRGB(0, 210, 255)
floatingBtn.Parent = ScreenGui

makeDraggable(floatingBtn)

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 210, 255)
btnStroke.Thickness = 2
btnStroke.Parent = floatingBtn

local mainWin = Instance.new("Frame")
mainWin.Name = "MainWindow"
mainWin.Size = UDim2.new(0, 540, 0, 360)
mainWin.Position = UDim2.new(0.5, -270, 0.5, -180)
mainWin.BackgroundColor3 = Color3.fromRGB(8, 10, 15)
mainWin.BackgroundTransparency = 1
mainWin.BorderSizePixel = 0
mainWin.Visible = false
mainWin.Parent = ScreenGui

local winCorner = Instance.new("UICorner")
winCorner.CornerRadius = UDim.new(0, 12)
winCorner.Parent = mainWin

local winStroke = Instance.new("UIStroke")
winStroke.Color = Color3.fromRGB(0, 210, 255)
winStroke.Thickness = 1.5
winStroke.Transparency = 1
winStroke.Parent = mainWin

local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 38)
headerBar.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
headerBar.BorderSizePixel = 0
headerBar.Parent = mainWin

makeDraggable(mainWin, headerBar)

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerBar

local headerIcon = Instance.new("ImageLabel")
headerIcon.Size = UDim2.new(0, 20, 0, 20)
headerIcon.Position = UDim2.new(0, 10, 0, 9)
headerIcon.BackgroundTransparency = 1
headerIcon.Image = customMenuIcon
headerIcon.ImageColor3 = Color3.fromRGB(0, 210, 255)
headerIcon.Parent = headerBar

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -90, 1, 0)
headerTitle.Position = UDim2.new(0, 36, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "KhoaDiemHub • Custom Engine V13"
headerTitle.TextColor3 = Color3.fromRGB(230, 240, 255)
headerTitle.TextSize = 11
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = headerBar

local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 26, 0, 26)
exitBtn.Position = UDim2.new(1, -32, 0, 6)
exitBtn.BackgroundColor3 = Color3.fromRGB(25, 35, 55)
exitBtn.BorderSizePixel = 0
exitBtn.Text = "✕"
exitBtn.TextColor3 = Color3.fromRGB(0, 210, 255)
exitBtn.TextSize = 11
exitBtn.Font = Enum.Font.GothamBold
exitBtn.Parent = headerBar

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 6)
exitCorner.Parent = exitBtn

exitBtn.MouseButton1Click:Connect(function() mainWin.Visible = false end)

floatingBtn.MouseButton1Click:Connect(function()
    if mainWin.Visible then
        TweenService:Create(mainWin, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        TweenService:Create(winStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Transparency = 1}):Play()
        task.wait(0.2)
        mainWin.Visible = false
    else
        mainWin.Visible = true
        mainWin.BackgroundTransparency = 1
        winStroke.Transparency = 1
        TweenService:Create(mainWin, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02}):Play()
        TweenService:Create(winStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Transparency = 0}):Play()
    end
end)

local tabMenu = Instance.new("ScrollingFrame")
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 135, 1, -46)
tabMenu.Position = UDim2.new(0, 8, 0, 42)
tabMenu.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
tabMenu.BorderSizePixel = 0
tabMenu.CanvasSize = UDim2.new(0, 0, 0, 320)
tabMenu.ScrollBarThickness = 2
tabMenu.Parent = mainWin

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabMenu

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabMenu

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -155, 1, -46)
contentArea.Position = UDim2.new(0, 149, 0, 42)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainWin

local function hideAllTabs()
    for _, child in ipairs(contentArea:GetChildren()) do child.Visible = false end
end

local function makeTab(name)
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = name .. "Page"
    scroller.Size = UDim2.new(1, 0, 1, 0)
    scroller.BackgroundTransparency = 1
    scroller.CanvasSize = UDim2.new(0, 0, 0, 2000)
    scroller.ScrollBarThickness = 2
    scroller.Visible = false
    scroller.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroller

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 28)
    btn.BackgroundColor3 = Color3.fromRGB(14, 18, 26)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 205, 230)
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamMedium
    btn.Parent = tabMenu

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 5)
    c.Parent = btn

    btn.MouseButton1Click:Connect(function()
        hideAllTabs()
        scroller.Visible = true
    end)

    return scroller
end

local function makeButton(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 30)
    b.BackgroundColor3 = Color3.fromRGB(16, 21, 30)
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(210, 230, 250)
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = b
    b.MouseButton1Click:Connect(cb)
    return b
end

local function makeToggle(parent, text, default, cb)
    local state = default
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(16, 21, 30)
    f.BorderSizePixel = 0
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -46, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(210, 230, 250)
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local ind = Instance.new("TextButton")
    ind.Size = UDim2.new(0, 34, 0, 16)
    ind.Position = UDim2.new(1, -38, 0.5, -8)
    ind.BackgroundColor3 = state and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(30, 40, 60)
    ind.BorderSizePixel = 0
    ind.Text = state and "ON" or "OFF"
    ind.TextColor3 = state and Color3.fromRGB(8, 10, 15) or Color3.fromRGB(140, 165, 195)
    ind.TextSize = 8
    ind.Font = Enum.Font.GothamBold
    ind.Parent = f

    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 4)
    ic.Parent = ind

    ind.MouseButton1Click:Connect(function()
        state = not state
        ind.BackgroundColor3 = state and Color3.fromRGB(0, 210, 255) or Color3.fromRGB(30, 40, 60)
        ind.TextColor3 = state and Color3.fromRGB(8, 10, 15) or Color3.fromRGB(140, 165, 195)
        ind.Text = state and "ON" or "OFF"
        cb(state)
    end)
    return f
end

local function makeSlider(parent, text, min, max, default, cb)
    local val = default
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 42)
    f.BackgroundColor3 = Color3.fromRGB(16, 21, 30)
    f.BorderSizePixel = 0
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -12, 0, 16)
    l.Position = UDim2.new(0, 8, 0, 3)
    l.BackgroundTransparency = 1
    l.Text = text .. ": " .. tostring(val)
    l.TextColor3 = Color3.fromRGB(210, 230, 250)
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local bg = Instance.new("TextButton")
    bg.Size = UDim2.new(1, -16, 0, 6)
    bg.Position = UDim2.new(0, 8, 0, 26)
    bg.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
    bg.BorderSizePixel = 0
    bg.Text = ""
    bg.Parent = f

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 3)
    sc.Parent = bg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 210, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 3)
    fc.Parent = fill

    local dragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
        val = math.floor(min + ((max - min) * pos))
        fill.Size = UDim2.new(pos, 0, 1, 0)
        l.Text = text .. ": " .. tostring(val)
        cb(val)
    end

    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    return f
end

local function makeDropdown(parent, text, opts, cb)
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 30)
    f.BackgroundColor3 = Color3.fromRGB(16, 21, 30)
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundTransparency = 1
    btn.Text = text .. ": Chọn..."
    btn.TextColor3 = Color3.fromRGB(210, 230, 250)
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Position = UDim2.new(0, 8, 0, 0)
    btn.Parent = f

    local opened = false
    local subBtns = {}

    btn.MouseButton1Click:Connect(function()
        opened = not opened
        for _, b in ipairs(subBtns) do b:Destroy() end
        subBtns = {}
        local list = opts()
        if opened then
            f.Size = UDim2.new(1, -6, 0, 34 + #list * 24)
            for i, name in ipairs(list) do
                local sb = Instance.new("TextButton")
                sb.Size = UDim2.new(1, -16, 0, 22)
                sb.Position = UDim2.new(0, 8, 0, 30 + (i - 1) * 24)
                sb.BackgroundColor3 = Color3.fromRGB(22, 28, 40)
                sb.BorderSizePixel = 0
                sb.Text = name
                sb.TextColor3 = Color3.fromRGB(170, 200, 230)
                sb.TextSize = 9
                sb.Font = Enum.Font.Gotham
                sb.Parent = f

                local sbc = Instance.new("UICorner")
                sbc.CornerRadius = UDim.new(0, 4)
                sbc.Parent = sb

                sb.MouseButton1Click:Connect(function()
                    btn.Text = text .. ": " .. name
                    opened = false
                    f.Size = UDim2.new(1, -6, 0, 30)
                    cb(name)
                end)
                table.insert(subBtns, sb)
            end
        else
            f.Size = UDim2.new(1, -6, 0, 30)
        end
    end)
    return f
end

local t1 = makeTab("1. Di chuyển")
local t2 = makeTab("2. AimBot Center")
local t3 = makeTab("3. Sky Stand / Bay")
local t4 = makeTab("4. ESP Xuyên Tường")
local t5 = makeTab("5. TP All Players")
local t6 = makeTab("6. Thế giới")
local t7 = makeTab("7. Tiện ích 500+")

t1.Visible = true

local speedOn = false
local speedVal = 16
makeToggle(t1, "Tốc độ chạy siêu tốc", false, function(s)
    speedOn = s
    if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 16
    end
end)
makeSlider(t1, "Mức Tốc Độ", 16, 400, 16, function(v) speedVal = v end)

local jumpOn = false
local jumpVal = 50
makeToggle(t1, "Nhảy cao đặc biệt", false, function(s)
    jumpOn = s
    if not s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
    end
end)
makeSlider(t1, "Mức Độ Nhảy", 50, 700, 50, function(v) jumpVal = v end)

local noclipOn = false
makeToggle(t1, "Đi xuyên tường (Noclip)", false, function(s) noclipOn = s end)

local infJump = false
makeToggle(t1, "Nhảy vô hạn trên không", false, function(s) infJump = s end)

local aimCenterOn = false
local aimPartName = "Head"
makeToggle(t2, "Khóa Aim giữa màn hình", false, function(s) aimCenterOn = s end)
makeButton(t2, "Đổi Bộ Phận (Đầu / Thân)", function()
    if aimPartName == "Head" then aimPartName = "HumanoidRootPart" else aimPartName = "Head" end
end)

local trigBot = false
makeToggle(t2, "Tự động đánh khi chĩa tâm", false, function(s) trigBot = s end)

local autoClick = false
makeToggle(t2, "Auto Click chuột liên tục", false, function(s) autoClick = s end)
task.spawn(function()
    while true do
        task.wait(0.03)
        if autoClick then pcall(function() mouse1click() end) end
    end
end)

local skyStandOn = false
local skyH = 60
makeToggle(t3, "Bật Đứng Trên Không (Sky Stand)", false, function(s) skyStandOn = s end)
makeSlider(t3, "Độ cao đứng trên trời", 10, 500, 60, function(v) skyH = v end)

local flyOn = false
local flySpd = 50
makeToggle(t3, "Bay tự do (Free Fly)", false, function(s) flyOn = s end)
makeSlider(t3, "Tốc độ bay tự do", 10, 300, 50, function(v) flySpd = v end)

local espBox = false
local espName = false
local espHP = false
local espDist = false
local espChams = false

makeToggle(t4, "ESP Khung 2D (Box)", false, function(s) espBox = s end)
makeToggle(t4, "ESP Tên Người Chơi", false, function(s) espName = s end)
makeToggle(t4, "ESP Thanh Máu (HP)", false, function(s) espHP = s end)
makeToggle(t4, "ESP Khoảng Cách (m)", false, function(s) espDist = s end)
makeToggle(t4, "ESP Highlight Xuyên Tường", false, function(s)
    espChams = s
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if s then
                if not p.Character:FindFirstChild("CustomChamV13") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "CustomChamV13"
                    hl.FillColor = Color3.fromRGB(0, 210, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                    hl.AlwaysOnTop = true
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("CustomChamV13") then p.Character.CustomChamV13:Destroy() end
            end
        end
    end
end)

local espDrawings = {}
RunService.RenderStepped:Connect(function()
    for _, obj in pairs(espDrawings) do
        if obj and obj.Remove then pcall(function() obj:Remove() end) end
    end
    espDrawings = {}

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
                    local sq = Drawing.new("Square")
                    sq.Visible = true
                    sq.Size = Vector2.new(width, height)
                    sq.Position = Vector2.new(pos.X - width / 2, topPos.Y)
                    sq.Color = Color3.fromRGB(0, 210, 255)
                    sq.Thickness = 1
                    sq.Filled = false
                    table.insert(espDrawings, sq)
                end

                if espName or espHP or espDist then
                    local info = ""
                    if espName then info = info .. p.Name .. " " end
                    if espHP then info = info .. "[" .. math.floor(p.Character.Humanoid.Health) .. "HP] " end
                    if espDist then info = info .. "[" .. math.floor(dist) .. "m]" end

                    local tx = Drawing.new("Text")
                    tx.Visible = true
                    tx.Text = info
                    tx.Size = 10
                    tx.Color = Color3.fromRGB(220, 240, 255)
                    tx.Center = true
                    tx.Outline = true
                    tx.Position = Vector2.new(pos.X, topPos.Y - 14)
                    table.insert(espDrawings, tx)
                end
            end
        end
    end
end)

local targetPlayer = nil
local function getPlayerNames()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t, p.Name) end
    end
    return t
end

makeDropdown(t5, "Chọn Player cụ thể", getPlayerNames, function(name)
    targetPlayer = Players:FindFirstChild(name)
end)

makeButton(t5, "Bay tới trước mặt Target đã chọn", function()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame + (targetPlayer.Character.HumanoidRootPart.CFrame.LookVector * 4) + Vector3.new(0, 2, 0)
        end
    end
end)

makeButton(t5, "Bay ra trước mặt TẤT CẢ player trong Server", function()
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

makeButton(t5, "Xem Camera Target (Spectate)", function()
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = targetPlayer.Character.Humanoid
    end
end)

makeButton(t5, "Reset Camera về bản thân", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

local godOn = false
makeToggle(t6, "Bất tử hoàn toàn (God Mode)", false, function(s) godOn = s end)

local lavaOn = false
makeToggle(t6, "Kháng dung nham & Hố độc", false, function(s) lavaOn = s end)

local waterOn = false
makeToggle(t6, "Đi trên mặt nước", false, function(s) waterOn = s end)

local afkOn = false
makeToggle(t6, "Anti-AFK (Chống văng game)", false, function(s) afkOn = s end)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if afkOn then
            vu:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
        end
    end)
end)

makeToggle(t7, "Fullbright (Sáng bản đồ)", false, function(s)
    if s then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.GlobalShadows = true
    end
end)

makeButton(t7, "Tăng FPS & Xóa hiệu ứng lag", function()
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

makeButton(t7, "Lưu vị trí hiện tại (Save Pos)", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().CustomSavedPos = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end)
end)

makeButton(t7, "Quay lại vị trí đã lưu (Load Pos)", function()
    pcall(function()
        if getgenv().CustomSavedPos and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().CustomSavedPos
        end
    end)
end)

makeButton(t7, "Rejoin Server hiện tại", function()
    pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end)
end)

makeButton(t7, "Chuyển Server mới (Server Hop)", function()
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end)

makeButton(t7, "Tải Infinite Yield Commands (500+ Lệnh)", function()
    pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))() end)
end)

UserInputService.JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.RenderStepped:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")

    if hum then
        if speedOn then hum.WalkSpeed = speedVal end
        if jumpOn then hum.JumpPower = jumpVal end
        if godOn then hum.Health = hum.MaxHealth end
    end

    if noclipOn and char then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end

    if skyStandOn and root then
        root.Velocity = Vector3.new(0, 0, 0)
        root.CFrame = CFrame.new(root.Position.X, Workspace.FallenPartsDestroyHeight + skyH, root.Position.Z) * (root.CFrame - root.Position)
    end

    if flyOn and root then
        root.Velocity = Vector3.new(0, 1, 0)
        local cv = Camera.CFrame.LookVector
        local mv = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + cv end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - cv end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + Camera.CFrame.RightVector end
        root.CFrame = root.CFrame + (mv * (flySpd * 0.05))
    end

    if aimCenterOn then
        local targetPart = nil
        local shortDist = math.huge
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(aimPartName) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) then
                    local part = p.Character[aimPartName]
                    local screenPos, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if dist < shortDist then
                            shortDist = dist
                            targetPart = part
                        end
                    end
                end
            end
        end

        if targetPart then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetPart.Position)
        end
    end

    if trigBot then
        pcall(function()
            local mouse = LocalPlayer:GetMouse()
            local target = mouse.Target
            if target and target.Parent and target.Parent:FindFirstChild("Humanoid") then
                local enemy = Players:GetPlayerFromCharacter(target.Parent)
                if enemy and enemy ~= LocalPlayer then mouse1click() end
            end
        end)
    end

    if lavaOn then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("lava") or obj.Name:lower():find("kill") or obj.Material == Enum.Material.Lava) then
                obj.CanTouch = false
            end
        end
    end

    if waterOn and root then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("water") or obj.Material == Enum.Material.Water) then
                obj.CanCollide = true
            end
        end
    end
end)
