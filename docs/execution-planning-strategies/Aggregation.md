# Aggregation Execution Planning Strategy

`Aggregation` is an [execution planning strategy](SparkStrategy.md) that [SparkPlanner](../SparkPlanner.md) uses for [planning Aggregate logical operators](#apply) (in the order of preference):

1. [HashAggregateExec](../physical-operators/HashAggregateExec.md)
1. [ObjectHashAggregateExec](../physical-operators/ObjectHashAggregateExec.md)
1. [SortAggregateExec](../physical-operators/SortAggregateExec.md)

## Executing Rule { #apply }

??? note "GenericStrategy"

    ```scala
    apply(
      plan: LogicalPlan): Seq[SparkPlan]
    ```

    `apply` is part of the [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.

`apply` plans [Aggregate](../logical-operators/Aggregate.md) logical operators with the [aggregate expressions](../logical-operators/Aggregate.md#aggregateExpressions) all being of the same type, either [AggregateExpression](#apply-AggregateExpressions)s or [PythonUDF](#apply-PythonUDFs)s (with `SQL_GROUPED_AGG_PANDAS_UDF` eval type).

??? note "AnalysisException"
    `apply` throws an `AnalysisException` for mis-placed `PythonUDF`s:

    ```text
    Cannot use a mixture of aggregate function and group aggregate pandas UDF
    ```

`apply` [destructures the Aggregate logical operator](../aggregations/PhysicalAggregation.md#unapply) (into a four-element tuple) with the following:

* Grouping Expressions
* Aggregration Expressions
* Result Expressions
* Child Logical Operator

### AggregateExpressions { #apply-AggregateExpressions }

For [Aggregate](../logical-operators/Aggregate.md) logical operators with [AggregateExpression](../expressions/AggregateExpression.md)s, `apply` splits them based on the [isDistinct](../expressions/AggregateExpression.md#isDistinct) flag.

Without distinct aggregate functions (expressions), `apply` [planAggregateWithoutDistinct](../aggregations/AggUtils.md#planAggregateWithoutDistinct). Otherwise, `apply` [planAggregateWithOneDistinct](../aggregations/AggUtils.md#planAggregateWithOneDistinct).

In the end, `apply` creates one of the following physical operators based on whether [there is distinct aggregate function](../aggregations/AggUtils.md#planAggregateWithOneDistinct) or [not](../aggregations/AggUtils.md#planAggregateWithoutDistinct).

!!! note
    It is assumed that all the distinct aggregate functions have the same column expressions.

    ```text
    COUNT(DISTINCT foo), MAX(DISTINCT foo)
    ```

    The following is not valid due to different column expressions

    ```text
    COUNT(DISTINCT bar), COUNT(DISTINCT foo)
    ```

### PythonUDFs { #apply-PythonUDFs }

For [Aggregate](../logical-operators/Aggregate.md) logical operators with [PythonUDF](../expressions/PythonUDF.md)s, `apply`...FIXME

## Demo

A structured query with `count` aggregate function.

```scala
val q = spark
  .range(5)
  .groupBy($"id" % 2 as "group")
  .agg(count("id") as "count")
val plan = q.queryExecution.optimizedPlan
```

=== "Scala"

    ```scala
    println(plan.numberedTreeString)
    ```

```text
00 Aggregate [_groupingexpression#9L], [_groupingexpression#9L AS group#2L, count(1) AS count#6L]
01 +- Project [(id#0L % 2) AS _groupingexpression#9L]
02    +- Range (0, 5, step=1, splits=Some(12))
```

```scala
import spark.sessionState.planner.Aggregation
val physicalPlan = Aggregation.apply(plan)
```

=== "Scala"

    ```scala
    println(physicalPlan.head.numberedTreeString)
    ```

```text
// HashAggregateExec selected
00 HashAggregate(keys=[_groupingexpression#9L], functions=[count(1)], output=[group#2L, count#6L])
01 +- HashAggregate(keys=[_groupingexpression#9L], functions=[partial_count(1)], output=[_groupingexpression#9L, count#11L])
02    +- PlanLater Project [(id#0L % 2) AS _groupingexpression#9L]
```
