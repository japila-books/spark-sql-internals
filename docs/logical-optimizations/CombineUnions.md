# CombineUnions Logical Optimization

`CombineUnions` is a [base logical optimization](../catalyst/Optimizer.md#batches) that <<apply, FIXME>>.

`CombineUnions` is part of the [Union](../catalyst/Optimizer.md#Union) once-executed batch in the standard batches of the [Logical Optimizer](../catalyst/Optimizer.md).

`CombineUnions` is simply a <<catalyst/Rule.md#, Catalyst rule>> for transforming <<spark-sql-LogicalPlan.md#, logical plans>>, i.e. `Rule[LogicalPlan]`.

[source, scala]
----
// FIXME Demo
----

## <span id="apply"> Executing Rule

```scala
apply(plan: LogicalPlan): LogicalPlan
```

`apply`...FIXME

`apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.
