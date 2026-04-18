local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local remotes = ReplicatedStorage:WaitForChild("Remotes")

local spawnCarRemote = remotes:WaitForChild("SpawnCar")
local resetCarRemote = remotes:WaitForChild("ResetCar")
local buyVehicleRemote = remotes:WaitForChild("BuyVehicle")

local playerGui = player:WaitForChild("PlayerGui")
local mainGui = playerGui:WaitForChild("MainGui")

local cashLabel = mainGui:WaitForChild("CashLabel")
local vehicleButton = mainGui:WaitForChild("VehicleButton")
local resetButton = mainGui:WaitForChild("ResetButton")
local garageFrame = mainGui:WaitForChild("GarageFrame")

local starterButton = garageFrame:WaitForChild("StarterJeepButton")
local trailButton = garageFrame:WaitForChild("TrailTruckButton")
local crawlerButton = garageFrame:WaitForChild("RockCrawlerButton")

local function watchCash()
	local leaderstats = player:WaitForChild("leaderstats")
	local cash = leaderstats:WaitForChild("Cash")

	local function refresh()
		cashLabel.Text = "Cash: " .. cash.Value
	end

	refresh()
	cash:GetPropertyChangedSignal("Value"):Connect(refresh)
end

watchCash()

vehicleButton.MouseButton1Click:Connect(function()
	garageFrame.Visible = not garageFrame.Visible
end)

resetButton.MouseButton1Click:Connect(function()
	resetCarRemote:FireServer()
end)

starterButton.MouseButton1Click:Connect(function()
	spawnCarRemote:FireServer("StarterJeep")
end)

trailButton.MouseButton1Click:Connect(function()
	local owned = player:FindFirstChild("OwnedVehicles") and player.OwnedVehicles:FindFirstChild("TrailTruck")
	if owned then
		spawnCarRemote:FireServer("TrailTruck")
	else
		buyVehicleRemote:FireServer("TrailTruck")
	end
end)

crawlerButton.MouseButton1Click:Connect(function()
	local owned = player:FindFirstChild("OwnedVehicles") and player.OwnedVehicles:FindFirstChild("RockCrawler")
	if owned then
		spawnCarRemote:FireServer("RockCrawler")
	else
		buyVehicleRemote:FireServer("RockCrawler")
	end
end)
