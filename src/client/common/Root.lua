local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local React = require(ReplicatedStorage.packages.React)

local function Root(props: PropsWithChildren)
	return if RunService:IsRunning()
		then React.createElement("ScreenGui", {
			ResetOnSpawn = false,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		}, props.children)
		else React.createElement(React.Fragment, {}, props.children)
end

return Root
