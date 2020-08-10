# InMemoryScans Execution Planning Strategy

`InMemoryScans` is an spark-sql-SparkStrategy.md[execution planning strategy] that <<apply, plans InMemoryRelation logical operators to InMemoryTableScanExec physical operators>>.

[source, scala]
----
val spark: SparkSession = ...
// query uses InMemoryRelation logical operator
val q = spark.range(5).cache
val plan = q.queryExecution.optimizedPlan
scala> println(plan.numberedTreeString)
00 InMemoryRelation [id#208L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
01    +- *Range (0, 5, step=1, splits=8)

// InMemoryScans is an internal class of SparkStrategies
import spark.sessionState.planner.InMemoryScans
val physicalPlan = InMemoryScans.apply(plan).head
scala> println(physicalPlan.numberedTreeString)
00 InMemoryTableScan [id#208L]
01    +- InMemoryRelation [id#208L], true, 10000, StorageLevel(disk, memory, deserialized, 1 replicas)
02          +- *Range (0, 5, step=1, splits=8)
----

`InMemoryScans` is part of the [standard execution planning strategies](../SparkPlanner.md#strategies) of [SparkPlanner](../SparkPlanner.md).

=== [[apply]] Applying InMemoryScans Strategy to Logical Plan (Executing InMemoryScans) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): Seq[SparkPlan]
----

NOTE: `apply` is part of catalyst/GenericStrategy.md#apply[GenericStrategy Contract] to generate a collection of SparkPlan.md[SparkPlans] for a given spark-sql-LogicalPlan.md[logical plan].

`apply` spark-sql-PhysicalOperation.md#unapply[destructures the input logical plan] to a spark-sql-LogicalPlan-InMemoryRelation.md[InMemoryRelation] logical operator.

In the end, `apply` [pruneFilterProject](../SparkPlanner.md#pruneFilterProject) with a new spark-sql-SparkPlan-InMemoryTableScanExec.md#creating-instance[InMemoryTableScanExec] physical operator.
