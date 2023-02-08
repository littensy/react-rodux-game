local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script:FindFirstAncestor("client")

local React = require(ReplicatedStorage.packages.React)
local Root = require(client.common.Root)
local Counter = require(client.components.Counter)

local function App()
	return React.createElement(Root, {}, {
		Counter = React.createElement(Counter),
	})
end

return App
