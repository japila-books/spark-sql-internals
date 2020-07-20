# CombineUnions Logical Optimization

`CombineUnions` is a <<spark-sql-Optimizer.adoc#batches, base logical optimization>> that <<apply, FIXME>>.

`CombineUnions` is part of the <<spark-sql-Optimizer.adoc#Union, Union>> once-executed batch in the standard batches of the <<spark-sql-Optimizer.adoc#, Catalyst Optimizer>>.

`CombineUnions` is simply a <<spark-sql-catalyst-Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.adoc#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME Demo
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../spark-sql-catalyst-Rule.md#apply) abstraction.
