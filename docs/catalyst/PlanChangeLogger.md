# PlanChangeLogger

`PlanChangeLogger` is a logging utility for rule executors to log plan changes (at [rule](#logRule) and [batch](#logBatch) level).

## Creating Instance

`PlanChangeLogger` takes no arguments to be created.

`PlanChangeLogger` is created when:

* `RuleExecutor` is requested to [execute rules](RuleExecutor.md#execute)
* `QueryExecution` is requested to [prepare for execution](../QueryExecution.md#prepareForExecution)
* `AdaptiveSparkPlanExec` physical operator is [created](../adaptive-query-execution/AdaptiveSparkPlanExec.md#planChangeLogger)

## <span id="TreeType"> TreeType

```scala
PlanChangeLogger[TreeType <: TreeNode[_]]
```

`PlanChangeLogger` is a Scala type constructor (_generic class_) with `TreeType` type alias of a subclass of [TreeNode](TreeNode.md).

## <span id="logRule"> Logging Plan Changes by Rule

```scala
logRule(
  ruleName: String,
  oldPlan: TreeType,
  newPlan: TreeType): Unit
```

`logRule` [prints out the following message to the logs](#logBasedOnLevel) when the given `newPlan` and `oldPlan` are different and the `ruleName` is included in the [spark.sql.planChangeLog.rules](../configuration-properties.md#spark.sql.planChangeLog.rules) configuration property.

```text
=== Applying Rule [ruleName] ===
[oldPlan] [newPlan]
```

`logRule` is used when:

* `RuleExecutor` is requested to [execute](RuleExecutor.md#execute)
* `QueryExecution` is requested to [prepare for execution](../QueryExecution.md#prepareForExecution)
* `AdaptiveSparkPlanExec` physical operator is requested to [applyPhysicalRules](../adaptive-query-execution/AdaptiveSparkPlanExec.md#applyPhysicalRules)

## <span id="logBatch"> Logging Plan Changes by Batch

```scala
logBatch(
  batchName: String,
  oldPlan: TreeType,
  newPlan: TreeType): Unit
```

`logBatch` [prints out one of the following messages to the logs](#logBasedOnLevel) when the given `batchName` is included in the [spark.sql.planChangeLog.batches](../configuration-properties.md#spark.sql.planChangeLog.batches) configuration property.

When the given `oldPlan` and `newPlan` are different, `logBatch` prints out the following message:

```text
=== Result of Batch [batchName] ===
[oldPlan] [newPlan]
```

Otherwise, `logBatch` prints out the following message:

```text
Batch [batchName] has no effect.
```

`logBatch` is used when:

* `RuleExecutor` is requested to [execute](RuleExecutor.md#execute)
* `QueryExecution` is requested to [prepare for execution](../QueryExecution.md#prepareForExecution)
* `AdaptiveSparkPlanExec` physical operator is requested to [applyPhysicalRules](../adaptive-query-execution/AdaptiveSparkPlanExec.md#applyPhysicalRules)

## <span id="logMetrics"> Logging Metrics

```scala
logMetrics(
  metrics: QueryExecutionMetrics): Unit
```

`logMetrics` [prints out the following message to the logs](#logBasedOnLevel):

```text
=== Metrics of Executed Rules ===
Total number of runs: [numRuns]
Total time: [totalTime] seconds
Total number of effective runs: [numEffectiveRuns]
Total time of effective runs: [totalTimeEffective] seconds
```

`logMetrics` is used when:

* `RuleExecutor` is requested to [execute](RuleExecutor.md#execute)

## <span id="logBasedOnLevel"><span id="logLevel"> logBasedOnLevel

```scala
logBasedOnLevel(
  f: => String): Unit
```

`logBasedOnLevel` uses the [spark.sql.planChangeLog.level](../configuration-properties.md#spark.sql.planChangeLog.level) configuration property for the log level and prints out the given `f` message to the logs.
