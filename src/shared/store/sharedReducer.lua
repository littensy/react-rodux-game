local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local counter = require(script.Parent.counter)

export type SharedState = {
	counter: counter.CounterState,
}
export type SharedReducer = Rodux.Reducer<SharedState>
export type SharedStore = RoduxStore<SharedState>

local sharedReducer: SharedReducer = Rodux.combineReducers({
	counter = counter.counterReducer,
})

return sharedReducer
