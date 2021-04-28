# AdaptiveExecutionContext

## Creating Instance

`AdaptiveExecutionContext` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)
* <span id="qe"> [QueryExecution](../QueryExecution.md)

`AdaptiveExecutionContext` is created when:

* `QueryExecution` is requested for the [physical preparations rules](../QueryExecution.md#preparations) (and creates a [InsertAdaptiveSparkPlan](InsertAdaptiveSparkPlan.md))
