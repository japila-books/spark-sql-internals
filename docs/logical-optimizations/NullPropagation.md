# NullPropagation Logical Optimization -- Nullability (NULL Value) Propagation

`NullPropagation` is a [base logical optimization](../Optimizer.md#batches) that <<apply, FIXME>>.

`NullPropagation` is part of the [Operator Optimization before Inferring Filters](../Optimizer.md#Operator_Optimization_before_Inferring_Filters) fixed-point batch in the standard batches of the [Logical Optimizer](../Optimizer.md).

`NullPropagation` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

=== [[example-count-with-nullable-expressions-only]] Example: Count Aggregate Operator with Nullable Expressions Only

`NullPropagation` optimization rewrites `Count` [aggregate expressions](../expressions/AggregateExpression.md) that include expressions that are all nullable to `Cast(Literal(0L))`.

```text
val table = (0 to 9).toDF("num").as[Int]

// NullPropagation applied
scala> table.select(countDistinct($"num" === null)).explain(true)
== Parsed Logical Plan ==
'Project [count(distinct ('num = null)) AS count(DISTINCT (num = NULL))#45]
+- Project [value#1 AS num#3]
   +- LocalRelation [value#1]

== Analyzed Logical Plan ==
count(DISTINCT (num = NULL)): bigint
Aggregate [count(distinct (num#3 = cast(null as int))) AS count(DISTINCT (num = NULL))#45L]
+- Project [value#1 AS num#3]
   +- LocalRelation [value#1]

== Optimized Logical Plan ==
Aggregate [0 AS count(DISTINCT (num = NULL))#45L] // <-- HERE
+- LocalRelation

== Physical Plan ==
*HashAggregate(keys=[], functions=[], output=[count(DISTINCT (num = NULL))#45L])
+- Exchange SinglePartition
   +- *HashAggregate(keys=[], functions=[], output=[])
      +- LocalTableScan
```

=== [[example-count-without-nullable-distinct-expressions]] Example: Count Aggregate Operator with Non-Nullable Non-Distinct Expressions

`NullPropagation` optimization rewrites any non-``nullable`` non-distinct `Count` [aggregate expressions](../expressions/AggregateExpression.md) to `Literal(1)`.

```text
val table = (0 to 9).toDF("num").as[Int]

// NullPropagation applied
// current_timestamp() is a non-nullable expression (see the note below)
val query = table.select(count(current_timestamp()) as "count")

scala> println(query.queryExecution.optimizedPlan)
Aggregate [count(1) AS count#64L]
+- LocalRelation

// NullPropagation skipped
val tokens = Seq((0, null), (1, "hello")).toDF("id", "word")
val query = tokens.select(count("word") as "count")

scala> println(query.queryExecution.optimizedPlan)
Aggregate [count(word#55) AS count#71L]
+- LocalRelation [word#55]
```

[NOTE]
====
`Count` aggregate expression represents `count` function internally.

```text
import org.apache.spark.sql.catalyst.expressions.aggregate.Count
import org.apache.spark.sql.functions.count

scala> count("*").expr.children(0).asInstanceOf[Count]
res0: org.apache.spark.sql.catalyst.expressions.aggregate.Count = count(1)
```
====

[NOTE]
====
`current_timestamp()` function is non-``nullable`` expression.

[source, scala]
----
import org.apache.spark.sql.catalyst.expressions.CurrentTimestamp
import org.apache.spark.sql.functions.current_timestamp

scala> current_timestamp().expr.asInstanceOf[CurrentTimestamp].nullable
res38: Boolean = false
----
====

=== [[example]] Example

[source, scala]
----
val table = (0 to 9).toDF("num").as[Int]
val query = table.where('num === null)

scala> query.explain(extended = true)
== Parsed Logical Plan ==
'Filter ('num = null)
+- Project [value#1 AS num#3]
   +- LocalRelation [value#1]

== Analyzed Logical Plan ==
num: int
Filter (num#3 = cast(null as int))
+- Project [value#1 AS num#3]
   +- LocalRelation [value#1]

== Optimized Logical Plan ==
LocalRelation <empty>, [num#3]

== Physical Plan ==
LocalTableScan <empty>, [num#3]
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
