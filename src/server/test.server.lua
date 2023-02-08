local ReplicatedStorage = game:GetService("ReplicatedStorage")

local counter = require(ReplicatedStorage.shared.store.counter)
local effects = require(ReplicatedStorage.shared.store.effects)

effects.onUpdate(counter.selectCount, function(state)
	print(`🟢 Count changed to {state}`)
end)

effects.waitForStore():andThen(function(store)
	while true do
		task.wait(math.random() + 0.2)

		if math.random() > 0.5 then
			store:dispatch(counter.increment(math.random(-5, 5)))
		else
			store:dispatch(counter.multiply(math.random() * 4 - 2))
		end
	end
end)
