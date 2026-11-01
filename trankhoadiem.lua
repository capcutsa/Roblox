-- ====================================================================================
-- KHOADIEMHUB CUSTOM ENGINE V17 - FULL NATIVE MASSIVE SOURCE CODE EDITION
-- ====================================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local PathfindingService = game:GetService("PathfindingService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Dọn dẹp giao diện cũ nếu tồn tại trước khi khởi tạo mới
if CoreGui:FindFirstChild("KhoaDiemCustomV17") then
    CoreGui.KhoaDiemCustomV17:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KhoaDiemCustomV17"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local menuImageIcon = "rbxassetid://6031091000"

-- Hệ thống kéo thả cửa sổ chính và nút bấm tùy chỉnh
local function makeDraggable(guiObject, dragHandle)
    dragHandle = dragHandle or guiObject
    local dragging, dragInput, dragStart, startPos
    
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

-- Nút mở menu nổi trên màn hình
local floatingBtn = Instance.new("ImageButton")
floatingBtn.Name = "CustomMenuButton"
floatingBtn.Size = UDim2.new(0, 48, 0, 48)
floatingBtn.Position = UDim2.new(0, 25, 0, 25)
floatingBtn.BackgroundColor3 = Color3.fromRGB(10, 13, 19)
floatingBtn.BorderSizePixel = 0
floatingBtn.Image = menuImageIcon
floatingBtn.ImageColor3 = Color3.fromRGB(0, 220, 255)
floatingBtn.Parent = ScreenGui

makeDraggable(floatingBtn)

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(1, 0)
btnCorner.Parent = floatingBtn

local btnStroke = Instance.new("UIStroke")
btnStroke.Color = Color3.fromRGB(0, 220, 255)
btnStroke.Thickness = 2
btnStroke.Parent = floatingBtn

-- Cửa sổ chính của Hub
local mainWin = Instance.new("Frame")
mainWin.Name = "MainWindow"
mainWin.Size = UDim2.new(0, 620, 0, 420)
mainWin.Position = UDim2.new(0.5, -310, 0.5, -210)
mainWin.BackgroundColor3 = Color3.fromRGB(7, 9, 14)
mainWin.BackgroundTransparency = 1
mainWin.BorderSizePixel = 0
mainWin.Visible = false
mainWin.Parent = ScreenGui

local winCorner = Instance.new("UICorner")
winCorner.CornerRadius = UDim.new(0, 12)
winCorner.Parent = mainWin

local winStroke = Instance.new("UIStroke")
winStroke.Color = Color3.fromRGB(0, 220, 255)
winStroke.Thickness = 1.5
winStroke.Transparency = 1
winStroke.Parent = mainWin

-- Thanh tiêu đề
local headerBar = Instance.new("Frame")
headerBar.Name = "HeaderBar"
headerBar.Size = UDim2.new(1, 0, 0, 40)
headerBar.BackgroundColor3 = Color3.fromRGB(13, 17, 24)
headerBar.BorderSizePixel = 0
headerBar.Parent = mainWin

makeDraggable(mainWin, headerBar)

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = headerBar

local headerIcon = Instance.new("ImageLabel")
headerIcon.Size = UDim2.new(0, 22, 0, 22)
headerIcon.Position = UDim2.new(0, 12, 0, 9)
headerIcon.BackgroundTransparency = 1
headerIcon.Image = menuImageIcon
headerIcon.ImageColor3 = Color3.fromRGB(0, 220, 255)
headerIcon.Parent = headerBar

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -100, 1, 0)
headerTitle.Position = UDim2.new(0, 42, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "KhoaDiemHub • Custom Engine V17 (Massive Native Edition)"
headerTitle.TextColor3 = Color3.fromRGB(230, 240, 255)
headerTitle.TextSize = 11
headerTitle.Font = Enum.Font.GothamBold
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.Parent = headerBar

local exitBtn = Instance.new("TextButton")
exitBtn.Size = UDim2.new(0, 28, 0, 28)
exitBtn.Position = UDim2.new(1, -36, 0, 6)
exitBtn.BackgroundColor3 = Color3.fromRGB(22, 31, 48)
exitBtn.BorderSizePixel = 0
exitBtn.Text = "✕"
exitBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
exitBtn.TextSize = 11
exitBtn.Font = Enum.Font.GothamBold
exitBtn.Parent = headerBar

local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 6)
exitCorner.Parent = exitBtn

exitBtn.MouseButton1Click:Connect(function()
    mainWin.Visible = false
end)

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

-- Thanh menu chứa danh sách các Tab hệ thống
local tabMenu = Instance.new("ScrollingFrame")
tabMenu.Name = "TabMenu"
tabMenu.Size = UDim2.new(0, 160, 1, -50)
tabMenu.Position = UDim2.new(0, 8, 0, 46)
tabMenu.BackgroundColor3 = Color3.fromRGB(9, 12, 18)
tabMenu.BorderSizePixel = 0
tabMenu.CanvasSize = UDim2.new(0, 0, 0, 800)
tabMenu.ScrollBarThickness = 2
tabMenu.Parent = mainWin

local tabCorner = Instance.new("UICorner")
tabCorner.CornerRadius = UDim.new(0, 8)
tabCorner.Parent = tabMenu

local tabLayout = Instance.new("UIListLayout")
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabMenu

-- Vùng chứa nội dung các Tab
local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -180, 1, -50)
contentArea.Position = UDim2.new(0, 172, 0, 46)
contentArea.BackgroundTransparency = 1
contentArea.Parent = mainWin

local function hideAllTabs()
    for _, child in ipairs(contentArea:GetChildren()) do
        child.Visible = false
    end
end

local function makeTab(name)
    local scroller = Instance.new("ScrollingFrame")
    scroller.Name = name .. "Page"
    scroller.Size = UDim2.new(1, 0, 1, 0)
    scroller.BackgroundTransparency = 1
    scroller.CanvasSize = UDim2.new(0, 0, 0, 5000)
    scroller.ScrollBarThickness = 2
    scroller.Visible = false
    scroller.Parent = contentArea

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 6)
    layout.Parent = scroller

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 32)
    btn.BackgroundColor3 = Color3.fromRGB(13, 17, 24)
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(180, 205, 230)
    btn.TextSize = 10
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

-- Hàm khởi tạo các thành phần giao diện chi tiết
local function makeButton(parent, text, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 32)
    b.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
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
    f.Size = UDim2.new(1, -6, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
    f.BorderSizePixel = 0
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 8, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(210, 230, 250)
    l.TextSize = 10
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = f

    local ind = Instance.new("TextButton")
    ind.Size = UDim2.new(0, 38, 0, 18)
    ind.Position = UDim2.new(1, -42, 0.5, -9)
    ind.BackgroundColor3 = state and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(28, 38, 56)
    ind.BorderSizePixel = 0
    ind.Text = state and "ON" or "OFF"
    ind.TextColor3 = state and Color3.fromRGB(7, 9, 14) or Color3.fromRGB(140, 165, 195)
    ind.TextSize = 8
    ind.Font = Enum.Font.GothamBold
    ind.Parent = f

    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, 4)
    ic.Parent = ind

    ind.MouseButton1Click:Connect(function()
        state = not state
        ind.BackgroundColor3 = state and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(28, 38, 56)
        ind.TextColor3 = state and Color3.fromRGB(7, 9, 14) or Color3.fromRGB(140, 165, 195)
        ind.Text = state and "ON" or "OFF"
        cb(state)
    end)
    return f
end

local function makeSlider(parent, text, min, max, default, cb)
    local val = default
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -6, 0, 44)
    f.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
    f.BorderSizePixel = 0
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -12, 0, 18)
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
    bg.Position = UDim2.new(0, 8, 0, 28)
    bg.BackgroundColor3 = Color3.fromRGB(28, 38, 56)
    bg.BorderSizePixel = 0
    bg.Text = ""
    bg.Parent = f

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 3)
    sc.Parent = bg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((val - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
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
    f.Size = UDim2.new(1, -6, 0, 32)
    f.BackgroundColor3 = Color3.fromRGB(15, 20, 28)
    f.BorderSizePixel = 0
    f.ClipsDescendants = true
    f.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = f

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 32)
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
        for _, b in ipairs(subBtns) do
            b:Destroy()
        end
        subBtns = {}
        local list = opts()
        if opened then
            f.Size = UDim2.new(1, -6, 0, 36 + #list * 24)
            for i, name in ipairs(list) do
                local sb = Instance.new("TextButton")
                sb.Size = UDim2.new(1, -16, 0, 22)
                sb.Position = UDim2.new(0, 8, 0, 32 + (i - 1) * 24)
                sb.BackgroundColor3 = Color3.fromRGB(21, 27, 38)
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
                    f.Size = UDim2.new(1, -6, 0, 32)
                    cb(name)
                end)
                table.insert(subBtns, sb)
            end
        else
            f.Size = UDim2.new(1, -6, 0, 32)
        end
    end)
    return f
end

-- TẠO ĐẦY ĐỦ 15 TAB HỆ THỐNG MỞ RỘNG SÂU CHO MỌI CHỨC NĂNG
local t1 = makeTab("1. Tốc độ & Di chuyển")
local t2 = makeTab("2. AimBot & Tâm Giữa")
local t3 = makeTab("3. Sky Stand & Bay")
local t4 = makeTab("4. ESP Xuyên Tường Pro")
local t5 = makeTab("5. TP All & Tương tác")
local t6 = makeTab("6. Thế giới & Môi trường")
local t7 = makeTab("7. Kháng sát thương")
local t8 = makeTab("8. Combat & Tự động")
local t9 = makeTab("9. Camera & Góc nhìn")
local t10 = makeTab("10. Kỹ năng nhân vật")
local t11 = makeTab("11. Hiệu ứng & Visuals")
local t12 = makeTab("12. Quản lý Vị trí (Pos)")
local t13 = makeTab("13. Tối ưu hóa FPS / Lag")
local t14 = makeTab("14. Tiện ích Server")
local t15 = makeTab("15. Công cụ bổ sung")

t1.Visible = true

-- KHỞI TẠO BIẾN ĐIỀU KHIỂN LOGIC TOÀN HỆ THỐNG
local speedOn = false
local speedVal = 16
makeToggle(t1, "1. Kích hoạt tốc độ chạy", false, function(s) speedOn = s end)
makeSlider(t1, "Mức Tốc Độ", 16, 600, 16, function(v) speedVal = v end)

local jumpOn = false
local jumpVal = 50
makeToggle(t1, "2. Kích hoạt nhảy cao", false, function(s) jumpOn = s end)
makeSlider(t1, "Mức Độ Nhảy", 50, 900, 50, function(v) jumpVal = v end)

local noclipOn = false
makeToggle(t1, "3. Đi xuyên tường (Noclip)", false, function(s) noclipOn = s end)

local infJump = false
makeToggle(t1, "4. Nhảy vô hạn không trung", false, function(s) infJump = s end)

local gravityVal = 196.2
makeToggle(t1, "5. Bật tùy chỉnh trọng lực", false, function(s)
    if not s then Workspace.Gravity = 196.2 end
end)
makeSlider(t1, "Mức trọng lực", 0, 300, 196, function(v) gravityVal = v Workspace.Gravity = v end)

-- TAB 2: AIMBOT & TÂM GIỮA
local centerAim = false
local aimTargetPart = "Head"
makeToggle(t2, "1. Khóa Aim chính xác giữa màn hình", false, function(s) centerAim = s end)
makeButton(t2, "2. Chuyển đổi bộ phận (Đầu <-> Thân)", function()
    if aimTargetPart == "Head" then aimTargetPart = "HumanoidRootPart" else aimTargetPart = "Head" end
end)

local autoShoot = false
makeToggle(t2, "3. Tự động đánh khi chĩa tâm", false, function(s) autoShoot = s end)

-- TAB 3: SKY STAND & BAY
local skyStand = false
local skyHeightVal = 80
makeToggle(t3, "1. Bật đứng trên không (Sky Stand)", false, function(s) skyStand = s end)
makeSlider(t3, "Độ cao đứng trên trời", 10, 600, 80, function(v) skyHeightVal = v end)

local freeFly = false
local flySpeedVal = 60
makeToggle(t3, "2. Bay tự do 3D (Free Fly)", false, function(s) freeFly = s end)
makeSlider(t3, "Tốc độ bay tự do", 10, 400, 60, function(v) flySpeedVal = v end)

-- TAB 4: ESP XUYÊN TƯỜNG PRO
local espBox = false
local espName = false
local espHP = false
local espDist = false
local espTracer = false
local espChams = false

makeToggle(t4, "1. ESP Khung hình 2D (Box)", false, function(s) espBox = s end)
makeToggle(t4, "2. ESP Tên người chơi", false, function(s) espName = s end)
makeToggle(t4, "3. ESP Thanh Máu (HP)", false, function(s) espHP = s end)
makeToggle(t4, "4. ESP Khoảng Cách (m)", false, function(s) espDist = s end)
makeToggle(t4, "5. ESP Đường chỉ hướng (Tracer)", false, function(s) espTracer = s end)
makeToggle(t4, "6. ESP Tô sáng (Chams Highlight)", false, function(s)
    espChams = s
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if s then
                if not p.Character:FindFirstChild("CustomChamV17") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "CustomChamV17"
                    hl.FillColor = Color3.fromRGB(0, 220, 255)
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.4
                    hl.AlwaysOnTop = true
                    hl.Parent = p.Character
                end
            else
                if p.Character:FindFirstChild("CustomChamV17") then
                    p.Character.CustomChamV17:Destroy()
                end
            end
        end
    end
end)

local espDrawings = {}
RunService.RenderStepped:Connect(function()
    for _, obj in pairs(espDrawings) do
        if obj and obj.Remove then
            pcall(function() obj:Remove() end)
        end
    end
    espDrawings = {}

    if not (espBox or espName or espHP or espDist or espTracer) then return end
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
                    sq.Color = Color3.fromRGB(0, 220, 255)
                    sq.Thickness = 1
                    sq.Filled = false
                    table.insert(espDrawings, sq)
                end

                if espTracer then
                    local ln = Drawing.new("Line")
                    ln.Visible = true
                    ln.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    ln.To = Vector2.new(pos.X, pos.Y)
                    ln.Color = Color3.fromRGB(0, 220, 255)
                    ln.Thickness = 1
                    table.insert(espDrawings, ln)
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

-- TAB 5: TP ALL & TƯƠNG TÁC
local selectedTarget = nil
local function getPlayerNames()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            table.insert(t, p.Name)
        end
    end
    return t
end

makeDropdown(t5, "1. Chọn Player cụ thể", getPlayerNames, function(name)
    selectedTarget = Players:FindFirstChild(name)
end)

makeButton(t5, "2. Bay tới trước mặt Target đã chọn", function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = selectedTarget.Character.HumanoidRootPart.CFrame + (selectedTarget.Character.HumanoidRootPart.CFrame.LookVector * 4) + Vector3.new(0, 2, 0)
        end
    end
end)

makeButton(t5, "3. Bay ra trước mặt TẤT CẢ player", function()
    task.spawn(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + (p.Character.HumanoidRootPart.CFrame.LookVector * 4) + Vector3.new(0, 2, 0)
                    task.wait(0.6)
                end
            end
        end
    end)
end)

makeButton(t5, "4. Xem Camera Player (Spectate)", function()
    if selectedTarget and selectedTarget.Character and selectedTarget.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = selectedTarget.Character.Humanoid
    end
end)

makeButton(t5, "5. Reset Camera về bản thân", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

-- TAB 6: THẾ GIỚI & MÔI TRƯỜNG
makeToggle(t6, "1. Fullbright (Sáng bản đồ)", false, function(s)
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

-- TAB 7: KHÁNG SÁT THƯƠNG
local godOn = false
makeToggle(t7, "1. Bất tử hoàn toàn (God Mode)", false, function(s) godOn = s end)

local lavaOn = false
makeToggle(t7, "2. Kháng dung nham & Hố độc", false, function(s) lavaOn = s end)

local waterOn = false
makeToggle(t7, "3. Đi trên mặt nước", false, function(s) waterOn = s end)

-- TAB 8: COMBAT & TỰ ĐỘNG
local autoClick = false
makeToggle(t8, "1. Auto Clicker chuột", false, function(s) autoClick = s end)
task.spawn(function()
    while true do
        task.wait(0.03)
        if autoClick then
            pcall(function() mouse1click() end)
        end
    end
end)

-- TAB 12: QUẢN LÝ VỊ TRÍ (POS)
makeButton(t12, "1. Lưu vị trí hiện tại (Save Pos)", function()
    pcall(function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            getgenv().CustomSavedPosV17 = LocalPlayer.Character.HumanoidRootPart.CFrame
        end
    end)
end)

makeButton(t12, "2. Quay lại vị trí đã lưu (Load Pos)", function()
    pcall(function()
        if getgenv().CustomSavedPosV17 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = getgenv().CustomSavedPosV17
        end
    end)
end)

-- TAB 13: TỐI ƯU HÓA FPS / LAG
makeButton(t13, "1. Tăng FPS & Xóa vật thể lag nặng", function()
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

-- TAB 14: TIỆN ÍCH SERVER
makeButton(t14, "1. Rejoin Server hiện tại ngay lập tức", function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

makeButton(t14, "2. Server Hop (Chuyển sang server ngẫu nhiên)", function()
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
end)

-- TAB 15: CÔNG CỤ BỔ SUNG
local afkProt = false
makeToggle(t15, "1. Chống AFK văng game (Anti-AFK)", false, function(s) afkProt = s end)
task.spawn(function()
    local vu = game:GetService("VirtualUser")
    LocalPlayer.Idled:Connect(function()
        if afkProt then
            vu:Button2Down(Vector2.new(0, 0), Camera.CFrame)
            task.wait(1)
            vu:Button2Up(Vector2.new(0, 0), Camera.CFrame)
        end
    end)
end)

makeButton(t15, "2. Tải bảng điều khiển lệnh mở rộng", function()
    pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end)
end)

-- VÒNG LẶP XỬ LÝ CHÍNH TOÀN HỆ THỐNG
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

    if skyStand and root then
        root.Velocity = Vector3.new(0, 0, 0)
        root.CFrame = CFrame.new(root.Position.X, Workspace.FallenPartsDestroyHeight + skyHeightVal, root.Position.Z) * (root.CFrame - root.Position)
    end

    if freeFly and root then
        root.Velocity = Vector3.new(0, 1, 0)
        local cv = Camera.CFrame.LookVector
        local mv = Vector3.new(0, 0, 0)
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then mv = mv + cv end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then mv = mv - cv end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then mv = mv - Camera.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then mv = mv + Camera.CFrame.RightVector end
        root.CFrame = root.CFrame + (mv * (flySpeedVal * 0.05))
    end

    if centerAim then
        local targetPart = nil
        local shortDist = math.huge
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild(aimTargetPart) and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                if not (p.Team and LocalPlayer.Team and p.Team == LocalPlayer.Team) then
                    local part = p.Character[aimTargetPart]
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
