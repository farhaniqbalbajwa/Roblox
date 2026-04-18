local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local cashStore = DataStoreService:GetDataStore("OffroadCashV1")
local vehicleStore = DataStoreService:GetDataStore("OffroadVehiclesV1")

local defaultOwnedVehicles = {
	StarterJeep = true,
}

local function ensureStarterJeep(ownedFolder: Folder)
	if ownedFolder:FindFirstChild("StarterJeep") then
		return
	end

	local starterValue = Instance.new("BoolValue")
	starterValue.Name = "StarterJeep"
	starterValue.Value = true
	starterValue.Parent = ownedFolder
end

Players.PlayerAdded:Connect(function(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local cash = Instance.new("IntValue")
	cash.Name = "Cash"
	cash.Parent = leaderstats

	local ownedFolder = Instance.new("Folder")
	ownedFolder.Name = "OwnedVehicles"
	ownedFolder.Parent = player

	local successCash, savedCash = pcall(function()
		return cashStore:GetAsync(player.UserId)
	end)

	if successCash and type(savedCash) == "number" then
		cash.Value = savedCash
	else
		cash.Value = 100
	end

	local successVehicles, savedVehicles = pcall(function()
		return vehicleStore:GetAsync(player.UserId)
	end)

	local vehicleTable = if successVehicles and type(savedVehicles) == "table" then savedVehicles else defaultOwnedVehicles

	for vehicleName, owned in pairs(vehicleTable) do
		if owned then
			local value = Instance.new("BoolValue")
			value.Name = vehicleName
			value.Value = true
			value.Parent = ownedFolder
		end
	end

	ensureStarterJeep(ownedFolder)
end)

local function savePlayer(player: Player)
	local cash = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Cash")
	local ownedFolder = player:FindFirstChild("OwnedVehicles")

	if cash then
		pcall(function()
			cashStore:SetAsync(player.UserId, cash.Value)
		end)
	end

	if ownedFolder then
		local vehicleTable = {}
		for _, child in ipairs(ownedFolder:GetChildren()) do
			if child:IsA("BoolValue") then
				vehicleTable[child.Name] = child.Value
			end
		end

		pcall(function()
			vehicleStore:SetAsync(player.UserId, vehicleTable)
		end)
	end
end

Players.PlayerRemoving:Connect(savePlayer)

game:BindToClose(function()
	for _, player in ipairs(Players:GetPlayers()) do
		savePlayer(player)
	end
end)
