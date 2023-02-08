local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script:FindFirstAncestor("client")

local React = require(ReplicatedStorage.packages.React)
local ReactRoblox = require(ReplicatedStorage.packages.ReactRoblox)
local ReactRodux = require(client.providers.ReactRodux)
local effects = require(ReplicatedStorage.shared.store.effects)
local App = require(script.Parent.App)

local target = Players.LocalPlayer:WaitForChild("PlayerGui")
local root = ReactRoblox.createRoot(target)

effects.waitForStore():andThen(function(store)
	root:render(React.createElement(ReactRodux.Provider, { store = store }, {
		app = React.createElement(App),
	}))
end)
