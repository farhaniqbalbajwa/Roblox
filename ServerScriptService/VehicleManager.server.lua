local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local remotes = ReplicatedStorage:WaitForChild("Remotes")
local vehicleModels = ReplicatedStorage:WaitForChild("VehicleModels")
local garageSpawn = workspace:WaitForChild("GarageSpawn")

local spawnCarRemote = remotes:WaitForChild("SpawnCar")
local resetCarRemote = remotes:WaitForChild("ResetCar")
local buyVehicleRemote = remotes:WaitForChild("BuyVehicle")

local vehiclePrices = {
	StarterJeep = 0,
	TrailTruck = 300,
	RockCrawler = 800,
}

local playerVehicles: {[Player]: Model} = {}

local function removeOldVehicle(player: Player)
	if playerVehicles[player] and playerVehicles[player].Parent then
		playerVehicles[player]:Destroy()
		playerVehicles[player] = nil
	end
end

local function playerOwnsVehicle(player: Player, vehicleName: string): boolean
	local ownedFolder = player:FindFirstChild("OwnedVehicles")
	if not ownedFolder then
		return false
	end
	return ownedFolder:FindFirstChild(vehicleName) ~= nil
end

local function spawnVehicle(player: Player, vehicleName: string)
	local model = vehicleModels:FindFirstChild(vehicleName)
	if not (model and model:IsA("Model")) then
		return
	end

	removeOldVehicle(player)

	local clone = model:Clone()
	clone.Name = vehicleName
	clone.Parent = workspace

	if not clone.PrimaryPart then
		warn(vehicleName .. " has no PrimaryPart set.")
		clone:Destroy()
		return
	end

	clone:PivotTo(garageSpawn.CFrame + Vector3.new(0, 4, 0))
	playerVehicles[player] = clone

	local seat = clone:FindFirstChildWhichIsA("VehicleSeat", true)
	if seat and player.Character and player.Character:FindFirstChild("Humanoid") then
		task.wait(0.25)
		seat:Sit(player.Character.Humanoid)
	end
end

spawnCarRemote.OnServerEvent:Connect(function(player, vehicleName)
	if type(vehicleName) ~= "string" then
		return
	end
	if not playerOwnsVehicle(player, vehicleName) then
		return
	end
	spawnVehicle(player, vehicleName)
end)

resetCarRemote.OnServerEvent:Connect(function(player)
	local currentVehicle = playerVehicles[player]
	if not (currentVehicle and currentVehicle.Parent) then
		return
	end

	local vehicleName = currentVehicle.Name
	removeOldVehicle(player)
	spawnVehicle(player, vehicleName)
end)

buyVehicleRemote.OnServerEvent:Connect(function(player, vehicleName)
	if type(vehicleName) ~= "string" then
		return
	end

	local price = vehiclePrices[vehicleName]
	if not price then
		return
	end
	if playerOwnsVehicle(player, vehicleName) then
		return
	end

	local cash = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Cash")
	if not cash then
		return
	end

	if cash.Value >= price then
		cash.Value -= price

		local ownedFolder = player:FindFirstChild("OwnedVehicles")
		if not ownedFolder then
			return
		end

		local newValue = Instance.new("BoolValue")
		newValue.Name = vehicleName
		newValue.Value = true
		newValue.Parent = ownedFolder
	end
end)

Players.PlayerRemoving:Connect(function(player)
	removeOldVehicle(player)
end)
