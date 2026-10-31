local CONFIG = {
	Version = "v1.0",
	MenuName = "TKD Menu",
	DeveloperName = "Tran Khoa Diem",
	TelegramHandle = "@TranKhoaDiem",
	TelegramLink = "https://t.me/TranKhoaDiem",
	Introduction = "Xin chào! Mình là Tran Khoa Diem, nhà phát triển của menu này. "
		.. "Menu được làm riêng cho trải nghiệm của mình: giao diện đen, gọn nhẹ, mượt trên cả PC lẫn điện thoại. "
		.. "Cảm ơn bạn đã sử dụng!",
	GuiName = "TKD_UtilityMenu",
	AllowedUserIds = {},
	MenuToggleKey = Enum.KeyCode.RightShift,
	WelcomeDuration = 2.2,
	NotificationDuration = 2.5,
	ClickSoundId = "rbxasset://sounds/switch.wav",
	ClickVolume = 0.6,
	MaxLoopFailures = 5,
	ShowHudByDefault = true,

	WalkSpeed = { Min = 16, Max = 150, Default = 50, Step = 1 },
	JumpPower = { Min = 50, Max = 300, Default = 100, Step = 1 },
	JumpHeight = { Min = 7.2, Max = 80, Default = 20, Step = 0.5 },
	CameraFov = { Min = 40, Max = 120, Default = 90, Step = 1 },
	MaxZoomDistance = 1000,

	EnemyTag = "FarmableEnemy",
	FallbackEnemyFolder = "Enemies",
	EnemyHoverHeight = 10,
	AttackInterval = 0.4,

	LootTags = { "LootChest", "DevilFruit" },
	LootStopDistance = 4,
	LootRetryCooldown = 15,
	MaxLootAttempts = 3,
	CollectWithProximityPrompt = true,

	TweenSpeed = 80,
	MinTweenTime = 0.08,
	TargetSearchInterval = 0.5,
	FarmTickInterval = 0.1,
	GoalTolerance = 1,

	Fly = { Speed = 120, HeightOffset = 3 },

	Aim = {
		Fov = { Min = 40, Max = 400, Default = 150, Step = 5 },
		Smooth = { Min = 0.05, Max = 1, Default = 0.3, Step = 0.05 },
		HoldInput = Enum.UserInputType.MouseButton2,
		SearchInterval = 0.1,
		Mode = "Tâm màn hình",
		Part = "Đầu",
		WallCheck = true,
		TeamCheck = true,
		CircleColor = Color3.fromRGB(255, 255, 255),
	},

	Esp = {
		UpdateInterval = 0.2,
		ShowNames = true,
		ShowDistance = true,
		ShowHealth = true,
		HideSameTeam = false,
		TracerOrigin = "Dưới",
		TracerThickness = 1.5,
		OutlineColor = Color3.fromRGB(255, 255, 255),
		FillColor = Color3.fromRGB(255, 60, 90),
		FillTransparency = 0.8,
		BoxColor = Color3.fromRGB(255, 255, 255),
		TracerColor = Color3.fromRGB(255, 80, 100),
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
		HitboxNameKeyword = "hitbox",
	},

	FullBright = {
		Brightness = 2,
		Ambient = Color3.fromRGB(140, 140, 140),
		OutdoorAmbient = Color3.fromRGB(140, 140, 140),
		ExposureCompensation = 0.25,
		GlobalShadows = false,
	},

	Theme = {
		Background = Color3.fromRGB(8, 8, 8),
		Panel = Color3.fromRGB(16, 16, 16),
		Element = Color3.fromRGB(26, 26, 26),
		Stroke = Color3.fromRGB(44, 44, 44),
		Off = Color3.fromRGB(62, 62, 62),
		Accent = Color3.fromRGB(70, 150, 255),
		Text = Color3.fromRGB(240, 240, 240),
		SubText = Color3.fromRGB(150, 150, 150),
		Success = Color3.fromRGB(60, 200, 120),
		Danger = Color3.fromRGB(235, 75, 85),
		Warning = Color3.fromRGB(240, 175, 50),
	},
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local theme = CONFIG.Theme
local weakKeys = { __mode = "k" }

if #CONFIG.AllowedUserIds > 0 and not table.find(CONFIG.AllowedUserIds, player.UserId) then
	return
end

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

local playerGui = player:WaitForChild("PlayerGui")
local previousGui = playerGui:FindFirstChild(CONFIG.GuiName)
if previousGui then
	previousGui:Destroy()
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

local layoutCounter = 0
local function nextOrder()
	layoutCounter += 1
	return layoutCounter
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

local errorLog = {}
local errorLogChanged

local function logError(source, err)
	table.insert(errorLog, 1, string.format("%s  %s: %s", os.date("%H:%M:%S"), source, tostring(err)))
	while #errorLog > 5 do
		table.remove(errorLog)
	end
	warn("[TKD] " .. source .. ": " .. tostring(err))
	if errorLogChanged then
		errorLogChanged()
	end
end

local function guard(source, callback, ...)
	local ok, result = pcall(callback, ...)
	if not ok then
		logError(source, result)
	end
	return ok, result
end

local function connectGuarded(signal, source, callback)
	return rootBin.add(signal:Connect(function(...)
		guard(source, callback, ...)
	end))
end

local soundState = { enabled = true, last = 0 }
local clickSound = create("Sound", {
	SoundId = CONFIG.ClickSoundId,
	Volume = CONFIG.ClickVolume,
	Parent = gui,
})

local function playClick()
	local now = os.clock()
	if soundState.enabled and now - soundState.last > 0.06 then
		soundState.last = now
		clickSound:Play()
	end
end

local function bindSurfaceClick(surface)
	rootBin.add(surface.InputBegan:Connect(function(input)
		local inputType = input.UserInputType
		if inputType == Enum.UserInputType.MouseButton1 or inputType == Enum.UserInputType.Touch then
			playClick()
		end
	end))
end

local toastHolder = create("Frame", {
	Name = "Toasts",
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 12),
	Size = UDim2.fromOffset(270, 0),
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
		Size = UDim2.fromOffset(270, 0),
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

local selection = {
	enemyType = nil,
	lootTypes = {},
	walkSpeed = CONFIG.WalkSpeed.Default,
	jumpValues = {
		JumpPower = CONFIG.JumpPower.Default,
		JumpHeight = CONFIG.JumpHeight.Default,
	},
	cameraFov = CONFIG.CameraFov.Default,
	spectateName = nil,
	destination = nil,
	coordinateText = "",
	esp = {
		Chams = true,
		Box = true,
		Info = true,
		HealthBar = true,
		HideTeam = CONFIG.Esp.HideSameTeam,
		TracerOrigin = CONFIG.Esp.TracerOrigin,
	},
	aim = {
		Mode = CONFIG.Aim.Mode,
		Part = CONFIG.Aim.Part,
		Fov = CONFIG.Aim.Fov.Default,
		Smooth = CONFIG.Aim.Smooth.Default,
		WallCheck = CONFIG.Aim.WallCheck,
		TeamCheck = CONFIG.Aim.TeamCheck,
	},
}

local features = {}
local statusLabels = {}
local setFeature
local stopFlight
local enemyListChanged
local playerListChanged

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

local function isTeammate(target)
	return target.Team ~= nil and target.Team == player.Team
end

local function listOtherPlayerNames()
	local names = {}
	for _, other in Players:GetPlayers() do
		if other ~= player then
			table.insert(names, other.Name)
		end
	end
	table.sort(names)
	return names
end

local function createFrameGuard(featureNames, source, step)
	local failures = 0
	return function(...)
		local ok = guard(source, step, ...)
		failures = ok and 0 or failures + 1
		if failures >= CONFIG.MaxLoopFailures then
			failures = 0
			notify(source .. " lỗi liên tục nên đã tự tắt", "error")
			task.defer(function()
				for _, name in featureNames do
					setFeature(name, false, true)
				end
			end)
		end
	end
end

local function runGuardedLoop(featureName, isActive, interval, step)
	local failures = 0
	while isActive() do
		local ok = guard(featureName, step)
		failures = ok and 0 or failures + 1
		if failures >= CONFIG.MaxLoopFailures then
			notify(features[featureName].label .. " lỗi liên tục nên đã tự tắt", "error")
			setFeature(featureName, false, true)
			return
		end
		task.wait(interval)
	end
end

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
			guard("FixLag", reducer, instance)
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

local function startFullBright()
	for property, value in CONFIG.FullBright do
		setLightingOverride("FullBright", property, value)
	end
	return true
end

local function stopFullBright()
	clearLightingOverride("FullBright")
end

local function createHumanoidStat(label, resolveProperty, resolveTarget)
	local stat = {
		enabled = false,
		humanoid = nil,
		bin = newBin(),
		originals = setmetatable({}, weakKeys),
		lastWarning = 0,
	}
	rootBin.add(stat.bin.clean)

	local function applyToHumanoid(humanoid)
		local property = resolveProperty(humanoid)
		if stat.originals[humanoid] == nil then
			stat.originals[humanoid] = { property = property, value = humanoid[property] }
		end
		humanoid[property] = resolveTarget(property)
	end

	local function enforce()
		local humanoid = stat.humanoid
		if not humanoid or humanoid.Parent == nil then
			return
		end
		local property = resolveProperty(humanoid)
		local target = resolveTarget(property)
		if math.abs(humanoid[property] - target) <= 0.05 then
			return
		end
		humanoid[property] = target
		if os.clock() - stat.lastWarning > 8 then
			stat.lastWarning = os.clock()
			notify(label .. ": game đang ghi đè " .. property .. ", đã áp dụng lại", "warning")
		end
	end

	local function bindCharacter(character)
		stat.humanoid = nil
		task.spawn(function()
			local humanoid = character:WaitForChild("Humanoid", 10)
			if not stat.enabled or player.Character ~= character then
				return
			end
			if not humanoid then
				notify(label .. ": không tìm thấy Humanoid", "error")
				return
			end
			stat.humanoid = humanoid
			applyToHumanoid(humanoid)
		end)
	end

	function stat.start()
		stat.enabled = true
		if player.Character then
			bindCharacter(player.Character)
		end
		stat.bin.add(player.CharacterAdded:Connect(bindCharacter))
		stat.bin.add(RunService.Stepped:Connect(function()
			guard(label, enforce)
		end))
		return true
	end

	function stat.stop()
		stat.enabled = false
		stat.bin.clean()
		for humanoid, saved in stat.originals do
			if humanoid.Parent then
				humanoid[saved.property] = saved.value
			end
		end
		stat.originals = setmetatable({}, weakKeys)
		stat.humanoid = nil
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

local InfiniteJump = { bin = newBin() }
rootBin.add(InfiniteJump.bin.clean)

local function startInfiniteJump()
	InfiniteJump.bin.add(UserInputService.JumpRequest:Connect(function()
		local humanoid = getHumanoid()
		if humanoid and humanoid.Health > 0 then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end))
	return true
end

local function stopInfiniteJump()
	InfiniteJump.bin.clean()
end

local CameraFov = { bin = newBin(), original = nil }
rootBin.add(CameraFov.bin.clean)

local function startCameraFov()
	local camera = Workspace.CurrentCamera
	if not camera then
		return false, "Chưa có camera"
	end
	CameraFov.original = camera.FieldOfView
	CameraFov.bin.add(RunService.RenderStepped:Connect(function()
		local current = Workspace.CurrentCamera
		if current and math.abs(current.FieldOfView - selection.cameraFov) > 0.05 then
			current.FieldOfView = selection.cameraFov
		end
	end))
	return true
end

local function stopCameraFov()
	CameraFov.bin.clean()
	local camera = Workspace.CurrentCamera
	if camera and CameraFov.original then
		camera.FieldOfView = CameraFov.original
	end
end

local ZoomState = { original = nil }

local function startFarZoom()
	ZoomState.original = player.CameraMaxZoomDistance
	player.CameraMaxZoomDistance = CONFIG.MaxZoomDistance
	return true
end

local function stopFarZoom()
	if ZoomState.original then
		player.CameraMaxZoomDistance = ZoomState.original
	end
end

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

local EnemyRegistry = { tagged = {}, folder = {}, folderBound = false, folderBin = newBin() }
rootBin.add(EnemyRegistry.folderBin.clean)

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
	EnemyRegistry.folderBound = true
	EnemyRegistry.folderBin.clean()
	local function onAdded(descendant)
		if descendant:IsA("Humanoid") and descendant.Parent and descendant.Parent:IsA("Model") then
			registerEnemy(EnemyRegistry.folder, descendant.Parent)
		end
	end
	for _, descendant in folder:GetDescendants() do
		onAdded(descendant)
	end
	EnemyRegistry.folderBin.add(folder.DescendantAdded:Connect(onAdded))
	EnemyRegistry.folderBin.add(folder.DescendantRemoving:Connect(function(descendant)
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

local function rescanEnemies()
	EnemyRegistry.tagged = {}
	EnemyRegistry.folder = {}
	for _, model in CollectionService:GetTagged(CONFIG.EnemyTag) do
		registerEnemy(EnemyRegistry.tagged, model)
	end
	local folder = Workspace:FindFirstChild(CONFIG.FallbackEnemyFolder)
	if folder then
		bindFallbackFolder(folder)
	end
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

local AutoFarm = { token = 0, attackWarned = false }

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
	local ok = guard("attackTarget", attackTarget, target)
	if not ok then
		notify("Lỗi attackTarget, đã tắt Auto Farm", "error")
		task.defer(setFeature, "AutoFarm", false, true)
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

local function createFarmStep()
	local state = { target = nil, lastSearch = 0, lastAttack = 0 }
	return function()
		local _, _, root = getLivingCharacter()
		if not root then
			movement.cancel()
			state.target = nil
			setStatus("AutoFarm", "Đang chờ hồi sinh...")
			return
		end
		if state.target and not isEnemyAlive(state.target) then
			state.target = nil
		end
		if not state.target and os.clock() - state.lastSearch >= CONFIG.TargetSearchInterval then
			state.lastSearch = os.clock()
			state.target = findNearestEnemy(selection.enemyType, root.Position)
		end
		if state.target then
			state.lastAttack = farmTarget(root, state.target, state.lastAttack)
		else
			movement.cancel()
			setStatus("AutoFarm", "Waiting for enemy to spawn")
		end
	end
end

local function startAutoFarm()
	if not selection.enemyType then
		return false, "Hãy chọn loại quái trước khi bật Auto Farm"
	end
	AutoFarm.token += 1
	local token = AutoFarm.token
	stopFlight()
	requestNoclip("AutoFarm")
	setStatus("AutoFarm", "Đang tìm quái...")
	task.spawn(runGuardedLoop, "AutoFarm", function()
		return AutoFarm.token == token
	end, CONFIG.FarmTickInterval, createFarmStep())
	return true
end

local function stopAutoFarm()
	AutoFarm.token += 1
	movement.cancel()
	releaseNoclip("AutoFarm")
	setStatus("AutoFarm", "Tắt")
end

local AutoLoot = {
	token = 0,
	attempts = setmetatable({}, weakKeys),
	skipUntil = setmetatable({}, weakKeys),
	collectWarned = false,
}

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
	local ok = guard("collectLoot", collectLoot, item)
	if not ok then
		notify("Lỗi collectLoot, đã tắt Auto Loot", "error")
		task.defer(setFeature, "AutoLoot", false, true)
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

local function createLootStep()
	local state = { target = nil, lastSearch = 0 }
	return function()
		local _, _, root = getLivingCharacter()
		if not root then
			movement.cancel()
			state.target = nil
			setStatus("AutoLoot", "Đang chờ hồi sinh...")
			return
		end
		if state.target and not isLootValid(state.target) then
			state.target = nil
		end
		if not state.target and os.clock() - state.lastSearch >= CONFIG.TargetSearchInterval then
			state.lastSearch = os.clock()
			state.target = findNearestLoot(root.Position)
		end
		if state.target then
			if lootTarget(root, state.target) then
				state.target = nil
			end
		else
			movement.cancel()
			setStatus("AutoLoot", "Waiting for loot to spawn")
		end
	end
end

local function startAutoLoot()
	if next(selection.lootTypes) == nil then
		return false, "Hãy chọn ít nhất một loại vật phẩm"
	end
	AutoLoot.token += 1
	local token = AutoLoot.token
	stopFlight()
	requestNoclip("AutoLoot")
	setStatus("AutoLoot", "Đang tìm vật phẩm...")
	task.spawn(runGuardedLoop, "AutoLoot", function()
		return AutoLoot.token == token
	end, CONFIG.FarmTickInterval, createLootStep())
	return true
end

local function stopAutoLoot()
	AutoLoot.token += 1
	movement.cancel()
	releaseNoclip("AutoLoot")
	setStatus("AutoLoot", "Tắt")
end

local function startManualNoclip()
	requestNoclip("Manual")
	return true
end

local function stopManualNoclip()
	releaseNoclip("Manual")
end

local Esp = {
	owners = {},
	ownerCount = 0,
	entries = {},
	playerBins = {},
	bin = newBin(),
	container = nil,
	tracerLayer = nil,
	elapsed = 0,
	token = 0,
}
rootBin.add(Esp.bin.clean)

local espFlags = { All = false, Tracer = false }

local function isEspHidden(target)
	return selection.esp.HideTeam and isTeammate(target)
end

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
		table.insert(lines, table.concat(details, "  |  "))
	end
	return table.concat(lines, "\n")
end

local function updateEspVisuals(target, entry)
	local options = selection.esp
	local showAll = espFlags.All and not isEspHidden(target)
	entry.highlight.Enabled = showAll and options.Chams
	entry.box.Enabled = showAll and options.Box
	local showInfo = showAll and options.Info
	local showBar = showAll and options.HealthBar
	entry.info.Enabled = showInfo or showBar
	entry.infoLabel.Visible = showInfo
	entry.barBack.Visible = showBar
	if not (showInfo or showBar) then
		return
	end
	local _, _, localRoot = getLivingCharacter()
	local distance = localRoot and (entry.root.Position - localRoot.Position).Magnitude or 0
	entry.infoLabel.Text = buildEspText(target, entry, distance)
	local ratio = math.clamp(entry.humanoid.Health / math.max(entry.humanoid.MaxHealth, 1), 0, 1)
	entry.barFill.Size = UDim2.fromScale(ratio, 1)
	entry.barFill.BackgroundColor3 = CONFIG.Esp.HealthLowColor:Lerp(CONFIG.Esp.HealthHighColor, ratio)
end

local function refreshEspVisuals()
	for target, entry in Esp.entries do
		updateEspVisuals(target, entry)
	end
end

local function getTracerOrigin(camera)
	local size = camera.ViewportSize
	local mode = selection.esp.TracerOrigin
	if mode == "Giữa" then
		return Vector2.new(size.X / 2, size.Y / 2)
	end
	if mode == "Nhân vật" then
		local _, _, root = getLivingCharacter()
		if root then
			local point, onScreen = camera:WorldToViewportPoint(root.Position)
			if onScreen then
				return Vector2.new(point.X, point.Y)
			end
		end
	end
	return Vector2.new(size.X / 2, size.Y)
end

local function updateTracer(target, entry, camera, origin)
	if not espFlags.Tracer or isEspHidden(target) or not origin then
		entry.tracer.Visible = false
		return
	end
	local point = camera:WorldToViewportPoint(entry.root.Position)
	if point.Z <= 0 then
		entry.tracer.Visible = false
		return
	end
	local delta = Vector2.new(point.X, point.Y) - origin
	entry.tracer.Size = UDim2.fromOffset(delta.Magnitude, CONFIG.Esp.TracerThickness)
	entry.tracer.Position = UDim2.fromOffset(origin.X + delta.X / 2, origin.Y + delta.Y / 2)
	entry.tracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	entry.tracer.Visible = true
end

local function stepEsp(dt)
	local camera = Workspace.CurrentCamera
	if not camera then
		return
	end
	Esp.elapsed += dt
	local refreshInfo = Esp.elapsed >= CONFIG.Esp.UpdateInterval
	if refreshInfo then
		Esp.elapsed = 0
	end
	local origin = espFlags.Tracer and getTracerOrigin(camera) or nil
	for target, entry in Esp.entries do
		if refreshInfo then
			updateEspVisuals(target, entry)
		end
		updateTracer(target, entry, camera, origin)
	end
end

local espFrameGuard = createFrameGuard({ "EspAll", "EspTracer" }, "ESP", stepEsp)

local function createEspInfoGui(root, entryBin)
	local settings = CONFIG.Esp
	local info = entryBin.add(create("BillboardGui", {
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
		Parent = info,
	})
	local barBack = create("Frame", {
		Position = UDim2.new(0.1, 0, 0, 34),
		Size = UDim2.new(0.8, 0, 0, 6),
		BackgroundColor3 = Color3.fromRGB(20, 20, 20),
		BorderSizePixel = 0,
		Parent = info,
	})
	local barFill = create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = settings.HealthHighColor,
		BorderSizePixel = 0,
		Parent = barBack,
	})
	return info, infoLabel, barBack, barFill
end

local function createEspBox(root, entryBin)
	local box = entryBin.add(create("BillboardGui", {
		Adornee = root,
		AlwaysOnTop = true,
		Size = UDim2.fromScale(4.2, 6),
		ResetOnSpawn = false,
		Parent = Esp.container,
	}))
	create("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = box,
	}, { create("UIStroke", { Color = CONFIG.Esp.BoxColor, Thickness = 1.5 }) })
	return box
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
		Enabled = false,
		Parent = Esp.container,
	}))
	local box = createEspBox(root, entryBin)
	local info, infoLabel, barBack, barFill = createEspInfoGui(root, entryBin)
	local tracer = entryBin.add(create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = settings.TracerColor,
		BorderSizePixel = 0,
		Visible = false,
		Parent = Esp.tracerLayer,
	}))
	entryBin.add(humanoid.Died:Connect(function()
		removeEspEntry(target)
	end))
	local entry = {
		bin = entryBin, humanoid = humanoid, root = root, highlight = highlight, box = box,
		info = info, infoLabel = infoLabel, barBack = barBack, barFill = barFill, tracer = tracer,
	}
	Esp.entries[target] = entry
	updateEspVisuals(target, entry)
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
			logError("ESP", "không tìm thấy Humanoid/HumanoidRootPart của " .. target.Name)
			return
		end
		guard("ESP", createEspEntry, target, character)
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

local function startEspSystem()
	Esp.token += 1
	Esp.container = Esp.bin.add(create("Folder", { Name = "TKD_ESP", Parent = Workspace }))
	Esp.tracerLayer = Esp.bin.add(create("Frame", {
		Name = "TracerLayer",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 1,
		Parent = gui,
	}))
	for _, other in Players:GetPlayers() do
		trackEspPlayer(other)
	end
	Esp.bin.add(Players.PlayerAdded:Connect(trackEspPlayer))
	Esp.bin.add(Players.PlayerRemoving:Connect(untrackEspPlayer))
	Esp.bin.add(RunService.RenderStepped:Connect(espFrameGuard))
end

local function stopEspSystem()
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

local function requestEsp(owner)
	if Esp.owners[owner] then
		return
	end
	Esp.owners[owner] = true
	Esp.ownerCount += 1
	if Esp.ownerCount == 1 then
		startEspSystem()
	end
end

local function releaseEsp(owner)
	if not Esp.owners[owner] then
		return
	end
	Esp.owners[owner] = nil
	Esp.ownerCount -= 1
	if Esp.ownerCount == 0 then
		stopEspSystem()
	end
end

local function rebuildEsp()
	if Esp.ownerCount == 0 then
		return
	end
	stopEspSystem()
	startEspSystem()
end

local function startEspAll()
	espFlags.All = true
	requestEsp("All")
	return true
end

local function stopEspAll()
	espFlags.All = false
	releaseEsp("All")
end

local function startEspTracer()
	espFlags.Tracer = true
	requestEsp("Tracer")
	return true
end

local function stopEspTracer()
	espFlags.Tracer = false
	releaseEsp("Tracer")
end

local Spectate = { bin = newBin(), targetName = nil }
rootBin.add(Spectate.bin.clean)

local function setCameraSubject(humanoid)
	local camera = Workspace.CurrentCamera
	if camera and humanoid then
		camera.CameraType = Enum.CameraType.Custom
		camera.CameraSubject = humanoid
	end
end

local function applySpectateSubject(name)
	local target = Players:FindFirstChild(name)
	local character = target and target:IsA("Player") and target.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if features.Spectate.enabled and humanoid then
		setCameraSubject(humanoid)
	end
end

local function watchSpectateTarget(target)
	local name = target.Name
	local function bindCharacter(character)
		task.spawn(function()
			character:WaitForChild("Humanoid", 10)
			if Spectate.targetName == name then
				applySpectateSubject(name)
			end
		end)
	end
	Spectate.bin.add(target.CharacterAdded:Connect(bindCharacter))
	if target.Character then
		bindCharacter(target.Character)
	end
	Spectate.bin.add(Players.PlayerRemoving:Connect(function(leaving)
		if leaving == target then
			notify(name .. " đã rời server, dừng xem camera", "warning")
			task.defer(setFeature, "Spectate", false, true)
		end
	end))
	Spectate.bin.add(player.CharacterAdded:Connect(function()
		task.delay(0.6, function()
			if Spectate.targetName == name then
				applySpectateSubject(name)
			end
		end)
	end))
end

local function startSpectate()
	local name = selection.spectateName
	if not name then
		return false, "Hãy chọn đối thủ cần xem"
	end
	local target = Players:FindFirstChild(name)
	if not target or not target:IsA("Player") or target == player then
		return false, "Người chơi không còn trong server"
	end
	Spectate.targetName = name
	watchSpectateTarget(target)
	return true
end

local function stopSpectate()
	Spectate.bin.clean()
	Spectate.targetName = nil
	setCameraSubject(getHumanoid())
end

local Aim = {
	target = nil,
	lastSearch = 0,
	circle = nil,
	bin = newBin(),
	raycastParams = RaycastParams.new(),
}
Aim.raycastParams.FilterType = Enum.RaycastFilterType.Exclude
rootBin.add(Aim.bin.clean)

local AIM_BIND_NAME = "TKD_AimAssist"

local function getAimPart(character)
	if selection.aim.Part == "Đầu" then
		return character:FindFirstChild("Head")
	end
	return character:FindFirstChild("HumanoidRootPart")
end

local function hasClearLine(camera, part)
	local filter = { part.Parent }
	if player.Character then
		table.insert(filter, player.Character)
	end
	Aim.raycastParams.FilterDescendantsInstances = filter
	local origin = camera.CFrame.Position
	return Workspace:Raycast(origin, part.Position - origin, Aim.raycastParams) == nil
end

local function scoreAimTarget(camera, target, center)
	local character = target.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not humanoid or humanoid.Health <= 0 then
		return nil
	end
	if selection.aim.TeamCheck and isTeammate(target) then
		return nil
	end
	local part = getAimPart(character)
	if not part then
		return nil
	end
	local point, onScreen = camera:WorldToViewportPoint(part.Position)
	if not onScreen then
		return nil
	end
	local screenDistance = (Vector2.new(point.X, point.Y) - center).Magnitude
	if screenDistance > selection.aim.Fov then
		return nil
	end
	if selection.aim.WallCheck and not hasClearLine(camera, part) then
		return nil
	end
	local mode = selection.aim.Mode
	if mode == "Gần nhất" then
		return part, (part.Position - camera.CFrame.Position).Magnitude
	elseif mode == "Máu thấp" then
		return part, humanoid.Health
	end
	return part, screenDistance
end

local function findAimTarget(camera)
	local size = camera.ViewportSize
	local center = Vector2.new(size.X / 2, size.Y / 2)
	local bestPart, bestScore = nil, math.huge
	for _, other in Players:GetPlayers() do
		if other ~= player then
			local part, score = scoreAimTarget(camera, other, center)
			if part and score < bestScore then
				bestPart, bestScore = part, score
			end
		end
	end
	return bestPart
end

local function isAimHeld()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		return true
	end
	return UserInputService:IsMouseButtonPressed(CONFIG.Aim.HoldInput)
end

local function updateAimCircle()
	if Aim.circle then
		local diameter = selection.aim.Fov * 2
		Aim.circle.Size = UDim2.fromOffset(diameter, diameter)
	end
end

local function stepAim()
	local camera = Workspace.CurrentCamera
	if not camera or not isAimHeld() then
		Aim.target = nil
		setStatus("Aim", "Đang chờ (giữ chuột phải)")
		return
	end
	local now = os.clock()
	local stale = not Aim.target or not Aim.target.Parent
	if stale or now - Aim.lastSearch >= CONFIG.Aim.SearchInterval then
		Aim.lastSearch = now
		Aim.target = findAimTarget(camera)
	end
	local part = Aim.target
	if not part then
		setStatus("Aim", "Không có mục tiêu trong vòng FOV")
		return
	end
	local goal = CFrame.lookAt(camera.CFrame.Position, part.Position)
	camera.CFrame = camera.CFrame:Lerp(goal, selection.aim.Smooth)
	setStatus("Aim", "Đang khóa: " .. part.Parent.Name)
end

local aimFrameGuard = createFrameGuard({ "Aim" }, "Aim", stepAim)

local function startAim()
	Aim.circle = Aim.bin.add(create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 2,
		Parent = gui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(1, 0) }),
		create("UIStroke", { Color = CONFIG.Aim.CircleColor, Thickness = 1.2, Transparency = 0.4 }),
	}))
	updateAimCircle()
	RunService:BindToRenderStep(AIM_BIND_NAME, Enum.RenderPriority.Camera.Value + 1, aimFrameGuard)
	Aim.bin.add(function()
		RunService:UnbindFromRenderStep(AIM_BIND_NAME)
	end)
	setStatus("Aim", "Đang chờ (giữ chuột phải)")
	return true
end

local function stopAim()
	Aim.bin.clean()
	Aim.target = nil
	Aim.circle = nil
	setStatus("Aim", "Tắt")
end

local Flight = { token = 0, tween = nil, waypoints = {} }
local PLAYER_PREFIX = "Người: "
local POINT_PREFIX = "Điểm: "
local MANUAL_KEY = "Tọa độ nhập"

local function parseCoordinates(text)
	local x, y, z = string.match(text or "", "^%s*(-?[%d%.]+)[,%s]+(-?[%d%.]+)[,%s]+(-?[%d%.]+)%s*$")
	if not x then
		return nil, "Tọa độ không hợp lệ, nhập dạng: x, y, z"
	end
	local vector = Vector3.new(tonumber(x) or 0, tonumber(y) or 0, tonumber(z) or 0)
	return vector
end

local function resolveDestination(key)
	if not key then
		return nil, "Hãy chọn điểm đến"
	end
	if key == MANUAL_KEY then
		return parseCoordinates(selection.coordinateText)
	end
	if string.sub(key, 1, #PLAYER_PREFIX) == PLAYER_PREFIX then
		local target = Players:FindFirstChild(string.sub(key, #PLAYER_PREFIX + 1))
		local character = target and target:IsA("Player") and target.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root then
			return root.Position
		end
		return nil, "Người chơi này không có nhân vật"
	end
	local pointName = string.sub(key, #POINT_PREFIX + 1)
	for _, waypoint in Flight.waypoints do
		if waypoint.name == pointName then
			return waypoint.position
		end
	end
	return nil, "Không tìm thấy điểm đã lưu"
end

local function listDestinations()
	local options = { MANUAL_KEY }
	for _, name in listOtherPlayerNames() do
		table.insert(options, PLAYER_PREFIX .. name)
	end
	for _, waypoint in Flight.waypoints do
		table.insert(options, POINT_PREFIX .. waypoint.name)
	end
	return options
end

local function finishFlight(token)
	if Flight.token ~= token then
		return
	end
	Flight.token += 1
	if Flight.tween then
		Flight.tween:Cancel()
		Flight.tween = nil
	end
	releaseNoclip("Flight")
end

local function runFlight(token, root, destination)
	local distance = (root.Position - destination).Magnitude
	local duration = math.max(distance / CONFIG.Fly.Speed, CONFIG.MinTweenTime)
	local goal = CFrame.new(destination + Vector3.new(0, CONFIG.Fly.HeightOffset, 0)) * root.CFrame.Rotation
	local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = goal })
	Flight.tween = tween
	setStatus("Flight", string.format("Đang bay... %dm", math.floor(distance)))
	tween:Play()
	while Flight.token == token and root.Parent and tween.PlaybackState == Enum.PlaybackState.Playing do
		task.wait(0.1)
	end
	if Flight.token ~= token then
		return
	end
	root.AssemblyLinearVelocity = Vector3.zero
	finishFlight(token)
	setStatus("Flight", "Đã đến nơi")
	notify("Đã bay đến nơi", "success")
end

local function startFlight()
	local destination, reason = resolveDestination(selection.destination)
	if not destination then
		notify(reason or "Điểm đến không hợp lệ", "error")
		return
	end
	local _, _, root = getLivingCharacter()
	if not root then
		notify("Nhân vật chưa sẵn sàng", "error")
		return
	end
	if features.AutoFarm.enabled then
		setFeature("AutoFarm", false)
	end
	if features.AutoLoot.enabled then
		setFeature("AutoLoot", false)
	end
	stopFlight()
	Flight.token += 1
	local token = Flight.token
	requestNoclip("Flight")
	task.spawn(function()
		local ok = guard("Flight", runFlight, token, root, destination)
		if not ok then
			finishFlight(token)
			setStatus("Flight", "Lỗi khi bay")
			notify("Bay đến thất bại", "error")
		end
	end)
end

function stopFlight()
	if Flight.tween or Noclip.owners.Flight then
		Flight.token += 1
		if Flight.tween then
			Flight.tween:Cancel()
			Flight.tween = nil
		end
		releaseNoclip("Flight")
		setStatus("Flight", "Đã dừng")
	end
end

local function saveWaypoint()
	local _, _, root = getLivingCharacter()
	if not root then
		notify("Không thể lưu vị trí lúc này", "error")
		return nil
	end
	local name = "Điểm " .. (#Flight.waypoints + 1)
	table.insert(Flight.waypoints, { name = name, position = root.Position })
	notify("Đã lưu " .. name, "success")
	if playerListChanged then
		playerListChanged()
	end
	return name
end

local Monitor = { frames = 0, elapsed = 0, fps = 0, ping = 0, listeners = {} }

local function readPing()
	local network = Stats:FindFirstChild("Network")
	local serverItems = network and network:FindFirstChild("ServerStatsItem")
	local pingItem = serverItems and serverItems:FindFirstChild("Data Ping")
	if pingItem then
		return pingItem:GetValue()
	end
	return player:GetNetworkPing() * 1000
end

rootBin.add(RunService.Heartbeat:Connect(function(dt)
	Monitor.frames += 1
	Monitor.elapsed += dt
	if Monitor.elapsed < 0.5 then
		return
	end
	Monitor.fps = Monitor.frames / Monitor.elapsed
	Monitor.frames, Monitor.elapsed = 0, 0
	local ok, ping = guard("Ping", readPing)
	Monitor.ping = ok and ping or 0
	for name, listener in Monitor.listeners do
		guard(name, listener)
	end
end))

local hudState = { label = nil }

local function startHud()
	if hudState.label then
		hudState.label.Visible = true
	end
	return true
end

local function stopHud()
	if hudState.label then
		hudState.label.Visible = false
	end
end

features.FixLag = { label = "Fix Lag", start = startFixLag, stop = stopFixLag }
features.FullBright = { label = "Full Bright", start = startFullBright, stop = stopFullBright }
features.SpeedWalk = { label = "Speed Walk", start = walkStat.start, stop = walkStat.stop }
features.HighJump = { label = "High Jump", start = jumpStat.start, stop = jumpStat.stop }
features.InfiniteJump = { label = "Nhảy vô hạn", start = startInfiniteJump, stop = stopInfiniteJump }
features.Noclip = { label = "Noclip", start = startManualNoclip, stop = stopManualNoclip }
features.CameraFov = { label = "FOV camera", start = startCameraFov, stop = stopCameraFov }
features.FarZoom = { label = "Zoom xa", start = startFarZoom, stop = stopFarZoom }
features.EspAll = { label = "ESP tất cả", start = startEspAll, stop = stopEspAll }
features.EspTracer = { label = "ESP dây", start = startEspTracer, stop = stopEspTracer }
features.Spectate = { label = "Xem camera", start = startSpectate, stop = stopSpectate }
features.Aim = { label = "Aim", start = startAim, stop = stopAim }
features.AutoFarm = { label = "Auto Farm", start = startAutoFarm, stop = stopAutoFarm }
features.AutoLoot = { label = "Auto Loot", start = startAutoLoot, stop = stopAutoLoot }
features.Hud = { label = "FPS / Ping", start = startHud, stop = stopHud }

local EXCLUSIVE_FEATURES = { AutoFarm = "AutoLoot", AutoLoot = "AutoFarm" }

local function syncToggle(feature)
	if feature.toggle then
		feature.toggle.set(feature.enabled)
	end
end

local function enableFeature(feature, silent)
	local ok, success, reason = pcall(feature.start)
	if not ok then
		logError(feature.label, success)
		notify("Lỗi khi bật " .. feature.label, "error")
		return false
	end
	if success == false then
		notify(reason or ("Không thể bật " .. feature.label), "error")
		return false
	end
	feature.enabled = true
	if not silent then
		notify("Đã bật " .. feature.label, "success")
	end
	return true
end

local function disableFeature(feature, silent)
	local ok, err = pcall(feature.stop)
	if not ok then
		logError(feature.label, err)
		notify("Lỗi khi tắt " .. feature.label, "error")
	end
	feature.enabled = false
	if not silent then
		notify("Đã tắt " .. feature.label, "info")
	end
end

function setFeature(name, enabled, silent)
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
		enableFeature(feature, silent)
	else
		disableFeature(feature, silent)
	end
	syncToggle(feature)
	return feature.enabled == enabled
end

local function shutdown()
	stopFlight()
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
		playClick()
		animate(0.96, 0.08)
	end))
	rootBin.add(button.MouseButton1Up:Connect(function()
		animate(1, 0.12)
	end))
	rootBin.add(button.MouseLeave:Connect(function()
		animate(1, 0.12)
	end))
end

local function createBar(parent, color, length, thickness, position, rotation)
	return create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = position,
		Size = UDim2.fromOffset(length, thickness),
		Rotation = rotation,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = parent,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
end

local function createIcon(kind, parent, color, size)
	local icon = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size, size),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	local center = UDim2.fromScale(0.5, 0.5)
	if kind == "grid" then
		local cell = size * 0.42
		for row = 0, 1 do
			for column = 0, 1 do
				create("Frame", {
					Position = UDim2.fromOffset(size * 0.05 + column * size * 0.48, size * 0.05 + row * size * 0.48),
					Size = UDim2.fromOffset(cell, cell),
					BackgroundColor3 = color,
					BorderSizePixel = 0,
					Parent = icon,
				}, { create("UICorner", { CornerRadius = UDim.new(0.28, 0) }) })
			end
		end
	elseif kind == "close" then
		createBar(icon, color, size, 2, center, 45)
		createBar(icon, color, size, 2, center, -45)
	elseif kind == "minus" then
		createBar(icon, color, size, 2, center, 0)
	elseif kind == "chevron" then
		createBar(icon, color, size * 0.6, 2, UDim2.fromScale(0.34, 0.5), 45)
		createBar(icon, color, size * 0.6, 2, UDim2.fromScale(0.66, 0.5), -45)
	end
	return icon
end

local function createSection(parent, text)
	return create("TextLabel", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Text = string.upper(text),
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.Accent,
		TextSize = 11,
		Font = Enum.Font.GothamBold,
		Parent = parent,
	})
end

local function createInfoLabel(parent, text, textSize, color)
	return create("TextLabel", {
		LayoutOrder = nextOrder(),
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

local function createCard(parent, size)
	return create("Frame", {
		LayoutOrder = nextOrder(),
		Size = size,
		BackgroundColor3 = theme.Element,
		BorderSizePixel = 0,
		Parent = parent,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
	})
end

local function createButton(parent, text, onClick, color, size)
	local button = create("TextButton", {
		LayoutOrder = nextOrder(),
		Size = size or UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = color or theme.Element,
		Text = text,
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = parent,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
	})
	addPressFeedback(button)
	connectGuarded(button.Activated, text, onClick)
	return button
end

local function createButtonRow(parent, definitions)
	local row = create("Frame", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		Parent = parent,
	}, { create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6) }) })
	local width = 1 / #definitions
	for _, definition in definitions do
		createButton(row, definition.text, definition.onClick, definition.color, UDim2.new(width, -4, 1, 0))
	end
end

local function createToggle(parent, text, onClick)
	local row = create("TextButton", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = theme.Element,
		AutoButtonColor = false,
		Text = "",
		Parent = parent,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
	})
	create("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -64, 1, 0),
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
		Position = UDim2.new(1, -12, 0.5, 0),
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
	connectGuarded(row.Activated, text, function()
		onClick(not toggle.state)
	end)
	return toggle
end

local function bindFeatureToggle(parent, name)
	local feature = features[name]
	feature.toggle = createToggle(parent, feature.label, function(wanted)
		setFeature(name, wanted)
	end)
end

local function createOptionToggle(parent, text, initial, onChanged)
	local toggle
	toggle = createToggle(parent, text, function(wanted)
		toggle.set(wanted)
		onChanged(wanted)
	end)
	toggle.set(initial)
	return toggle
end

local function formatNumber(value, step)
	if step < 0.1 then
		return string.format("%.2f", value)
	end
	if step < 1 then
		return string.format("%.1f", value)
	end
	return string.format("%d", math.floor(value + 0.5))
end

local function createSlider(parent, text, range, onChanged)
	local slider = { min = range.Min, max = range.Max, step = range.Step, value = range.Default }
	local container = createCard(parent, UDim2.new(1, 0, 0, 58))
	local title = create("TextLabel", {
		Position = UDim2.fromOffset(12, 4),
		Size = UDim2.new(1, -90, 0, 24),
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
		Position = UDim2.new(1, -10, 0, 5),
		Size = UDim2.fromOffset(60, 22),
		BackgroundColor3 = theme.Background,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		Text = "",
		Parent = container,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 6) }),
		create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
	})
	local track = create("TextButton", {
		Position = UDim2.fromOffset(12, 34),
		Size = UDim2.new(1, -24, 0, 16),
		BackgroundTransparency = 1,
		Text = "",
		AutoButtonColor = false,
		Parent = container,
	})
	local rail = create("Frame", {
		Position = UDim2.new(0, 0, 0.5, -3),
		Size = UDim2.new(1, 0, 0, 6),
		BackgroundColor3 = theme.Off,
		BorderSizePixel = 0,
		Parent = track,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	local fill = create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = theme.Accent,
		BorderSizePixel = 0,
		Parent = rail,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })

	local function render()
		local span = math.max(slider.max - slider.min, 0.0001)
		fill.Size = UDim2.fromScale((slider.value - slider.min) / span, 1)
		box.Text = formatNumber(slider.value, slider.step)
	end

	function slider.setValue(value, silent)
		local stepped = math.round(value / slider.step) * slider.step
		slider.value = math.clamp(stepped, slider.min, slider.max)
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
			playClick()
			guard("Slider", setFromPointer, input.Position.X)
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
			guard("Slider", setFromPointer, input.Position.X)
		end
	end))
	rootBin.add(box.FocusGained:Connect(playClick))
	connectGuarded(box.FocusLost, text, function()
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
	end)
	render()
	return slider
end

local function createSegmented(parent, title, choices, default, onChanged)
	local container = createCard(parent, UDim2.new(1, 0, 0, 62))
	create("TextLabel", {
		Position = UDim2.fromOffset(12, 4),
		Size = UDim2.new(1, -24, 0, 22),
		BackgroundTransparency = 1,
		Text = title,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.SubText,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		Parent = container,
	})
	local strip = create("Frame", {
		Position = UDim2.fromOffset(8, 28),
		Size = UDim2.new(1, -16, 0, 26),
		BackgroundTransparency = 1,
		Parent = container,
	}, { create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4) }) })
	local segmented = { value = default, buttons = {} }
	local function render()
		for choice, button in segmented.buttons do
			button.BackgroundColor3 = choice == segmented.value and theme.Accent or theme.Background
		end
	end
	function segmented.set(value, silent)
		segmented.value = value
		render()
		if not silent then
			onChanged(value)
		end
	end
	for _, choice in choices do
		local button = create("TextButton", {
			Size = UDim2.new(1 / #choices, -4, 1, 0),
			BackgroundColor3 = theme.Background,
			Text = choice,
			TextColor3 = theme.Text,
			TextSize = 12,
			Font = Enum.Font.GothamMedium,
			AutoButtonColor = false,
			Parent = strip,
		}, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
		segmented.buttons[choice] = button
		addPressFeedback(button)
		connectGuarded(button.Activated, title, function()
			segmented.set(choice)
		end)
	end
	render()
	return segmented
end

local function createInput(parent, placeholder, onChanged)
	local box = create("TextBox", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = theme.Element,
		PlaceholderText = placeholder,
		PlaceholderColor3 = theme.SubText,
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		Parent = parent,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
		create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
	})
	rootBin.add(box.FocusGained:Connect(playClick))
	connectGuarded(box.FocusLost, placeholder, function()
		onChanged(box.Text)
	end)
	return box
end

local function createDropdown(parent, options)
	local dropdown = { selected = {}, open = false }
	local container = createCard(parent, UDim2.new(1, 0, 0, 0))
	container.AutomaticSize = Enum.AutomaticSize.Y
	create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = container })
	local header = create("TextButton", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		Parent = container,
	})
	local headerLabel = create("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(1, -40, 1, 0),
		BackgroundTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = theme.Text,
		TextSize = 13,
		Font = Enum.Font.GothamMedium,
		Parent = header,
	})
	local arrowHolder = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, -10, 0.5, 0),
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		Parent = header,
	})
	createIcon("chevron", arrowHolder, theme.SubText, 12)
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
		Size = UDim2.new(1, 0, 0, 104),
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
					Size = UDim2.new(1, -4, 0, 26),
					BackgroundColor3 = isSelected and theme.Accent or theme.Background,
					AutoButtonColor = false,
					Text = name,
					TextColor3 = theme.Text,
					TextSize = 12,
					Font = Enum.Font.GothamMedium,
					Parent = list,
				}, { create("UICorner", { CornerRadius = UDim.new(0, 6) }) })
				item.MouseButton1Down:Connect(playClick)
				item.Activated:Connect(function()
					guard("Dropdown", choose, name)
				end)
			end
		end
		updateHeader()
	end

	function dropdown.setOpen(open)
		dropdown.open = open
		body.Visible = open
		if open then
			dropdown.refresh()
		end
	end

	addPressFeedback(header)
	connectGuarded(header.Activated, options.title, function()
		dropdown.setOpen(not dropdown.open)
	end)
	rootBin.add(search:GetPropertyChangedSignal("Text"):Connect(dropdown.refresh))
	rootBin.add(search.FocusGained:Connect(playClick))
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
					guard("Tap", onTap)
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

local viewport = getViewportSize()
local WINDOW_WIDTH = math.min(360, viewport.X - 16)
local WINDOW_HEIGHT = math.min(430, viewport.Y - 16)
local TITLE_HEIGHT = 38

local bubble = create("TextButton", {
	Name = "MenuBubble",
	Position = UDim2.fromOffset(14, 100),
	Size = UDim2.fromOffset(48, 48),
	BackgroundColor3 = theme.Panel,
	Text = "",
	AutoButtonColor = false,
	Visible = false,
	ZIndex = 10,
	Parent = gui,
}, {
	create("UICorner", { CornerRadius = UDim.new(1, 0) }),
	create("UIStroke", { Color = theme.Accent, Thickness = 1.5 }),
})
createIcon("grid", bubble, theme.Text, 22)
addPressFeedback(bubble)

local window = create("Frame", {
	Name = "Window",
	Position = UDim2.fromOffset(math.max(math.min(72, viewport.X - WINDOW_WIDTH - 4), 0), 56),
	Size = UDim2.fromOffset(WINDOW_WIDTH, WINDOW_HEIGHT),
	BackgroundColor3 = theme.Background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Active = true,
	Visible = false,
	ZIndex = 5,
	Parent = gui,
}, {
	create("UICorner", { CornerRadius = UDim.new(0, 12) }),
	create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
})
local windowScale = create("UIScale", { Parent = window })
local windowState = { open = false, id = 0, minimized = false }
bindSurfaceClick(window)
bindSurfaceClick(bubble)

local titleBar = create("Frame", {
	Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
	BackgroundColor3 = theme.Panel,
	BorderSizePixel = 0,
	Parent = window,
})
local titleIconHolder = create("Frame", {
	Position = UDim2.fromOffset(10, 0),
	Size = UDim2.fromOffset(20, TITLE_HEIGHT),
	BackgroundTransparency = 1,
	Parent = titleBar,
})
createIcon("grid", titleIconHolder, theme.Accent, 14)
create("TextLabel", {
	Position = UDim2.fromOffset(36, 0),
	Size = UDim2.new(1, -100, 1, 0),
	BackgroundTransparency = 1,
	Text = CONFIG.MenuName .. "  " .. CONFIG.Version,
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = theme.Text,
	TextSize = 14,
	Font = Enum.Font.GothamBold,
	Parent = titleBar,
})

local function createTitleButton(iconKind, offsetX, color)
	local button = create("TextButton", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, offsetX, 0.5, 0),
		Size = UDim2.fromOffset(26, 26),
		BackgroundColor3 = color,
		Text = "",
		AutoButtonColor = false,
		Parent = titleBar,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 7) }) })
	createIcon(iconKind, button, theme.Text, 11)
	addPressFeedback(button)
	return button
end

local minimizeButton = createTitleButton("minus", -42, theme.Element)
local closeButton = createTitleButton("close", -10, theme.Danger)

local body = create("Frame", {
	Position = UDim2.fromOffset(0, TITLE_HEIGHT),
	Size = UDim2.new(1, 0, 1, -TITLE_HEIGHT),
	BackgroundTransparency = 1,
	Parent = window,
})
local tabBar = create("ScrollingFrame", {
	Position = UDim2.fromOffset(8, 6),
	Size = UDim2.new(1, -16, 0, 30),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.X,
	AutomaticCanvasSize = Enum.AutomaticSize.X,
	CanvasSize = UDim2.new(),
	Parent = body,
}, {
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})
local pagesHolder = create("Frame", {
	Position = UDim2.fromOffset(8, 42),
	Size = UDim2.new(1, -16, 1, -50),
	BackgroundTransparency = 1,
	Parent = body,
})

local pages, tabButtons = {}, {}

local function selectTab(name)
	for pageName, page in pages do
		page.Visible = pageName == name
		tabButtons[pageName].BackgroundColor3 = pageName == name and theme.Accent or theme.Element
	end
	windowState.activeTab = name
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
		create("UIPadding", { PaddingRight = UDim.new(0, 6), PaddingBottom = UDim.new(0, 10) }),
	})
	local tab = create("TextButton", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(0, 0, 1, 0),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = theme.Element,
		Text = title,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		AutoButtonColor = false,
		Parent = tabBar,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 8) }),
		create("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }),
	})
	addPressFeedback(tab)
	connectGuarded(tab.Activated, title, function()
		selectTab(name)
	end)
	pages[name], tabButtons[name] = page, tab
	return page
end

local function setWindowOpen(open)
	windowState.open = open
	windowState.id += 1
	local id = windowState.id
	if open then
		windowScale.Scale = 0.92
		window.Visible = true
		playTween(windowScale, 0.15, { Scale = 1 })
	else
		playTween(windowScale, 0.12, { Scale = 0.92 })
		task.delay(0.12, function()
			if windowState.id == id then
				window.Visible = false
			end
		end)
	end
end

local function setMinimized(minimized)
	windowState.minimized = minimized
	body.Visible = not minimized
	playTween(window, 0.18, { Size = UDim2.fromOffset(WINDOW_WIDTH, minimized and TITLE_HEIGHT or WINDOW_HEIGHT) })
end

connectGuarded(minimizeButton.Activated, "Minimize", function()
	setMinimized(not windowState.minimized)
end)
connectGuarded(closeButton.Activated, "Close", function()
	setWindowOpen(false)
end)

makeDraggable(titleBar, window)
makeDraggable(bubble, bubble, function()
	setWindowOpen(not windowState.open)
end)

rootBin.add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == CONFIG.MenuToggleKey then
		setWindowOpen(not windowState.open)
	end
end))

local controls = {}
local dropdowns = {}

local function createInfoRow(parent, title)
	local row = createCard(parent, UDim2.new(1, 0, 0, 28))
	create("TextLabel", {
		Position = UDim2.fromOffset(12, 0),
		Size = UDim2.new(0, 110, 1, 0),
		BackgroundTransparency = 1,
		Text = title,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.SubText,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		Parent = row,
	})
	return create("TextLabel", {
		Position = UDim2.fromOffset(122, 0),
		Size = UDim2.new(1, -134, 1, 0),
		BackgroundTransparency = 1,
		Text = "-",
		TextXAlignment = Enum.TextXAlignment.Right,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		Parent = row,
	})
end

local function createHealthWidget(parent)
	local card = createCard(parent, UDim2.new(1, 0, 0, 46))
	local label = create("TextLabel", {
		Position = UDim2.fromOffset(12, 4),
		Size = UDim2.new(1, -24, 0, 18),
		BackgroundTransparency = 1,
		Text = "Máu",
		TextXAlignment = Enum.TextXAlignment.Left,
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamBold,
		Parent = card,
	})
	local rail = create("Frame", {
		Position = UDim2.fromOffset(12, 28),
		Size = UDim2.new(1, -24, 0, 8),
		BackgroundColor3 = theme.Off,
		BorderSizePixel = 0,
		Parent = card,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	local fill = create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = CONFIG.Esp.HealthHighColor,
		BorderSizePixel = 0,
		Parent = rail,
	}, { create("UICorner", { CornerRadius = UDim.new(1, 0) }) })
	return function(health, maxHealth)
		local ratio = math.clamp(health / math.max(maxHealth, 1), 0, 1)
		label.Text = string.format("Máu  %d / %d", math.floor(health), math.floor(maxHealth))
		fill.Size = UDim2.fromScale(ratio, 1)
		fill.BackgroundColor3 = CONFIG.Esp.HealthLowColor:Lerp(CONFIG.Esp.HealthHighColor, ratio)
	end
end

local function buildDashboardPage(page)
	local clock = create("TextLabel", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 26,
		Font = Enum.Font.GothamBold,
		Parent = page,
	})
	local dateLabel = createInfoLabel(page, "", 12, theme.SubText)
	dateLabel.TextXAlignment = Enum.TextXAlignment.Center
	local updateHealth = createHealthWidget(page)
	local rows = {}
	local function addRow(title, getter)
		table.insert(rows, { label = createInfoRow(page, title), getter = getter })
	end
	addRow("Tên", function()
		return player.DisplayName .. " (@" .. player.Name .. ")"
	end)
	addRow("UserId", function()
		return player.UserId
	end)
	addRow("Tuổi tài khoản", function()
		return player.AccountAge .. " ngày"
	end)
	addRow("FPS", function()
		return string.format("%d", math.floor(Monitor.fps + 0.5))
	end)
	addRow("Ping", function()
		return string.format("%d ms", math.floor(Monitor.ping + 0.5))
	end)
	addRow("Tốc độ / Nhảy", function()
		local humanoid = getHumanoid()
		if not humanoid then
			return "-"
		end
		local jump = humanoid.UseJumpPower and humanoid.JumpPower or humanoid.JumpHeight
		return string.format("%.1f / %.1f", humanoid.WalkSpeed, jump)
	end)
	addRow("Vị trí", function()
		local _, _, root = getLivingCharacter()
		if not root then
			return "-"
		end
		local position = root.Position
		return string.format("%d, %d, %d", position.X, position.Y, position.Z)
	end)
	addRow("Đội", function()
		return player.Team and player.Team.Name or "Không có"
	end)
	addRow("Người chơi", function()
		return #Players:GetPlayers() .. " / " .. Players.MaxPlayers
	end)
	addRow("Server", function()
		return game.JobId ~= "" and string.sub(game.JobId, 1, 8) or "Studio"
	end)
	addRow("PlaceId", function()
		return game.PlaceId
	end)
	addRow("Tính năng bật", function()
		local count = 0
		for _, feature in features do
			if feature.enabled then
				count += 1
			end
		end
		return count
	end)
	local function refresh()
		clock.Text = os.date("%H:%M:%S")
		dateLabel.Text = os.date("%A, %d/%m/%Y")
		local humanoid = getHumanoid()
		if humanoid then
			updateHealth(humanoid.Health, humanoid.MaxHealth)
		else
			updateHealth(0, 100)
		end
		for _, row in rows do
			local ok, value = pcall(row.getter)
			row.label.Text = ok and tostring(value) or "N/A"
		end
	end
	Monitor.listeners.Dashboard = function()
		if windowState.open and not windowState.minimized and windowState.activeTab == "overview" then
			refresh()
		end
	end
	refresh()
end

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

local function buildCharacterPage(page)
	createSection(page, "Di chuyển")
	bindFeatureToggle(page, "SpeedWalk")
	controls.walk = createSlider(page, "Tốc độ chạy (WalkSpeed)", CONFIG.WalkSpeed, function(value)
		selection.walkSpeed = value
	end)
	bindFeatureToggle(page, "HighJump")
	jumpSlider = createSlider(page, "Độ nhảy", CONFIG.JumpPower, function(value)
		selection.jumpValues[detectJumpProperty()] = value
	end)
	controls.jump = jumpSlider
	bindFeatureToggle(page, "InfiniteJump")
	bindFeatureToggle(page, "Noclip")
	createSection(page, "Camera")
	bindFeatureToggle(page, "CameraFov")
	controls.fov = createSlider(page, "Góc nhìn (FOV)", CONFIG.CameraFov, function(value)
		selection.cameraFov = value
	end)
	bindFeatureToggle(page, "FarZoom")
	syncJumpSlider()
end

local function buildEspPage(page)
	createSection(page, "ESP tất cả (thấy xuyên tường)")
	bindFeatureToggle(page, "EspAll")
	local function optionToggle(text, key)
		createOptionToggle(page, text, selection.esp[key], function(wanted)
			selection.esp[key] = wanted
			refreshEspVisuals()
		end)
	end
	optionToggle("Hình người xuyên tường (Chams)", "Chams")
	optionToggle("Khung hộp (Box)", "Box")
	optionToggle("Tên, khoảng cách, máu", "Info")
	optionToggle("Thanh máu", "HealthBar")
	createSection(page, "ESP dây (từ họ đến mình)")
	bindFeatureToggle(page, "EspTracer")
	controls.tracerOrigin = createSegmented(page, "Điểm đầu dây", { "Dưới", "Giữa", "Nhân vật" }, selection.esp.TracerOrigin, function(value)
		selection.esp.TracerOrigin = value
	end)
	createSection(page, "Bộ lọc")
	controls.hideTeam = createOptionToggle(page, "Ẩn đồng đội", selection.esp.HideTeam, function(wanted)
		selection.esp.HideTeam = wanted
		refreshEspVisuals()
	end)
	createSection(page, "Xem camera đối thủ")
	dropdowns.spectate = createDropdown(page, {
		title = "Đối thủ",
		multi = false,
		getOptions = listOtherPlayerNames,
		onChanged = function(selected)
			selection.spectateName = next(selected)
			if features.Spectate.enabled then
				setFeature("Spectate", false, true)
				setFeature("Spectate", true, true)
			end
		end,
	})
	bindFeatureToggle(page, "Spectate")
end

local function buildAimPage(page)
	createSection(page, "Aim hỗ trợ")
	bindFeatureToggle(page, "Aim")
	statusLabels.Aim = createInfoLabel(page, "Tắt", 12, theme.SubText)
	controls.aimMode = createSegmented(page, "Kiểu chọn mục tiêu", { "Tâm màn hình", "Gần nhất", "Máu thấp" }, selection.aim.Mode, function(value)
		selection.aim.Mode = value
	end)
	controls.aimPart = createSegmented(page, "Vị trí ngắm", { "Đầu", "Thân" }, selection.aim.Part, function(value)
		selection.aim.Part = value
	end)
	controls.aimFov = createSlider(page, "Vòng FOV (px)", CONFIG.Aim.Fov, function(value)
		selection.aim.Fov = value
		updateAimCircle()
	end)
	controls.aimSmooth = createSlider(page, "Độ mượt (nhỏ = mượt)", CONFIG.Aim.Smooth, function(value)
		selection.aim.Smooth = value
	end)
	controls.aimWall = createOptionToggle(page, "Kiểm tra vật cản", selection.aim.WallCheck, function(wanted)
		selection.aim.WallCheck = wanted
	end)
	controls.aimTeam = createOptionToggle(page, "Bỏ qua đồng đội", selection.aim.TeamCheck, function(wanted)
		selection.aim.TeamCheck = wanted
	end)
	createInfoLabel(page, "PC: giữ chuột phải để ngắm. Điện thoại: tự ngắm khi bật.", 11, theme.SubText)
end

local function buildFarmPage(page)
	createSection(page, "Auto Farm")
	statusLabels.AutoFarm = createInfoLabel(page, "Tắt", 12, theme.SubText)
	dropdowns.enemy = createDropdown(page, {
		title = "Quái",
		multi = false,
		getOptions = listEnemyTypes,
		onChanged = function(selected)
			selection.enemyType = next(selected)
		end,
	})
	bindFeatureToggle(page, "AutoFarm")
	createSection(page, "Auto Loot")
	statusLabels.AutoLoot = createInfoLabel(page, "Tắt", 12, theme.SubText)
	dropdowns.loot = createDropdown(page, {
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

local function buildFlightPage(page)
	createSection(page, "Bay đến vị trí")
	statusLabels.Flight = createInfoLabel(page, "Sẵn sàng", 12, theme.SubText)
	dropdowns.destination = createDropdown(page, {
		title = "Điểm đến",
		multi = false,
		getOptions = listDestinations,
		onChanged = function(selected)
			selection.destination = next(selected)
		end,
	})
	local coordinateBox = createInput(page, "Tọa độ: x, y, z", function(text)
		selection.coordinateText = text
	end)
	createButtonRow(page, {
		{ text = "Bay đến", color = theme.Accent, onClick = startFlight },
		{ text = "Dừng", onClick = function()
			stopFlight()
		end },
	})
	createButton(page, "Lưu vị trí hiện tại", function()
		local name = saveWaypoint()
		local _, _, root = getLivingCharacter()
		if name and root then
			local position = root.Position
			coordinateBox.Text = string.format("%d, %d, %d", position.X, position.Y, position.Z)
			selection.coordinateText = coordinateBox.Text
		end
	end)
	createInfoLabel(page, "Chọn người chơi, điểm đã lưu hoặc nhập tọa độ rồi bấm Bay đến.", 11, theme.SubText)
end

local function refreshAll()
	rescanEnemies()
	rebuildEsp()
	AutoLoot.skipUntil = setmetatable({}, weakKeys)
	AutoLoot.attempts = setmetatable({}, weakKeys)
	syncJumpSlider()
	for _, dropdown in dropdowns do
		dropdown.refresh()
	end
	refreshEspVisuals()
	notify(string.format("Đã làm mới: %d người chơi, %d loại quái", #Players:GetPlayers() - 1, #listEnemyTypes()), "success")
end

local function resetAll()
	stopFlight()
	for name, feature in features do
		if feature.enabled then
			setFeature(name, false, true)
		end
	end
	selection.walkSpeed = CONFIG.WalkSpeed.Default
	selection.cameraFov = CONFIG.CameraFov.Default
	selection.jumpValues.JumpPower = CONFIG.JumpPower.Default
	selection.jumpValues.JumpHeight = CONFIG.JumpHeight.Default
	controls.walk.setValue(CONFIG.WalkSpeed.Default, true)
	controls.fov.setValue(CONFIG.CameraFov.Default, true)
	syncJumpSlider()
	controls.tracerOrigin.set(CONFIG.Esp.TracerOrigin)
	controls.hideTeam.set(CONFIG.Esp.HideSameTeam)
	selection.esp.HideTeam = CONFIG.Esp.HideSameTeam
	controls.aimMode.set(CONFIG.Aim.Mode)
	controls.aimPart.set(CONFIG.Aim.Part)
	controls.aimFov.setValue(CONFIG.Aim.Fov.Default)
	controls.aimSmooth.setValue(CONFIG.Aim.Smooth.Default)
	controls.aimWall.set(CONFIG.Aim.WallCheck)
	controls.aimTeam.set(CONFIG.Aim.TeamCheck)
	selection.aim.WallCheck = CONFIG.Aim.WallCheck
	selection.aim.TeamCheck = CONFIG.Aim.TeamCheck
	if CONFIG.ShowHudByDefault then
		setFeature("Hud", true, true)
	end
	notify("Đã đặt lại toàn bộ tính năng", "success")
end

local function rejoinServer()
	notify("Đang vào lại server...", "info")
	local ok, err = pcall(TeleportService.Teleport, TeleportService, game.PlaceId, player)
	if not ok then
		logError("Rejoin", err)
		notify("Không thể vào lại server", "error")
	end
end

local function openTelegram()
	local ok, err = pcall(GuiService.OpenBrowserWindow, GuiService, CONFIG.TelegramLink)
	if ok then
		notify("Đang mở Telegram...", "success")
		return
	end
	logError("Telegram", err)
	notify("Roblox không cho mở trình duyệt. Link: " .. CONFIG.TelegramLink, "warning")
end

local function buildSettingsPage(page)
	createSection(page, "Hiệu năng & hình ảnh")
	bindFeatureToggle(page, "FixLag")
	bindFeatureToggle(page, "FullBright")
	createSection(page, "Hiển thị & âm thanh")
	bindFeatureToggle(page, "Hud")
	createOptionToggle(page, "Âm thanh khi bấm", true, function(wanted)
		soundState.enabled = wanted
	end)
	createSection(page, "Hệ thống")
	createButtonRow(page, {
		{ text = "Làm mới", color = theme.Accent, onClick = refreshAll },
		{ text = "Đặt lại", onClick = resetAll },
	})
	createButton(page, "Vào lại server", rejoinServer)
	createSection(page, "Nhật ký lỗi")
	local logLabel = createInfoLabel(page, "Không có lỗi", 11, theme.SubText)
	errorLogChanged = function()
		logLabel.Text = #errorLog > 0 and table.concat(errorLog, "\n") or "Không có lỗi"
	end
end

local function buildAboutPage(page)
	createSection(page, "Thông tin")
	createInfoLabel(page, CONFIG.MenuName .. " " .. CONFIG.Version .. "  |  Giao diện đen", 14, theme.Text)
	createInfoLabel(page, "Dev: " .. CONFIG.DeveloperName, 13, theme.Accent)
	createInfoLabel(page, CONFIG.Introduction, 12, theme.SubText)
	createSection(page, "Liên hệ")
	createInfoLabel(page, "Telegram: " .. CONFIG.TelegramHandle, 13, theme.Text)
	createButton(page, "Mở Telegram", openTelegram, theme.Accent)
	create("TextBox", {
		LayoutOrder = nextOrder(),
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundColor3 = theme.Element,
		Text = CONFIG.TelegramLink,
		TextColor3 = theme.SubText,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		ClearTextOnFocus = false,
		TextEditable = false,
		Parent = page,
	}, { create("UICorner", { CornerRadius = UDim.new(0, 8) }) })
end

local function createHud()
	local hud = create("TextLabel", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 46),
		Size = UDim2.fromOffset(0, 24),
		AutomaticSize = Enum.AutomaticSize.X,
		BackgroundColor3 = theme.Panel,
		BackgroundTransparency = 0.1,
		RichText = true,
		Text = "",
		TextColor3 = theme.Text,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		Visible = false,
		ZIndex = 8,
		Parent = gui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 6) }),
		create("UIStroke", { Color = theme.Stroke, Thickness = 1 }),
		create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
	})
	hudState.label = hud
	Monitor.listeners.Hud = function()
		if not hud.Visible then
			return
		end
		local fps = math.floor(Monitor.fps + 0.5)
		local color = fps >= 50 and theme.Success or (fps >= 30 and theme.Warning or theme.Danger)
		hud.Text = string.format(
			'FPS <font color="#%s">%d</font>   Ping %dms   %s',
			color:ToHex(), fps, math.floor(Monitor.ping + 0.5), os.date("%H:%M:%S")
		)
	end
end

local function createDevNotice()
	local bottomOffset = UserInputService.TouchEnabled and -110 or -12
	local notice = create("CanvasGroup", {
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 300, 1, bottomOffset),
		Size = UDim2.fromOffset(250, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = theme.Panel,
		ZIndex = 30,
		Parent = gui,
	}, {
		create("UICorner", { CornerRadius = UDim.new(0, 10) }),
		create("UIStroke", { Color = theme.Accent, Thickness = 1 }),
		create("UIPadding", {
			PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
			PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
		}),
		create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }),
	})
	bindSurfaceClick(notice)
	local function addLine(text, size, color, font)
		create("TextLabel", {
			LayoutOrder = nextOrder(),
			Size = UDim2.new(1, 0, 0, size + 6),
			BackgroundTransparency = 1,
			Text = text,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextColor3 = color,
			TextSize = size,
			Font = font,
			Parent = notice,
		})
	end
	addLine(CONFIG.MenuName .. " " .. CONFIG.Version, 14, theme.Text, Enum.Font.GothamBold)
	addLine("Dev: " .. CONFIG.DeveloperName, 13, theme.Accent, Enum.Font.GothamMedium)
	addLine("Telegram: " .. CONFIG.TelegramHandle, 13, theme.Text, Enum.Font.GothamMedium)
	createButtonRow(notice, {
		{ text = "Mở Telegram", onClick = openTelegram },
		{ text = "OK", color = theme.Accent, onClick = function()
			playTween(notice, 0.25, { Position = UDim2.new(1, 300, 1, bottomOffset) })
			task.delay(0.3, function()
				if notice.Parent then
					notice:Destroy()
				end
			end)
		end },
	})
	playTween(notice, 0.35, { Position = UDim2.new(1, -12, 1, bottomOffset) })
end

buildDashboardPage(createPage("overview", "Tổng quan"))
buildCharacterPage(createPage("character", "Nhân vật"))
buildEspPage(createPage("esp", "ESP"))
buildAimPage(createPage("aim", "Aim"))
buildFarmPage(createPage("farm", "Farm"))
buildFlightPage(createPage("flight", "Bay"))
buildSettingsPage(createPage("settings", "Cài đặt"))
buildAboutPage(createPage("about", "Giới thiệu"))
createHud()
selectTab("overview")

local enemyRefreshQueued = false
enemyListChanged = function()
	if enemyRefreshQueued then
		return
	end
	enemyRefreshQueued = true
	task.delay(0.3, function()
		enemyRefreshQueued = false
		if dropdowns.enemy and dropdowns.enemy.open then
			dropdowns.enemy.refresh()
		end
	end)
end

local playerRefreshQueued = false
playerListChanged = function()
	if playerRefreshQueued then
		return
	end
	playerRefreshQueued = true
	task.delay(0.3, function()
		playerRefreshQueued = false
		for _, name in { "spectate", "destination" } do
			local dropdown = dropdowns[name]
			if dropdown and dropdown.open then
				dropdown.refresh()
			end
		end
	end)
end

rootBin.add(Players.PlayerAdded:Connect(playerListChanged))
rootBin.add(Players.PlayerRemoving:Connect(playerListChanged))

rootBin.add(player.CharacterAdded:Connect(function(character)
	local humanoid = character:WaitForChild("Humanoid", 10)
	if humanoid and gui.Parent then
		syncJumpSlider()
	end
end))

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
		playTween(welcome:FindFirstChildOfClass("UICorner"), 0.45, { CornerRadius = UDim.new(1, 0) })
		playTween(welcome, 0.45, { Size = bubble.Size, Position = bubble.Position })
		task.wait(0.5)
		if welcome.Parent then
			welcome:Destroy()
			bubble.Visible = true
			notify("Bấm nút menu hoặc phím " .. CONFIG.MenuToggleKey.Name .. " để mở", "info")
		end
	end)
end

startEnemyRegistry()
if CONFIG.ShowHudByDefault then
	setFeature("Hud", true, true)
end
createDevNotice()
playWelcome()
