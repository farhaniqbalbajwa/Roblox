local Players = game:GetService("Players")
local checkpointFolder = workspace:WaitForChild("CheckpointFolder")

local playerProgress: {[Player]: number} = {}
local touchDebounces: {[Player]: {[BasePart]: boolean}} = {}

local CHECKPOINT_REWARD = 50
local FINISH_BONUS = 200

local checkpoints = checkpointFolder:GetChildren()
table.sort(checkpoints, function(a, b)
	return a.Name < b.Name
end)

Players.PlayerAdded:Connect(function(player)
	playerProgress[player] = 1
	touchDebounces[player] = {}
end)

Players.PlayerRemoving:Connect(function(player)
	playerProgress[player] = nil
	touchDebounces[player] = nil
end)

local function rewardPlayer(player: Player, amount: number)
	local cash = player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Cash")
	if cash then
		cash.Value += amount
	end
end

for index, checkpoint in ipairs(checkpoints) do
	if not checkpoint:IsA("BasePart") then
		continue
	end

	checkpoint.Touched:Connect(function(hit)
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

		touchDebounces[player] = touchDebounces[player] or {}
		if touchDebounces[player][checkpoint] then
			return
		end
		touchDebounces[player][checkpoint] = true

		local expectedCheckpoint = playerProgress[player] or 1
		if index == expectedCheckpoint then
			rewardPlayer(player, CHECKPOINT_REWARD)
			playerProgress[player] += 1

			if playerProgress[player] > #checkpoints then
				rewardPlayer(player, FINISH_BONUS)
				playerProgress[player] = 1
			end
		end

		task.delay(1, function()
			if touchDebounces[player] then
				touchDebounces[player][checkpoint] = nil
			end
		end)
	end)
end
