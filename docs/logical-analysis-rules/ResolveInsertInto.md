# ResolveInsertInto Logical Resolution Rule

`ResolveInsertInto` is a logical resolution rule (`Rule[LogicalPlan]`).

`ResolveInsertInto` is part of [Resolution](../Analyzer.md#Resolution) batch of [Logical Analyzer](../Analyzer.md).

## Creating Instance

`ResolveInsertInto` takes no parameters to be created.

`ResolveInsertInto` is created when `Analyzer` is requested for [batches](../Analyzer.md#batches).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` resolves [InsertIntoStatement](../logical-operators/InsertIntoStatement.md) logical operators with [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) tables to the following operators:

* [AppendData](../logical-operators/AppendData.md)
* [OverwritePartitionsDynamic](../logical-operators/OverwritePartitionsDynamic.md)
* [OverwriteByExpression](../logical-operators/OverwriteByExpression.md)

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
