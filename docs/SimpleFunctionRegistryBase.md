# SimpleFunctionRegistryBase

`SimpleFunctionRegistryBase[T]` is an extension of the [FunctionRegistryBase](FunctionRegistryBase.md) abstraction for [function registries](#implementations) (of type `T`).

## Implementations

* [SimpleFunctionRegistry](SimpleFunctionRegistry.md) (for scalar functions using [Expression](expressions/Expression.md)s)
* [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md) (for table-valued functions using [LogicalPlan](logical-operators/LogicalPlan.md)s)

## <span id="functionBuilders"> functionBuilders

```scala
functionBuilders: HashMap[FunctionIdentifier, (ExpressionInfo, FunctionBuilder)]
```

`SimpleFunctionRegistryBase` defines `functionBuilders` registry of named user-defined functions.

A new user-defined function is registered in [internalRegisterFunction](#internalRegisterFunction).

`functionBuilders` is used when:

* [lookupFunction](#lookupFunction)
* [listFunction](#listFunction)
* [lookupFunctionBuilder](#lookupFunctionBuilder)
* [dropFunction](#dropFunction)
* [clear](#clear)
* [clone](#clone)

## <span id="lookupFunction"> lookupFunction

```scala
lookupFunction(
  name: FunctionIdentifier): Option[ExpressionInfo]
```

`lookupFunction` is part of the [FunctionRegistryBase](FunctionRegistryBase.md#lookupFunction) abstraction.

---

`lookupFunction` finds the given `name` in the [functionBuilders](#functionBuilders) registry.

## <span id="registerFunction"> Registering Named User-Defined Function

```scala
registerFunction(
  name: FunctionIdentifier,
  info: ExpressionInfo,
  builder: FunctionBuilder): Unit
```

`registerFunction` is part of the [FunctionRegistryBase](FunctionRegistryBase.md#registerFunction) abstraction.

---

`registerFunction` [internalRegisterFunction](#internalRegisterFunction) with a normalized (lower-case) name.

## <span id="internalRegisterFunction"> internalRegisterFunction

```scala
internalRegisterFunction(
  name: FunctionIdentifier,
  info: ExpressionInfo,
  builder: FunctionBuilder): Unit
```

`internalRegisterFunction` adds a new function to the [functionBuilders](#functionBuilders) registry.

---

`internalRegisterFunction` is used when;

* `SimpleFunctionRegistryBase` is requested to [registerFunction](#registerFunction)
* `FunctionRegistry` utility is used to [create a SimpleFunctionRegistry with built-in functions](FunctionRegistry.md#builtin)
* `TableFunctionRegistry` utility is used to [create a SimpleTableFunctionRegistry with built-in functions](TableFunctionRegistry.md#builtin)
