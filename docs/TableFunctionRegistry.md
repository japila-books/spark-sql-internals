# TableFunctionRegistry

`TableFunctionRegistry` is an extension of the [FunctionRegistryBase](FunctionRegistryBase.md) abstraction for [function registries](#implementations) that manage table-valued functions (_table functions_) that produce a [LogicalPlan](logical-operators/LogicalPlan.md).

## Implementations

* `EmptyTableFunctionRegistry`
* [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md)

## <span id="logicalPlans"> Built-In Table-Valued Functions

Name | Logical Operator | Generator Expression
-----|------------------|---------------------
 `range` | `Range` |
 `explode` | | `Explode`
 `explode_outer` | | `Explode`
 `inline` | | [Inline](expressions/Inline.md)
 `inline_outer` | | [Inline](expressions/Inline.md)
 `json_tuple` | | `JsonTuple`
 `posexplode` | | `PosExplode`
 `posexplode_outer` | | `PosExplode`
 `stack` | | `Stack`

## <span id="builtin"> SimpleTableFunctionRegistry

```scala
builtin: SimpleTableFunctionRegistry
```

`TableFunctionRegistry` creates a system-wide [SimpleTableFunctionRegistry](SimpleTableFunctionRegistry.md) and [registers](SimpleFunctionRegistryBase.md#internalRegisterFunction) all the [built-in table-valued functions](#logicalPlans).

```scala
import org.apache.spark.sql.catalyst.analysis.TableFunctionRegistry
import org.apache.spark.sql.catalyst.analysis.SimpleTableFunctionRegistry
assert(TableFunctionRegistry.builtin.isInstanceOf[SimpleTableFunctionRegistry])
```

```scala
import org.apache.spark.sql.catalyst.analysis.TableFunctionRegistry
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
