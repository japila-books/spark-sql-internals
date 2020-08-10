# Aggregation Execution Planning Strategy for Aggregate Physical Operators

`Aggregation` is an [execution planning strategy](SparkStrategy.md) that [SparkPlanner](../SparkPlanner.md) uses to <<apply, select aggregate physical operator>> for <<spark-sql-LogicalPlan-Aggregate.md#, Aggregate>> logical operator in a <<spark-sql-LogicalPlan.md#, logical query plan>>.

[source, scala]
----
scala> :type spark
org.apache.spark.sql.SparkSession

// structured query with count aggregate function
val q = spark
  .range(5)
  .groupBy($"id" % 2 as "group")
  .agg(count("id") as "count")
val plan = q.queryExecution.optimizedPlan
scala> println(plan.numberedTreeString)
00 Aggregate [(id#0L % 2)], [(id#0L % 2) AS group#3L, count(1) AS count#8L]
01 +- Range (0, 5, step=1, splits=Some(8))

import spark.sessionState.planner.Aggregation
val physicalPlan = Aggregation.apply(plan)

// HashAggregateExec selected
scala> println(physicalPlan.head.numberedTreeString)
00 HashAggregate(keys=[(id#0L % 2)#12L], functions=[count(1)], output=[group#3L, count#8L])
01 +- HashAggregate(keys=[(id#0L % 2) AS (id#0L % 2)#12L], functions=[partial_count(1)], output=[(id#0L % 2)#12L, count#14L])
02    +- PlanLater Range (0, 5, step=1, splits=Some(8))
----

[[aggregate-physical-operator-preference]]
`Aggregation` <<spark-sql-AggUtils.md#aggregate-physical-operator-selection-criteria, can select>> the following aggregate physical operators (in the order of preference):

. <<spark-sql-SparkPlan-HashAggregateExec.md#, HashAggregateExec>>

. <<spark-sql-SparkPlan-ObjectHashAggregateExec.md#, ObjectHashAggregateExec>>

. <<spark-sql-SparkPlan-SortAggregateExec.md#, SortAggregateExec>>

=== [[apply]] Applying Aggregation Strategy to Logical Plan (Executing Aggregation) -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): Seq[SparkPlan]
----

NOTE: `apply` is part of catalyst/GenericStrategy.md#apply[GenericStrategy Contract] to generate a collection of SparkPlan.md[SparkPlans] for a given spark-sql-LogicalPlan.md[logical plan].

`apply` requests `PhysicalAggregation` extractor for spark-sql-PhysicalAggregation.md#unapply[Aggregate logical operators] and creates a single aggregate physical operator for every spark-sql-LogicalPlan-Aggregate.md[Aggregate] logical operator found.

Internally, `apply` requests `PhysicalAggregation` to spark-sql-PhysicalAggregation.md#unapply[destructure a Aggregate logical operator] (into a four-element tuple) and splits [aggregate expressions](../expressions/AggregateExpression.md) per whether they are distinct or not (using their [isDistinct](../expressions/AggregateExpression.md#isDistinct) flag).

`apply` then creates a physical operator using the following helper methods:

* [AggUtils.planAggregateWithoutDistinct](../spark-sql-AggUtils.md#planAggregateWithoutDistinct) when no distinct aggregate expression is used

* [AggUtils.planAggregateWithOneDistinct](../spark-sql-AggUtils.md#planAggregateWithOneDistinct) when at least one distinct aggregate expression is used.
