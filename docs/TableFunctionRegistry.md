# TableFunctionRegistry

`TableFunctionRegistry` is an extension of the [FunctionRegistryBase](FunctionRegistryBase.md) abstraction for [function registries](#implementations) that manage table functions (_table-valued functions_) that produce a [LogicalPlan](logical-operators/LogicalPlan.md).

## Implementations

* `EmptyTableFunctionRegistry`
* [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md)

## <span id="builtin"> SimpleTableFunctionRegistry

```scala
builtin: SimpleTableFunctionRegistry
```

`TableFunctionRegistry` creates a system-wide [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md) and [registers](SimpleFunctionRegistryBase.md#internalRegisterFunction) all the [built-in function expressions](#logicalPlans).

```scala
import org.apache.spark.sql.catalyst.analysis.TableFunctionRegistry
import org.apache.spark.sql.catalyst.analysis.SimpleTableFunctionRegistry
assert(TableFunctionRegistry.builtin.isInstanceOf[SimpleTableFunctionRegistry])

TableFunctionRegistry.builtin.listFunction
```

`builtin` is used when:

* `TableFunctionRegistry` utility is used for the [functionSet](#functionSet)
* `SessionCatalog` is requested to [isBuiltinFunction](SessionCatalog.md#isBuiltinFunction), [lookupBuiltinOrTempTableFunction](SessionCatalog.md#lookupBuiltinOrTempTableFunction), [resolveBuiltinOrTempTableFunction](SessionCatalog.md#resolveBuiltinOrTempTableFunction), [reset](SessionCatalog.md#reset)
* `BaseSessionStateBuilder` is requested for the [TableFunctionRegistry](BaseSessionStateBuilder.md#tableFunctionRegistry)

## Accessing TableFunctionRegistry

`TableFunctionRegistry` is available using [BaseSessionStateBuilder.tableFunctionRegistry](BaseSessionStateBuilder.md#tableFunctionRegistry).

## <span id="SessionCatalog"> SessionCatalog

`TableFunctionRegistry` is used to create the following:

* [SessionCatalog](SessionCatalog.md#tableFunctionRegistry)
* [HiveSessionCatalog](hive/HiveSessionCatalog.md#tableFunctionRegistry)
* [SessionState](SessionState.md#tableFunctionRegistry)
