# Aggregation Execution Planning Strategy

`Aggregation` is an [execution planning strategy](SparkStrategy.md) that [SparkPlanner](../SparkPlanner.md) uses for [planning Aggregate logical operators](#apply) (in the order of preference):

1. [HashAggregateExec](../physical-operators/HashAggregateExec.md)
1. [ObjectHashAggregateExec](../physical-operators/ObjectHashAggregateExec.md)
1. [SortAggregateExec](../physical-operators/SortAggregateExec.md)

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` is part of the [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.

`apply` works with [Aggregate](../logical-operators/Aggregate.md) logical operators with all the aggregate expressions being either [AggregateExpression](#apply-AggregateExpressions)s or [PythonUDF](#apply-PythonUDFs)s only. Otherwise, `apply` throws an [AnalysisException](#apply-AnalysisException).

`apply` [destructures the Aggregate logical operator](../PhysicalAggregation.md#unapply) (into a four-element tuple) with the following:

* Grouping Expressions
* Aggregration Expressions
* Result Expressions
* Child Logical Operator

### <span id="apply-AggregateExpressions"> AggregateExpressions

For [Aggregate](../logical-operators/Aggregate.md) logical operators with [AggregateExpression](../expressions/AggregateExpression.md)s, `apply` splits them based on the [isDistinct](../expressions/AggregateExpression.md#isDistinct) flag.

Without distinct aggregate functions (expressions), `apply` [planAggregateWithoutDistinct](../AggUtils.md#planAggregateWithoutDistinct). Otherwise, `apply` [planAggregateWithOneDistinct](../AggUtils.md#planAggregateWithOneDistinct).

In the end, `apply` creates one of the following physical operators based on whether [there is distinct aggregate function](../AggUtils.md#planAggregateWithOneDistinct) or [not](../AggUtils.md#planAggregateWithoutDistinct).

!!! note
    It is assumed that all the distinct aggregate functions have the same column expressions.

    ```text
    COUNT(DISTINCT foo), MAX(DISTINCT foo)
    ```

    The following is not valid due to different column expressions

    ```text
    COUNT(DISTINCT bar), COUNT(DISTINCT foo)
    ```

### <span id="apply-PythonUDFs"> PythonUDFs

For [Aggregate](../logical-operators/Aggregate.md) logical operators with `PythonUDF`s ([PySpark]({{ book.pyspark }}/sql/PythonUDF))...FIXME

### <span id="apply-AnalysisException"> AnalysisException

`apply` can throw an `AnalysisException`:

```text
Cannot use a mixture of aggregate function and group aggregate pandas UDF
```

## Demo

```text
scala> :type spark
org.apache.spark.sql.SparkSession

// structured query with count aggregate function
val q = spark
  .range(5)
  .groupBy($"id" % 2 as "group")
  .agg(count("id") as "count")
val plan = q.queryExecution.optimizedPlan
scala> println(plan.numberedTreeString)
00 Aggregate [(id#0L % 2)], [(id#0L % 2) AS group#3L, count(1) AS count#8L]
01 +- Range (0, 5, step=1, splits=Some(8))

import spark.sessionState.planner.Aggregation
val physicalPlan = Aggregation.apply(plan)

// HashAggregateExec selected
scala> println(physicalPlan.head.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[group#3L, count#8L])
01 +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#14L])
02    +- PlanLater Range (0, 5, step=1, splits=Some(8))
```
