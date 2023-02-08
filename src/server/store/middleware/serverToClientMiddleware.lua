local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local Net = require(ReplicatedStorage.packages.Net)
local remotes = require(ReplicatedStorage.shared.remotes)

--- A middleware that sends actions dispatched by the server to every client
--- for data synchronization. Only syncs actions that are returned by a shared
--- reducer.
local function serverToClientMiddleware(nextDispatch, store)
	local whitelist: { [string]: true } = {}
	local queue: { Rodux.Action } = {}
	local players: { Player } = {}

	local dispatchActions: Net.ServerSenderEvent = remotes.server:Get(remotes.DISPATCH_ACTIONS)
	local getState: Net.ServerAsyncCallback = remotes.server:Get(remotes.GET_STATE)

	-- Modules that export action creators will also export the action types, so
	-- we can use that to build a whitelist of actions that are safe to send to
	-- the client.
	for _, module in ReplicatedStorage.shared.store:GetChildren() do
		local actionsModule = module:FindFirstChild("actions")

		if not actionsModule or not actionsModule:IsA("ModuleScript") then
			continue
		end

		for key, value in require(actionsModule) do
			if type(value) == "string" then
				whitelist[value] = true
			end
		end
	end

	-- Flush the action queue every frame
	RunService.Heartbeat:Connect(function()
		if queue[1] then
			dispatchActions:SendToPlayers(players, table.clone(queue))
			table.clear(queue)
		end
	end)

	-- Remove players from the list when they leave
	Players.PlayerRemoving:Connect(function(player)
		local index = table.find(players, player)
		if index then
			table.remove(players, index)
		end
	end)

	-- Retrieves the state of the store and sends it to the client. Only allows
	-- one request per player, and adds them to the list of players.
	getState:SetCallback(function(player)
		if table.find(players, player) then
			return
		end
		table.insert(players, player)
		return store:getState().shared
	end)

	return function(action)
		if whitelist[action.type] then
			table.insert(queue, action)
		end
		return nextDispatch(action)
	end
end

return serverToClientMiddleware
