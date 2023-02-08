local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.packages.Net)
local definitions = require(script.Parent.definitions)

local remotes = Net.CreateDefinitions(definitions.create())

return {
	client = remotes.Client,
	server = remotes.Server,
}
