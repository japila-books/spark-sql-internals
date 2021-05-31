# AddMetadataColumns Logical Resolution Rule

`AddMetadataColumns` is a [Rule](../catalyst/Rule.md) to transform [LogicalPlan](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

`AddMetadataColumns` is part of the [Resolution](../Analyzer.md#Resolution) batch of the [Analyzer](../Analyzer.md).

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` [adds metadata columns](#addMetadataCol) to [logical operators](../logical-operators/LogicalPlan.md) (with [metadata columns defined](#hasMetadataCol)).

### <span id="addMetadataCol"> addMetadataCol

```scala
addMetadataCol(
  plan: LogicalPlan): LogicalPlan
```

`addMetadataCol`...FIXME

### <span id="hasMetadataCol"> hasMetadataCol

```scala
hasMetadataCol(
  plan: LogicalPlan): Boolean
```

`hasMetadataCol`...FIXME
