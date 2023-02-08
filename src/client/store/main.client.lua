local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.packages.Net)
local Rodux = require(ReplicatedStorage.packages.Rodux)
local remotes = require(ReplicatedStorage.shared.remotes)
local sharedReducer = require(ReplicatedStorage.shared.store.sharedReducer)
local store = require(script.Parent.store)

local getState: Net.ClientAsyncCaller = remotes.client:Get(remotes.GET_STATE)
local dispatchActions: Net.ClientListenerEvent = remotes.client:Get(remotes.DISPATCH_ACTIONS)

local rootStore = store.configureStore()

getState:CallServerAsync():andThen(function(state: sharedReducer.SharedState)
	rootStore:dispatch({ type = "SYNC", state = state })
end)

dispatchActions:Connect(function(actions: { Rodux.Action })
	for _, action in actions do
		rootStore:dispatch(action)
	end
end)
