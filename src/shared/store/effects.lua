local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Promise = require(ReplicatedStorage.packages.Promise)
local Rodux = require(ReplicatedStorage.packages.Rodux)

local actionCallbacksByType = {}
local currentStore: Rodux.Store

local function assertStore()
	if not currentStore then
		error("@rbxts/rodux-effects: store is not initialized, did you call waitForStore() before using an effect?")
	end
end

local function bind(store: Rodux.Store)
	if currentStore ~= nil then
		warn("@rbxts/rodux-effects: store is already initialized, did you call bind() twice?")
	end
	currentStore = store
end

local function effectMiddleware(nextDispatch)
	return function(action)
		if type(action) ~= "table" then
			return nextDispatch(action)
		end

		local callbacks = actionCallbacksByType[action.type]
		if callbacks then
			for _, callback in ipairs(callbacks) do
				task.spawn(callback, action)
			end
		end

		return nextDispatch(action)
	end
end

local function getStore(): Rodux.Store
	return currentStore
end

local function waitForStore(): Promise<Rodux.Store>
	if currentStore then
		return Promise.resolve(currentStore)
	end

	return Promise.new(function(resolve, _, onCancel)
		local handle
		handle = RunService.Heartbeat:Connect(function()
			if currentStore then
				handle:Disconnect()
				resolve(currentStore)
			end
		end)

		onCancel(function()
			handle:Disconnect()
		end)
	end)
end

local function getState<T>(selector: (state: any) -> T): T
	assertStore()
	return selector(currentStore:getState())
end

local function dispatch(action: Rodux.Action)
	assertStore()
	return currentStore:dispatch(action)
end

local function destruct()
	assertStore()
	currentStore:destruct()
end

local function onDispatch(type: string, callback: (action: Rodux.Action) -> ())
	local callbacks = actionCallbacksByType[type]

	if not callbacks then
		callbacks = {}
		actionCallbacksByType[type] = callbacks
	end

	table.insert(callbacks, callback)

	return function()
		local index = table.find(callbacks, callback)
		if index then
			table.remove(callbacks, index)
		end
	end
end

local function onUpdate<T>(selector: (state: any) -> T, callback: (T, T) -> (), isImmediate: boolean?): () -> ()
	local handle
	local lastSelectedState

	local function onChange(state)
		local selectedState = selector(state)

		if selectedState ~= lastSelectedState then
			task.spawn(callback, selectedState, lastSelectedState)
			lastSelectedState = selectedState
		end
	end

	local promise = waitForStore():andThen(function(store)
		handle = store.changed:connect(onChange)
		lastSelectedState = selector(store:getState())

		if isImmediate then
			task.defer(callback, lastSelectedState, lastSelectedState)
		end
	end)

	return function()
		if handle then
			handle:disconnect()
		else
			promise:cancel()
		end
	end
end

local function onUpdateImmediate<T>(selector: (state: any) -> T, callback: (T, T) -> ())
	return onUpdate(selector, callback, true)
end

local function onUpdateOnce<T>(selector: (state: any) -> T, callback: (T, T) -> ())
	local handle
	handle = onUpdate(selector, function(current, previous)
		handle()
		callback(current, previous)
	end)
	return handle
end

local function onDispatchOnce(type: string, callback: (action: Rodux.Action) -> ())
	local handle
	handle = onDispatch(type, function(action)
		handle()
		callback(action)
	end)
	return handle
end

local function waitForUpdate<T>(selector: (state: any) -> T): Promise<T>
	return Promise.new(function(resolve, _, onCancel)
		onCancel(onUpdateOnce(selector, resolve))
	end)
end

local function waitForDispatch(type: string): Promise<Rodux.Action>
	return Promise.new(function(resolve, _, onCancel)
		onCancel(onDispatchOnce(type, resolve))
	end)
end

return {
	bind = bind,
	effectMiddleware = effectMiddleware,
	waitForStore = waitForStore,
	getStore = getStore,
	getState = getState,
	dispatch = dispatch,
	destruct = destruct,
	onUpdate = onUpdate,
	onUpdateImmediate = onUpdateImmediate,
	onUpdateOnce = onUpdateOnce,
	waitForUpdate = waitForUpdate,
	onDispatch = onDispatch,
	onDispatchOnce = onDispatchOnce,
	waitForDispatch = waitForDispatch,
}
