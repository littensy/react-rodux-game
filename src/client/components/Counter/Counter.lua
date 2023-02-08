local ReplicatedStorage = game:GetService("ReplicatedStorage")
local client = script:FindFirstAncestor("client")

local Sift = require(ReplicatedStorage.packages.Sift)
local React = require(ReplicatedStorage.packages.React)
local ReactSpring = require(ReplicatedStorage.packages.ReactSpring)
local ReactRodux = require(client.providers.ReactRodux)
local counter = require(ReplicatedStorage.shared.store.counter)

export type Props = {
	color: (Color3 | Binding<Color3>)?,
}

local defaultProps = {
	color = Color3.fromRGB(0, 0, 0),
}

local function Counter(partialProps: Props)
	local props: typeof(defaultProps) & Props = Sift.Dictionary.join(defaultProps, partialProps)

	local count = ReactRodux.useSelector(counter.selectCount)

	local styles: { count: Binding<number> } = ReactSpring.useSpring({
		count = count,
	})

	return React.createElement("TextLabel", {
		Text = styles.count:map(function(value)
			return `server counter · {math.round(value * 100) / 100}`
		end),
		FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Bold),
		TextSize = 20,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		BackgroundColor3 = props.color,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 1),
		Size = UDim2.fromOffset(400, 100),
		Position = UDim2.new(1, -10, 1, -10),
	}, {
		CornerRadius = React.createElement("UICorner", {
			CornerRadius = UDim.new(0, 10),
		}),
	})
end

return Counter
