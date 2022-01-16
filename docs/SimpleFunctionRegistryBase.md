# SimpleFunctionRegistryBase

`SimpleFunctionRegistryBase` is an extension of the [FunctionRegistryBase](FunctionRegistryBase.md) abstraction for [function registries](#implementations).

## Implementations

* `SimpleFunctionRegistry`
* `SimpleTableFunctionRegistry`

## <span id="registerFunction"> registerFunction

```scala
registerFunction(
  name: FunctionIdentifier,
  info: ExpressionInfo,
  builder: FunctionBuilder): Unit
```

`registerFunction` [internalRegisterFunction](#internalRegisterFunction) with a normalized (lower-case) name.

`registerFunction` is part of the [FunctionRegistryBase](FunctionRegistryBase.md#registerFunction) abstraction.

## <span id="internalRegisterFunction"> internalRegisterFunction

```scala
internalRegisterFunction(
  name: FunctionIdentifier,
  info: ExpressionInfo,
  builder: FunctionBuilder): Unit
```

`internalRegisterFunction` adds a new function to the [functionBuilders](#functionBuilders) registry.

`internalRegisterFunction` is used when;

* `SimpleFunctionRegistryBase` is requested to [registerFunction](#registerFunction)
* `FunctionRegistry` utility is used to [create a SimpleFunctionRegistry with built-in functions](FunctionRegistry.md#builtin)
* `TableFunctionRegistry` utility is used to [create a SimpleTableFunctionRegistry with built-in functions](TableFunctionRegistry.md#builtin)
