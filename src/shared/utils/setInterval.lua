local RunService = game:GetService("RunService")

local function setInterval(callback: () -> (), interval: number?): () -> ()
	local connection: RBXScriptConnection
	local timer = 0

	connection = RunService.Heartbeat:Connect(function(deltaTime: number)
		timer += deltaTime

		if timer >= interval then
			timer -= interval
			callback()
		end
	end)

	return function()
		connection:Disconnect()
	end
end

return setInterval
