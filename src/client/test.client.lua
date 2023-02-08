local ReplicatedStorage = game:GetService("ReplicatedStorage")

local counter = require(ReplicatedStorage.shared.store.counter)
local effects = require(ReplicatedStorage.shared.store.effects)

effects.onUpdate(counter.selectCount, function(state)
	print(`🔵 Count changed to {state}`)
end)
