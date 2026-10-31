--[[
	TKD Utility Menu v1.0  |  Dev: Tran Khoa Diem  |  Telegram: @TranKhoaDiem
	VỊ TRÍ: StarterPlayer > StarterPlayerScripts  (LocalScript)
	Chạy hoàn toàn trên client, chỉ dùng API chính thức của Roblox.
]]

----------------------------------------------------------------
-- CẤU HÌNH (sửa tại đây)
----------------------------------------------------------------
local CONFIG = {
	Version = "v1.0",
	MenuName = "TKD Menu",
	DeveloperName = "Tran Khoa Diem",
	TelegramHandle = "@TranKhoaDiem",
	TelegramLink = "https://t.me/TranKhoaDiem",
	Introduction = "Xin chào! Mình là Tran Khoa Diem, nhà phát triển của menu này. "
		.. "Menu được làm riêng cho trải nghiệm của mình, giao diện tối, gọn nhẹ và mượt trên cả PC lẫn điện thoại. "
		.. "Cảm ơn bạn đã sử dụng!",
	GuiName = "TKD_UtilityMenu",
	MenuToggleKey = Enum.KeyCode.RightShift,
	WelcomeDuration = 2.2,
	NotificationDuration = 2.5,

	-- Speed Walk / High Jump (Step = bước làm tròn của slider)
	WalkSpeed = { Min = 16, Max = 120, Default = 40, Step = 1 },
	JumpPower = { Min = 50, Max = 250, Default = 100, Step = 1 },
	JumpHeight = { Min = 7.2, Max = 60, Default = 20, Step = 0.5 },

	-- Auto Farm
	EnemyTag = "FarmableEnemy",
	FallbackEnemyFolder = "Enemies", -- tên Folder nằm trực tiếp trong Workspace
	EnemyHoverHeight = 10, -- khoảng cách phía trên quái (studs)
	AttackInterval = 0.4, -- giây giữa 2 lần gọi attackTarget

	-- Auto Loot
	LootTags = { "LootChest", "DevilFruit" }, -- thêm tag mới vào đây
	LootStopDistance = 4, -- khoảng cách dừng khi tiến gần vật phẩm
	LootRetryCooldown = 15, -- giây bỏ qua vật phẩm không nhặt được
	MaxLootAttempts = 3,
	CollectWithProximityPrompt = true, -- dùng ProximityPrompt có sẵn (API chính thức)

	-- Di chuyển chung
	TweenSpeed = 80, -- studs / giây
	MinTweenTime = 0.08,
	TargetSearchInterval = 0.5, -- giây giữa 2 lần tìm mục tiêu mới
	FarmTickInterval = 0.1,
	GoalTolerance = 1, -- sai lệch cho phép trước khi tạo tween mới

	Esp = {
		UpdateInterval = 0.25,
		ShowNames = true,
		ShowDistance = true,
		ShowHealth = true,
		HideSameTeam = false,
		OutlineColor = Color3.fromRGB(255, 255, 255),
		FillColor = Color3.fromRGB(255, 70, 100),
		FillTransparency = 0.85,
		TextColor = Color3.fromRGB(255, 255, 255),
		HealthHighColor = Color3.fromRGB(80, 220, 120),
		HealthLowColor = Color3.fromRGB(235, 70, 70),
	},

	FixLag = {
		FogEnd = 1000000,
		ReplacementMaterial = Enum.Material.SmoothPlastic,
		DecorativeMaterials = {
			[Enum.Material.Grass] = true,
			[Enum.Material.Sand] = true,
			[Enum.Material.Brick] = true,
			[Enum.Material.Cobblestone] = true,
			[Enum.Material.Concrete] = true,
			[Enum.Material.Pavement] = true,
			[Enum.Material.Granite] = true,
			[Enum.Material.Marble] = true,
			[Enum.Material.Slate] = true,
			[Enum.Material.Wood] = true,
			[Enum.Material.WoodPlanks] = true,
			[Enum.Material.Fabric] = true,
			[Enum.Material.Ground] = true,
			[Enum.Material.Mud] = true,
			[Enum.Material.Rock] = true,
			[Enum.Material.Asphalt] = true,
			[Enum.Material.LeafyGrass] = true,
		},
		HitboxNameKeyword = "hitbox", -- phần tử có tên chứa từ này sẽ không bị sửa
	},

	FullBright = {
		Brightness = 2,
		Ambient = Color3.fromRGB(140, 140, 140),
		OutdoorAmbient = Color3.fromRGB(140, 140, 140),
		ExposureCompensation = 0.25,
		GlobalShadows = false,
	},

	Theme = {
		Background = Color3.fromRGB(16, 16, 22),
		Panel = Color3.fromRGB(24, 24, 33),
		Element = Color3.fromRGB(35, 35, 48),
		Off = Color3.fromRGB(65, 65, 85),
		Accent = Color3.fromRGB(125, 95, 255),
		Text = Color3.fromRGB(235, 235, 245),
		SubText = Color3.fromRGB(150, 150, 172),
		Success = Color3.fromRGB(70, 200, 120),
		Danger = Color3.fromRGB(235, 80, 90),
		Warning = Color3.fromRGB(240, 180, 60),
	},
}

----------------------------------------------------------------
-- DỊCH VỤ
----------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local theme = CONFIG.Theme
local weakKeys = { __mode = "k" }

----------------------------------------------------------------
-- BIN: gom và dọn connection / tween / instance / luồng
----------------------------------------------------------------
local function newBin()
	local bin = { items = {} }
	function bin.add(item)
		table.insert(bin.items, item)
		return item
	end
	function bin.clean()
		local items = bin.items
		bin.items = {}
		for _, item in items do
			local itemType = typeof(item)
			if itemType == "RBXScriptConnection" then
				item:Disconnect()
			elseif itemType == "function" then
				item()
			elseif itemType == "thread" then
				task.cancel(item)
			elseif itemType == "Instance" then
				if item:IsA("Tween") then
					item:Cancel()
				end
				item:Destroy()
			end
		end
	end
	return bin
end

local rootBin = newBin()

----------------------------------------------------------------
-- GUI GỐC (chống trùng lặp menu)
----------------------------------------------------------------
local playerGui = player:WaitForChild("PlayerGui")
local previousGui = playerGui:FindFirstChild(CONFIG.GuiName)
if previousGui then
	previousGui:Destroy() -- bản script cũ sẽ tự dọn dẹp qua sự kiện Destroying
end

local function create(className, properties, children)
	local instance = Instance.new(className)
	for key, value in properties do
		instance[key] = value
	end
	for _, child in children or {} do
		child.Parent = instance
	end
	return instance
end

local function playTween(instance, duration, properties)
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	)
	tween:Play()
	return tween
end

local gui = create("ScreenGui", {
	Name = CONFIG.GuiName,
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	DisplayOrder = 100,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = playerGui,
})

local function getViewportSize()
	local camera = Workspace.CurrentCamera
	return camera and camera.ViewportSize or Vector2.new(800, 600)
end

----------------------------------------------------------------
-- THÔNG BÁO
----------------------------------------------------------------
local toastHolder = create("Frame", {
	Name = "Toasts",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 12),
	Size = UDim2.fromOffset(260, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	ZIndex = 50,
	Parent = gui,
}, {
	create("UIListLayout", {
		Padding = UDim.new(0, 6),
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})

local toastCounter = 0

local function notify(message, kind)
	local colorByKind = {
		success = theme.Success,
		error = theme.Danger,
		warning = theme.Warning,
		info = theme.Accent,
	}
	local accent = colorByKind[kind or "info"] or theme.Accent
	local toasts = {}
	for _, child in toastHolder:GetChildren() do
		if child:IsA("CanvasGroup") then
			table.insert(toasts, child)
		end
	end
	if #toasts >= 3 then
		table.sort(toasts, function(a, b)
			return a.LayoutOrder < b.LayoutOrder
		end)
		toasts[1]:Destroy()
	end
	toastCounter += 1
	local toast = create("CanvasGroup", {
		Size = UDim2.fromOffset(260, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Panel,
		GroupTransparency = 1,
		LayoutOrder = toastCounter,
		Parent = toastHolder,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		create("UIStroke", { Color = accent, Thickness = 1 }),
		create("UIPadding", {
			PaddingTop = UDim.new(0, 7),
			PaddingBottom = UDim.new(0, 7),
			PaddingLeft = UDim.new(0, 10),
			PaddingRight = UDim.new(0, 10),
		}),
		create("TextLabel", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			Text = message,
			TextWrapped = true,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = theme.Text,
			TextSize = 13,
			Font = Enum.Font.GothamMedium,
		}),
	})
	playTween(toast, 0.2, { GroupTransparency = 0 })
	task.delay(CONFIG.NotificationDuration, function()
		if not toast.Parent then
			return
		end
		playTween(toast, 0.25, { GroupTransparency = 1 })
		task.delay(0.3, function()
			if toast.Parent then
				toast:Destroy()
			end
		end)
	end)
end

----------------------------------------------------------------
-- TRẠNG THÁI DÙNG CHUNG
----------------------------------------------------------------
local selection = {
	enemyType = nil,
	lootTypes = {},
	walkSpeed = CONFIG.WalkSpeed.Default,
	jumpValues = {
		JumpPower = CONFIG.JumpPower.Default,
		JumpHeight = CONFIG.JumpHeight.Default,
	},
	espHideSameTeam = CONFIG.Esp.HideSameTeam,
}

local features = {} -- [tên] = { label, start, stop, refresh, enabled, toggle }
local statusLabels = {}
local setFeature -- gán ở phần quản lý tính năng
local enemyListChanged -- gán ở phần UI

local function setStatus(name, text)
	local label = statusLabels[name]
	if label and label.Text ~= text then
		label.Text = text
	end
end

local function getHumanoid()
	local character = player.Character
	return character and character:FindFirstChildOfClass("Humanoid")
end

local function getLivingCharacter()
	local character = player.Character
	if not character then
		return nil
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if humanoid and root and humanoid.Health > 0 then
		return character, humanoid, root
	end
	return nil
end

----------------------------------------------------------------
-- LIGHTING: lớp ghi đè để Fix Lag và Full Bright độc lập nhau
----------------------------------------------------------------
local lightingOriginals = {}
local lightingOverrides = {}

local function setLightingOverride(owner, property, value)
	if lightingOriginals[property] == nil then
		lightingOriginals[property] = Lighting[property]
	end
	lightingOverrides[property] = lightingOverrides[property] or {}
	lightingOverrides[property][owner] = value
	Lighting[property] = value
end

local function clearLightingOverride(owner)
	for property, owners in lightingOverrides do
		owners[owner] = nil
		local remainingOwner, remainingValue = next(owners)
		if remainingOwner ~= nil then
			Lighting[property] = remainingValue
		else
			Lighting[property] = lightingOriginals[property]
			lightingOriginals[property] = nil
			lightingOverrides[property] = nil
		end
	end
end

----------------------------------------------------------------
-- NOCLIP (đếm yêu cầu theo chủ sở hữu)
----------------------------------------------------------------
local Noclip = {
	owners = {},
	ownerCount = 0,
	originalCollide = setmetatable({}, weakKeys),
	partList = {},
	activeBin = newBin(),
	characterBin = newBin(),
}
rootBin.add(Noclip.activeBin.clean)
rootBin.add(Noclip.characterBin.clean)

local function trackNoclipPart(part)
	if not part:IsA("BasePart") then
		return
	end
	if Noclip.originalCollide[part] == nil then
		Noclip.originalCollide[part] = part.CanCollide
	end
	table.insert(Noclip.partList, part)
end

local function bindNoclipCharacter(character)
	Noclip.characterBin.clean()
	Noclip.partList = {}
	if not character then
		return
	end
	for _, descendant in character:GetDescendants() do
		trackNoclipPart(descendant)
	end
	Noclip.characterBin.add(character.DescendantAdded:Connect(trackNoclipPart))
end

local function startNoclip()
	bindNoclipCharacter(player.Character)
	Noclip.activeBin.add(player.CharacterAdded:Connect(bindNoclipCharacter))
	Noclip.activeBin.add(RunService.Stepped:Connect(function()
		for _, part in Noclip.partList do
			part.CanCollide = false
		end
	end))
end

local function stopNoclip()
	Noclip.activeBin.clean()
	Noclip.characterBin.clean()
	for part, original in Noclip.originalCollide do
		part.CanCollide = original
		Noclip.originalCollide[part] = nil
	end
	Noclip.partList = {}
end

local function requestNoclip(owner)
	if Noclip.owners[owner] then
		return
	end
	Noclip.owners[owner] = true
	Noclip.ownerCount += 1
	if Noclip.ownerCount == 1 then
		startNoclip()
	end
end

local function releaseNoclip(owner)
	if not Noclip.owners[owner] then
		return
	end
	Noclip.owners[owner] = nil
	Noclip.ownerCount -= 1
	if Noclip.ownerCount == 0 then
		stopNoclip()
	end
end

----------------------------------------------------------------
-- FIX LAG
----------------------------------------------------------------
local FixLag = {
	token = 0,
	originals = setmetatable({}, weakKeys),
	bin = newBin(),
}
rootBin.add(FixLag.bin.clean)

local LAG_EFFECT_CLASSES = {
	"ParticleEmitter", "Trail", "Beam", "Smoke", "Fire", "Sparkles",
	"PointLight", "SpotLight", "SurfaceLight",
}
local LIGHTING_EFFECT_CLASSES = {
	"BloomEffect", "BlurEffect", "SunRaysEffect", "ColorCorrectionEffect", "DepthOfFieldEffect",
}

local function hasProtectedMarker(instance)
	if string.find(string.lower(instance.Name), CONFIG.FixLag.HitboxNameKeyword, 1, true) then
		return true
	end
	if CollectionService:HasTag(instance, CONFIG.EnemyTag) then
		return true
	end
	for _, tag in CONFIG.LootTags do
		if CollectionService:HasTag(instance, tag) then
			return true
		end
	end
	return false
end

local function isProtectedInstance(instance)
	if hasProtectedMarker(instance) then
		return true
	end
	local ancestor = instance.Parent
	while ancestor and ancestor ~= Workspace do
		if ancestor:IsA("Model") and ancestor:FindFirstChildOfClass("Humanoid") then
			return true
		end
		if hasProtectedMarker(ancestor) then
			return true
		end
		ancestor = ancestor.Parent
	end
	return false
end

local function rememberAndSet(instance, property, value)
	local saved = FixLag.originals[instance]
	if not saved then
		saved = {}
		FixLag.originals[instance] = saved
	end
	if saved[property] == nil then
		saved[property] = instance[property]
	end
	instance[property] = value
end

local function isInstanceOfAny(instance, classNames)
	for _, className in classNames do
		if instance:IsA(className) then
			return true
		end
	end
	return false
end

local function reduceInstance(instance)
	if isProtectedInstance(instance) then
		return
	end
	if isInstanceOfAny(instance, LAG_EFFECT_CLASSES) then
		rememberAndSet(instance, "Enabled", false)
	elseif instance:IsA("Texture") then
		rememberAndSet(instance, "Transparency", 1)
	elseif instance:IsA("BasePart") and not instance:IsA("Terrain") then
		rememberAndSet(instance, "CastShadow", false)
		if CONFIG.FixLag.DecorativeMaterials[instance.Material] then
			rememberAndSet(instance, "Material", CONFIG.FixLag.ReplacementMaterial)
		end
	elseif instance:IsA("Atmosphere") then
		rememberAndSet(instance, "Density", 0)
	end
end

local function reduceLightingInstance(instance)
	if isInstanceOfAny(instance, LIGHTING_EFFECT_CLASSES) then
		rememberAndSet(instance, "Enabled", false)
	elseif instance:IsA("Atmosphere") then
		rememberAndSet(instance, "Density", 0)
	end
end

local function scanForLag(token)
	for index, instance in Workspace:GetDescendants() do
		if FixLag.token ~= token then
			return
		end
		reduceInstance(instance)
		if index % 300 == 0 then
			task.wait()
		end
	end
	if FixLag.token ~= token then
		return
	end
	for _, instance in Lighting:GetDescendants() do
		reduceLightingInstance(instance)
	end
	local camera = Workspace.CurrentCamera
	if camera then
		for _, instance in camera:GetChildren() do
			reduceLightingInstance(instance)
		end
	end
end

local function deferReduce(token, reducer, instance)
	task.defer(function()
		if FixLag.token == token and instance.Parent then
			reducer(instance)
		end
	end)
end

local function startFixLag()
	FixLag.token += 1
	local token = FixLag.token
	setLightingOverride("FixLag", "GlobalShadows", false)
	setLightingOverride("FixLag", "FogEnd", CONFIG.FixLag.FogEnd)
	FixLag.bin.add(Workspace.DescendantAdded:Connect(function(instance)
		deferReduce(token, reduceInstance, instance)
	end))
	FixLag.bin.add(Lighting.DescendantAdded:Connect(function(instance)
		deferReduce(token, reduceLightingInstance, instance)
	end))
	task.spawn(scanForLag, token)
	return true
end

local function stopFixLag()
	FixLag.token += 1
	FixLag.bin.clean()
	for instance, savedProperties in FixLag.originals do
		for property, value in savedProperties do
			instance[property] = value
		end
	end
	FixLag.originals = setmetatable({}, weakKeys)
	clearLightingOverride("FixLag")
end

----------------------------------------------------------------
-- FULL BRIGHT
----------------------------------------------------------------
local function startFullBright()
	for property, value in CONFIG.FullBright do
		setLightingOverride("FullBright", property, value)
	end
	return true
end

local function stopFullBright()
	clearLightingOverride("FullBright")
end

----------------------------------------------------------------
-- SPEED WALK / HIGH JUMP (dùng chung một bộ điều khiển Humanoid)
----------------------------------------------------------------
local function createHumanoidStat(label, resolveProperty, resolveTarget)
	local stat = {
		enabled = false,
		bin = newBin(),
		characterBin = newBin(),
		originals = setmetatable({}, weakKeys),
		lastWarning = 0,
	}
	rootBin.add(stat.bin.clean)
	rootBin.add(stat.characterBin.clean)

	local function applyToHumanoid(humanoid)
		local property = resolveProperty(humanoid)
		if stat.originals[humanoid] == nil then
			stat.originals[humanoid] = { property = property, value = humanoid[property] }
		end
		humanoid[property] = resolveTarget(property)
	end

	local function watchForOverride(humanoid)
		local property = resolveProperty(humanoid)
		stat.characterBin.add(humanoid:GetPropertyChangedSignal(property):Connect(function()
			local expected = resolveTarget(property)
			local overridden = math.abs(humanoid[property] - expected) > 0.05
			if stat.enabled and overridden and os.clock() - stat.lastWarning > 5 then
				stat.lastWarning = os.clock()
				notify(label .. ": server đang ghi đè giá trị " .. property, "warning")
			end
		end))
	end

	local function bindCharacter(character)
		stat.characterBin.clean()
		task.spawn(function()
			local humanoid = character:WaitForChild("Humanoid", 10)
			if not stat.enabled or player.Character ~= character then
				return
			end
			if not humanoid then
				notify(label .. ": không tìm thấy Humanoid", "error")
				return
			end
			applyToHumanoid(humanoid)
			watchForOverride(humanoid)
		end)
	end

	function stat.start()
		stat.enabled = true
		if player.Character then
			bindCharacter(player.Character)
		end
		stat.bin.add(player.CharacterAdded:Connect(bindCharacter))
		return true
	end

	function stat.refresh()
		local humanoid = getHumanoid()
		if stat.enabled and humanoid then
			applyToHumanoid(humanoid)
		end
	end

	function stat.stop()
		stat.enabled = false
		stat.bin.clean()
		stat.characterBin.clean()
		for humanoid, saved in stat.originals do
			if humanoid.Parent then
				humanoid[saved.property] = saved.value
			end
		end
		stat.originals = setmetatable({}, weakKeys)
	end

	return stat
end

local walkStat = createHumanoidStat("Speed Walk", function()
	return "WalkSpeed"
end, function()
	return selection.walkSpeed
end)

local jumpStat = createHumanoidStat("High Jump", function(humanoid)
	return humanoid.UseJumpPower and "JumpPower" or "JumpHeight"
end, function(property)
	return selection.jumpValues[property]
end)

local function detectJumpProperty()
	local humanoid = getHumanoid()
	if humanoid and not humanoid.UseJumpPower then
		return "JumpHeight"
	end
	return "JumpPower"
end

----------------------------------------------------------------
-- DI CHUYỂN DÙNG CHUNG (Auto Farm / Auto Loot)
----------------------------------------------------------------
local movement = { tween = nil, goal = nil, root = nil }
rootBin.add(function()
	if movement.tween then
		movement.tween:Cancel()
	end
end)

function movement.cancel()
	if movement.tween then
		movement.tween:Cancel()
		movement.tween:Destroy()
	end
	movement.tween = nil
	movement.goal = nil
	movement.root = nil
end

function movement.follow(root, goal)
	if movement.root ~= root then
		movement.cancel()
	end
	root.AssemblyLinearVelocity = Vector3.zero
	local distance = (root.Position - goal.Position).Magnitude
	if movement.tween and movement.goal then
		if (movement.goal.Position - goal.Position).Magnitude <= CONFIG.GoalTolerance then
			return
		end
	elseif distance <= 0.25 then
		root.CFrame = CFrame.new(root.Position) * goal.Rotation
		return
	end
	movement.cancel()
	local duration = math.max(distance / CONFIG.TweenSpeed, CONFIG.MinTweenTime)
	local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = goal })
	movement.tween = tween
	movement.goal = goal
	movement.root = root
	tween.Completed:Once(function()
		if movement.tween == tween then
			movement.tween = nil
			movement.goal = nil
		end
	end)
	tween:Play()
end

local function getInstancePosition(instance)
	return instance:GetPivot().Position
end

----------------------------------------------------------------
-- DANH SÁCH QUÁI (CollectionService trước, Folder dự phòng sau)
----------------------------------------------------------------
local EnemyRegistry = { tagged = {}, folder = {} }

local function registerEnemy(set, model)
	if model:IsA("Model") and not set[model] then
		set[model] = true
		if enemyListChanged then
			enemyListChanged()
		end
	end
end

local function unregisterEnemy(set, model)
	if set[model] then
		set[model] = nil
		if enemyListChanged then
			enemyListChanged()
		end
	end
end

local function bindFallbackFolder(folder)
	local function onAdded(descendant)
		if descendant:IsA("Humanoid") and descendant.Parent and descendant.Parent:IsA("Model") then
			registerEnemy(EnemyRegistry.folder, descendant.Parent)
		end
	end
	for _, descendant in folder:GetDescendants() do
		onAdded(descendant)
	end
	rootBin.add(folder.DescendantAdded:Connect(onAdded))
	rootBin.add(folder.DescendantRemoving:Connect(function(descendant)
		if descendant:IsA("Humanoid") and descendant.Parent then
			unregisterEnemy(EnemyRegistry.folder, descendant.Parent)
		end
	end))
end

local function watchFallbackFolder()
	local folder = Workspace:FindFirstChild(CONFIG.FallbackEnemyFolder)
	if folder then
		bindFallbackFolder(folder)
		return
	end
	local connection
	connection = Workspace.ChildAdded:Connect(function(child)
		if child.Name == CONFIG.FallbackEnemyFolder then
			connection:Disconnect()
			bindFallbackFolder(child)
		end
	end)
	rootBin.add(connection)
end

local function startEnemyRegistry()
	local tag = CONFIG.EnemyTag
	for _, model in CollectionService:GetTagged(tag) do
		registerEnemy(EnemyRegistry.tagged, model)
	end
	rootBin.add(CollectionService:GetInstanceAddedSignal(tag):Connect(function(model)
		registerEnemy(EnemyRegistry.tagged, model)
	end))
	rootBin.add(CollectionService:GetInstanceRemovedSignal(tag):Connect(function(model)
		unregisterEnemy(EnemyRegistry.tagged, model)
	end))
	watchFallbackFolder()
end

local function getActiveEnemySet()
	if next(EnemyRegistry.tagged) ~= nil then
		return EnemyRegistry.tagged
	end
	return EnemyRegistry.folder
end

local function listEnemyTypes()
	local seen, names = {}, {}
	for model in getActiveEnemySet() do
		if model:IsDescendantOf(Workspace) and not seen[model.Name] then
			seen[model.Name] = true
			table.insert(names, model.Name)
		end
	end
	table.sort(names)
	return names
end

local function isEnemyAlive(model)
	if not model or not model:IsDescendantOf(Workspace) then
		return false
	end
	local humanoid = model:FindFirstChildOfClass("Humanoid")
	return humanoid ~= nil and humanoid.Health > 0
end

local function findNearestEnemy(enemyType, origin)
	local nearest, nearestDistance = nil, math.huge
	for model in getActiveEnemySet() do
		if model.Name == enemyType and isEnemyAlive(model) then
			local distance = (getInstancePosition(model) - origin).Magnitude
			if distance < nearestDistance then
				nearest, nearestDistance = model, distance
			end
		end
	end
	return nearest
end

----------------------------------------------------------------
-- AUTO FARM
----------------------------------------------------------------
local AutoFarm = { token = 0, attackWarned = false }

-- >>> KẾT NỐI HỆ THỐNG CHIẾN ĐẤU CỦA GAME TẠI ĐÂY <<<
-- Gọi hệ thống combat có sẵn của bạn (vd: kích hoạt công cụ, gọi hàm trong module của game).
-- Không tự tạo RemoteEvent. Trả về true nếu đã thực hiện tấn công.
local function attackTarget(target)
	if not AutoFarm.attackWarned then
		AutoFarm.attackWarned = true
		warn("[TKD] attackTarget chưa được kết nối với hệ thống chiến đấu của game.")
	end
	return false
end

local function computeFarmGoal(root, targetPosition)
	local hoverPosition = targetPosition + Vector3.new(0, CONFIG.EnemyHoverHeight, 0)
	local look = Vector3.new(targetPosition.X - root.Position.X, 0, targetPosition.Z - root.Position.Z)
	if look.Magnitude < 0.5 then
		look = Vector3.new(root.CFrame.LookVector.X, 0, root.CFrame.LookVector.Z)
	end
	if look.Magnitude < 0.01 then
		look = Vector3.zAxis
	end
	return CFrame.lookAt(hoverPosition, hoverPosition + look.Unit)
end

local function tryAttack(target)
	local ok, result = pcall(attackTarget, target)
	if not ok then
		notify("Lỗi attackTarget: " .. tostring(result), "error")
		warn("[TKD] attackTarget lỗi: " .. tostring(result))
		setFeature("AutoFarm", false)
	end
end

local function farmTarget(root, target, lastAttack)
	local goal = computeFarmGoal(root, getInstancePosition(target))
	movement.follow(root, goal)
	setStatus("AutoFarm", "Đang farm: " .. target.Name)
	local closeEnough = (root.Position - goal.Position).Magnitude <= CONFIG.GoalTolerance * 3
	if closeEnough and os.clock() - lastAttack >= CONFIG.AttackInterval then
		tryAttack(target)
		return os.clock()
	end
	return lastAttack
end

local function runAutoFarm(token)
	local target, lastSearch, lastAttack = nil, 0, 0
	while AutoFarm.token == token do
		local _, _, root = getLivingCharacter()
		if not root then
			movement.cancel()
			target = nil
			setStatus("AutoFarm", "Đang chờ hồi sinh...")
		else
			if target and not isEnemyAlive(target) then
				target = nil
			end
			if not target and os.clock() - lastSearch >= CONFIG.TargetSearchInterval then
				lastSearch = os.clock()
				target = findNearestEnemy(selection.enemyType, root.Position)
			end
			if target then
				lastAttack = farmTarget(root, target, lastAttack)
			else
				movement.cancel()
				setStatus("AutoFarm", "Waiting for enemy to spawn")
			end
		end
		task.wait(CONFIG.FarmTickInterval)
	end
end

local function startAutoFarm()
	if not selection.enemyType then
		return false, "Hãy chọn loại quái trước khi bật Auto Farm"
	end
	AutoFarm.token += 1
	requestNoclip("AutoFarm")
	setStatus("AutoFarm", "Đang tìm quái...")
	task.spawn(runAutoFarm, AutoFarm.token)
	return true
end

local function stopAutoFarm()
	AutoFarm.token += 1
	movement.cancel()
	releaseNoclip("AutoFarm")
	setStatus("AutoFarm", "Tắt")
end

----------------------------------------------------------------
-- AUTO LOOT
----------------------------------------------------------------
local AutoLoot = {
	token = 0,
	attempts = setmetatable({}, weakKeys),
	skipUntil = setmetatable({}, weakKeys),
	collectWarned = false,
}

-- >>> KẾT NỐI HỆ THỐNG NHẶT VẬT PHẨM CỦA GAME TẠI ĐÂY <<<
-- Mặc định: dùng ProximityPrompt có sẵn trên vật phẩm (API chính thức).
-- ClickDetector không có API client chính thức, hãy tự nối vào cơ chế nhặt của game.
-- Không tự tạo RemoteEvent. Trả về true nếu đã thực hiện thao tác nhặt.
local function collectLoot(item)
	if CONFIG.CollectWithProximityPrompt then
		local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
		if prompt and prompt.Enabled then
			prompt:InputHoldBegin()
			task.wait(prompt.HoldDuration + 0.1)
			prompt:InputHoldEnd()
			return true
		end
	end
	if not AutoLoot.collectWarned then
		AutoLoot.collectWarned = true
		warn("[TKD] collectLoot chưa được kết nối (vật phẩm không có ProximityPrompt).")
	end
	return false
end

local function isLootValid(item)
	return item ~= nil and item.Parent ~= nil and item:IsA("PVInstance") and item:IsDescendantOf(Workspace)
end

local function findNearestLoot(origin)
	local nearest, nearestDistance = nil, math.huge
	local now = os.clock()
	for tag in selection.lootTypes do
		for _, item in CollectionService:GetTagged(tag) do
			local blockedUntil = AutoLoot.skipUntil[item] or 0
			if isLootValid(item) and blockedUntil <= now then
				local distance = (getInstancePosition(item) - origin).Magnitude
				if distance < nearestDistance then
					nearest, nearestDistance = item, distance
				end
			end
		end
	end
	return nearest
end

local function computeLootGoal(root, itemPosition)
	local offset = root.Position - itemPosition
	local direction = offset.Magnitude > 0.1 and offset.Unit or Vector3.xAxis
	local goalPosition = itemPosition + direction * CONFIG.LootStopDistance
	local flatTarget = Vector3.new(itemPosition.X, goalPosition.Y, itemPosition.Z)
	if (flatTarget - goalPosition).Magnitude < 0.1 then
		return CFrame.new(goalPosition)
	end
	return CFrame.lookAt(goalPosition, flatTarget)
end

local function attemptCollect(item)
	AutoLoot.attempts[item] = (AutoLoot.attempts[item] or 0) + 1
	local ok, result = pcall(collectLoot, item)
	if not ok then
		notify("Lỗi collectLoot: " .. tostring(result), "error")
		warn("[TKD] collectLoot lỗi: " .. tostring(result))
		setFeature("AutoLoot", false)
		return true
	end
	if isLootValid(item) and AutoLoot.attempts[item] >= CONFIG.MaxLootAttempts then
		AutoLoot.skipUntil[item] = os.clock() + CONFIG.LootRetryCooldown
		AutoLoot.attempts[item] = nil
		return true
	end
	return false
end

local function lootTarget(root, item)
	local goal = computeLootGoal(root, getInstancePosition(item))
	movement.follow(root, goal)
	setStatus("AutoLoot", "Đang nhặt: " .. item.Name)
	local arrived = (root.Position - goal.Position).Magnitude <= CONFIG.GoalTolerance * 2
	if arrived then
		return attemptCollect(item)
	end
	return false
end

local function runAutoLoot(token)
	local target, lastSearch = nil, 0
	while AutoLoot.token == token do
		local _, _, root = getLivingCharacter()
		if not root then
			movement.cancel()
			target = nil
			setStatus("AutoLoot", "Đang chờ hồi sinh...")
		else
			if target and not isLootValid(target) then
				target = nil
			end
			if not target and os.clock() - lastSearch >= CONFIG.TargetSearchInterval then
				lastSearch = os.clock()
				target = findNearestLoot(root.Position)
			end
			if target then
				if lootTarget(root, target) then
					target = nil
				end
			else
				movement.cancel()
				setStatus("AutoLoot", "Waiting for loot to spawn")
			end
		end
		task.wait(CONFIG.FarmTickInterval)
	end
end

local function startAutoLoot()
	if next(selection.lootTypes) == nil then
		return false, "Hãy chọn ít nhất một loại vật phẩm"
	end
	AutoLoot.token += 1
	requestNoclip("AutoLoot")
	setStatus("AutoLoot", "Đang tìm vật phẩm...")
	task.spawn(runAutoLoot, AutoLoot.token)
	return true
end

local function stopAutoLoot()
	AutoLoot.token += 1
	movement.cancel()
	releaseNoclip("AutoLoot")
	setStatus("AutoLoot", "Tắt")
end

----------------------------------------------------------------
-- NOCLIP THỦ CÔNG
----------------------------------------------------------------
local function startManualNoclip()
	requestNoclip("Manual")
	return true
end

local function stopManualNoclip()
	releaseNoclip("Manual")
end

----------------------------------------------------------------
-- PLAYER ESP
----------------------------------------------------------------
local Esp = { token = 0, entries = {}, playerBins = {}, bin = newBin() }
rootBin.add(Esp.bin.clean)

local function removeEspEntry(target)
	local entry = Esp.entries[target]
	if entry then
		entry.bin.clean()
		Esp.entries[target] = nil
	end
end

local function buildEspText(target, entry, distance)
	local settings = CONFIG.Esp
	local lines = {}
	if settings.ShowNames then
		table.insert(lines, target.DisplayName)
	end
	local details = {}
	if settings.ShowDistance then
		table.insert(details, string.format("%dm", math.floor(distance)))
	end
	if settings.ShowHealth then
		table.insert(details, string.format("%d/%d HP", math.floor(entry.humanoid.Health), math.floor(entry.humanoid.MaxHealth)))
	end
	if #details > 0 then
		table.insert(lines, table.concat(details, " | "))
	end
	return table.concat(lines, "\n")
end

local function updateEspEntry(target, entry)
	local hidden = selection.espHideSameTeam and target.Team ~= nil and target.Team == player.Team
	entry.highlight.Enabled = not hidden
	entry.billboard.Enabled = not hidden
	if hidden then
		return
	end
	local _, _, localRoot = getLivingCharacter()
	local distance = localRoot and (entry.root.Position - localRoot.Position).Magnitude or 0
	entry.infoLabel.Text = buildEspText(target, entry, distance)
	local ratio = math.clamp(entry.humanoid.Health / math.max(entry.humanoid.MaxHealth, 1), 0, 1)
	entry.barFill.Size = UDim2.fromScale(ratio, 1)
	entry.barFill.BackgroundColor3 = CONFIG.Esp.HealthLowColor:Lerp(CONFIG.Esp.HealthHighColor, ratio)
end

local function createEspBillboard(root, entryBin)
	local settings = CONFIG.Esp
	local billboard = entryBin.add(create("BillboardGui", {
		Adornee = root,
		AlwaysOnTop = true,
		Size = UDim2.fromOffset(150, 46),
		StudsOffset = Vector3.new(0, 3.4, 0),
		ResetOnSpawn = false,
		Parent = Esp.container,
	}))
	local infoLabel = create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundTransparency = 1,
		TextColor3 = settings.TextColor,
		TextStrokeTransparency = 0.4,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		Text = "",
		Parent = billboard,
	})
	local barBack = create("Frame", {
		Position = UDim2.new(0.1, 0, 0, 34),
		Size = UDim2.new(0.8, 0, 0, 6),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		Visible = settings.ShowHealth,
		Parent = billboard,
	})
	local barFill = create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = settings.HealthHighColor,
		BorderSizePixel = 0,
		Parent = barBack,
	})
	return billboard, infoLabel, barFill
end

local function createEspEntry(target, character)
	removeEspEntry(target)
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local root = character:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root or humanoid.Health <= 0 then
		return
	end
	local settings = CONFIG.Esp
	local entryBin = newBin()
	local highlight = entryBin.add(create("Highlight", {
		Adornee = character,
		FillColor = settings.FillColor,
		FillTransparency = settings.FillTransparency,
		OutlineColor = settings.OutlineColor,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		Parent = Esp.container,
	}))
	local billboard, infoLabel, barFill = createEspBillboard(root, entryBin)
	entryBin.add(humanoid.Died:Connect(function()
		removeEspEntry(target)
	end))
	local entry = {
		bin = entryBin, humanoid = humanoid, root = root, highlight = highlight,
		billboard = billboard, infoLabel = infoLabel, barFill = barFill,
	}
	Esp.entries[target] = entry
	updateEspEntry(target, entry)
end

local function attachEsp(target, character)
	local token = Esp.token
	task.spawn(function()
		local root = character:WaitForChild("HumanoidRootPart", 10)
		local humanoid = character:WaitForChild("Humanoid", 10)
		if Esp.token ~= token or target.Character ~= character then
			return
		end
		if not root or not humanoid then
			warn("[TKD] ESP: không tìm thấy Humanoid/HumanoidRootPart của " .. target.Name)
			return
		end
		createEspEntry(target, character)
	end)
end

local function untrackEspPlayer(target)
	removeEspEntry(target)
	local playerBin = Esp.playerBins[target]
	if playerBin then
		playerBin.clean()
		Esp.playerBins[target] = nil
	end
end

local function trackEspPlayer(target)
	if target == player or Esp.playerBins[target] then
		return
	end
	local playerBin = newBin()
	Esp.playerBins[target] = playerBin
	playerBin.add(target.CharacterAdded:Connect(function(character)
		attachEsp(target, character)
	end))
	playerBin.add(target.CharacterRemoving:Connect(function()
		removeEspEntry(target)
	end))
	if target.Character then
		attachEsp(target, target.Character)
	end
end

local function runEspUpdates(token)
	while Esp.token == token do
		for target, entry in Esp.entries do
			updateEspEntry(target, entry)
		end
		task.wait(CONFIG.Esp.UpdateInterval)
	end
end

local function startEsp()
	Esp.token += 1
	Esp.container = Esp.bin.add(create("Folder", { Name = "TKD_ESP", Parent = Workspace }))
	for _, other in Players:GetPlayers() do
		trackEspPlayer(other)
	end
	Esp.bin.add(Players.PlayerAdded:Connect(trackEspPlayer))
	Esp.bin.add(Players.PlayerRemoving:Connect(untrackEspPlayer))
	task.spawn(runEspUpdates, Esp.token)
	return true
end

local function stopEsp()
	Esp.token += 1
	for target in Esp.entries do
		removeEspEntry(target)
	end
	for target, playerBin in Esp.playerBins do
		playerBin.clean()
		Esp.playerBins[target] = nil
	end
	Esp.bin.clean()
end

----------------------------------------------------------------
-- QUẢN LÝ TÍNH NĂNG
----------------------------------------------------------------
features.FixLag = { label = "Fix Lag", start = startFixLag, stop = stopFixLag }
features.FullBright = { label = "Full Bright", start = startFullBright, stop = stopFullBright }
features.SpeedWalk = { label = "Speed Walk", start = walkStat.start, stop = walkStat.stop, refresh = walkStat.refresh }
features.HighJump = { label = "High Jump", start = jumpStat.start, stop = jumpStat.stop, refresh = jumpStat.refresh }
features.Noclip = { label = "Noclip", start = startManualNoclip, stop = stopManualNoclip }
features.AutoFarm = { label = "Auto Farm", start = startAutoFarm, stop = stopAutoFarm }
features.AutoLoot = { label = "Auto Loot", start = startAutoLoot, stop = stopAutoLoot }
features.PlayerEsp = { label = "Player ESP", start = startEsp, stop = stopEsp }

local EXCLUSIVE_FEATURES = { AutoFarm = "AutoLoot", AutoLoot = "AutoFarm" }

local function syncToggle(feature)
	if feature.toggle then
		feature.toggle.set(feature.enabled)
	end
end

local function enableFeature(feature)
	local ok, success, reason = pcall(feature.start)
	if not ok then
		notify("Lỗi khi bật " .. feature.label, "error")
		warn("[TKD] Lỗi bật " .. feature.label .. ": " .. tostring(success))
		return false
	end
	if success == false then
		notify(reason or ("Không thể bật " .. feature.label), "error")
		return false
	end
	feature.enabled = true
	notify("Đã bật " .. feature.label, "success")
	return true
end

local function disableFeature(feature)
	local ok, err = pcall(feature.stop)
	if not ok then
		warn("[TKD] Lỗi tắt " .. feature.label .. ": " .. tostring(err))
		notify("Lỗi khi tắt " .. feature.label, "error")
	end
	feature.enabled = false
	notify("Đã tắt " .. feature.label, "info")
end

function setFeature(name, enabled)
	local feature = features[name]
	if feature.enabled == enabled then
		syncToggle(feature)
		return true
	end
	if enabled then
		local rival = EXCLUSIVE_FEATURES[name]
		if rival and features[rival].enabled then
			setFeature(rival, false)
		end
		enableFeature(feature)
	else
		disableFeature(feature)
	end
	syncToggle(feature)
	return feature.enabled == enabled
end

local function shutdown()
	for _, feature in features do
		if feature.enabled then
			local ok, err = pcall(feature.stop)
			if not ok then
				warn("[TKD] Lỗi dọn dẹp " .. feature.label .. ": " .. tostring(err))
			end
			feature.enabled = false
		end
	end
	rootBin.clean()
end

rootBin.add(gui.Destroying:Connect(shutdown))

----------------------------------------------------------------
-- THÀNH PHẦN GIAO DIỆN
----------------------------------------------------------------
local function addPressFeedback(button)
	local scale = create("UIScale", { Parent = button })
	local active
	local function animate(target, duration)
		if active then
			active:Cancel()
		end
		active = playTween(scale, duration, { Scale = target })
	end
	rootBin.add(button.MouseButton1Down:Connect(function()
		animate(0.95, 0.08)
	end))
	rootBin.add(button.MouseButton1Up:Connect(function()
		animate(1, 0.12)
	end))
	rootBin.add(button.MouseLeave:Connect(function()
		animate(1, 0.12)
	end))
end

local function createRoundedFrame(parent, size, color)
	return create("Frame", {
		Size = size,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = parent,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
end

local function createSection(parent, text)
	return create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Text = text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.Accent,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		Parent = parent,
	})
end

local function createInfoLabel(parent, text, textSize, color)
	return create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Text = text,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = color or theme.Text,
		TextSize = textSize or 13,
		Font = Enum.Font.GothamMedium,
		Parent = parent,
	})
end

local function createToggle(parent, text, onClick)
	local row = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = theme.Element,
		AutoButtonColor = false,
		Text = "",
		Parent = parent,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
	create("TextLabel", {
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -62, 1, 0),
		BackgroundTransparency = 1,
		Text = text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		Parent = row,
	})
	local track = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(36, 18),
		BackgroundColor3 = theme.Off,
		BorderSizePixel = 0,
		Parent = row,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	local knob = create("Frame", {
		Position = UDim2.new(0, 2, 0.5, -7),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = theme.Text,
		BorderSizePixel = 0,
		Parent = track,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	local toggle = { state = false }
	function toggle.set(state)
		toggle.state = state
		playTween(track, 0.15, { BackgroundColor3 = state and theme.Accent or theme.Off })
		playTween(knob, 0.15, { Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) })
	end
	addPressFeedback(row)
	rootBin.add(row.Activated:Connect(function()
		onClick(not toggle.state)
	end))
	return toggle
end

local function bindFeatureToggle(parent, name)
	local feature = features[name]
	feature.toggle = createToggle(parent, feature.label, function(wanted)
		setFeature(name, wanted)
	end)
end

local function roundToStep(value, step)
	return math.round(value / step) * step
end

local function createSlider(parent, text, range, onChanged)
	local slider = { min = range.Min, max = range.Max, step = range.Step, value = range.Default }
	local container = createRoundedFrame(parent, UDim2.new(1, 0, 0, 56), theme.Element)
	local title = create("TextLabel", {
		Position = UDim2.fromOffset(10, 4),
		Size = UDim2.new(1, -80, 0, 22),
		BackgroundTransparency = 1,
		Text = text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.SubText,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		Parent = container,
	})
	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 4),
		Size = UDim2.fromOffset(56, 22),
		BackgroundColor3 = theme.Background,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		Text = "",
		Parent = container,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
	local track = create("TextButton", {
		Position = UDim2.fromOffset(10, 32),
		Size = UDim2.new(1, -20, 0, 16),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = container,
	})
	local rail = createRoundedFrame(track, UDim2.new(1, 0, 0, 6), theme.Off)
	rail.Position = UDim2.new(0, 0, 0.5, -3)
	local fill = createRoundedFrame(rail, UDim2.fromScale(0, 1), theme.Accent)

	local function render()
		local span = math.max(slider.max - slider.min, 0.0001)
		fill.Size = UDim2.fromScale((slider.value - slider.min) / span, 1)
		local decimals = slider.step < 1 and "%.1f" or "%d"
		box.Text = string.format(decimals, slider.value)
	end

	function slider.setValue(value, silent)
		slider.value = math.clamp(roundToStep(value, slider.step), slider.min, slider.max)
		render()
		if not silent then
			onChanged(slider.value)
		end
	end

	function slider.setRange(minimum, maximum)
		slider.min, slider.max = minimum, maximum
		slider.value = math.clamp(slider.value, minimum, maximum)
		render()
	end

	function slider.setLabel(newText)
		title.Text = newText
	end

	local function setFromPointer(positionX)
		local ratio = math.clamp((positionX - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		slider.setValue(slider.min + (slider.max - slider.min) * ratio)
	end

	local dragging = false
	rootBin.add(track.InputBegan:Connect(function(input)
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
			dragging = true
			setFromPointer(input.Position.X)
			local endConnection
			endConnection = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					endConnection:Disconnect()
				end
			end)
			rootBin.add(endConnection)
		end
	end))
	rootBin.add(UserInputService.InputChanged:Connect(function(input)
		local inputType = input.UserInputType
		if dragging and (inputType == Enum.UserInputType.MouseMovement or inputType == Enum.UserInputType.Touch) then
			setFromPointer(input.Position.X)
		end
	end))
	rootBin.add(box.FocusLost:Connect(function()
		local number = tonumber(box.Text)
		if not number or number ~= number then
			notify("Giá trị không hợp lệ", "error")
			render()
			return
		end
		if number < slider.min or number > slider.max then
			notify(string.format("Phạm vi cho phép: %s - %s", slider.min, slider.max), "warning")
		end
		slider.setValue(number)
	end))
	render()
	return slider
end

local function createDropdown(parent, options)
	local dropdown = { selected = {}, open = false }
	local container = createRoundedFrame(parent, UDim2.new(1, 0, 0, 0), theme.Element)
	container.AutomaticSize = Enum.AutomaticSize.Y
	create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })
	local header = create("TextButton", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = container,
	})
	local headerLabel = create("TextLabel", {
		Position = UDim2.fromOffset(10, 0),
		Size = UDim2.new(1, -34, 1, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		Parent = header,
	})
	local arrow = create("TextLabel", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundTransparency = 1,
		Text = "▾",
		TextColor3 = theme.SubText,
		TextSize = 14,
		Parent = header,
	})
	local body = create("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		Parent = container,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
		create("UIPadding", { PaddingBottom = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }),
	})
	local search = create("TextBox", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundColor3 = theme.Background,
		PlaceholderText = "Tìm kiếm...",
		PlaceholderColor3 = theme.SubText,
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		Parent = body,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
	local list = create("ScrollingFrame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 100),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		Parent = body,
	}, { create("UIListLayout", { Padding = UDim.new(0, 3) }) })

	local function updateHeader()
		local names = {}
		for name in dropdown.selected do
			table.insert(names, name)
		end
		table.sort(names)
		local summary = #names > 0 and table.concat(names, ", ") or "Chưa chọn"
		headerLabel.Text = options.title .. ": " .. summary
	end

	local function choose(name)
		if options.multi then
			dropdown.selected[name] = (not dropdown.selected[name]) or nil
		else
			dropdown.selected = { [name] = true }
			dropdown.setOpen(false)
		end
		updateHeader()
		options.onChanged(dropdown.selected)
		dropdown.refresh()
	end

	function dropdown.refresh()
		for _, child in list:GetChildren() do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		local query = string.lower(search.Text)
		for _, name in options.getOptions() do
			if query == "" or string.find(string.lower(name), query, 1, true) then
				local isSelected = dropdown.selected[name] == true
				local item = create("TextButton", {
					Size = UDim2.new(1, -4, 0, 24),
					BackgroundColor3 = isSelected and theme.Accent or theme.Background,
					AutoButtonColor = false,
					Text = (isSelected and "✓ " or "") .. name,
					TextColor3 = theme.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					Parent = list,
				}, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
				item.Activated:Connect(function()
					choose(name)
				end)
			end
		end
		updateHeader()
	end

	function dropdown.setOpen(open)
		dropdown.open = open
		body.Visible = open
		playTween(arrow, 0.15, { Rotation = open and 180 or 0 })
		if open then
			dropdown.refresh()
		end
	end

	addPressFeedback(header)
	rootBin.add(header.Activated:Connect(function()
		dropdown.setOpen(not dropdown.open)
	end))
	rootBin.add(search:GetPropertyChangedSignal("Text"):Connect(dropdown.refresh))
	updateHeader()
	return dropdown
end

local function makeDraggable(handle, target, onTap)
	local dragging, moved = false, false
	local dragStart, startPosition
	local endConnection
	rootBin.add(function()
		if endConnection then
			endConnection:Disconnect()
		end
	end)
	rootBin.add(handle.InputBegan:Connect(function(input)
		local inputType = input.UserInputType
		if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
			return
		end
		dragging, moved = true, false
		dragStart, startPosition = input.Position, target.Position
		endConnection = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				endConnection:Disconnect()
				if not moved and onTap then
					onTap()
				end
			end
		end)
	end))
	rootBin.add(UserInputService.InputChanged:Connect(function(input)
		local inputType = input.UserInputType
		if not dragging or (inputType ~= Enum.UserInputType.MouseMovement and inputType ~= Enum.UserInputType.Touch) then
			return
		end
		local delta = input.Position - dragStart
		if delta.Magnitude > 6 then
			moved = true
		end
		if moved then
			local size, viewport = target.AbsoluteSize, gui.AbsoluteSize
			target.Position = UDim2.fromOffset(
				math.clamp(startPosition.X.Offset + delta.X, 0, math.max(viewport.X - size.X, 0)),
				math.clamp(startPosition.Y.Offset + delta.Y, 0, math.max(viewport.Y - size.Y, 0))
			)
		end
	end))
end

----------------------------------------------------------------
-- CỬA SỔ CHÍNH
----------------------------------------------------------------
local viewport = getViewportSize()
local WINDOW_WIDTH = math.min(330, viewport.X - 20)
local WINDOW_HEIGHT = math.min(370, viewport.Y - 20)
local TITLE_HEIGHT = 34

local bubble = create("TextButton", {
	Name = "MenuBubble",
	Position = UDim2.fromOffset(14, 100),
	Size = UDim2.fromOffset(46, 46),
	BackgroundColor3 = theme.Panel,
	Text = "TKD",
	TextColor3 = theme.Accent,
	TextSize = 13,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = false,
	Visible = false,
	ZIndex = 10,
	Parent = gui,
}, {
	create("UICorner", { CornerRadius = UDim.new(1, 0) }),
	create("UIStroke", { Color = theme.Accent, Thickness = 1.5 }),
})
addPressFeedback(bubble)

local window = create("Frame", {
	Name = "Window",
	Position = UDim2.fromOffset(math.max(math.min(70, viewport.X - WINDOW_WIDTH - 4), 0), 60),
	Size = UDim2.fromOffset(WINDOW_WIDTH, WINDOW_HEIGHT),
	BackgroundColor3 = theme.Background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Visible = false,
	ZIndex = 5,
	Parent = gui,
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 12) }),
	create("UIStroke", { Color = theme.Off, Thickness = 1 }),
})
local windowScale = create("UIScale", { Parent = window })
local windowState = { open = false, id = 0, minimized = false }

local titleBar = create("Frame", {
	Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
	BackgroundColor3 = theme.Panel,
	BorderSizePixel = 0,
	Parent = window,
})
create("TextLabel", {
	Position = UDim2.fromOffset(12, 0),
	Size = UDim2.new(1, -80, 1, 0),
	BackgroundTransparency = 1,
	Text = "◆ " .. CONFIG.MenuName .. "  " .. CONFIG.Version,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	Parent = titleBar,
})

local function createTitleButton(text, offsetX, color)
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, offsetX, 0.5, 0),
		Size = UDim2.fromOffset(24, 24),
		BackgroundColor3 = color,
		Text = text,
		TextColor3 = theme.Text,
		TextSize = 14,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = titleBar,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
	addPressFeedback(button)
	return button
end

local minimizeButton = createTitleButton("–", -38, theme.Element)
local closeButton = createTitleButton("×", -8, theme.Danger)

local body = create("Frame", {
	Position = UDim2.fromOffset(0, TITLE_HEIGHT),
	Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT),
	BackgroundTransparency = 1,
	Parent = window,
})
local tabBar = create("Frame", {
	Position = UDim2.fromOffset(8, 6),
	Size = UDim2.new(1, -16, 0, 28),
	BackgroundTransparency = 1,
	Parent = body,
}, { create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }) })
local pagesHolder = create("Frame", {
	Position = UDim2.fromOffset(8, 40),
	Size = UDim2.new(1, -16, 1, -48),
	BackgroundTransparency = 1,
	Parent = body,
})

local pages, tabButtons = {}, {}

local function selectTab(name)
	for pageName, page in pages do
		page.Visible = pageName == name
		tabButtons[pageName].BackgroundColor3 = pageName == name and theme.Accent or theme.Element
	end
end

local function createPage(name, title)
	local page = create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 3,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(),
		Visible = false,
		Parent = pagesHolder,
	}, {
		create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }),
		create("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 8) }),
	})
	local tab = create("TextButton", {
		Size = UDim2.new(1 / 3, -4, 1, 0),
		BackgroundColor3 = theme.Element,
		Text = title,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = tabBar,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
	addPressFeedback(tab)
	rootBin.add(tab.Activated:Connect(function()
		selectTab(name)
	end))
	pages[name], tabButtons[name] = page, tab
	return page
end

local function setWindowOpen(open)
	windowState.open = open
	windowState.id += 1
	local id = windowState.id
	if open then
		windowScale.Scale = 0.9
		window.Visible = true
		playTween(windowScale, 0.15, { Scale = 1 })
	else
		playTween(windowScale, 0.12, { Scale = 0.9 })
		task.delay(0.12, function()
			if windowState.id == id then
				window.Visible = false
			end
		end)
	end
end

local function setMinimized(minimized)
	windowState.minimized = minimized
	local height = minimized and TITLE_HEIGHT or WINDOW_HEIGHT
	body.Visible = not minimized
	playTween(window, 0.18, { Size = UDim2.fromOffset(WINDOW_WIDTH, height) })
end

rootBin.add(minimizeButton.Activated:Connect(function()
	setMinimized(not windowState.minimized)
end))
rootBin.add(closeButton.Activated:Connect(function()
	setWindowOpen(false)
end))

makeDraggable(titleBar, window)
makeDraggable(bubble, bubble, function()
	setWindowOpen(not windowState.open)
end)

rootBin.add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == CONFIG.MenuToggleKey then
		setWindowOpen(not windowState.open)
	end
end))

----------------------------------------------------------------
-- NỘI DUNG CÁC TRANG
----------------------------------------------------------------
local jumpSlider

local function syncJumpSlider()
	if not jumpSlider then
		return
	end
	local property = detectJumpProperty()
	local range = CONFIG[property]
	jumpSlider.step = range.Step
	jumpSlider.setLabel("Độ nhảy (" .. property .. ")")
	jumpSlider.setRange(range.Min, range.Max)
	jumpSlider.setValue(selection.jumpValues[property], true)
end

local function buildFeaturePage(page)
	createSection(page, "HIỆU NĂNG & HÌNH ẢNH")
	bindFeatureToggle(page, "FixLag")
	bindFeatureToggle(page, "FullBright")
	createSection(page, "NHÂN VẬT")
	bindFeatureToggle(page, "SpeedWalk")
	createSlider(page, "Tốc độ chạy (WalkSpeed)", CONFIG.WalkSpeed, function(value)
		selection.walkSpeed = value
		features.SpeedWalk.refresh()
	end)
	bindFeatureToggle(page, "HighJump")
	jumpSlider = createSlider(page, "Độ nhảy", CONFIG.JumpPower, function(value)
		selection.jumpValues[detectJumpProperty()] = value
		features.HighJump.refresh()
	end)
	bindFeatureToggle(page, "Noclip")
	createSection(page, "NGƯỜI CHƠI")
	bindFeatureToggle(page, "PlayerEsp")
	local teamToggle
	teamToggle = createToggle(page, "ESP: chỉ hiện đối thủ", function(wanted)
		selection.espHideSameTeam = wanted
		teamToggle.set(wanted)
	end)
	teamToggle.set(selection.espHideSameTeam)
	syncJumpSlider()
end

local enemyDropdown, lootDropdown

local function buildFarmPage(page)
	createSection(page, "AUTO FARM")
	statusLabels.AutoFarm = createInfoLabel(page, "Tắt", 12, theme.SubText)
	enemyDropdown = createDropdown(page, {
		title = "Quái",
		multi = false,
		getOptions = listEnemyTypes,
		onChanged = function(selected)
			selection.enemyType = next(selected)
		end,
	})
	bindFeatureToggle(page, "AutoFarm")
	createSection(page, "AUTO LOOT")
	statusLabels.AutoLoot = createInfoLabel(page, "Tắt", 12, theme.SubText)
	lootDropdown = createDropdown(page, {
		title = "Vật phẩm",
		multi = true,
		getOptions = function()
			return CONFIG.LootTags
		end,
		onChanged = function(selected)
			selection.lootTypes = table.clone(selected)
		end,
	})
	bindFeatureToggle(page, "AutoLoot")
end

local function buildAboutPage(page)
	createSection(page, "THÔNG TIN")
	createInfoLabel(page, CONFIG.MenuName .. " " .. CONFIG.Version .. "  •  Giao diện Dark", 14, theme.Text)
	createInfoLabel(page, "Dev: " .. CONFIG.DeveloperName, 13, theme.Accent)
	createInfoLabel(page, CONFIG.Introduction, 12, theme.SubText)
	createSection(page, "LIÊN HỆ")
	local linkBox = create("TextBox", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = theme.Element,
		Text = CONFIG.TelegramLink,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		TextEditable = false,
		Parent = page,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
	local telegramButton = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = theme.Accent,
		Text = "Telegram: " .. CONFIG.TelegramHandle,
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = page,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
	addPressFeedback(telegramButton)
	rootBin.add(telegramButton.Activated:Connect(function()
		linkBox:CaptureFocus()
		notify("Chọn và sao chép link: " .. CONFIG.TelegramLink, "info")
	end))
end

buildFeaturePage(createPage("features", "Tính năng"))
buildFarmPage(createPage("farm", "Farm / Loot"))
buildAboutPage(createPage("about", "Giới thiệu"))
selectTab("features")

-- Cập nhật danh sách quái (gộp nhiều thay đổi liên tiếp thành một lần)
local enemyRefreshQueued = false
enemyListChanged = function()
	if enemyRefreshQueued or not enemyDropdown then
		return
	end
	enemyRefreshQueued = true
	task.delay(0.3, function()
		enemyRefreshQueued = false
		if enemyDropdown and enemyDropdown.open then
			enemyDropdown.refresh()
		end
	end)
end

-- Đồng bộ slider nhảy khi hồi sinh
rootBin.add(player.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if humanoid and gui.Parent then
		syncJumpSlider()
	end
end))

----------------------------------------------------------------
-- MÀN HÌNH CHÀO MỪNG -> THU NHỎ THÀNH NÚT MENU
----------------------------------------------------------------
local function playWelcome()
	local welcomeSize = Vector2.new(280, 120)
	local welcome = create("Frame", {
		Position = UDim2.fromOffset(viewport.X / 2 - welcomeSize.X / 2, viewport.Y / 2 - welcomeSize.Y / 2),
		Size = UDim2.fromOffset(welcomeSize.X, welcomeSize.Y),
		BackgroundColor3 = theme.Panel,
		BorderSizePixel = 0,
		ZIndex = 20,
		Parent = gui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 14) }),
		create("UIStroke", { Color = theme.Accent, Thickness = 1.5 }),
	})
	local scale = create("UIScale", { Scale = 0.7, Parent = welcome })
	local labels = {
		create("TextLabel", {
			Position = UDim2.fromOffset(0, 14), Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1,
			Text = "Chào Mừng", TextColor3 = theme.Text, TextSize = 26, Font = Enum.Font.GothamBold, Parent = welcome,
		}),
		create("TextLabel", {
			Position = UDim2.fromOffset(0, 54), Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
			Text = CONFIG.MenuName .. " " .. CONFIG.Version, TextColor3 = theme.Accent, TextSize = 14,
			Font = Enum.Font.GothamMedium, Parent = welcome,
		}),
		create("TextLabel", {
			Position = UDim2.fromOffset(0, 80), Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
			Text = "Dev: " .. CONFIG.DeveloperName, TextColor3 = theme.SubText, TextSize = 12,
			Font = Enum.Font.GothamMedium, Parent = welcome,
		}),
	}
	playTween(scale, 0.3, { Scale = 1 })
	task.spawn(function()
		task.wait(CONFIG.WelcomeDuration)
		if not welcome.Parent then
			return
		end
		for _, label in labels do
			playTween(label, 0.2, { TextTransparency = 1 })
		end
		local corner = welcome:FindFirstChildOfClass("UICorner")
		playTween(corner, 0.45, { CornerRadius = UDim.new(1, 0) })
		playTween(welcome, 0.45, { Size = bubble.Size, Position = bubble.Position })
		task.wait(0.5)
		if welcome.Parent then
			welcome:Destroy()
			bubble.Visible = true
			notify("Bấm nút TKD hoặc phím " .. CONFIG.MenuToggleKey.Name .. " để mở menu", "info")
		end
	end)
end

----------------------------------------------------------------
-- KHỞI ĐỘNG
----------------------------------------------------------------
startEnemyRegistry()
playWelcome()
