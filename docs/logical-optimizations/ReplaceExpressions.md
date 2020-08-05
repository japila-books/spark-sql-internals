# ReplaceExpressions Logical Optimization

`ReplaceExpressions` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, replaces RuntimeReplaceable expressions with their single child expression>>.

`ReplaceExpressions` is part of the [Finish Analysis](../catalyst/Optimizer.md#Finish_Analysis) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`ReplaceExpressions` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
val query = sql("select ifnull(NULL, array('2')) from values 1")
val analyzedPlan = query.queryExecution.analyzed
scala> println(analyzedPlan.numberedTreeString)
00 Project [ifnull(null, array(2)) AS ifnull(NULL, array('2'))#3]
01 +- LocalRelation [col1#2]

import org.apache.spark.sql.catalyst.optimizer.ReplaceExpressions
val optimizedPlan = ReplaceExpressions(analyzedPlan)
scala> println(optimizedPlan.numberedTreeString)
00 Project [coalesce(cast(null as array<string>), cast(array(2) as array<string>)) AS ifnull(NULL, array('2'))#3]
01 +- LocalRelation [col1#2]
----

=== [[apply]] Executing Rule -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

`apply` <<catalyst/QueryPlan.md#transformAllExpressions, traverses all Catalyst expressions>> (in the input <<spark-sql-LogicalPlan.md#, LogicalPlan>>) and replaces a spark-sql-Expression-RuntimeReplaceable.md[RuntimeReplaceable] expression into its single child.

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
