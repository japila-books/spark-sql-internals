# CollapseWindow Logical Optimization

`CollapseWindow` is a <<spark-sql-Optimizer.adoc#batches, base logical optimization>> that <<apply, FIXME>>.

`CollapseWindow` is part of the <<spark-sql-Optimizer.adoc#Operator_Optimization, Operator Optimization>> fixed-point batch in the standard batches of the <<spark-sql-Optimizer.adoc#, Catalyst Optimizer>>.

`CollapseWindow` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.adoc#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME: DEMO
import org.apache.spark.sql.catalyst.optimizer.CollapseWindow

val logicalPlan = ???
val afterCollapseWindow = CollapseWindow(logicalPlan)
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
