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
	StartOpen = false,
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
	pcall(function() PlayerGui[CONFIG.GuiName]:Destroy() end)
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
			pcall(function() item:Disconnect() end)
		elseif itemType == "Instance" then
			pcall(function()
				if item:IsA("Tween") then item:Cancel() end
				item:Destroy()
			end)
		elseif itemType == "function" then
			pcall(item)
		elseif itemType == "thread" then
			pcall(function()
				if item ~= coroutine.running() and coroutine.status(item) ~= "dead" then
					task.cancel(item)
				end
			end)
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
			pcall(function() instance[property] = value end)
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
	if not character then return nil end
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
		pcall(callback, character, humanoid, root)
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
	warnPlaceholderOnce("attack", "attackTarget(target) chưa được kết nối.")
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
			end
		end
	end

	local function enableFeature(feature)
		if feature.canEnable then
			local allowed, reason = feature.canEnable()
			if not allowed then
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
		if not feature then return end
		if feature.enabled == enabled then
			emit(name)
			return
		end
		if enabled then
			enableFeature(feature)
		else
			disableFeature(feature)
		end
	end

	function StateManager.disableAll()
		for _, feature in features do
			if feature.enabled then disableFeature(feature) end
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
				if part.CanCollide then part.CanCollide = false end
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
			if part.Parent then part.CanCollide = original end
		end
		originalCollisions = {}
		trackedParts = {}
	end

	function Noclip.request(owner)
		if requesters[owner] then return end
		requesters[owner] = true
		requesterCount += 1
		if requesterCount == 1 then activate() end
	end

	function Noclip.release(owner)
		if not requesters[owner] then return end
		requesters[owner] = nil
		requesterCount -= 1
		if requesterCount == 0 then deactivate() end
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
		if tween then pcall(function() tween:Cancel() tween:Destroy() end) end
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
		if not goal then return end
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
		if mode == "idle" then return end
		local _, _, root = getCharacterParts()
		if not root then return end
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		if mode == "hold" then holdStep(root, dt) end
	end

	function Movement.acquire()
		if not connection then connection = RunService.Heartbeat:Connect(step) end
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
		if connection then connection:Disconnect() connection = nil end
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

	local function onExternalChange()
		if not modifier.enabled or not trackedHumanoid then return end
		local target = getTargetValue(trackedProperty)
		if math.abs(trackedHumanoid[trackedProperty] - target) < 0.01 then return end
		pcall(function() trackedHumanoid[trackedProperty] = target end)
	end

	local function attach(_, humanoid)
		humanoidJanitor:Cleanup()
		trackedHumanoid = humanoid
		trackedProperty = resolveProperty(humanoid)
		originalValue = humanoid[trackedProperty]
		pcall(function() humanoid[trackedProperty] = getTargetValue(trackedProperty) end)
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
			pcall(function() trackedHumanoid[trackedProperty] = originalValue end)
		end
		trackedHumanoid = nil
	end

	function modifier.refresh()
		if modifier.enabled and trackedHumanoid then
			pcall(function() trackedHumanoid[trackedProperty] = getTargetValue(trackedProperty) end)
		end
	end

	return modifier
end

local walkSpeedValue = CONFIG.WalkSpeed.Default
local jumpValues = { JumpPower = CONFIG.JumpPower.Default, JumpHeight = CONFIG.JumpHeight.Default }

local function detectJumpProperty(humanoid)
	return if humanoid.UseJumpPower then "JumpPower" else "JumpHeight"
end

local SpeedWalk = createHumanoidModifier("Speed Walk", function() return "WalkSpeed" end, function() return walkSpeedValue end)
local HighJump = createHumanoidModifier("High Jump", detectJumpProperty, function(property) return jumpValues[property] end)

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
			if layer and layer[property] ~= nil then return layer[property] end
		end
		return nil
	end

	local function restoreProperty(property)
		if watchers[property] then watchers[property]:Disconnect() watchers[property] = nil end
		pcall(function() Lighting[property] = originals[property] end)
		originals[property] = nil
		appliedValues[property] = nil
	end

	local function onExternalChange(property)
		if valuesMatch(Lighting[property], appliedValues[property]) then return end
		originals[property] = Lighting[property]
		pcall(function() Lighting[property] = appliedValues[property] end)
	end

	local function applyProperty(property)
		local value = effectiveValue(property)
		if value == nil then
			if originals[property] ~= nil then restoreProperty(property) end
			return
		end
		if originals[property] == nil then
			originals[property] = Lighting[property]
			watchers[property] = Lighting:GetPropertyChangedSignal(property):Connect(function() onExternalChange(property) end)
		end
		appliedValues[property] = value
		pcall(function() Lighting[property] = value end)
	end

	function LightingLayers.set(layerName, values)
		layers[layerName] = values
		for property in values do applyProperty(property) end
	end

	function LightingLayers.clear(layerName)
		local values = layers[layerName]
		layers[layerName] = nil
		if values then for property in values do applyProperty(property) end end
	end
end

local FullBright = {}
function FullBright.enable() LightingLayers.set("FullBright", CONFIG.FullBright) end
function FullBright.disable() LightingLayers.clear("FullBright") end

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
	for _, tag in CONFIG.Loot.Tags do table.insert(protectedTags, tag) end

	local originals = setmetatable({}, { __mode = "k" })
	local janitor = Janitor.new()
	local runId = 0
	local active = false

	local function remember(instance, property)
		local record = originals[instance]
		if not record then record = {} originals[instance] = record end
		if record[property] == nil then record[property] = instance[property] end
	end

	local function setProperty(instance, property, value)
		remember(instance, property)
		pcall(function() instance[property] = value end)
	end

	local function hasProtectedTag(instance)
		for _, tag in protectedTags do
			if CollectionService:HasTag(instance, tag) then return true end
		end
		return false
	end

	local function isProtected(instance)
		if hasProtectedTag(instance) then return true end
		local ancestor = instance.Parent
		while ancestor and ancestor ~= Workspace do
			if ancestor:IsA("Model") and ancestor:FindFirstChildOfClass("Humanoid") then return true end
			if hasProtectedTag(ancestor) then return true end
			ancestor = ancestor.Parent
		end
		return false
	end

	local function isHitboxPart(part)
		if part.Transparency >= 0.95 then return true end
		local lowerName = string.lower(part.Name)
		for _, keyword in CONFIG.FixLag.ProtectedNameKeywords do
			if string.find(lowerName, keyword, 1, true) then return true end
		end
		return false
	end

	local function simplifyPart(part)
		if part:IsA("Terrain") or isHitboxPart(part) or isProtected(part) then return end
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
			if not isProtected(instance) then setProperty(instance, "Enabled", false) end
		elseif className == "Atmosphere" then
			setProperty(instance, "Density", 0)
			setProperty(instance, "Haze", 0)
		elseif instance:IsA("BasePart") then
			simplifyPart(instance)
		elseif CONFIG.FixLag.HideDecals and (className == "Decal" or className == "Texture") then
			if not isProtected(instance) then setProperty(instance, "Transparency", 1) end
		end
	end

	function FixLag.enable()
		runId += 1
		active = true
		LightingLayers.set("FixLag", { GlobalShadows = false, FogEnd = CONFIG.FixLag.FogEnd })
		for _, inst in Workspace:GetDescendants() do pcall(processInstance, inst) end
	end

	function FixLag.disable()
		runId += 1
		active = false
		janitor:Cleanup()
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
	if item:IsA("BasePart") then return item.Position end
	if item:IsA("Model") then
		if item.PrimaryPart then return item.PrimaryPart.Position end
		return item:GetPivot().Position
	end
	return nil
end

local EnemyRegistry = {}
do
	local taggedModels = {}
	function EnemyRegistry.start(janitor)
		local tag = CONFIG.Farm.EnemyTag
		for _, inst in CollectionService:GetTagged(tag) do
			if inst:IsA("Model") then taggedModels[inst] = true end
		end
	end
	function EnemyRegistry.getModels()
		local models = {}
		for model in taggedModels do table.insert(models, model) end
		return models
	end
	function EnemyRegistry.isAlive(model)
		if not model.Parent then return false end
		local hum = model:FindFirstChildOfClass("Humanoid")
		return hum and hum.Health > 0
	end
	function EnemyRegistry.getTypeNames()
		local seen, names = {}, {}
		for _, m in EnemyRegistry.getModels() do
			if not seen[m.Name] then seen[m.Name] = true table.insert(names, m.Name) end
		end
		return names
	end
	function EnemyRegistry.findNearest(typeName, origin)
		local nearest, nearestDist = nil, math.huge
		for _, m in EnemyRegistry.getModels() do
			if m.Name == typeName and EnemyRegistry.isAlive(m) then
				local pos = getModelPosition(m)
				if pos then
					local dist = (pos - origin).Magnitude
					if dist < nearestDist then nearest = m nearestDist = dist end
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
			for _, inst in CollectionService:GetTagged(tag) do items[inst] = true end
		end
	end
	function LootRegistry.isValid(item)
		return item.Parent ~= nil and getItemPosition(item) ~= nil
	end
	function LootRegistry.findNearest(selectedTags, origin, ignoredUntil)
		local nearest, nearestDist = nil, math.huge
		local now = os.clock()
		for tag in selectedTags do
			for item in itemsByTag[tag] or {} do
				local ignored = ignoredUntil[item]
				if (not ignored or ignored < now) and LootRegistry.isValid(item) then
					local dist = (getItemPosition(item) - origin).Magnitude
					if dist < nearestDist then nearest = item nearestDist = dist end
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

	function AutoFarm.setSelectedType(name) selectedType = name target = nil end
	function AutoFarm.canEnable() return selectedType ~= nil, "Chọn loại enemy trước" end
	function AutoFarm.enable() runId += 1 Noclip.request("AutoFarm") Movement.acquire() end
	function AutoFarm.disable() runId += 1 janitor:Cleanup() Movement.release() Noclip.release("AutoFarm") end
end

local AutoLoot = {}
do
	local janitor = Janitor.new()
	local selectedTags = {}
	function AutoLoot.setSelectedTags(tags) selectedTags = tags end
	function AutoLoot.canEnable() return next(selectedTags) ~= nil, "Chọn ít nhất một loại loot" end
	function AutoLoot.enable() Noclip.request("AutoLoot") Movement.acquire() end
	function AutoLoot.disable() janitor:Cleanup() releaseActivePrompt() Movement.release() Noclip.release("AutoLoot") end
end

local PlayerEsp = {}
do
	local janitor = Janitor.new()
	function PlayerEsp.setHideTeammates(v) end
	function PlayerEsp.enable() end
	function PlayerEsp.disable() janitor:Cleanup() end
end

StateManager.register("FixLag", { label = "Fix Lag", enable = FixLag.enable, disable = FixLag.disable })
StateManager.register("FullBright", { label = "Full Bright", enable = FullBright.enable, disable = FullBright.disable })
StateManager.register("SpeedWalk", { label = "Speed Walk", enable = SpeedWalk.enable, disable = SpeedWalk.disable })
StateManager.register("HighJump", { label = "High Jump", enable = HighJump.enable, disable = HighJump.disable })
StateManager.register("Noclip", { label = "Noclip", enable = function() Noclip.request("UserToggle") end, disable = function() Noclip.release("UserToggle") end })
StateManager.register("AutoFarm", { label = "Auto Farm", canEnable = AutoFarm.canEnable, enable = AutoFarm.enable, disable = AutoFarm.disable })
StateManager.register("AutoLoot", { label = "Auto Loot", canEnable = AutoLoot.canEnable, enable = AutoLoot.enable, disable = AutoLoot.disable })
StateManager.register("PlayerESP", { label = "Player ESP", enable = PlayerEsp.enable, disable = PlayerEsp.disable })

local interfaceJanitor = Janitor.new()
local activeTweens = setmetatable({}, { __mode = "k" })

local function animate(instance, goals, duration)
	local tween = TweenService:Create(instance, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
	tween:Play()
	return tween
end

local function styleCorner(instance, radius) return create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = instance }) end
local function styleStroke(instance, color) return create("UIStroke", { Color = color, Thickness = 1, Parent = instance }) end

local function addHover(button, baseColor, hoverColor, pressColor)
	button.AutoButtonColor = false
	button.BackgroundColor3 = baseColor
	button.MouseEnter:Connect(function() animate(button, { BackgroundColor3 = hoverColor }, 0.12) end)
	button.MouseLeave:Connect(function() animate(button, { BackgroundColor3 = baseColor }, 0.15) end)
end

local function createSection(parent, titleText, order)
	local card = create("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = THEME.Card, LayoutOrder = order, Parent = parent })
	styleCorner(card, 10)
	styleStroke(card, THEME.Stroke)
	create("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = card })
	create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = card })
	createText({ Text = titleText, TextSize = 12, TextColor3 = THEME.Muted, Font = THEME.FontBold, Size = UDim2.new(1, 0, 0, 14), LayoutOrder = -1, Parent = card })
	return card
end

local function createToggleRow(parent, text, onClick)
	local row = create("TextButton", { Size = UDim2.new(1, 0, 0, 32), Text = "", Parent = parent })
	styleCorner(row, 8)
	addHover(row, THEME.Card, THEME.CardHover, THEME.CardPress)
	createText({ Text = text, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(6, 0), Parent = row })
	local track = create("Frame", { Size = UDim2.fromOffset(38, 20), Position = UDim2.new(1, -44, 0.5, -10), BackgroundColor3 = THEME.Off, Parent = row })
	styleCorner(track, 10)
	local knob = create("Frame", { Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = Color3.new(1, 1, 1), Parent = track })
	styleCorner(knob, 7)
	row.Activated:Connect(onClick)
	local toggle = {}
	function toggle.setState(enabled)
		animate(track, { BackgroundColor3 = enabled and THEME.Accent or THEME.Off }, 0.15)
		animate(knob, { Position = enabled and UDim2.fromOffset(21, 3) or UDim2.fromOffset(3, 3) }, 0.15)
	end
	return toggle
end

local function createSlider(parent, scroller, spec)
	local range = { min = spec.min, max = spec.max }
	local value = spec.value
	local row = create("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundTransparency = 1, Parent = parent })
	createText({ Text = spec.label, Size = UDim2.new(1, -64, 0, 22), TextColor3 = THEME.Muted, TextSize = 13, Parent = row })
	local input = create("TextBox", { Size = UDim2.fromOffset(58, 22), Position = UDim2.new(1, -58, 0, 0), BackgroundColor3 = THEME.Field, Font = THEME.Font, TextSize = 14, TextColor3 = THEME.Text, Text = "", Parent = row })
	styleCorner(input, 6)
	styleStroke(input, THEME.Stroke)
	local hitbox = create("TextButton", { Size = UDim2.new(1, 0, 0, 26), Position = UDim2.fromOffset(0, 24), BackgroundTransparency = 1, Text = "", Parent = row })
	local track = create("Frame", { Size = UDim2.new(1, 0, 0, 6), Position = UDim2.new(0, 0, 0.5, -3), BackgroundColor3 = THEME.Off, Parent = hitbox })
	styleCorner(track, 3)
	local fill = create("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = THEME.Accent, Parent = track })
	styleCorner(fill, 3)
	local knob = create("Frame", { Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = Color3.new(1, 1, 1), Parent = track })
	styleCorner(knob, 7)

	local slider = {}
	function slider.setValue(newValue, silent)
		value = math.clamp(newValue, range.min, range.max)
		local alpha = (value - range.min) / (range.max - range.min)
		animate(fill, { Size = UDim2.fromScale(alpha, 1) }, 0.07)
		animate(knob, { Position = UDim2.new(alpha, 0, 0.5, 0) }, 0.07)
		input.Text = tostring(value)
		if not silent then spec.onChange(value) end
	end
	slider.setValue(value, true)
	return slider
end

local function buildInterface()
	local screenGui = create("ScreenGui", {
		Name = CONFIG.GuiName,
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = 99999,
		Parent = PlayerGui,
	})

	local WIDTH, HEIGHT, TITLE = 330, 430, 40
	local menuVisible = false

	local window = create("CanvasGroup", {
		Name = "Window",
		Size = UDim2.fromOffset(WIDTH, HEIGHT),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = THEME.Background,
		GroupTransparency = 1,
		Visible = false,
		Parent = screenGui,
	})
	styleCorner(window, 12)
	styleStroke(window, THEME.Stroke)

	local titleBar = create("Frame", { Size = UDim2.new(1, 0, 0, TITLE), BackgroundColor3 = THEME.Card, Parent = window })
	createText({ Text = "KhoaDiemHub", Font = THEME.FontBold, TextSize = 17, Size = UDim2.fromOffset(130, TITLE), Position = UDim2.fromOffset(14, 0), Parent = titleBar })
	
	local closeButton = create("TextButton", { Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -36, 0, 6), Text = "X", Font = THEME.FontBold, TextSize = 15, TextColor3 = THEME.Text, Parent = titleBar })
	styleCorner(closeButton, 8)
	addHover(closeButton, THEME.Card, THEME.CardHover, THEME.CardPress)

	local body = create("ScrollingFrame", { Size = UDim2.new(1, -16, 1, -60), Position = UDim2.fromOffset(8, 50), BackgroundTransparency = 1, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = window })
	create("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body })

	local graphics = createSection(body, "Hiệu năng & hình ảnh", 1)
	createToggleRow(graphics, "Fix Lag", function() StateManager.set("FixLag", not StateManager.isEnabled("FixLag")) end)
	createToggleRow(graphics, "Full Bright", function() StateManager.set("FullBright", not StateManager.isEnabled("FullBright")) end)

	local movement = createSection(body, "Di chuyển", 2)
	createToggleRow(movement, "Speed Walk", function() StateManager.set("SpeedWalk", not StateManager.isEnabled("SpeedWalk")) end)
	createSlider(movement, body, { label = "Walk Speed", min = 16, max = 150, value = 50, onChange = function(v) walkSpeedValue = v SpeedWalk.refresh() end })

	local function setMenuVisible(visible)
		menuVisible = visible
		if visible then
			window.Visible = true
			animate(window, { GroupTransparency = 0 }, 0.2)
		else
			animate(window, { GroupTransparency = 1 }, 0.2).Completed:Once(function()
				window.Visible = false
			end)
		end
	end

	closeButton.Activated:Connect(function() setMenuVisible(false) end)

	local launcher = create("TextButton", {
		Name = "Launcher",
		Size = UDim2.fromOffset(44, 44),
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 12, 0.5, 0),
		Text = "Hub",
		Font = THEME.FontBold,
		TextColor3 = THEME.Text,
		Parent = screenGui,
	})
	styleCorner(launcher, 22)
	styleStroke(launcher, THEME.Stroke)
	addHover(launcher, THEME.Card, THEME.CardHover, THEME.CardPress)
	launcher.Activated:Connect(function() setMenuVisible(!menuVisible) end)

	-- BẢNG CHÀO MỪNG VỚI HIỆU ỨNG MỜ DẦN (FADE OUT)
	local welcomeModal = create("CanvasGroup", {
		Name = "WelcomeModal",
		Size = UDim2.fromOffset(300, 140),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		BackgroundColor3 = THEME.Card,
		GroupTransparency = 0,
		Parent = screenGui,
	})
	styleCorner(welcomeModal, 12)
	styleStroke(welcomeModal, THEME.Accent)

	createText({ Text = "CHÀO MỪNG ĐẾN VỚI", TextSize = 13, TextColor3 = THEME.Muted, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 25), Parent = welcomeModal })
	createText({ Text = "KhoaDiemHub", Font = THEME.FontBold, TextSize = 22, TextColor3 = THEME.Accent, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, 30), Position = UDim2.fromOffset(0, 48), Parent = welcomeModal })
	createText({ Text = "Đang khởi tạo hệ thống...", TextSize = 12, TextColor3 = THEME.Text, TextXAlignment = Enum.TextXAlignment.Center, Size = UDim2.new(1, 0, 0, 20), Position = UDim2.fromOffset(0, 90), Parent = welcomeModal })

	task.delay(2, function()
		if welcomeModal and welcomeModal.Parent then
			animate(welcomeModal, { GroupTransparency = 1 }, 0.4).Completed:Once(function()
				welcomeModal:Destroy()
				setMenuVisible(true)
			end)
		end
	end)

	return screenGui
end

pcall(buildInterface)
notify("KhoaDiemHub v1.0 sẵn sàng", "success")
