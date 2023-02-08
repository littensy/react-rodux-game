local types = require(script.Parent.types)

local NOT_FOUND = "NOT_FOUND"

local function createSingletonCache(equals: types.EqualityFn)
	local entry
	return {
		get = function(key: unknown)
			if entry and equals(key, entry.key) then
				return entry.value
			end

			return NOT_FOUND
		end,

		put = function(key: unknown, value: unknown)
			entry = {
				key = key,
				value = value,
			}
		end,
	}
end

local function createCacheKeyComparator(equalityCheck: types.EqualityFn)
	return function(prev: { unknown }?, next: { unknown }?)
		if not prev or not next or #prev ~= #next then
			return false
		end

		for i, prevValue in ipairs(prev :: { unknown }) do
			if not equalityCheck(prevValue, (next :: { unknown })[i]) then
				return false
			end
		end

		return true
	end
end

local defaultEqualityCheck: types.EqualityFn = function(a, b)
	return a == b
end

local function defaultMemoize(func: () -> (), equalityCheck: types.EqualityFn?)
	local comparator = createCacheKeyComparator(equalityCheck or defaultEqualityCheck)
	local cache = createSingletonCache(comparator)

	return function(...)
		local arguments = { ... }
		local value = cache.get(arguments)

		if value == NOT_FOUND then
			value = func(...)
			cache.put(arguments, value)
		end

		return value
	end
end

return defaultMemoize
