# EliminateSubqueryAliases Logical Optimization

`EliminateSubqueryAliases` is a [base logical optimization](../Optimizer.md#batches) that <<apply, removes (eliminates) SubqueryAlias logical operators from a logical query plan>>.

`EliminateSubqueryAliases` is part of the [Finish Analysis](../Optimizer.md#Finish_Analysis) once-executed batch in the standard batches of the [Logical Optimizer](../Optimizer.md).

`EliminateSubqueryAliases` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// Using Catalyst DSL
import org.apache.spark.sql.catalyst.dsl.plans._
val t1 = table("t1")
val logicalPlan = t1.subquery('a)

import org.apache.spark.sql.catalyst.analysis.EliminateSubqueryAliases
val afterEliminateSubqueryAliases = EliminateSubqueryAliases(logicalPlan)
scala> println(afterEliminateSubqueryAliases.numberedTreeString)
00 'UnresolvedRelation `t1`
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply` simply removes (eliminates) <<spark-sql-LogicalPlan-SubqueryAlias.md#, SubqueryAlias>> unary logical operators from the input <<spark-sql-LogicalPlan.md#, logical plan>>.

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
