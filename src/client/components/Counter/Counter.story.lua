local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script:FindFirstAncestor("client")

local React = require(ReplicatedStorage.packages.React)
local ReactRoblox = require(ReplicatedStorage.packages.ReactRoblox)
local ReactRodux = require(client.providers.ReactRodux)
local store = require(client.store)
local counter = require(ReplicatedStorage.shared.store.counter)
local setInterval = require(ReplicatedStorage.shared.utils.setInterval)
local Counter = require(script.Parent.Counter)

return function(target)
	local root = ReactRoblox.createRoot(target)
	local rootStore = store.configureStore()

	root:render(React.createElement(ReactRodux.Provider, { store = rootStore }, {
		React.createElement(Counter),
	}))

	local handle = setInterval(function()
		if math.random() > 0.5 then
			rootStore:dispatch(counter.increment(math.random(-5, 5)))
		else
			rootStore:dispatch(counter.multiply(math.random() * 4 - 2))
		end
	end, 0.5)

	return function()
		root:unmount()
		handle()
	end
end
