local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script:FindFirstAncestor("client")

local React = require(ReplicatedStorage.packages.React)
local ReactRoblox = require(ReplicatedStorage.packages.ReactRoblox)
local ReactRodux = require(client.providers.ReactRodux)
local store = require(client.store)
local App = require(script.Parent.App)

return function(target)
	local root = ReactRoblox.createRoot(target)

	root:render(React.createElement(ReactRodux.Provider, { store = store.configureStore() }, {
		React.createElement(App),
	}))

	return function()
		root:unmount()
	end
end
