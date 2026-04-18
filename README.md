# Offroad Adventure (Roblox)

This repository contains a complete script scaffold for a beginner-friendly Roblox off-road driving game (not a race game).

## Included systems

- `Bootstrap.server.lua`: auto-creates required folders, remotes, basic checkpoints, reward parts, template vehicle models, and GUI (idempotent).
- `DataManager.server.lua`: leaderstats + datastore save/load for cash and owned vehicles.
- `VehicleManager.server.lua`: spawn/reset/purchase logic for three vehicles.
- `CheckpointManager.server.lua`: ordered checkpoint progression rewards with debounce.
- `DiscoveryRewards.server.lua`: optional one-time exploration cash rewards.
- `ClientUI.client.lua`: cash display, garage toggle, vehicle spawn/purchase, and reset actions.

## Roblox Studio setup

1. Open your place in Roblox Studio.
2. Create the following folders in your project and paste scripts from this repository:
   - `ServerScriptService`
   - `StarterPlayer/StarterPlayerScripts`
3. Paste all `*.server.lua` files into `ServerScriptService`.
4. Paste `ClientUI.client.lua` into `StarterPlayer > StarterPlayerScripts`.
5. Press **Play** once: `Bootstrap.server.lua` will create the minimum runtime hierarchy automatically.
6. Replace template vehicle models (`ReplicatedStorage/VehicleModels`) with your real chassis models.
7. Build your full terrain (base camp, mud pit, forest route, mountain ridge) and move checkpoints to final positions.

## Required hierarchy (auto-created by bootstrap)

```text
Workspace
 ├── Map
 │    └── Rewards
 │         ├── MudPitReward
 │         └── MountainTopReward
 ├── VehicleSpawns
 ├── CheckpointFolder
 │    ├── Checkpoint1 ... Checkpoint6
 └── GarageSpawn

ReplicatedStorage
 ├── Remotes
 │    ├── SpawnCar
 │    ├── ResetCar
 │    ├── CheckpointReached
 │    └── BuyVehicle
 └── VehicleModels
      ├── StarterJeep
      ├── TrailTruck
      └── RockCrawler

StarterGui
 └── MainGui
      ├── CashLabel
      ├── VehicleButton
      ├── ResetButton
      └── GarageFrame
           ├── StarterJeepButton
           ├── TrailTruckButton
           └── RockCrawlerButton
```

## Notes

- Enable **Game Settings → Security → Allow Studio Access to API Services** to test DataStores in published experiences.
- Template vehicles are placeholders only. For production handling, use a real chassis model with wheels/suspension and set `PrimaryPart`.
- Reward tuning:
  - checkpoint = 50 cash
  - lap finish bonus = 200 cash
  - discovery rewards = 100/200 cash
