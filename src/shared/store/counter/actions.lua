local INCREMENT = "INCREMENT"
local MULTIPLY = "MULTIPLY"

--- Increments the counter by the given amount.
--- @param amount The amount to increment by.
--- @return The action to dispatch.
local function increment(amount: number)
	return { type = INCREMENT, payload = amount }
end

--- Multiplies the counter by the given amount.
--- @param amount The amount to multiply by.
--- @return The action to dispatch.
local function multiply(amount: number)
	return { type = MULTIPLY, payload = amount }
end

return {
	INCREMENT = INCREMENT,
	MULTIPLY = MULTIPLY,
	increment = increment,
	multiply = multiply,
}
