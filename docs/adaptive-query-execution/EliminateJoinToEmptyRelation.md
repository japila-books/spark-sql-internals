# EliminateJoinToEmptyRelation Logical Optimization

`EliminateJoinToEmptyRelation` is a logical optimization in [Adaptive Query Execution](index.md).

`EliminateJoinToEmptyRelation` is a [Catalyst rule](../catalyst/Rule.md) for transforming [logical plans](../logical-operators/LogicalPlan.md) (`Rule[LogicalPlan]`).

## Creating Instance

`EliminateJoinToEmptyRelation` takes no arguments to be created.

`EliminateJoinToEmptyRelation` is created when:

* `AQEOptimizer` is requested for the [batches](AQEOptimizer.md#batches)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` transforms [Join](../logical-operators/Join.md) logical operators (`LeftAnti`, `Inner` and `LeftSemi`) to empty [LocalRelation](../logical-operators/LocalRelation.md) leaf logical operators.

### <span id="canEliminate"> canEliminate

```scala
canEliminate(
  plan: LogicalPlan,
  relation: HashedRelation): Boolean
```

`canEliminate` is `true` when the input [LogicalPlan](../logical-operators/LogicalPlan.md) is a [LogicalQueryStage](LogicalQueryStage.md) with a materialized [BroadcastQueryStageExec](BroadcastQueryStageExec.md) with the [result](QueryStageExec.md#resultOption) being the input [HashedRelation](../physical-operators/HashedRelation.md).
