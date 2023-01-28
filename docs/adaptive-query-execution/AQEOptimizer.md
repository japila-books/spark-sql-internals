# AQEOptimizer &mdash; Adaptive Logical Optimizer

`AQEOptimizer` is a logical optimizer (a [RuleExecutor](../catalyst/RuleExecutor.md) of the logical rules) for re-optimizing logical plans in [Adaptive Query Execution](index.md).

<figure markdown>
  ![AQEOptimizer](../images/AQEOptimizer.png)
</figure>

## Creating Instance

`AQEOptimizer` takes the following to be created:

* <span id="conf"> [SQLConf](../SQLConf.md)

`AQEOptimizer` is created alongside [AdaptiveSparkPlanExec](../physical-operators/AdaptiveSparkPlanExec.md#optimizer) physical operator.

## <span id="defaultBatches"> Default Batches

### Propagate Empty Relations

* [AQEPropagateEmptyRelation](../logical-optimizations/AQEPropagateEmptyRelation.md)
* [ConvertToLocalRelation](../logical-optimizations/ConvertToLocalRelation.md)
* [UpdateAttributeNullability](../logical-optimizations/UpdateAttributeNullability.md)

### Dynamic Join Selection

* [DynamicJoinSelection](../logical-optimizations/DynamicJoinSelection.md)

## <span id="batches"> Batches

```scala
batches: Seq[Batch]
```

`batches` is part of the [RuleExecutor](../catalyst/RuleExecutor.md#batches) abstraction.

`batches` uses the [spark.sql.adaptive.optimizer.excludedRules](../configuration-properties.md#spark.sql.adaptive.optimizer.excludedRules) configuration property for the rules to exclude from the [default rules](#defaultBatches).

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
