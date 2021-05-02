# AQEOptimizer &mdash; Adaptive Logical Optimizer

`AQEOptimizer` is a logical optimizer (a [RuleExecutor](../catalyst/RuleExecutor.md) of the logical rules) for re-optimizing logical plans in [Adaptive Query Execution](index.md).

## Creating Instance

`AQEOptimizer` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`AQEOptimizer` is created when:

* `AdaptiveSparkPlanExec` physical operator is [created](AdaptiveSparkPlanExec.md#optimizer)

## <span id="defaultBatches"> Default Batches

Batch Name | Strategy | Rules
---------|----------|---------
 Demote BroadcastHashJoin | Once | [DemoteBroadcastHashJoin](DemoteBroadcastHashJoin.md)
 Eliminate Join to Empty Relation | Once | [EliminateJoinToEmptyRelation](EliminateJoinToEmptyRelation.md)

## <span id="batches"> Batches

```scala
batches: Seq[Batch]
```

`batches` is part of the [RuleExecutor](../catalyst/RuleExecutor.md#batches) abstraction.

`batches` uses the [spark.sql.adaptive.optimizer.excludedRules](../configuration-properties.md#spark.sql.adaptive.optimizer.excludedRules) configuration property for the rules to exclude from the [default rules](#defaultBatches).

For excluded rules, `batches` prints out the following INFO message to the logs:

```text
Optimization rule '[ruleName]' is excluded from the optimizer.
```

For batches with all rules excluded, `batches` prints out the following INFO message to the logs:

```text
Optimization batch '[name]' is excluded from the optimizer as all enclosed rules have been excluded.
```
