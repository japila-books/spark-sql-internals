# PlanChangeLogger

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

## <span id="logRule"> logRule

```scala
logRule(
  ruleName: String,
  oldPlan: TreeType,
  newPlan: TreeType): Unit
```

`logRule`...FIXME

`logRule` is used when:

* `RuleExecutor` is requested to [execute](RuleExecutor.md#execute)
* `QueryExecution` is requested to [prepare for execution](../QueryExecution.md#prepareForExecution)
* `AdaptiveSparkPlanExec` physical operator is requested to [applyPhysicalRules](../adaptive-query-execution/AdaptiveSparkPlanExec.md#applyPhysicalRules)

## <span id="logBatch"> logBatch

```scala
logBatch(
  batchName: String,
  oldPlan: TreeType,
  newPlan: TreeType): Unit
```

`logBatch`...FIXME

`logBatch` is used when:

* `RuleExecutor` is requested to [execute](RuleExecutor.md#execute)
* `QueryExecution` is requested to [prepare for execution](../QueryExecution.md#prepareForExecution)
* `AdaptiveSparkPlanExec` physical operator is requested to [applyPhysicalRules](../adaptive-query-execution/AdaptiveSparkPlanExec.md#applyPhysicalRules)

## <span id="logMetrics"> logMetrics

```scala
logMetrics(
  metrics: QueryExecutionMetrics): Unit
```

`logMetrics`...FIXME

`logMetrics` is used when:

* `RuleExecutor` is requested to [execute](RuleExecutor.md#execute)

## <span id="logBasedOnLevel"><span id="logLevel"> logBasedOnLevel

```scala
logBasedOnLevel(
  f: => String): Unit
```

`logBasedOnLevel` uses the [spark.sql.planChangeLog.level](../configuration-properties.md#spark.sql.planChangeLog.level) configuration property for the log level and prints out the given `f` message to the logs.
