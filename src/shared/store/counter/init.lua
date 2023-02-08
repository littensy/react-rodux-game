local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Sift = require(ReplicatedStorage.packages.Sift)
local actions = require(script.actions)
local reducer = require(script.reducer)
local selectors = require(script.selectors)

export type CounterState = reducer.CounterState

return Sift.Dictionary.join(actions, reducer, selectors) :: typeof(actions) & typeof(reducer) & typeof(selectors)
