local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)
local Rodux = require(ReplicatedStorage.packages.Rodux)
local actions = require(script.Parent.actions)

export type CounterState = {
	count: number,
}

local initialState: CounterState = {
	count = 0,
}

local counterReducer = Rodux.createReducer(initialState, {
	SYNC = function(state, action)
		-- Dispatched on the client when loading the state from the server.
		return action.state.counter
	end,

	[actions.INCREMENT] = function(state, action: typeof(ReturnValue(actions.increment)))
		return Sift.Dictionary.set(state, "count", state.count + action.payload)
	end,

	[actions.MULTIPLY] = function(state, action: typeof(ReturnValue(actions.multiply)))
		return Sift.Dictionary.set(state, "count", state.count * action.payload)
	end,
})

return {
	counterReducer = counterReducer,
}
