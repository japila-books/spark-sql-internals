# HashedRelationBroadcastMode

`HashedRelationBroadcastMode` is a [BroadcastMode](BroadcastMode.md).

## Creating Instance

`HashedRelationBroadcastMode` takes the following to be created:

* <span id="key"> Key [Expression](../expressions/Expression.md)s
* <span id="isNullAware"> `isNullAware` flag (default: `false`)

`HashedRelationBroadcastMode` is created when:

* `PlanAdaptiveDynamicPruningFilters` physical optimization is [executed](../physical-optimizations/PlanAdaptiveDynamicPruningFilters.md) (to optimize query plans with [DynamicPruningExpression](../expressions/DynamicPruningExpression.md))
* `PlanDynamicPruningFilters` physical optimization is requested to [broadcastMode](../physical-optimizations/PlanDynamicPruningFilters.md#broadcastMode)
* `BroadcastHashJoinExec` physical operator is requested for [requiredChildDistribution](BroadcastHashJoinExec.md#requiredChildDistribution)

## <span id="transform"> Transforming InternalRows into HashedRelation

```scala
transform(
  rows: Iterator[InternalRow],
  sizeHint: Option[Long]): HashedRelation
```

`transform` creates a [HashedRelation](HashedRelation.md#apply) with or without `sizeEstimate` based on the given `sizeHint`.

`transform` is part of the [BroadcastMode](BroadcastMode.md#transform) abstraction.
