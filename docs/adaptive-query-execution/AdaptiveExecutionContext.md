# AdaptiveExecutionContext

## Creating Instance

`AdaptiveExecutionContext` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)
* <span id="qe"> [QueryExecution](../QueryExecution.md)

`AdaptiveExecutionContext` is created when:

* `QueryExecution` is requested for the [physical preparations rules](../QueryExecution.md#preparations) (and creates a [InsertAdaptiveSparkPlan](InsertAdaptiveSparkPlan.md))

## <span id="subqueryCache"> Subquery Cache

```scala
subqueryCache: TrieMap[SparkPlan, BaseSubqueryExec]
```

`subqueryCache`...FIXME

`subqueryCache` is used when:

* `AdaptiveSparkPlanExec` leaf physical operator is requested for the [adaptive optimizations](AdaptiveSparkPlanExec.md#queryStageOptimizerRules) (and creates a [ReuseAdaptiveSubquery](ReuseAdaptiveSubquery.md))
