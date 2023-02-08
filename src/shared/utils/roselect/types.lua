export type EqualityFn = (any, any) -> boolean

export type CreateSelectorFunction = <Result, Input, Argument...>(
	dependencies: { (Argument...) -> Input },
	resultFunc: (...Input) -> Result
) -> ((Argument...) -> Result)

export type Function = (...any) -> unknown

return nil
