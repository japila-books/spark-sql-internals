# EliminateView Logical Optimization

`EliminateView` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, removes (eliminates) View logical operators from a logical query plan>>.

`EliminateView` is part of the [Finish Analysis](../catalyst/Optimizer.md#Finish_Analysis) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`EliminateView` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
val name = "demo_view"
sql(s"CREATE OR REPLACE VIEW $name COMMENT 'demo view' AS VALUES 1,2")
assert(spark.catalog.tableExists(name))

val q = spark.table(name)

val analyzedPlan = q.queryExecution.analyzed
scala> println(analyzedPlan.numberedTreeString)
00 SubqueryAlias demo_view
01 +- View (`default`.`demo_view`, [col1#37])
02    +- Project [cast(col1#38 as int) AS col1#37]
03       +- LocalRelation [col1#38]

import org.apache.spark.sql.catalyst.analysis.EliminateView
val afterEliminateView = EliminateView(analyzedPlan)
// Notice no View operator
scala> println(afterEliminateView.numberedTreeString)
00 SubqueryAlias demo_view
01 +- Project [cast(col1#38 as int) AS col1#37]
02    +- LocalRelation [col1#38]

// TIP: You may also want to use EliminateSubqueryAliases to eliminate SubqueryAliases
----

## <span id="apply"> Executing Rule

```scala
apply(
  plan: LogicalPlan): LogicalPlan
```

`apply` simply removes (eliminates) <<View.md#, View>> unary logical operators from the input <<spark-sql-LogicalPlan.md#, logical plan>> and replaces them with their <<View.md#child, child>> logical operator.

`apply` throws an `AssertionError` when the <<View.md#output, output schema>> of the `View` operator does not match the <<catalyst/QueryPlan.md#output, output schema>> of the <<View.md#child, child>> logical operator.

```text
assertion failed: The output of the child [output] is different from the view output [output]
```

NOTE: The assertion should not really happen since [AliasViewChild](../logical-analysis-rules/AliasViewChild.md) logical analysis rule is executed earlier and takes care of not allowing for such difference in the output schema (by throwing an `AnalysisException` earlier).

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
