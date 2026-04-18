local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local function ensureFolder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("Folder") then
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function ensureRemote(remotes: Folder, remoteName: string)
	local existing = remotes:FindFirstChild(remoteName)
	if existing and existing:IsA("RemoteEvent") then
		return existing
	end

	local remote = Instance.new("RemoteEvent")
	remote.Name = remoteName
	remote.Parent = remotes
	return remote
end

local function ensurePart(parent: Instance, name: string, size: Vector3, cframe: CFrame, transparency: number, color: Color3)
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("BasePart") then
		return existing
	end

	local part = Instance.new("Part")
	part.Name = name
	part.Size = size
	part.CFrame = cframe
	part.Anchored = true
	part.CanCollide = false
	part.Transparency = transparency
	part.Color = color
	part.Parent = parent
	return part
end

local function ensureTextButton(parent: Instance, name: string, text: string, position: UDim2)
	local existing = parent:FindFirstChild(name)
	if existing and existing:IsA("TextButton") then
		return existing
	end

	local button = Instance.new("TextButton")
	button.Name = name
	button.Text = text
	button.Size = UDim2.fromOffset(220, 40)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	button.TextColor3 = Color3.fromRGB(245, 245, 245)
	button.TextScaled = true
	button.Parent = parent
	return button
end

local function ensureMainGui()
	local existing = StarterGui:FindFirstChild("MainGui")
	if existing and existing:IsA("ScreenGui") then
		return
	end

	local mainGui = Instance.new("ScreenGui")
	mainGui.Name = "MainGui"
	mainGui.ResetOnSpawn = false
	mainGui.Parent = StarterGui

	local cashLabel = Instance.new("TextLabel")
	cashLabel.Name = "CashLabel"
	cashLabel.Text = "Cash: 0"
	cashLabel.Size = UDim2.fromOffset(220, 50)
	cashLabel.Position = UDim2.fromOffset(16, 16)
	cashLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	cashLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	cashLabel.TextScaled = true
	cashLabel.Parent = mainGui

	local vehicleButton = Instance.new("TextButton")
	vehicleButton.Name = "VehicleButton"
	vehicleButton.Text = "Garage"
	vehicleButton.Size = UDim2.fromOffset(180, 44)
	vehicleButton.Position = UDim2.fromOffset(16, 78)
	vehicleButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	vehicleButton.TextColor3 = Color3.fromRGB(245, 245, 245)
	vehicleButton.TextScaled = true
	vehicleButton.Parent = mainGui

	local resetButton = Instance.new("TextButton")
	resetButton.Name = "ResetButton"
	resetButton.Text = "Reset Car"
	resetButton.Size = UDim2.fromOffset(180, 44)
	resetButton.Position = UDim2.fromOffset(16, 130)
	resetButton.BackgroundColor3 = Color3.fromRGB(110, 30, 30)
	resetButton.TextColor3 = Color3.fromRGB(245, 245, 245)
	resetButton.TextScaled = true
	resetButton.Parent = mainGui

	local garageFrame = Instance.new("Frame")
	garageFrame.Name = "GarageFrame"
	garageFrame.Visible = false
	garageFrame.Size = UDim2.fromOffset(250, 200)
	garageFrame.Position = UDim2.fromOffset(16, 184)
	garageFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
	garageFrame.Parent = mainGui

	ensureTextButton(garageFrame, "StarterJeepButton", "Starter Jeep", UDim2.fromOffset(15, 15))
	ensureTextButton(garageFrame, "TrailTruckButton", "Trail Truck / Buy 300", UDim2.fromOffset(15, 62))
	ensureTextButton(garageFrame, "RockCrawlerButton", "Rock Crawler / Buy 800", UDim2.fromOffset(15, 109))
end

local function createTemplateVehicleModels(vehicleModels: Folder)
	local names = { "StarterJeep", "TrailTruck", "RockCrawler" }

	for _, modelName in ipairs(names) do
		if vehicleModels:FindFirstChild(modelName) then
			continue
		end

		local model = Instance.new("Model")
		model.Name = modelName

		local body = Instance.new("Part")
		body.Name = "Body"
		body.Size = Vector3.new(6, 1, 10)
		body.Anchored = false
		body.Color = Color3.fromRGB(76, 109, 255)
		body.Parent = model

		local seat = Instance.new("VehicleSeat")
		seat.Name = "DriverSeat"
		seat.Size = Vector3.new(2, 1, 2)
		seat.CFrame = body.CFrame * CFrame.new(0, 1.2, 0)
		seat.Anchored = false
		seat.MaxSpeed = 55
		seat.Torque = 1800
		seat.TurnSpeed = 2
		seat.Parent = model

		local weld = Instance.new("WeldConstraint")
		weld.Part0 = body
		weld.Part1 = seat
		weld.Parent = body

		model.PrimaryPart = body
		model.Parent = vehicleModels
	end
end

local function createCheckpoints(folder: Folder)
	if #folder:GetChildren() > 0 then
		return
	end

	for index = 1, 6 do
		local checkpoint = ensurePart(
			folder,
			("Checkpoint%d"):format(index),
			Vector3.new(14, 8, 2),
			CFrame.new(index * 60, 6, -40 + (index % 2) * 20),
			0.35,
			Color3.fromRGB(255, 214, 10)
		)
		checkpoint.Material = Enum.Material.Neon
	end
end

local mapFolder = ensureFolder(workspace, "Map")
ensureFolder(workspace, "VehicleSpawns")
local checkpointFolder = ensureFolder(workspace, "CheckpointFolder")

local garageSpawn = workspace:FindFirstChild("GarageSpawn")
if not (garageSpawn and garageSpawn:IsA("BasePart")) then
	garageSpawn = Instance.new("Part")
	garageSpawn.Name = "GarageSpawn"
	garageSpawn.Size = Vector3.new(20, 1, 20)
	garageSpawn.Anchored = true
	garageSpawn.CFrame = CFrame.new(0, 3, 0)
	garageSpawn.Color = Color3.fromRGB(40, 133, 55)
	garageSpawn.Parent = workspace
end

local rewardsFolder = ensureFolder(mapFolder, "Rewards")
ensurePart(rewardsFolder, "MudPitReward", Vector3.new(8, 8, 8), CFrame.new(180, 5, 120), 0.4, Color3.fromRGB(93, 64, 55))
ensurePart(rewardsFolder, "MountainTopReward", Vector3.new(8, 8, 8), CFrame.new(420, 120, -120), 0.4, Color3.fromRGB(141, 110, 99))

local remotes = ensureFolder(ReplicatedStorage, "Remotes")
ensureRemote(remotes, "SpawnCar")
ensureRemote(remotes, "ResetCar")
ensureRemote(remotes, "CheckpointReached")
ensureRemote(remotes, "BuyVehicle")

local vehicleModels = ensureFolder(ReplicatedStorage, "VehicleModels")
createTemplateVehicleModels(vehicleModels)
createCheckpoints(checkpointFolder)
ensureMainGui()

Players.PlayerAdded:Connect(function(player)
	-- Ensure PlayerGui receives MainGui immediately for existing places that clone late.
	if not player:FindFirstChild("PlayerGui") then
		player:WaitForChild("PlayerGui", 5)
	end
end)

print("[Bootstrap] Off-road game folders, remotes, GUI, and template content are ready.")
