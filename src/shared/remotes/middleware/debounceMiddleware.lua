local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.packages.Net)

--- A middleware that prevents a remote from being called more than once
--- per `debounceTime` seconds.
--- @param debounceTime The time in seconds to debounce the remote
--- @return A middleware function
local function debounceMiddleware(debounceTime: number): Net.NetMiddleware
	return function(nextMiddleware, instance)
		local throttled: Dictionary<number, boolean> = {}

		return function(sender, ...)
			if throttled[sender.UserId] then
				warn(`Dropped request to {instance:GetInstance()} from {sender.Name}`)
				return
			end

			throttled[sender.UserId] = true

			task.delay(debounceTime, function()
				throttled[sender.UserId] = nil
			end)

			return nextMiddleware(sender, ...)
		end
	end
end

return debounceMiddleware
