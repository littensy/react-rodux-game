local types = require(script.types)
local defaultMemoize = require(script.defaultMemoize)

export type EqualityFn = types.EqualityFn
export type CreateSelectorFunction = types.CreateSelectorFunction
export type Function = types.Function

local function createSelectorCreator(memoize: (func: Function) -> Function)
	local function createSelector(dependencies: { Function }, resultFunc: Function)
		local lastResult: unknown

		assert(
			type(resultFunc) == "function",
			`createSelector expects last argument to be a function, but received: {type(resultFunc)}`
		)

		local memoizedResultFunc = memoize(function(...)
			return resultFunc(...)
		end)

		local selector = memoize(function(...)
			local params = {}
			local count = 0

			for index, dep in ipairs(dependencies) do
				params[index] = dep(...)
				count += 1
			end

			lastResult = memoizedResultFunc(table.unpack(params, 1, count))
			return lastResult
		end)

		return selector
	end

	return (createSelector :: any) :: CreateSelectorFunction
end

local createSelector: CreateSelectorFunction = createSelectorCreator(defaultMemoize)

return {
	createSelector = createSelector,
	createSelectorCreator = createSelectorCreator,
	defaultMemoize = defaultMemoize,
}
