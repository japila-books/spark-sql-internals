# CombineTypedFilters Logical Optimization

`CombineTypedFilters` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, combines two back to back (typed) filters into one>> that ultimately ends up as a single method call.

`CombineTypedFilters` is part of the [Object Expressions Optimization](../catalyst/Optimizer.md#Object_Expressions_Optimization) fixed-point batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`CombineTypedFilters` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

// A query with two consecutive typed filters
val q = spark.range(10).filter(_ % 2 == 0).filter(_ == 0)
scala> q.queryExecution.optimizedPlan
...
TRACE SparkOptimizer:
=== Applying Rule org.apache.spark.sql.catalyst.optimizer.CombineTypedFilters ===
 TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)      TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)
!+- TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)   +- Range (0, 10, step=1, splits=Some(8))
!   +- Range (0, 10, step=1, splits=Some(8))

TRACE SparkOptimizer: Fixed point reached for batch Typed Filter Optimization after 2 iterations.
DEBUG SparkOptimizer:
=== Result of Batch Typed Filter Optimization ===
 TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)      TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)
!+- TypedFilter <function1>, class java.lang.Long, [StructField(value,LongType,true)], newInstance(class java.lang.Long)   +- Range (0, 10, step=1, splits=Some(8))
!   +- Range (0, 10, step=1, splits=Some(8))
...
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
