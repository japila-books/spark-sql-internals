# FunctionRegistryBase

`FunctionRegistryBase[T]` is an [abstraction](#contract) of [function registries](#implementations) for [registering functions](#registerFunction) (that produce results of type `T`).

## Contract

### <span id="registerFunction"> Registering Named Function

```scala
registerFunction(
  name: FunctionIdentifier,
  info: ExpressionInfo,
  builder: Seq[Expression] => T): Unit
```

Used when:

* `SessionCatalog` is requested to [register a catalog function](SessionCatalog.md#registerFunction) and [reset](SessionCatalog.md#reset)
* `SparkSessionExtensions` is requested to [registerFunctions](SparkSessionExtensions.md#registerFunctions) and [registerTableFunctions](SparkSessionExtensions.md#registerTableFunctions)

## Implementations

* `EmptyFunctionRegistryBase`
* [FunctionRegistry](FunctionRegistry.md)
* [SimpleFunctionRegistryBase](SimpleFunctionRegistryBase.md)
* [TableFunctionRegistry](TableFunctionRegistry.md)

## <span id="createOrReplaceTempFunction"> createOrReplaceTempFunction

```scala
createOrReplaceTempFunction(
  name: String,
  builder: FunctionBuilder,
  source: String): Unit
```

`createOrReplaceTempFunction` [registers a named function](#registerFunction) with a `FunctionIdentifier` for the given name.
