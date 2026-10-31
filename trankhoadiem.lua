repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local function safeGetService(serviceName)
    local service = game:GetService(serviceName)
    return (cloneref and cloneref(service)) or service
end

local Players = safeGetService("Players")
local RunService = safeGetService("RunService")
local TweenService = safeGetService("TweenService")
local UserInputService = safeGetService("UserInputService")
local CollectionService = safeGetService("CollectionService")
local Lighting = safeGetService("Lighting")
local Workspace = safeGetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local CONFIG = {
	MenuToggleKey = Enum.KeyCode.RightShift,
	StartOpen = true,
	GuiName = "KhoaDiemHub",
	Version = "v1.0",

	Developer = {
		Name = "Tran Khoa Diem",
		Telegram = "@TranKhoaDiem",
		TelegramUrl = "https://t.me/TranKhoaDiem",
		Intro = "Xin chào! Mình là Tran Khoa Diem, người phát triển KhoaDiemHub. Menu được thiết kế gọn nhẹ, giao diện tối và thao tác mượt trên cả máy tính lẫn điện thoại. Nếu cần hỗ trợ, góp ý hoặc báo lỗi, hãy liên hệ mình qua Telegram nhé!",
	},

	WalkSpeed = { Min = 16, Max = 150, Default = 50 },
	JumpPower = { Min = 50, Max = 300, Default = 100 },
	JumpHeight = { Min = 7, Max = 80, Default = 25 },
	MaxCorrectionsPerSecond = 10,

	Movement = {
		TweenSpeed = 90,
		FollowSharpness = 14,
		SettleDistance = 4,
		RetweenDistance = 30,
	},
	SearchInterval = 0.5,

	Farm = {
		EnemyTag = "FarmableEnemy",
		FallbackEnemyFolderPath = { "Enemies" },
		HeightAboveEnemy = 8,
		AttackInterval = 0.4,
	},

	Loot = {
		Tags = { "LootChest", "DevilFruit" },
		StopDistance = 4,
		HeightOffset = 2.5,
		ApproachTimeout = 20,
		CollectTimeout = 3,
		IgnoreSeconds = 30,
	},

	FixLag = {
		FogEnd = 100000,
		ScanBatchSize = 400,
		SimplifyMaterials = true,
		HideDecals = true,
		ReduceMeshDetail = true,
		ProtectedNameKeywords = { "hitbox" },
	},

	FullBright = {
		Brightness = 2,
		Ambient = Color3.fromRGB(150, 150, 150),
		OutdoorAmbient = Color3.fromRGB(150, 150, 150),
		ExposureCompensation = 0.25,
		GlobalShadows = false,
	},

	ESP = {
		ShowNames = true,
		ShowHealth = true,
		ShowDistance = true,
		HideTeammates = false,
		UpdateInterval = 0.25,
		MaxDistance = 1500,
		Colors = {
			Enemy = Color3.fromRGB(255, 70, 70),
			Team = Color3.fromRGB(70, 200, 120),
			Text = Color3.fromRGB(255, 255, 255),
			HealthFull = Color3.fromRGB(80, 220, 120),
			HealthLow = Color3.fromRGB(235, 70, 70),
			BarBackground = Color3.fromRGB(25, 25, 30),
		},
	},
}

if PlayerGui:FindFirstChild(CONFIG.GuiName) then
	warn("[KhoaDiemHub] Menu đã tồn tại, bỏ qua lần chạy trùng.")
	return
end

local THEME = {
	Background = Color3.fromRGB(16, 16, 20),
	Card = Color3.fromRGB(26, 26, 32),
	CardHover = Color3.fromRGB(36, 36, 45),
	CardPress = Color3.fromRGB(46, 46, 58),
	Field = Color3.fromRGB(21, 21, 27),
	FieldHover = Color3.fromRGB(30, 30, 38),
	Stroke = Color3.fromRGB(48, 48, 60),
	Accent = Color3.fromRGB(99, 102, 241),
	Text = Color3.fromRGB(240, 240, 246),
	Muted = Color3.fromRGB(145, 145, 162),
	Off = Color3.fromRGB(58, 58, 72),
	Success = Color3.fromRGB(52, 211, 153),
	Warning = Color3.fromRGB(251, 191, 36),
	Error = Color3.fromRGB(248, 113, 113),
	Font = Enum.Font.SourceSansSemibold,
	FontBold = Enum.Font.SourceSansBold,
}

local STATUS_COLORS = {
	off = THEME.Muted,
	success = THEME.Success,
	warn = THEME.Warning,
	error = THEME.Error,
	info = THEME.Accent,
}

local Janitor = {}
Janitor.__index = Janitor

function Janitor.new()
	return setmetatable({ items = {} }, Janitor)
end

function Janitor:Add(item)
	table.insert(self.items, item)
	return item
end

function Janitor:Cleanup()
	local items = self.items
	self.items = {}
	for index = #items, 1, -1 do
		local item = items[index]
		local itemType = typeof(item)
		if itemType == "RBXScriptConnection" then
			item:Disconnect()
		elseif itemType == "Instance" then
			if item:IsA("Tween") then
				item:Cancel()
			end
			item:Destroy()
		elseif itemType == "function" then
			pcall(item)
		elseif itemType == "thread" then
			if item ~= coroutine.running() and coroutine.status(item) ~= "dead" then
				task.cancel(item)
			end
		end
	end
end

local function create(className, properties, children)
	local instance = Instance.new(className)
	if instance:IsA("GuiObject") then
		instance.BorderSizePixel = 0
	end
	local parent = nil
	for property, value in properties do
		if property == "Parent" then
			parent = value
		else
			instance[property] = value
		end
	end
	if children then
		for _, child in children do
			child.Parent = instance
		end
	end
	instance.Parent = parent
	return instance
end

local function createText(properties)
	local defaults = {
		BackgroundTransparency = 1,
		Font = THEME.Font,
		TextColor3 = THEME.Text,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
	}
	for key, value in defaults do
		if properties[key] == nil then
			properties[key] = value
		end
	end
	return create("TextLabel", properties)
end

local notify = function(text, kind)
	print(string.format("[KhoaDiemHub][%s] %s", kind or "info", text))
end

local statusListeners = {}
local function setStatus(key, text, kind)
	for _, listener in statusListeners do
		pcall(listener, key, text, kind)
	end
end

local function getCharacterParts()
	local character = LocalPlayer.Character
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

local function resolveCharacter(character, callback)
	local humanoid = character:WaitForChild("Humanoid", 10)
	local root = character:WaitForChild("HumanoidRootPart", 10)
	if humanoid and root and character.Parent then
		callback(character, humanoid, root)
	else
		warn("[KhoaDiemHub] Không tìm thấy Humanoid/HumanoidRootPart của nhân vật mới.")
	end
end

local function watchCharacter(callback)
	local connection = LocalPlayer.CharacterAdded:Connect(function(character)
		resolveCharacter(character, callback)
	end)
	if LocalPlayer.Character then
		task.spawn(resolveCharacter, LocalPlayer.Character, callback)
	end
	return connection
end

local function buildFacingCFrame(position, lookPoint, fallback)
	local flat = Vector3.new(lookPoint.X - position.X, 0, lookPoint.Z - position.Z)
	if flat.Magnitude < 0.5 then
		flat = Vector3.new(fallback.LookVector.X, 0, fallback.LookVector.Z)
		if flat.Magnitude < 0.01 then
			return CFrame.new(position)
		end
	end
	return CFrame.lookAt(position, position + flat)
end

local placeholderWarnings = {}
local function warnPlaceholderOnce(key, message)
	if not placeholderWarnings[key] then
		placeholderWarnings[key] = true
		warn("[KhoaDiemHub] " .. message)
	end
end

local function attackTarget(target)
	warnPlaceholderOnce("attack", "attackTarget(target) chưa được kết nối với hệ thống chiến đấu. Auto Farm chỉ di chuyển.")
end

local activePrompt = nil

local function releaseActivePrompt()
	if activePrompt then
		pcall(function() activePrompt:InputHoldEnd() end)
		activePrompt = nil
	end
end

local function collectLoot(item)
	local prompt = item:FindFirstChildWhichIsA("ProximityPrompt", true)
	if prompt and prompt.Enabled then
		activePrompt = prompt
		pcall(function() prompt:InputHoldBegin() end)
		task.wait(prompt.HoldDuration + 0.1)
		releaseActivePrompt()
		return true
	end
	warnPlaceholderOnce("collect", "collectLoot(item): vật phẩm không có ProximityPrompt. Hãy nối vào hệ thống nhặt của game.")
	return false
end

local StateManager = {}
do
	local features = {}
	local listeners = {}

	local function emit(name)
		for _, listener in listeners do
			pcall(listener, name, features[name].enabled)
		end
	end

	local function runSafely(feature, phase)
		local ok, err = pcall(feature[phase])
		if not ok then
			warn(string.format("[KhoaDiemHub] %s.%s lỗi: %s", feature.name, phase, tostring(err)))
			notify(feature.label .. ": lỗi (xem Output)", "error")
		end
		return ok
	end

	local function disableFeature(feature)
		feature.enabled = false
		runSafely(feature, "disable")
		emit(feature.name)
	end

	local function disableConflicts(feature)
		for _, other in features do
			if other ~= feature and other.enabled and other.exclusiveGroup == feature.exclusiveGroup then
				disableFeature(other)
				notify(other.label .. " đã tắt để tránh tranh quyền di chuyển", "info")
			end
		end
	end

	local function enableFeature(feature)
		if feature.canEnable then
			local allowed, reason = feature.canEnable()
			if not allowed then
				notify(reason, "error")
				emit(feature.name)
				return false
			end
		end
		if feature.exclusiveGroup then
			disableConflicts(feature)
		end
		feature.enabled = true
		if not runSafely(feature, "enable") then
			disableFeature(feature)
			return false
		end
		emit(feature.name)
		return true
	end

	function StateManager.register(name, definition)
		definition.name = name
		definition.enabled = false
		features[name] = definition
	end

	function StateManager.isEnabled(name)
		return features[name] and features[name].enabled or false
	end

	function StateManager.onChanged(listener)
		table.insert(listeners, listener)
	end

	function StateManager.set(name, enabled)
		local feature = features[name]
		if not feature then
			error("Feature không tồn tại: " .. tostring(name))
		end
		if feature.enabled == enabled then
			emit(name)
			return
		end
		if enabled then
			if enableFeature(feature) then
				notify("Đã bật " .. feature.label, "success")
			end
		else
			disableFeature(feature)
			notify("Đã tắt " .. feature.label, "info")
		end
	end

	function StateManager.disableAll()
		for _, feature in features do
			if feature.enabled then
				disableFeature(feature)
			end
		end
	end
end

local Noclip = {}
do
	local requesters = {}
	local requesterCount = 0
	local originalCollisions = {}
	local trackedParts = {}
	local runtimeJanitor = Janitor.new()
	local characterJanitor = Janitor.new()

	local function trackPart(instance)
		if instance:IsA("BasePart") and not trackedParts[instance] then
			trackedParts[instance] = true
			if originalCollisions[instance] == nil then
				originalCollisions[instance] = instance.CanCollide
			end
		end
	end

	local function bindCharacter(character)
		characterJanitor:Cleanup()
		trackedParts = {}
		originalCollisions = {}
		for _, descendant in character:GetDescendants() do
			trackPart(descendant)
		end
		characterJanitor:Add(character.DescendantAdded:Connect(trackPart))
	end

	local function applyNoclip()
		for part in trackedParts do
			if part.Parent then
				if part.CanCollide then
					part.CanCollide = false
				end
			else
				trackedParts[part] = nil
			end
		end
	end

	local function activate()
		runtimeJanitor:Add(watchCharacter(bindCharacter))
		runtimeJanitor:Add(RunService.Stepped:Connect(applyNoclip))
	end

	local function deactivate()
		runtimeJanitor:Cleanup()
		characterJanitor:Cleanup()
		for part, original in originalCollisions do
			if part.Parent then
				part.CanCollide = original
			end
		end
		originalCollisions = {}
		trackedParts = {}
	end

	function Noclip.request(owner)
		if requesters[owner] then
			return
		end
		requesters[owner] = true
		requesterCount += 1
		if requesterCount == 1 then
			activate()
		end
	end

	function Noclip.release(owner)
		if not requesters[owner] then
			return
		end
		requesters[owner] = nil
		requesterCount -= 1
		if requesterCount == 0 then
			deactivate()
		end
	end
end

local Movement = {}
do
	local connection = nil
	local activeTween = nil
	local mode = "idle"
	local goalProvider = nil
	local settled = false

	local function cancelTween()
		local tween = activeTween
		activeTween = nil
		if tween then
			tween:Cancel()
			tween:Destroy()
		end
	end

	local function startTween(root, goal)
		cancelTween()
		local distance = (goal.Position - root.Position).Magnitude
		local duration = math.max(distance / CONFIG.Movement.TweenSpeed, 0.05)
		local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), { CFrame = goal })
		activeTween = tween
		mode = "tween"
		settled = false
		tween.Completed:Once(function(playbackState)
			if activeTween == tween and playbackState == Enum.PlaybackState.Completed then
				mode = "hold"
			end
		end)
		tween:Play()
	end

	local function holdStep(root, dt)
		local goal = goalProvider and goalProvider()
		if not goal then
			return
		end
		local distance = (goal.Position - root.Position).Magnitude
		settled = distance <= CONFIG.Movement.SettleDistance
		if distance > CONFIG.Movement.RetweenDistance then
			startTween(root, goal)
			return
		end
		local alpha = 1 - math.exp(-CONFIG.Movement.FollowSharpness * dt)
		root.CFrame = root.CFrame:Lerp(goal, alpha)
	end

	local function step(dt)
		if mode == "idle" then
			return
		end
		local _, _, root = getCharacterParts()
		if not root then
			return
		end
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if mode == "hold" then
			holdStep(root, dt)
		end
	end

	function Movement.acquire()
		if not connection then
			connection = RunService.Heartbeat:Connect(step)
		end
	end

	function Movement.goTo(provider)
		goalProvider = provider
		settled = false
		local _, _, root = getCharacterParts()
		local goal = provider()
		if not root or not goal then
			Movement.idle()
			return
		end
		if (goal.Position - root.Position).Magnitude <= CONFIG.Movement.SettleDistance then
			cancelTween()
			mode = "hold"
		else
			startTween(root, goal)
		end
	end

	function Movement.idle()
		cancelTween()
		mode = "idle"
		settled = false
		goalProvider = nil
	end

	function Movement.release()
		Movement.idle()
		if connection then
			connection:Disconnect()
			connection = nil
		end
	end

	function Movement.isSettled()
		return settled
	end
end

local function createHumanoidModifier(label, resolveProperty, getTargetValue)
	local modifier = { enabled = false }
	local watchJanitor = Janitor.new()
	local humanoidJanitor = Janitor.new()
	local trackedHumanoid = nil
	local trackedProperty = nil
	local originalValue = nil
	local windowStart = 0
	local windowCount = 0
	local lastWarning = 0

	local function withinCorrectionBudget()
		local now = os.clock()
		if now - windowStart > 1 then
			windowStart = now
			windowCount = 0
		end
		windowCount += 1
		return windowCount <= CONFIG.MaxCorrectionsPerSecond
	end

	local function onExternalChange()
		if not modifier.enabled or not trackedHumanoid then
			return
		end
		local target = getTargetValue(trackedProperty)
		if math.abs(trackedHumanoid[trackedProperty] - target) < 0.01 then
			return
		end
		if os.clock() - lastWarning > 5 then
			lastWarning = os.clock()
			notify(label .. ": server/game đang ghi đè giá trị này", "warn")
		end
		if withinCorrectionBudget() then
			trackedHumanoid[trackedProperty] = target
		end
	end

	local function attach(_, humanoid)
		humanoidJanitor:Cleanup()
		trackedHumanoid = humanoid
		trackedProperty = resolveProperty(humanoid)
		originalValue = humanoid[trackedProperty]
		humanoid[trackedProperty] = getTargetValue(trackedProperty)
		humanoidJanitor:Add(humanoid:GetPropertyChangedSignal(trackedProperty):Connect(onExternalChange))
	end

	function modifier.enable()
		modifier.enabled = true
		watchJanitor:Add(watchCharacter(attach))
	end

	function modifier.disable()
		modifier.enabled = false
		watchJanitor:Cleanup()
		humanoidJanitor:Cleanup()
		if trackedHumanoid and trackedHumanoid.Parent and originalValue ~= nil then
			trackedHumanoid[trackedProperty] = originalValue
		end
		trackedHumanoid = nil
	end

	function modifier.refresh()
		if modifier.enabled and trackedHumanoid then
			trackedHumanoid[trackedProperty] = getTargetValue(trackedProperty)
		end
	end

	return modifier
end

local walkSpeedValue = CONFIG.WalkSpeed.Default
local jumpValues = { JumpPower = CONFIG.JumpPower.Default, JumpHeight = CONFIG.JumpHeight.Default }

local function detectJumpProperty(humanoid)
	return if humanoid.UseJumpPower then "JumpPower" else "JumpHeight"
end

local SpeedWalk = createHumanoidModifier("Speed Walk", function()
	return "WalkSpeed"
end, function()
	return walkSpeedValue
end)

local HighJump = createHumanoidModifier("High Jump", detectJumpProperty, function(property)
	return jumpValues[property]
end)

local LightingLayers = {}
do
	local PRIORITY = { "FixLag", "FullBright" }
	local layers = {}
	local originals = {}
	local appliedValues = {}
	local watchers = {}

	local function valuesMatch(first, second)
		if typeof(first) == "number" and typeof(second) == "number" then
			return math.abs(first - second) < 0.001
		end
		return first == second
	end

	local function effectiveValue(property)
		for index = #PRIORITY, 1, -1 do
			local layer = layers[PRIORITY[index]]
			if layer and layer[property] ~= nil then
				return layer[property]
			end
		end
		return nil
	end

	local function restoreProperty(property)
		if watchers[property] then
			watchers[property]:Disconnect()
			watchers[property] = nil
		end
		Lighting[property] = originals[property]
		originals[property] = nil
		appliedValues[property] = nil
	end

	local function onExternalChange(property)
		if valuesMatch(Lighting[property], appliedValues[property]) then
			return
		end
		originals[property] = Lighting[property]
		Lighting[property] = appliedValues[property]
	end

	local function applyProperty(property)
		local value = effectiveValue(property)
		if value == nil then
			if originals[property] ~= nil then
				restoreProperty(property)
			end
			return
		end
		if originals[property] == nil then
			originals[property] = Lighting[property]
			watchers[property] = Lighting:GetPropertyChangedSignal(property):Connect(function()
				onExternalChange(property)
			end)
		end
		appliedValues[property] = value
		Lighting[property] = value
	end

	function LightingLayers.set(layerName, values)
		layers[layerName] = values
		for property in values do
			applyProperty(property)
		end
	end

	function LightingLayers.clear(layerName)
		local values = layers[layerName]
		layers[layerName] = nil
		if values then
			for property in values do
				applyProperty(property)
			end
		end
	end
end

local FullBright = {}

function FullBright.enable()
	LightingLayers.set("FullBright", CONFIG.FullBright)
end

function FullBright.disable()
	LightingLayers.clear("FullBright")
end

local FixLag = {}
do
	local TOGGLED_CLASSES = {
		ParticleEmitter = true, Trail = true, Beam = true, Smoke = true, Fire = true, Sparkles = true,
		PointLight = true, SpotLight = true, SurfaceLight = true,
		BloomEffect = true, BlurEffect = true, SunRaysEffect = true,
		ColorCorrectionEffect = true, DepthOfFieldEffect = true,
	}
	local SIMPLIFIABLE_MATERIALS = {
		[Enum.Material.Grass] = true, [Enum.Material.Sand] = true, [Enum.Material.Mud] = true,
		[Enum.Material.Ground] = true, [Enum.Material.Slate] = true, [Enum.Material.Concrete] = true,
		[Enum.Material.Brick] = true, [Enum.Material.Cobblestone] = true, [Enum.Material.Pebble] = true,
		[Enum.Material.Granite] = true, [Enum.Material.Marble] = true, [Enum.Material.Rock] = true,
		[Enum.Material.Basalt] = true, [Enum.Material.Asphalt] = true, [Enum.Material.Pavement] = true,
		[Enum.Material.Limestone] = true, [Enum.Material.Sandstone] = true, [Enum.Material.Snow] = true,
		[Enum.Material.Fabric] = true, [Enum.Material.Wood] = true, [Enum.Material.WoodPlanks] = true,
		[Enum.Material.Salt] = true, [Enum.Material.Glacier] = true, [Enum.Material.CrackedLava] = true,
	}

	local protectedTags = { CONFIG.Farm.EnemyTag }
	for _, tag in CONFIG.Loot.Tags do
		table.insert(protectedTags, tag)
	end

	local originals = setmetatable({}, { __mode = "k" })
	local janitor = Janitor.new()
	local runId = 0
	local active = false
	local pending = {}
	local drainScheduled = false

	local function remember(instance, property)
		local record = originals[instance]
		if not record then
			record = {}
			originals[instance] = record
		end
		if record[property] == nil then
			record[property] = instance[property]
		end
	end

	local function setProperty(instance, property, value)
		remember(instance, property)
		instance[property] = value
	end

	local function hasProtectedTag(instance)
		for _, tag in protectedTags do
			if CollectionService:HasTag(instance, tag) then
				return true
			end
		end
		return false
	end

	local function isProtected(instance)
		if hasProtectedTag(instance) then
			return true
		end
		local ancestor = instance.Parent
		while ancestor and ancestor ~= Workspace do
			if ancestor:IsA("Model") and ancestor:FindFirstChildOfClass("Humanoid") then
				return true
			end
			if hasProtectedTag(ancestor) then
				return true
			end
			ancestor = ancestor.Parent
		end
		return false
	end

	local function isHitboxPart(part)
		if part.Transparency >= 0.95 then
			return true
		end
		local lowerName = string.lower(part.Name)
		for _, keyword in CONFIG.FixLag.ProtectedNameKeywords do
			if string.find(lowerName, keyword, 1, true) then
				return true
			end
		end
		return false
	end

	local function simplifyPart(part)
		if part:IsA("Terrain") or isHitboxPart(part) or isProtected(part) then
			return
		end
		setProperty(part, "CastShadow", false)
		if CONFIG.FixLag.ReduceMeshDetail and part:IsA("MeshPart") then
			setProperty(part, "RenderFidelity", Enum.RenderFidelity.Performance)
		end
		if CONFIG.FixLag.SimplifyMaterials and part.Anchored and SIMPLIFIABLE_MATERIALS[part.Material] then
			setProperty(part, "Material", Enum.Material.SmoothPlastic)
		end
	end

	local function processInstance(instance)
		local className = instance.ClassName
		if TOGGLED_CLASSES[className] then
			if not isProtected(instance) then
				setProperty(instance, "Enabled", false)
			end
		elseif className == "Atmosphere" then
			setProperty(instance, "Density", 0)
			setProperty(instance, "Haze", 0)
		elseif instance:IsA("BasePart") then
			simplifyPart(instance)
		elseif CONFIG.FixLag.HideDecals and (className == "Decal" or className == "Texture") then
			if not isProtected(instance) then
				setProperty(instance, "Transparency", 1)
			end
		end
	end

	local function drainPending()
		drainScheduled = false
		local batch = pending
		pending = {}
		if not active then
			return
		end
		for _, instance in batch do
			if instance.Parent then
				processInstance(instance)
			end
		end
	end

	local function queueInstance(instance)
		table.insert(pending, instance)
		if not drainScheduled then
			drainScheduled = true
			task.defer(drainPending)
		end
	end

	local function scanContainer(container, token)
		local descendants = container:GetDescendants()
		for index, instance in descendants do
			if token ~= runId then
				return false
			end
			if instance.Parent then
				processInstance(instance)
			end
			if index % CONFIG.FixLag.ScanBatchSize == 0 then
				task.wait()
			end
		end
		return true
	end

	local function initialScan(token)
		local finished = scanContainer(Lighting, token) and scanContainer(Workspace, token)
		if finished and token == runId then
			notify("Fix Lag: đã xử lý xong bản đồ", "success")
		end
	end

	function FixLag.enable()
		runId += 1
		active = true
		LightingLayers.set("FixLag", {
			GlobalShadows = false,
			FogEnd = CONFIG.FixLag.FogEnd,
		})
		janitor:Add(Workspace.DescendantAdded:Connect(queueInstance))
		janitor:Add(Lighting.DescendantAdded:Connect(queueInstance))
		janitor:Add(task.spawn(initialScan, runId))
	end

	function FixLag.disable()
		runId += 1
		active = false
		janitor:Cleanup()
		pending = {}
		LightingLayers.clear("FixLag")
		for instance, record in originals do
			for property, value in record do
				pcall(function() instance[property] = value end)
			end
		end
		originals = setmetatable({}, { __mode = "k" })
	end
end

local function getModelPosition(model)
	local part = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")
	return part and part.Position
end

local function getItemPosition(item)
	if item:IsA("BasePart") then
		return item.Position
	end
	if item:IsA("Model") then
		if item.PrimaryPart then
			return item.PrimaryPart.Position
		end
		return item:GetPivot().Position
	end
	return nil
end

local EnemyRegistry = {}
do
	local taggedModels = {}
	local folderCache = {}
	local folderCacheTime = 0

	local function resolveFolder()
		local current = Workspace
		for _, name in CONFIG.Farm.FallbackEnemyFolderPath do
			current = current:FindFirstChild(name)
			if not current then
				return nil
			end
		end
		return current
	end

	local function getFolderModels()
		if os.clock() - folderCacheTime < CONFIG.SearchInterval then
			return folderCache
		end
		folderCacheTime = os.clock()
		folderCache = {}
		local folder = resolveFolder()
		if folder then
			for _, descendant in folder:GetDescendants() do
				if descendant:IsA("Model") and descendant:FindFirstChildOfClass("Humanoid") then
					table.insert(folderCache, descendant)
				end
			end
		end
		return folderCache
	end

	function EnemyRegistry.start(janitor)
		local tag = CONFIG.Farm.EnemyTag
		for _, instance in CollectionService:GetTagged(tag) do
			if instance:IsA("Model") then
				taggedModels[instance] = true
			end
		end
		janitor:Add(CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance)
			if instance:IsA("Model") then
				taggedModels[instance] = true
			end
		end))
		janitor:Add(CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance)
			taggedModels[instance] = nil
		end))
	end

	function EnemyRegistry.getModels()
		local models = {}
		for model in taggedModels do
			table.insert(models, model)
		end
		if #models > 0 then
			return models
		end
		return getFolderModels()
	end

	function EnemyRegistry.isAlive(model)
		if not model.Parent or not model:IsDescendantOf(Workspace) then
			return false
		end
		if Players:GetPlayerFromCharacter(model) then
			return false
		end
		local humanoid = model:FindFirstChildOfClass("Humanoid")
		return humanoid ~= nil and humanoid.Health > 0
	end

	function EnemyRegistry.getTypeNames()
		local seen = {}
		local names = {}
		for _, model in EnemyRegistry.getModels() do
			if model:IsDescendantOf(Workspace) and not seen[model.Name] then
				seen[model.Name] = true
				table.insert(names, model.Name)
			end
		end
		table.sort(names)
		return names
	end

	function EnemyRegistry.findNearest(typeName, origin)
		local nearest = nil
		local nearestDistance = math.huge
		for _, model in EnemyRegistry.getModels() do
			if model.Name == typeName and EnemyRegistry.isAlive(model) then
				local position = getModelPosition(model)
				if position then
					local distance = (position - origin).Magnitude
					if distance < nearestDistance then
						nearest = model
						nearestDistance = distance
					end
				end
			end
		end
		return nearest
	end
end

local LootRegistry = {}
do
	local itemsByTag = {}

	function LootRegistry.start(janitor)
		for _, tag in CONFIG.Loot.Tags do
			local items = {}
			itemsByTag[tag] = items
			for _, instance in CollectionService:GetTagged(tag) do
				items[instance] = true
			end
			janitor:Add(CollectionService:GetInstanceAddedSignal(tag):Connect(function(instance)
				items[instance] = true
			end))
			janitor:Add(CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance)
				items[instance] = nil
			end))
		end
	end

	function LootRegistry.isValid(item)
		return item.Parent ~= nil and item:IsDescendantOf(Workspace) and getItemPosition(item) ~= nil
	end

	function LootRegistry.findNearest(selectedTags, origin, ignoredUntil)
		local nearest = nil
		local nearestDistance = math.huge
		local now = os.clock()
		for tag in selectedTags do
			for item in itemsByTag[tag] or {} do
				local ignored = ignoredUntil[item]
				if (not ignored or ignored < now) and LootRegistry.isValid(item) then
					local distance = (getItemPosition(item) - origin).Magnitude
					if distance < nearestDistance then
						nearest = item
						nearestDistance = distance
					end
				end
			end
		end
		return nearest
	end
end

local AutoFarm = {}
do
	local janitor = Janitor.new()
	local runId = 0
	local selectedType = nil
	local target = nil
	local lastAttackTime = 0

	local function buildGoalProvider(enemy, root)
		local approachFacing = buildFacingCFrame(root.Position, getModelPosition(enemy) or root.Position, root.CFrame)
		return function()
			local enemyPosition = getModelPosition(enemy)
			if not enemyPosition then
				return nil
			end
			local goalPosition = enemyPosition + Vector3.new(0, CONFIG.Farm.HeightAboveEnemy, 0)
			return buildFacingCFrame(goalPosition, enemyPosition, approachFacing)
		end
	end

	local function acquireTarget(root)
		target = EnemyRegistry.findNearest(selectedType, root.Position)
		if not target then
			Movement.idle()
			setStatus("farm", "Waiting for enemy to spawn", "warn")
			return
		end
		Movement.goTo(buildGoalProvider(target, root))
		setStatus("farm", "Đang farm: " .. target.Name, "success")
	end

	local function tryAttack()
		local now = os.clock()
		if not Movement.isSettled() or now - lastAttackTime < CONFIG.Farm.AttackInterval then
			return
		end
		lastAttackTime = now
		attackTarget(target)
	end

	local function farmStep()
		local _, _, root = getCharacterParts()
		if not root then
			target = nil
			Movement.idle()
			setStatus("farm", "Đang chờ hồi sinh", "warn")
			return
		end
		if target and not EnemyRegistry.isAlive(target) then
			target = nil
			Movement.idle()
		end
		if not target then
			acquireTarget(root)
		end
		if target then
			tryAttack()
		end
	end

	local function runLoop(token)
		local interval = math.min(CONFIG.SearchInterval, CONFIG.Farm.AttackInterval)
		while token == runId do
			local ok, err = pcall(farmStep)
			if not ok then
				warn("[KhoaDiemHub] Auto Farm lỗi: " .. tostring(err))
				notify("Auto Farm gặp lỗi và đã tắt (xem Output)", "error")
				task.defer(StateManager.set, "AutoFarm", false)
				return
			end
			task.wait(interval)
		end
	end

	function AutoFarm.setSelectedType(name)
		selectedType = name
		target = nil
		if StateManager.isEnabled("AutoFarm") then
			Movement.idle()
		end
	end

	function AutoFarm.canEnable()
		if not selectedType then
			return false, "Hãy chọn loại enemy trước khi bật Auto Farm"
		end
		return true
	end

	function AutoFarm.enable()
		runId += 1
		target = nil
		Noclip.request("AutoFarm")
		Movement.acquire()
		setStatus("farm", "Đang tìm enemy...", "warn")
		janitor:Add(task.spawn(runLoop, runId))
	end

	function AutoFarm.disable()
		runId += 1
		janitor:Cleanup()
		target = nil
		Movement.release()
		Noclip.release("AutoFarm")
		setStatus("farm", "Tắt", "off")
	end
end

local AutoLoot = {}
do
	local janitor = Janitor.new()
	local runId = 0
	local selectedTags = {}
	local ignoredUntil = setmetatable({}, { __mode = "k" })

	local function ignoreItem(item)
		ignoredUntil[item] = os.clock() + CONFIG.Loot.IgnoreSeconds
	end

	local function buildGoal(item, rootPosition)
		local itemPosition = getItemPosition(item)
		local horizontal = Vector3.new(rootPosition.X - itemPosition.X, 0, rootPosition.Z - itemPosition.Z)
		local direction = if horizontal.Magnitude > 0.1 then horizontal.Unit else Vector3.new(0, 0, 1)
		local goalPosition = itemPosition + direction * CONFIG.Loot.StopDistance + Vector3.new(0, CONFIG.Loot.HeightOffset, 0)
		return buildFacingCFrame(goalPosition, itemPosition, CFrame.new(goalPosition))
	end

	local function approachItem(item, token)
		local _, _, root = getCharacterParts()
		if not root then
			return false
		end
		local goal = buildGoal(item, root.Position)
		Movement.goTo(function()
			return goal
		end)
		local deadline = os.clock() + CONFIG.Loot.ApproachTimeout
		local timedOut = false
		while token == runId and LootRegistry.isValid(item) and not Movement.isSettled() do
			if not getCharacterParts() then
				return false
			end
			if os.clock() > deadline then
				timedOut = true
				break
			end
			task.wait(0.1)
		end
		if timedOut then
			ignoreItem(item)
			return false
		end
		return token == runId and LootRegistry.isValid(item)
	end

	local function collectItem(item, token)
		if not collectLoot(item) then
			ignoreItem(item)
			return
		end
		local deadline = os.clock() + CONFIG.Loot.CollectTimeout
		while token == runId and LootRegistry.isValid(item) and os.clock() < deadline do
			task.wait(0.1)
		end
		if token == runId and LootRegistry.isValid(item) then
			ignoreItem(item)
		end
	end

	local function lootStep(token)
		local _, _, root = getCharacterParts()
		if not root then
			Movement.idle()
			setStatus("loot", "Đang chờ hồi sinh", "warn")
			return
		end
		local item = LootRegistry.findNearest(selectedTags, root.Position, ignoredUntil)
		if not item then
			Movement.idle()
			setStatus("loot", "Waiting for loot to spawn", "warn")
			return
		end
		setStatus("loot", "Đang nhặt: " .. item.Name, "success")
		if approachItem(item, token) then
			collectItem(item, token)
		end
	end

	local function runLoop(token)
		while token == runId do
			local ok, err = pcall(lootStep, token)
			if not ok then
				warn("[KhoaDiemHub] Auto Loot lỗi: " .. tostring(err))
				notify("Auto Loot gặp lỗi và đã tắt (xem Output)", "error")
				task.defer(StateManager.set, "AutoLoot", false)
				return
			end
			task.wait(CONFIG.SearchInterval)
		end
	end

	function AutoLoot.setSelectedTags(tagSet)
		selectedTags = {}
		for tag in tagSet do
			selectedTags[tag] = true
		end
	end

	function AutoLoot.canEnable()
		if next(selectedTags) == nil then
			return false, "Hãy chọn ít nhất một loại loot trước khi bật Auto Loot"
		end
		return true
	end

	function AutoLoot.enable()
		runId += 1
		Noclip.request("AutoLoot")
		Movement.acquire()
		setStatus("loot", "Đang tìm loot...", "warn")
		janitor:Add(task.spawn(runLoop, runId))
	end

	function AutoLoot.disable()
		runId += 1
		janitor:Cleanup()
		releaseActivePrompt()
		Movement.release()
		Noclip.release("AutoLoot")
		setStatus("loot", "Tắt", "off")
	end
end

local PlayerEsp = {}
do
	local COLORS = CONFIG.ESP.Colors
	local janitor = Janitor.new()
	local entries = {}
	local playerJanitors = {}
	local runId = 0
	local hideTeammates = CONFIG.ESP.HideTeammates

	local function isTeammate(player)
		return LocalPlayer.Team ~= nil and player.Team == LocalPlayer.Team
	end

	local function createBillboard(head)
		local billboard = create("BillboardGui", {
			Name = "KhoaDiemHubEsp",
			Adornee = head,
			AlwaysOnTop = true,
			Size = UDim2.fromOffset(150, 42),
			StudsOffset = Vector3.new(0, 3, 0),
			MaxDistance = CONFIG.ESP.MaxDistance,
			ResetOnSpawn = false,
			Parent = head,
		})
		local nameLabel = createText({
			Size = UDim2.new(1, 0, 0, 16), TextXAlignment = Enum.TextXAlignment.Center, Font = THEME.FontBold,
			TextColor3 = COLORS.Text, TextStrokeTransparency = 0.4, Visible = CONFIG.ESP.ShowNames, Parent = billboard,
		})
		local barBack = create("Frame", {
			Size = UDim2.new(1, -20, 0, 5), Position = UDim2.fromOffset(10, 19),
			BackgroundColor3 = COLORS.BarBackground, Visible = CONFIG.ESP.ShowHealth, Parent = billboard,
		})
		local barFill = create("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = COLORS.HealthFull, Parent = barBack })
		local infoLabel = createText({
			Size = UDim2.new(1, 0, 0, 14), Position = UDim2.fromOffset(0, 26), TextSize = 13,
			TextXAlignment = Enum.TextXAlignment.Center, TextColor3 = COLORS.Text, TextStrokeTransparency = 0.5, Parent = billboard,
		})
		return billboard, nameLabel, barFill, infoLabel
	end

	local function applyVisibility(entry)
		local teammate = isTeammate(entry.player)
		local visible = entry.humanoid.Health > 0 and not (hideTeammates and teammate)
		local color = if teammate then COLORS.Team else COLORS.Enemy
		entry.highlight.Enabled = visible
		entry.billboard.Enabled = visible
		entry.highlight.OutlineColor = color
		entry.highlight.FillColor = color
	end

	local function updateEntry(entry, localRoot)
		local humanoid = entry.humanoid
		local maxHealth = math.max(humanoid.MaxHealth, 1)
		local fraction = math.clamp(humanoid.Health / maxHealth, 0, 1)
		entry.barFill.Size = UDim2.fromScale(fraction, 1)
		entry.barFill.BackgroundColor3 = COLORS.HealthLow:Lerp(COLORS.HealthFull, fraction)
		local parts = {}
		if CONFIG.ESP.ShowHealth then
			table.insert(parts, string.format("HP %d/%d", math.ceil(humanoid.Health), math.ceil(maxHealth)))
		end
		if CONFIG.ESP.ShowDistance and localRoot then
			table.insert(parts, string.format("%dm", math.floor((entry.head.Position - localRoot.Position).Magnitude)))
		end
		entry.infoLabel.Text = table.concat(parts, " | ")
	end

	local function removeEntry(player)
		local entry = entries[player]
		if entry then
			entry.janitor:Cleanup()
			entries[player] = nil
		end
	end

	local function buildEntry(player, character, token)
		local humanoid = character:WaitForChild("Humanoid", 10)
		local head = character:WaitForChild("Head", 10)
		if token ~= runId or not humanoid or not head or not character.Parent then
			return
		end
		removeEntry(player)
		local entryJanitor = Janitor.new()
		local highlight = entryJanitor:Add(create("Highlight", {
			Name = "KhoaDiemHubEsp", Adornee = character, FillTransparency = 0.75, OutlineTransparency = 0,
			DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = character,
		}))
		local billboard, nameLabel, barFill, infoLabel = createBillboard(head)
		entryJanitor:Add(billboard)
		nameLabel.Text = player.DisplayName
		local entry = {
			player = player, humanoid = humanoid, head = head, highlight = highlight, billboard = billboard,
			barFill = barFill, infoLabel = infoLabel, janitor = entryJanitor,
		}
		entries[player] = entry
		entryJanitor:Add(humanoid.Died:Connect(function()
			applyVisibility(entry)
		end))
		local _, _, localRoot = getCharacterParts()
		applyVisibility(entry)
		updateEntry(entry, localRoot)
	end

	local function attachPlayer(player)
		if player == LocalPlayer or playerJanitors[player] then
			return
		end
		local playerJanitor = Janitor.new()
		playerJanitors[player] = playerJanitor
		local token = runId
		playerJanitor:Add(player.CharacterAdded:Connect(function(character)
			buildEntry(player, character, token)
		end))
		playerJanitor:Add(player.CharacterRemoving:Connect(function()
			removeEntry(player)
		end))
		playerJanitor:Add(player:GetPropertyChangedSignal("Team"):Connect(function()
			if entries[player] then
				applyVisibility(entries[player])
			end
		end))
		if player.Character then
			task.spawn(buildEntry, player, player.Character, token)
		end
	end

	local function detachPlayer(player)
		removeEntry(player)
		if playerJanitors[player] then
			playerJanitors[player]:Cleanup()
			playerJanitors[player] = nil
		end
	end

	local function refreshAll()
		for _, entry in entries do
			applyVisibility(entry)
		end
	end

	local function updateLoop(token)
		while token == runId do
			local _, _, localRoot = getCharacterParts()
			for _, entry in entries do
				if entry.humanoid.Health > 0 then
					updateEntry(entry, localRoot)
				end
			end
			task.wait(CONFIG.ESP.UpdateInterval)
		end
	end

	function PlayerEsp.setHideTeammates(value)
		hideTeammates = value
		refreshAll()
	end

	function PlayerEsp.enable()
		runId += 1
		for _, player in Players:GetPlayers() do
			attachPlayer(player)
		end
		janitor:Add(Players.PlayerAdded:Connect(attachPlayer))
		janitor:Add(Players.PlayerRemoving:Connect(detachPlayer))
		janitor:Add(LocalPlayer:GetPropertyChangedSignal("Team"):Connect(refreshAll))
		janitor:Add(task.spawn(updateLoop, runId))
	end

	function PlayerEsp.disable()
		runId += 1
		janitor:Cleanup()
		for player in entries do
			removeEntry(player)
		end
		for player, playerJanitor in playerJanitors do
			playerJanitor:Cleanup()
			playerJanitors[player] = nil
		end
	end
end

StateManager.register("FixLag", { label = "Fix Lag", enable = FixLag.enable, disable = FixLag.disable })
StateManager.register("FullBright", { label = "Full Bright", enable = FullBright.enable, disable = FullBright.disable })
StateManager.register("SpeedWalk", { label = "Speed Walk", enable = SpeedWalk.enable, disable = SpeedWalk.disable })
StateManager.register("HighJump", { label = "High Jump", enable = HighJump.enable, disable = HighJump.disable })
StateManager.register("Noclip", {
	label = "Noclip",
	enable = function() Noclip.request("UserToggle") end,
	disable = function() Noclip.release("UserToggle") end,
})
StateManager.register("AutoFarm", {
	label = "Auto Farm", exclusiveGroup = "Movement",
	canEnable = AutoFarm.canEnable, enable = AutoFarm.enable, disable = AutoFarm.disable,
})
StateManager.register("AutoLoot", {
	label = "Auto Loot", exclusiveGroup = "Movement",
	canEnable = AutoLoot.canEnable, enable = AutoLoot.enable, disable = AutoLoot.disable,
})
StateManager.register("PlayerESP", { label = "Player ESP", enable = PlayerEsp.enable, disable = PlayerEsp.disable })

local interfaceJanitor = Janitor.new()
local activeTweens = setmetatable({}, { __mode = "k" })

local function animate(instance, goals, duration)
	local byProperty = activeTweens[instance]
	if not byProperty then
		byProperty = {}
		activeTweens[instance] = byProperty
	end
	for property in goals do
		if byProperty[property] then
			byProperty[property]:Cancel()
		end
	end
	local tween = TweenService:Create(
		instance,
		TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		goals
	)
	for property in goals do
		byProperty[property] = tween
	end
	tween:Play()
	return tween
end

local function styleCorner(instance, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = instance })
end

local function styleStroke(instance, color)
	return create("UIStroke", { Color = color, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = instance })
end

local function addHover(button, baseColor, hoverColor, pressColor)
	button.AutoButtonColor = false
	button.BackgroundColor3 = baseColor
	local hovering = false
	button.MouseEnter:Connect(function()
		hovering = true
		animate(button, { BackgroundColor3 = hoverColor }, 0.12)
	end)
	button.MouseLeave:Connect(function()
		hovering = false
		animate(button, { BackgroundColor3 = baseColor }, 0.15)
	end)
	button.MouseButton1Down:Connect(function()
		animate(button, { BackgroundColor3 = pressColor }, 0.06)
	end)
	button.MouseButton1Up:Connect(function()
		animate(button, { BackgroundColor3 = if hovering then hoverColor else baseColor }, 0.12)
	end)
end

local function createSection(parent, titleText, order)
	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = THEME.Card, LayoutOrder = order, Parent = parent,
	})
	styleCorner(card, 10)
	styleStroke(card, THEME.Stroke)
	create("UIPadding", {
		PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8),
		PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = card,
	})
	create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card })
	createText({
		Text = titleText, TextSize = 12, TextColor3 = THEME.Muted, Font = THEME.FontBold,
		Size = UDim2.new(1, 0, 0, 14), LayoutOrder = -1, Parent = card,
	})
	return card
end

local function createToggleRow(parent, text, onClick)
	local row = create("TextButton", { Size = UDim2.new(1, 0, 0, 32), Text = "", Parent = parent })
	styleCorner(row, 8)
	addHover(row, THEME.Card, THEME.CardHover, THEME.CardPress)
	createText({ Text = text, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(6, 0), Parent = row })
	local track = create("Frame", {
		Size = UDim2.fromOffset(38, 20), Position = UDim2.new(1, -44, 0.5, -10), BackgroundColor3 = THEME.Off, Parent = row,
	})
	styleCorner(track, 10)
	local knob = create("Frame", {
		Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.new(1, 1, 1), Parent = track,
	})
	styleCorner(knob, 7)
	row.Activated:Connect(onClick)
	local toggle = {}
	function toggle.setState(enabled)
		animate(track, { BackgroundColor3 = if enabled then THEME.Accent else THEME.Off }, 0.15)
		animate(knob, { Position = if enabled then UDim2.fromOffset(21, 3) else UDim2.fromOffset(3, 3) }, 0.15)
	end
	return toggle
end

local function createStatusRow(parent, key)
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Parent = parent })
	local dot = create("Frame", {
		Size = UDim2.fromOffset(8, 8), Position = UDim2.new(0, 8, 0.5, -4), BackgroundColor3 = THEME.Muted, Parent = row,
	})
	styleCorner(dot, 4)
	local label = createText({
		Text = "Trạng thái: Tắt", Size = UDim2.new(1, -26, 1, 0), Position = UDim2.fromOffset(22, 0),
		TextSize = 13, TextColor3 = THEME.Muted, Parent = row,
	})
	table.insert(statusListeners, function(statusKey, text, kind)
		if statusKey ~= key then
			return
		end
		local color = STATUS_COLORS[kind] or THEME.Muted
		label.Text = "Trạng thái: " .. text
		animate(dot, { BackgroundColor3 = color }, 0.15)
		animate(label, { TextColor3 = color }, 0.15)
	end)
end

local function createSlider(parent, scroller, spec)
	local range = { min = spec.min, max = spec.max }
	local value = spec.value
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = parent })
	local title = createText({ Text = spec.label, Size = UDim2.new(1, -64, 0, 22), TextColor3 = THEME.Muted, TextSize = 13, Parent = row })
	local input = create("TextBox", {
		Size = UDim2.fromOffset(58, 22), Position = UDim2.new(1, -58, 0, 0), BackgroundColor3 = THEME.Field,
		Font = THEME.Font, TextSize = 14, TextColor3 = THEME.Text, ClearTextOnFocus = false, Text = "", Parent = row,
	})
	styleCorner(input, 6)
	styleStroke(input, THEME.Stroke)
	local hitbox = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1, Text = "", Parent = row,
	})
	local track = create("Frame", { Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0.5, -3), BackgroundColor3 = THEME.Off, Parent = hitbox })
	styleCorner(track, 3)
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = THEME.Accent, Parent = track })
	styleCorner(fill, 3)
	local knob = create("Frame", {
		Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = Color3.new(1, 1, 1), Parent = track,
	})
	styleCorner(knob, 7)

	local slider = {}

	local function snap(raw)
		local step = spec.step or 1
		return tonumber(string.format("%.2f", math.floor(raw / step + 0.5) * step))
	end

	function slider.setValue(newValue, silent)
		value = math.clamp(snap(newValue), range.min, range.max)
		local alpha = (value - range.min) / (range.max - range.min)
		animate(fill, { Size = UDim2.fromScale(alpha, 1) }, 0.07)
		animate(knob, { Position = UDim2.new(alpha, 0, 0.5, 0) }, 0.07)
		input.Text = string.format("%g", value)
		if not silent then
			spec.onChange(value)
		end
	end

	function slider.setRange(minValue, maxValue)
		range.min, range.max = minValue, maxValue
		slider.setValue(value, true)
	end

	function slider.setLabel(text)
		title.Text = text
	end

	local function updateFromPosition(positionX)
		local alpha = math.clamp((positionX - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
		slider.setValue(range.min + alpha * (range.max - range.min))
	end

	hitbox.InputBegan:Connect(function(inputObject)
		local inputType = inputObject.UserInputType
		if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
			return
		end
		scroller.ScrollingEnabled = false
		updateFromPosition(inputObject.Position.X)
		local dragJanitor = Janitor.new()
		dragJanitor:Add(UserInputService.InputChanged:Connect(function(changed)
			if changed.UserInputType == Enum.UserInputType.MouseMovement or changed == inputObject then
				updateFromPosition(changed.Position.X)
			end
		end))
		dragJanitor:Add(inputObject.Changed:Connect(function()
			if inputObject.UserInputState == Enum.UserInputState.End then
				dragJanitor:Cleanup()
				scroller.ScrollingEnabled = true
			end
		end))
	end)

	input.FocusLost:Connect(function()
		local parsed = tonumber(input.Text)
		if not parsed or parsed ~= parsed or math.abs(parsed) == math.huge then
			notify("Giá trị không hợp lệ, hãy nhập một số", "error")
			input.Text = string.format("%g", value)
			return
		end
		if parsed < range.min or parsed > range.max then
			notify(string.format("Giá trị phải trong khoảng %g - %g (đã giới hạn)", range.min, range.max), "warn")
		end
		slider.setValue(parsed)
	end)

	slider.setValue(value, true)
	return slider
end

local function createDropdown(parent, spec)
	local PANEL_HEIGHT = 150
	local selection = if spec.multi then {} else nil
	local allOptions = {}
	local isOpen = false
	local setOpen

	local container = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = parent })
	create("UIListLayout", { Padding = UDim.new(0, 4), Parent = container })

	local header = create("TextButton", { Size = UDim2.new(1, 0, 0, 30), Text = "", Parent = container })
	styleCorner(header, 8)
	styleStroke(header, THEME.Stroke)
	addHover(header, THEME.Field, THEME.FieldHover, THEME.FieldHover)
	local headerLabel = createText({
		Text = spec.placeholder, Size = UDim2.new(1, -32, 1, 0), Position = UDim2.fromOffset(10, 0),
		TextTruncate = Enum.TextTruncate.AtEnd, TextColor3 = THEME.Muted, Parent = header,
	})
	local arrow = createText({
		Text = "▼", Size = UDim2.fromOffset(20, 30), Position = UDim2.new(1, -26, 0, 0), TextSize = 10,
		TextColor3 = THEME.Muted, TextXAlignment = Enum.TextXAlignment.Center, Parent = header,
	})

	local panel = create("Frame", { Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = THEME.Field, ClipsDescendants = true, Visible = false, Parent = container })
	styleCorner(panel, 8)
	styleStroke(panel, THEME.Stroke)
	local searchBox = create("TextBox", {
		Size = UDim2.new(1, -12, 0, 26), Position = UDim2.fromOffset(6, 6), BackgroundColor3 = THEME.Card, Text = "",
		PlaceholderText = "Tìm kiếm...", PlaceholderColor3 = THEME.Muted, ClearTextOnFocus = false, Font = THEME.Font,
		TextSize = 14, TextColor3 = THEME.Text, TextXAlignment = Enum.TextXAlignment.Left, Parent = panel,
	})
	styleCorner(searchBox, 6)
	create("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = searchBox })
	local list = create("ScrollingFrame", {
		Size = UDim2.new(1, -12, 1, -44), Position = UDim2.fromOffset(6, 38), BackgroundTransparency = 1, ScrollBarThickness = 3,
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = panel,
	})
	create("UIListLayout", { Padding = UDim.new(0, 2), Parent = list })

	local function isSelected(name)
		if spec.multi then
			return selection[name] == true
		end
		return selection == name
	end

	local function updateHeader()
		local text = nil
		if spec.multi then
			local names = {}
			for name in selection do
				table.insert(names, name)
			end
			table.sort(names)
			text = if #names > 0 then table.concat(names, ", ") else nil
		else
			text = selection
		end
		headerLabel.Text = text or spec.placeholder
		headerLabel.TextColor3 = if text then THEME.Text else THEME.Muted
	end

	local rebuild

	local function createOption(name)
		local selected = isSelected(name)
		local option = create("TextButton", {
			Size = UDim2.new(1, -4, 0, 26), Text = (if selected then "✓  " else "     ") .. name, Font = THEME.Font, TextSize = 14,
			TextColor3 = if selected then THEME.Accent else THEME.Text, TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd, Parent = list,
		})
		styleCorner(option, 6)
		addHover(option, THEME.Field, THEME.CardHover, THEME.CardPress)
		option.Activated:Connect(function()
			if spec.multi then
				selection[name] = if selection[name] then nil else true
				spec.onChange(selection)
			else
				selection = name
				spec.onChange(name)
				setOpen(false)
			end
			updateHeader()
			rebuild()
		end)
	end

	rebuild = function()
		for _, child in list:GetChildren() do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
		local filter = string.lower(searchBox.Text)
		local shown = 0
		for _, name in allOptions do
			if filter == "" or string.find(string.lower(name), filter, 1, true) then
				shown += 1
				createOption(name)
			end
		end
		if shown == 0 then
			createText({ Text = "Không có dữ liệu", Size = UDim2.new(1, 0, 0, 24), TextColor3 = THEME.Muted, TextXAlignment = Enum.TextXAlignment.Center, Parent = list })
		end
	end

	setOpen = function(open)
		isOpen = open
		if open then
			allOptions = spec.getOptions()
			searchBox.Text = ""
			rebuild()
			panel.Visible = true
			animate(panel, { Size = UDim2.new(1, 0, 0, PANEL_HEIGHT) }, 0.18)
		else
			animate(panel, { Size = UDim2.new(1, 0, 0, 0) }, 0.15).Completed:Once(function()
				if not isOpen then
					panel.Visible = false
				end
			end)
		end
		animate(arrow, { Rotation = if open then 180 else 0 }, 0.15)
	end

	header.Activated:Connect(function()
		setOpen(not isOpen)
	end)
	searchBox:GetPropertyChangedSignal("Text"):Connect(rebuild)
	return container
end

local function createNotifier(screenGui)
	local holder = create("Frame", {
		Name = "Toasts", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 8), Size = UDim2.fromOffset(280, 0),
		AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, ZIndex = 10, Parent = screenGui,
	})
	create("UIListLayout", { Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder, Parent = holder })
	local activeToasts = {}
	local pendingThreads = {}

	local function show(text, kind)
		local color = STATUS_COLORS[kind] or THEME.Accent
		local toast = create("CanvasGroup", { Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = THEME.Card, GroupTransparency = 1, ZIndex = 10, Parent = holder })
		styleCorner(toast, 8)
		styleStroke(toast, color)
		createText({ Text = text, Size = UDim2.new(1, -16, 1, 0), Position = UDim2.fromOffset(10, 0), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 10, Parent = toast })
		table.insert(activeToasts, toast)
		if #activeToasts > 4 then
			table.remove(activeToasts, 1):Destroy()
		end
		animate(toast, { GroupTransparency = 0 }, 0.2)
		local thread
		thread = task.delay(2.5, function()
			pendingThreads[thread] = nil
			if toast.Parent then
				animate(toast, { GroupTransparency = 1 }, 0.25).Completed:Once(function()
					toast:Destroy()
				end)
			end
		end)
		pendingThreads[thread] = true
	end

	local function cancelAll()
		for thread in pendingThreads do
			task.cancel(thread)
		end
		pendingThreads = {}
	end

	return show, cancelAll
end

local function makeDraggable(handle, target, clampPosition)
	handle.InputBegan:Connect(function(inputObject)
		local inputType = inputObject.UserInputType
		if inputType ~= Enum.UserInputType.MouseButton1 and inputType ~= Enum.UserInputType.Touch then
			return
		end
		local startInput = inputObject.Position
		local startX, startY = target.Position.X.Offset, target.Position.Y.Offset
		local dragJanitor = Janitor.new()
		dragJanitor:Add(UserInputService.InputChanged:Connect(function(changed)
			if changed.UserInputType == Enum.UserInputType.MouseMovement or changed == inputObject then
				local delta = changed.Position - startInput
				clampPosition(startX + delta.X, startY + delta.Y)
			end
		end))
		dragJanitor:Add(inputObject.Changed:Connect(function()
			if inputObject.UserInputState == Enum.UserInputState.End then
				dragJanitor:Cleanup()
			end
		end))
	end)
end

local function createAboutPage(scroller)
	local card = createSection(scroller, "Nhà phát triển", 1)
	local profile = create("Frame", { Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, Parent = card })
	local avatar = create("Frame", { Size = UDim2.fromOffset(46, 46), Position = UDim2.fromOffset(0, 3), BackgroundColor3 = THEME.Accent, Parent = profile })
	styleCorner(avatar, 23)
	createText({ Text = "TK", Font = THEME.FontBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), Parent = avatar })
	createText({ Text = "Dev: " .. CONFIG.Developer.Name, Font = THEME.FontBold, TextSize = 17, Size = UDim2.new(1, -56, 0, 24), Position = UDim2.fromOffset(56, 6), Parent = profile })
	createText({ Text = "Phiên bản " .. CONFIG.Version .. " • Giao diện Dark", TextSize = 13, TextColor3 = THEME.Muted, Size = UDim2.new(1, -56, 0, 18), Position = UDim2.fromOffset(56, 28), Parent = profile })

	local telegram = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 34), Text = "Telegram: " .. CONFIG.Developer.Telegram, Font = THEME.FontBold, TextSize = 15,
		TextColor3 = Color3.new(1, 1, 1), Parent = card,
	})
	styleCorner(telegram, 8)
	addHover(telegram, THEME.Accent, Color3.fromRGB(124, 127, 255), Color3.fromRGB(78, 81, 210))

	local linkBox = create("TextBox", {
		Size = UDim2.new(1, 0, 0, 28), Text = CONFIG.Developer.TelegramUrl, BackgroundColor3 = THEME.Field, Font = THEME.Font,
		TextSize = 14, TextColor3 = THEME.Accent, ClearTextOnFocus = false, Visible = false, Parent = card,
	})
	styleCorner(linkBox, 6)
	styleStroke(linkBox, THEME.Stroke)
	linkBox:GetPropertyChangedSignal("Text"):Connect(function()
		if linkBox.Text ~= CONFIG.Developer.TelegramUrl then
			linkBox.Text = CONFIG.Developer.TelegramUrl
		end
	end)
	telegram.Activated:Connect(function()
		linkBox.Visible = true
		linkBox:CaptureFocus()
		linkBox.SelectionStart = 1
		linkBox.CursorPosition = #linkBox.Text + 1
		local setCB = setclipboard or toclipboard or (syn and syn.write_clipboard)
		if setCB then
			pcall(setCB, CONFIG.Developer.TelegramUrl)
			notify("Đã sao chép liên kết Telegram vào bộ nhớ tạm!", "success")
		else
			notify("Đã chọn liên kết Telegram, hãy bấm Ctrl+C để sao chép", "info")
		end
	end)

	local intro = createSection(scroller, "Giới thiệu", 2)
	createText({
		Text = CONFIG.Developer.Intro, TextWrapped = true, TextSize = 14, TextColor3 = THEME.Text, AutomaticSize = Enum.AutomaticSize.Y,
		Size = UDim2.new(1, 0, 0, 0), TextYAlignment = Enum.TextYAlignment.Top, Parent = intro,
	})
end

local function createScroller(parent)
	local scroller = create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ScrollBarThickness = 4, ScrollBarImageColor3 = THEME.Stroke,
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = parent,
	})
	create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = scroller })
	create("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = scroller })
	return scroller
end

local function buildFeaturesPage(scroller)
	local toggles = {}
	local function bindToggle(parent, featureName, labelText)
		toggles[featureName] = createToggleRow(parent, labelText, function()
			StateManager.set(featureName, not StateManager.isEnabled(featureName))
		end)
	end
	StateManager.onChanged(function(name, enabled)
		if toggles[name] then
			toggles[name].setState(enabled)
		end
	end)

	local graphics = createSection(scroller, "Hiệu năng & hình ảnh", 1)
	bindToggle(graphics, "FixLag", "Fix Lag (giảm đồ họa)")
	bindToggle(graphics, "FullBright", "Full Bright")

	local movement = createSection(scroller, "Di chuyển", 2)
	bindToggle(movement, "SpeedWalk", "Speed Walk")
	createSlider(movement, scroller, {
		label = "Walk Speed", min = CONFIG.WalkSpeed.Min, max = CONFIG.WalkSpeed.Max, value = walkSpeedValue,
		onChange = function(value)
			walkSpeedValue = value
			SpeedWalk.refresh()
		end,
	})
	bindToggle(movement, "HighJump", "High Jump")
	local jumpSlider = createSlider(movement, scroller, {
		label = "Jump", min = CONFIG.JumpPower.Min, max = CONFIG.JumpPower.Max, value = jumpValues.JumpPower,
		onChange = function(value)
			jumpValues[movement:GetAttribute("JumpProperty") or "JumpPower"] = value
			HighJump.refresh()
		end,
	})
	interfaceJanitor:Add(watchCharacter(function(_, humanoid)
		local property = detectJumpProperty(humanoid)
		movement:SetAttribute("JumpProperty", property)
		jumpSlider.setLabel("Jump (" .. property .. ")")
		jumpSlider.setRange(CONFIG[property].Min, CONFIG[property].Max)
		jumpSlider.setValue(jumpValues[property], true)
	end))
	bindToggle(movement, "Noclip", "Noclip")

	local farm = createSection(scroller, "Auto Farm", 3)
	bindToggle(farm, "AutoFarm", "Auto Farm")
	createStatusRow(farm, "farm")
	createDropdown(farm, {
		placeholder = "Chọn loại enemy...",
		getOptions = EnemyRegistry.getTypeNames,
		onChange = AutoFarm.setSelectedType,
	})

	local loot = createSection(scroller, "Auto Loot", 4)
	bindToggle(loot, "AutoLoot", "Auto Loot")
	createStatusRow(loot, "loot")
	createDropdown(loot, {
		placeholder = "Chọn loại loot...", multi = true,
		getOptions = function() return CONFIG.Loot.Tags end,
		onChange = AutoLoot.setSelectedTags,
	})

	local esp = createSection(scroller, "Player ESP", 5)
	bindToggle(esp, "PlayerESP", "Player ESP")
	local opposingToggle = createToggleRow(esp, "Chỉ hiện đối thủ (khác đội)", function() end)
	local opposingOnly = CONFIG.ESP.HideTeammates
	opposingToggle.setState(opposingOnly)
	return opposingToggle
end

local function buildInterface()
	local screenGui = create("ScreenGui", {
		Name = CONFIG.GuiName, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 100, Parent = PlayerGui,
	})
	local showNotification, cancelNotifications = createNotifier(screenGui)
	notify = showNotification

	local WIDTH, HEIGHT, TITLE = 330, 430, 40
	local minimized = false
	local menuVisible = CONFIG.StartOpen
	local fadeToken = 0

	local window = create("CanvasGroup", {
		Name = "Window", Size = UDim2.fromOffset(WIDTH, HEIGHT), Position = UDim2.fromOffset(72, 56),
		BackgroundColor3 = THEME.Background, GroupTransparency = if menuVisible then 0 else 1, Visible = menuVisible, Parent = screenGui,
	})
	styleCorner(window, 12)
	styleStroke(window, THEME.Stroke)

	local function getBounds()
		local size = screenGui.AbsoluteSize
		return if size.X > 0 then size else Vector2.new(800, 600)
	end

	local function clampPosition(x, y)
		local bounds = getBounds()
		local width, height = window.Size.X.Offset, window.Size.Y.Offset
		window.Position = UDim2.fromOffset(
			math.clamp(x, 0, math.max(0, bounds.X - width)),
			math.clamp(y, 0, math.max(0, bounds.Y - height))
		)
	end

	local function fitWindow()
		local bounds = getBounds()
		local width = math.min(WIDTH, bounds.X - 16)
		local height = if minimized then TITLE else math.min(HEIGHT, bounds.Y - 16)
		window.Size = UDim2.fromOffset(width, height)
		clampPosition(window.Position.X.Offset, window.Position.Y.Offset)
	end

	local titleBar = create("Frame", { Size = UDim2.new(1, 0, 0, TITLE), BackgroundColor3 = THEME.Card, Parent = window })
	createText({ Text = "KhoaDiemHub", Font = THEME.FontBold, TextSize = 17, Size = UDim2.fromOffset(130, TITLE), Position = UDim2.fromOffset(14, 0), Parent = titleBar })
	local badge = create("Frame", { Size = UDim2.fromOffset(40, 18), Position = UDim2.fromOffset(145, 11), BackgroundColor3 = THEME.Accent, Parent = titleBar })
	styleCorner(badge, 9)
	createText({ Text = CONFIG.Version, TextSize = 12, Font = THEME.FontBold, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.fromScale(1, 1), Parent = badge })

	local function createTitleButton(text, offsetX)
		local button = create("TextButton", {
			Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, offsetX, 0, 6), Text = text, Font = THEME.FontBold,
			TextSize = 15, TextColor3 = THEME.Text, Parent = titleBar,
		})
		styleCorner(button, 8)
		addHover(button, THEME.Card, THEME.CardHover, THEME.CardPress)
		return button
	end
	local minimizeButton = createTitleButton("-", -68)
	local closeButton = createTitleButton("X", -36)

	local tabBar = create("Frame", { Size = UDim2.new(1, -16, 0, 28), Position = UDim2.fromOffset(8, 46), BackgroundTransparency = 1, Parent = window })
	local body = create("Frame", { Size = UDim2.new(1, -16, 1, -106), Position = UDim2.fromOffset(8, 80), BackgroundTransparency = 1, Parent = window })
	local footer = createText({
		Text = string.format("Phím tắt: %s  •  Dev: %s", CONFIG.MenuToggleKey.Name, CONFIG.Developer.Name), TextSize = 12,
		TextColor3 = THEME.Muted, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, 22),
		Position = UDim2.new(0, 0, 1, -22), Parent = window,
	})

	local featuresPage = createScroller(body)
	local aboutPage = createScroller(body)
	aboutPage.Visible = false
	local opposingToggle = buildFeaturesPage(featuresPage)
	createAboutPage(aboutPage)

	local tabButtons = {}
	local function selectTab(name)
		featuresPage.Visible = name == "features"
		aboutPage.Visible = name == "about"
		for key, button in tabButtons do
			local active = key == name
			animate(button, { BackgroundColor3 = if active then THEME.Accent else THEME.Card }, 0.15)
			animate(button, { TextColor3 = if active then Color3.new(1, 1, 1) else THEME.Muted }, 0.15)
		end
	end
	local function createTab(key, text, position)
		local button = create("TextButton", {
			Size = UDim2.new(0.5, -3, 1, 0), Position = position, Text = text, Font = THEME.FontBold, TextSize = 14,
			BackgroundColor3 = THEME.Card, TextColor3 = THEME.Muted, AutoButtonColor = false, Parent = tabBar,
		})
		styleCorner(button, 8)
		button.Activated:Connect(function()
			selectTab(key)
		end)
		tabButtons[key] = button
	end
	createTab("features", "Tính năng", UDim2.fromScale(0, 0))
	createTab("about", "Giới thiệu", UDim2.new(0.5, 3, 0, 0))
	selectTab("features")

	local opposingOnly = CONFIG.ESP.HideTeammates
	local opposingRow = nil
	for _, descendant in featuresPage:GetDescendants() do
		if descendant:IsA("TextLabel") and descendant.Text == "Chỉ hiện đối thủ (khác đội)" then
			opposingRow = descendant.Parent
		end
	end
	if opposingRow then
		opposingRow.Activated:Connect(function()
			opposingOnly = not opposingOnly
			opposingToggle.setState(opposingOnly)
			PlayerEsp.setHideTeammates(opposingOnly)
		end)
	end

	local function setMenuVisible(visible)
		menuVisible = visible
		fadeToken += 1
		local token = fadeToken
		if visible then
			window.Visible = true
			animate(window, { GroupTransparency = 0 }, 0.18)
		else
			animate(window, { GroupTransparency = 1 }, 0.15).Completed:Once(function()
				if token == fadeToken then
					window.Visible = false
				end
			end)
		end
	end

	local function setMinimized(value)
		minimized = value
		local bounds = getBounds()
		local height = if value then TITLE else math.min(HEIGHT, bounds.Y - 16)
		if not value then
			body.Visible, tabBar.Visible, footer.Visible = true, true, true
		end
		animate(window, { Size = UDim2.fromOffset(window.Size.X.Offset, height) }, 0.2).Completed:Once(function()
			if minimized then
				body.Visible, tabBar.Visible, footer.Visible = false, false, false
			end
		end)
	end

	minimizeButton.Activated:Connect(function()
		setMinimized(not minimized)
	end)
	closeButton.Activated:Connect(function()
		setMenuVisible(false)
	end)
	makeDraggable(titleBar, window, clampPosition)

	local launcher = create("TextButton", {
		Name = "Launcher", Size = UDim2.fromOffset(44, 44), AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 12, 0.5, 0),
		Text = "", Parent = screenGui,
	})
	styleCorner(launcher, 22)
	styleStroke(launcher, THEME.Stroke)
	addHover(launcher, THEME.Card, THEME.CardHover, THEME.CardPress)
	for index = 0, 2 do
		local line = create("Frame", { Size = UDim2.fromOffset(18, 2), Position = UDim2.fromOffset(13, 14 + index * 6), BackgroundColor3 = THEME.Text, Parent = launcher })
		styleCorner(line, 1)
	end
	launcher.Activated:Connect(function()
		setMenuVisible(not menuVisible)
	end)

	interfaceJanitor:Add(UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == CONFIG.MenuToggleKey then
			setMenuVisible(not menuVisible)
		end
	end))
	interfaceJanitor:Add(screenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(fitWindow))
	fitWindow()

	setStatus("farm", "Tắt", "off")
	setStatus("loot", "Tắt", "off")
	return screenGui, cancelNotifications
end

local coreJanitor = Janitor.new()
EnemyRegistry.start(coreJanitor)
LootRegistry.start(coreJanitor)

local screenGui, cancelNotifications = buildInterface()

screenGui.Destroying:Connect(function()
	StateManager.disableAll()
	cancelNotifications()
	interfaceJanitor:Cleanup()
	coreJanitor:Cleanup()
end)

notify("KhoaDiemHub " .. CONFIG.Version .. " sẵn sàng", "success")
