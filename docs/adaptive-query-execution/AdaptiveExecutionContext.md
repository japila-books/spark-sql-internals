# AdaptiveExecutionContext

`AdaptiveExecutionContext` is the execution context to share the following between the main query and all subqueries:

* [SparkSession](#session)
* [QueryExecution](#qe)
* [Subquery Cache](#subqueryCache)
* [Stage Cache](#stageCache)

## Creating Instance

`AdaptiveExecutionContext` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)
* <span id="qe"> [QueryExecution](../QueryExecution.md)

`AdaptiveExecutionContext` is created when:

* `QueryExecution` is requested for the [physical preparations rules](../QueryExecution.md#preparations) (and creates an [InsertAdaptiveSparkPlan](../physical-optimizations/InsertAdaptiveSparkPlan.md#adaptiveExecutionContext))

## <span id="subqueryCache"> Subquery Cache

```scala
subqueryCache: TrieMap[SparkPlan, BaseSubqueryExec]
```

`AdaptiveExecutionContext` creates a `TrieMap` ([Scala]({{ scala.api }}/scala/collection/concurrent/TrieMap.html)) of [SparkPlan](../physical-operators/SparkPlan.md)s (canonicalized [ExecSubqueryExpression](../expressions/ExecSubqueryExpression.md)s to be precise) and associated [BaseSubqueryExec](../physical-operators/BaseSubqueryExec.md)s.

---

`subqueryCache` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested for the [adaptive optimizations](../physical-operators/AdaptiveSparkPlanExec.md#queryStageOptimizerRules) (and creates a [ReuseAdaptiveSubquery](../physical-optimizations/ReuseAdaptiveSubquery.md#reuseMap))

## <span id="stageCache"> Stage Cache

```scala
stageCache: TrieMap[SparkPlan, QueryStageExec]
```

`AdaptiveExecutionContext` creates a `TrieMap` ([Scala]({{ scala.api }}/scala/collection/concurrent/TrieMap.html)) of [SparkPlan](../physical-operators/SparkPlan.md)s (canonicalized [Exchange](../physical-operators/Exchange.md)s to be precise) and associated [QueryStageExec](../physical-operators/QueryStageExec.md)s.

---

`stageCache` is used when:

* `AdaptiveSparkPlanExec` physical operator is requested to [createQueryStages](../physical-operators/AdaptiveSparkPlanExec.md#createQueryStages)
