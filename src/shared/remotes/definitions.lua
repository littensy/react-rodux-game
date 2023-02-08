local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Net = require(ReplicatedStorage.packages.Net)

local GET_STATE = "getState"
local DISPATCH_ACTIONS = "dispatchActions"

--- Creates a table of remote definitions. Does not create them unless the
--- server is running to avoid creating remotes in Hoarcekat.
--- @ignore
local function create()
	if RunService:IsRunning() then
		return {
			[GET_STATE] = Net.Definitions.ServerAsyncFunction(),
			[DISPATCH_ACTIONS] = Net.Definitions.ServerToClientEvent(),
		}
	end
	return {} :: never
end

return {
	create = create,
	GET_STATE = GET_STATE,
	DISPATCH_ACTIONS = DISPATCH_ACTIONS,
}
