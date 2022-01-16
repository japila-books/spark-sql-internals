# TableFunctionRegistry

`TableFunctionRegistry` is an extension of the [FunctionRegistryBase](FunctionRegistryBase.md) abstraction for [function registries](#implementations) that register functions that produce a [LogicalPlan](logical-operators/LogicalPlan.md).

## Implementations

* `EmptyTableFunctionRegistry`
* [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md)

## <span id="builtin"> Creating SimpleTableFunctionRegistry

```scala
builtin: SimpleTableFunctionRegistry
```

`builtin` creates a new [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md) and [registers](SimpleFunctionRegistryBase.md#internalRegisterFunction) all the [built-in function expressions](#logicalPlans).

`builtin` is used when:

* `TableFunctionRegistry` utility is used for [functionSet](#functionSet)
* `SessionCatalog` is requested to [isTemporaryFunction](SessionCatalog.md#isTemporaryFunction) and [reset](SessionCatalog.md#reset)
* `BaseSessionStateBuilder` is requested for a [TableFunctionRegistry](BaseSessionStateBuilder.md#tableFunctionRegistry)

## Accessing TableFunctionRegistry

`TableFunctionRegistry` is available using [BaseSessionStateBuilder.tableFunctionRegistry](BaseSessionStateBuilder.md#tableFunctionRegistry).

## <span id="SessionCatalog"> SessionCatalog

`TableFunctionRegistry` is used to create the following:

* [SessionCatalog](SessionCatalog.md#tableFunctionRegistry)
* [HiveSessionCatalog](hive/HiveSessionCatalog.md#tableFunctionRegistry)
* [SessionState](SessionState.md#tableFunctionRegistry)
