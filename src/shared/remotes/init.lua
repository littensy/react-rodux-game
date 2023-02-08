local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)
local definitions = require(script.definitions)
local remotes = require(script.remotes)

return Sift.Dictionary.join(definitions, remotes) :: typeof(definitions) & typeof(remotes)
