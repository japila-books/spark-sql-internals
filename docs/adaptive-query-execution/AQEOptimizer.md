# AQEOptimizer &mdash; AQE Logical Optimizer

`AQEOptimizer` is the logical optimizer for [optimizing logical plans](../physical-operators/AdaptiveSparkPlanExec.md#reOptimize) in [Adaptive Query Execution](index.md).

<figure markdown>
  ![AQEOptimizer](../images/AQEOptimizer.png)
</figure>

`AQEOptimizer` is used in [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md#optimizer) physical operator.

`AQEOptimizer` uses [spark.sql.adaptive.optimizer.excludedRules](../configuration-properties.md#spark.sql.adaptive.optimizer.excludedRules) configuration property to exclude logical optimizations from the [batches](#batches) of logical optimization rules.

`AQEOptimizer` is a Catalyst [RuleExecutor](../catalyst/RuleExecutor.md) of the logical (optimization) rules (`RuleExecutor[LogicalPlan]`).

## Creating Instance

`AQEOptimizer` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`AQEOptimizer` is created alongside [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md#optimizer) physical operator.

## <span id="defaultBatches"> Default Batches

```scala
defaultBatches: Seq[Batch]
```

`AQEOptimizer` creates a collection of batches with logical optimizations (in the order of their execution):

1. [Propagate Empty Relations](#propagate-empty-relations)
1. [Dynamic Join Selection](#dynamic-join-selection)
1. [Eliminate Limits](#eliminate-limits)
1. [Optimize One Row Plan](#optimize-one-row-plan)

`defaultBatches` is used as the [batches](#batches).

### Dynamic Join Selection

**Dynamic Join Selection** is a [once-executed](../catalyst/RuleExecutor.md#Once) batch of the following rules:

* [DynamicJoinSelection](../logical-optimizations/DynamicJoinSelection.md)

### Eliminate Limits

**Eliminate Limits** is a [fixed-point](#fixedPoint) batch of the following rules:

* `EliminateLimits`

### Optimize One Row Plan

**Optimize One Row Plan** is a [fixed-point](#fixedPoint) batch of the following rules:

* `OptimizeOneRowPlan`

### Propagate Empty Relations

**Propagate Empty Relations** is a [fixed-point](#fixedPoint) batch of the following rules:

* [AQEPropagateEmptyRelation](../logical-optimizations/AQEPropagateEmptyRelation.md)
* [ConvertToLocalRelation](../logical-optimizations/ConvertToLocalRelation.md)
* [UpdateAttributeNullability](../logical-optimizations/UpdateAttributeNullability.md)

## <span id="fixedPoint"> Creating FixedPoint Batch Execution Strategy

```scala
fixedPoint: FixedPoint
```

`fixedPoint` creates a `FixedPoint` batch execution strategy with the following:

Attribute | Value
----------|-------
maxIterations | [spark.sql.optimizer.maxIterations](../configuration-properties.md#spark.sql.optimizer.maxIterations)
maxIterationsSetting | `spark.sql.optimizer.maxIterations`

## <span id="batches"> Batches

```scala
batches: Seq[Batch]
```

`batches` is part of the [RuleExecutor](../catalyst/RuleExecutor.md#batches) abstraction.

---

`batches` returns the [default rules](#defaultBatches) excluding the ones specified in the [spark.sql.adaptive.optimizer.excludedRules](../configuration-properties.md#spark.sql.adaptive.optimizer.excludedRules) configuration property.

For excluded rules, `batches` prints out the following INFO message to the logs:

```text
Optimization rule '[ruleName]' is excluded from the optimizer.
```

For batches with all rules excluded, `batches` prints out the following INFO message to the logs:

```text
Optimization batch '[name]' is excluded from the optimizer as all enclosed rules have been excluded.
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.AQEOptimizer` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.AQEOptimizer=ALL
```

Refer to [Logging](../spark-logging.md).
