local Players = game:GetService("Players")
local rewardsFolder = workspace:WaitForChild("Map"):WaitForChild("Rewards")

local rewardValues = {
	MudPitReward = 100,
	MountainTopReward = 200,
}

local claimed: {[Player]: {[string]: boolean}} = {}

Players.PlayerAdded:Connect(function(player)
	claimed[player] = {}
end)

Players.PlayerRemoving:Connect(function(player)
	claimed[player] = nil
end)

for _, part in ipairs(rewardsFolder:GetChildren()) do
	if not part:IsA("BasePart") then
		continue
	end

	part.Touched:Connect(function(hit)
		local character = hit.Parent
		if not character then
			return
		end

		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then
			return
		end

		local player = Players:GetPlayerFromCharacter(character)
		if not player then
			return
		end

		claimed[player] = claimed[player] or {}
		if claimed[player][part.Name] then
			return
		end
		claimed[player][part.Name] = true

		local cash = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Cash")
		if cash then
			cash.Value += rewardValues[part.Name] or 50
		end
	end)
end
