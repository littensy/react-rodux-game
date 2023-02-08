local reducer = require(script.Parent.reducer)

type RootState = {
	shared: {
		counter: reducer.CounterState,
	},
}

local function selectCount(state: RootState): number
	return state.shared.counter.count
end

return {
	selectCount = selectCount,
}
