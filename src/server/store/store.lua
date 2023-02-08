local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Rodux = require(ReplicatedStorage.packages.Rodux)
local sharedReducer = require(ReplicatedStorage.shared.store.sharedReducer)
local effects = require(ReplicatedStorage.shared.store.effects)
local serverToClientMiddleware = require(script.Parent.middleware.serverToClientMiddleware)

export type RootState = {
	-- Your reducer state types
	shared: sharedReducer.SharedState,
}
export type RootReducer = Rodux.Reducer<RootState>
export type RootStore = RoduxStore<RootState>

local rootReducer: RootReducer = Rodux.combineReducers({
	-- Your reducers
	shared = sharedReducer,
})

--- Creates a new Rodux store and binds the side effects library to it. Actions
--- dispatched to this store are sent to the client through a middleware.
--- @param initialState An optional initial state to use for the store.
--- @return A new Rodux store.
local function configureStore(initialState: RootState?): RoduxStore<RootState>
	local store = Rodux.Store.new(rootReducer, initialState, { serverToClientMiddleware })
	effects.bind(store)
	return store
end

return {
	configureStore = configureStore,
}
