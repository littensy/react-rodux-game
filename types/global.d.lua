-- Sift
export type Dictionary<K, V> = { [K]: V }
export type Array<T> = Dictionary<number, T>
export type Set<T> = Dictionary<T, boolean>
export type Table = Dictionary<any, any>
export type AnyDictionary = Dictionary<any, any>

-- Type inferrers
declare function ReturnValue<R...>(fn: ((...any) -> R...)): R...
declare function ReturnValueArgs<A..., R...>(fn: ((A...) -> R...), ...: A...): R...
declare function Keys<K, V>(_: { [K]: V }): K

-- Promise
export type PromiseStatus = "Started" | "Resolved" | "Rejected" | "Cancelled"

export type AnyPromise = {
	timeout: (self: AnyPromise, seconds: number, rejectionValue: unknown) -> AnyPromise,
	getStatus: (self: AnyPromise) -> PromiseStatus,
	andThen: (
		self: AnyPromise,
		successHandler: (...any) -> any,
		failureHandler: ((any) -> any)?
	) -> AnyPromise,
	catch: (self: AnyPromise, failureHandler: (...any) -> any) -> AnyPromise,
	tap: (self: AnyPromise, successHandler: (...any) -> ()) -> AnyPromise,
	andThenCall: <T...>(self: AnyPromise, successHandler: (T...) -> any, T...) -> AnyPromise,
	andThenReturn: (self: AnyPromise, value: any) -> AnyPromise,
	cancel: (self: AnyPromise) -> (),
	finally: (self: AnyPromise, callback: (status: PromiseStatus) -> any) -> AnyPromise,
	finallyCall: <T...>(self: AnyPromise, callback: (T...) -> any, T...) -> AnyPromise,
	finallyReturn: (self: AnyPromise, value: any) -> AnyPromise,
	awaitStatus: (self: AnyPromise) -> (PromiseStatus, ...any),
	await: (self: AnyPromise) -> (boolean, ...any),
	expect: (self: AnyPromise) -> ...any,
	now: (self: AnyPromise, rejectionValue: unknown) -> AnyPromise,
}

export type Promise<T = any> = {
	timeout: (self: Promise<T>, seconds: number, rejectionValue: unknown) -> Promise<T>,
	getStatus: (self: Promise<T>) -> PromiseStatus,
	andThen: (
		self: Promise<T>,
		successHandler: (T) -> any,
		failureHandler: ((...any) -> any)?
	) -> AnyPromise,
	catch: (self: Promise<T>, failureHandler: (any) -> any) -> Promise<T>,
	tap: (self: Promise<T>, successHandler: (T) -> ()) -> Promise<T>,
	andThenCall: <U...>(self: Promise<T>, successHandler: (U...) -> any, U...) -> Promise<T>,
	andThenReturn: (self: Promise<T>, value: any) -> AnyPromise,
	cancel: (self: Promise<T>) -> (),
	finally: (self: Promise<T>, callback: (status: PromiseStatus) -> any) -> AnyPromise,
	finallyCall: <U...>(self: Promise<T>, callback: (U...) -> any, U...) -> AnyPromise,
	finallyReturn: (self: Promise<T>, value: any) -> AnyPromise,
	awaitStatus: (self: Promise<T>) -> (PromiseStatus, T),
	await: (self: Promise<T>) -> (boolean, T | unknown),
	expect: (self: Promise<T>) -> T,
	now: (self: Promise<T>, rejectionValue: unknown) -> Promise<T>,
}

export type PromiseStatic = {
	Status: Dictionary<PromiseStatus, PromiseStatus>,
	new: <T>(resolver: (resolve: (T | Promise<T>) -> (), reject: (any) -> ()) -> ()) -> Promise<T>,
	defer: <T>(resolver: (resolve: (T | Promise<T>) -> (), reject: (any) -> ()) -> ()) -> Promise<T>,
	resolve: <T>(value: T | Promise<T>) -> Promise<T>,
	reject: (value: any) -> Promise<never>,
	try: <T, A...>(callback: ((A...) -> T), A...) -> Promise<T>,
	all: <T>(promises: { Promise<T> }) -> Promise<{ T }>,
	fold: <T, U>(
		promises: { T | Promise<T> },
		reducer: (U, T, number) -> (U | Promise<U>),
		initialValue: U
	) -> Promise<U>,
	some: <T>(promises: { Promise<T> }, count: number) -> Promise<{ T }>,
	any: <T>(promises: { Promise<T> }) -> Promise<T>,
	allSettled: (promises: { Promise<any> }) -> Promise<{ PromiseStatus }>,
	race: <T>(promises: { Promise<T> }) -> Promise<T>,
	each: <T, U>(list: { T | Promise<T> }, predicate: (T, number) -> (U | Promise<U>)) -> Promise<{ U }>,
	is: (value: any) -> boolean,
	promisify: <R, A...>(fn: (A...) -> R) -> (A...) -> Promise<R>,
	delay: (seconds: number) -> Promise<number>,
}

-- React
export type Object = {}

export type PropsWithChildren = {
	children: Dictionary<string | number, any>?,
}

export type Binding<T> = {
	getValue: (self: Binding<T>) -> T,
	map: <U>(self: Binding<T>, transform: (value: T) -> U) -> any,
}

export type SetBinding<T> = (value: T) -> ()

-- Rodux
type RoduxAction = {
	type: string,
}

type RoduxChangedSignal<S = {}> = {
	connect: (
		self: RoduxChangedSignal<S>,
		listener: (newState: S, oldState: S) -> ()
	) -> {
		disconnect: () -> (),
	},
}

export type RoduxStore<S = {}, A = RoduxAction> = {
	changed: RoduxChangedSignal<S>,
	dispatch: (self: RoduxStore<S, A>, action: A) -> A,
	getState: (self: RoduxStore<S, A>) -> S,
	destruct: (self: RoduxStore<S, A>) -> (),
	flush: (self: RoduxStore<S, A>) -> (),
}
