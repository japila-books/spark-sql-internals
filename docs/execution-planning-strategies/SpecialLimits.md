# SpecialLimits Execution Planning Strategy

`SpecialLimits` is an spark-sql-SparkStrategy.md[execution planning strategy] that [Spark Planner](../SparkPlanner.md) uses to <<apply, FIXME>>.

=== [[apply]] Applying SpecialLimits Strategy to Logical Plan (Executing SpecialLimits) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): Seq[SparkPlan]
----

NOTE: `apply` is part of catalyst/GenericStrategy.md#apply[GenericStrategy Contract] to generate a collection of SparkPlan.md[SparkPlans] for a given spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME
