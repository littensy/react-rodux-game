local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.packages.React)
local Rodux = require(ReplicatedStorage.packages.Rodux)

export type Props = PropsWithChildren & {
	store: RoduxStore<any>,
}

local RoduxContext: React.Context<RoduxStore> = React.createContext(nil :: any)

local function RoduxProvider(props: Props)
	return React.createElement(RoduxContext.Provider, {
		value = props.store,
	}, props.children)
end

local function useStore(): RoduxStore
	local store = React.useContext(RoduxContext)
	assert(store, "useStore must be used within ReactRodux.Provider")
	return store
end

local function useDispatch(): (action: Rodux.Action) -> ()
	local store = useStore()

	local dispatch = React.useCallback(function(action)
		store:dispatch(action)
	end, { store })

	return dispatch
end

local function useSelector<T>(selector: (state: any) -> T): T
	local store = useStore()
	local value, setValue = React.useState(function()
		return selector(store:getState())
	end)

	local selectorRef = React.useRef(selector)
	selectorRef.current = selector

	React.useEffect(function()
		local previousValue = value
		local connection = store.changed:connect(function(newState)
			local newValue = selectorRef.current(newState)

			if newValue ~= previousValue then
				previousValue = newValue
				setValue(newValue)
			end
		end)

		return function()
			connection:disconnect()
		end
	end, { store })

	return value
end

local function useSelectorCreator<R, A...>(selectorCreator: (A...) -> (state: any) -> R, ...: A...): R
	local selectorParams = table.pack(...)

	local selector = React.useMemo(function()
		return (selectorCreator :: any)(table.unpack(selectorParams, 1, selectorParams.n))
	end, selectorParams)

	return useSelector(selector)
end

return {
	Provider = RoduxProvider,
	useStore = useStore,
	useDispatch = useDispatch,
	useSelector = useSelector,
	useSelectorCreator = useSelectorCreator,
}
