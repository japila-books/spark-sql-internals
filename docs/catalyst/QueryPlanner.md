# QueryPlanner

`QueryPlanner` <<plan, plans a logical plan for execution>>, i.e. converts a spark-sql-LogicalPlan.md[logical plan] to one or more SparkPlan.md[physical plans] using <<strategies, strategies>>.

NOTE: `QueryPlanner` <<plan, generates>> at least one physical plan.

``QueryPlanner``'s main method is <<plan, plan>> that defines the extension points, i.e. <<strategies, strategies>>, <<collectPlaceholders, collectPlaceholders>> and <<prunePlans, prunePlans>>.

`QueryPlanner` is part of [Catalyst Framework](index.md).

=== [[contract]] QueryPlanner Contract

[source, scala]
----
abstract class QueryPlanner[PhysicalPlan <: TreeNode[PhysicalPlan]] {
  def collectPlaceholders(plan: PhysicalPlan): Seq[(PhysicalPlan, LogicalPlan)]
  def prunePlans(plans: Iterator[PhysicalPlan]): Iterator[PhysicalPlan]
  def strategies: Seq[GenericStrategy[PhysicalPlan]]
}
----

.QueryPlanner Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| [[strategies]] `strategies`
| [GenericStrategy](GenericStrategy.md) planning strategies

Used exclusively as an extension point in <<plan, plan>>.

| [[collectPlaceholders]] `collectPlaceholders`
| Collection of "placeholder" physical plans and the corresponding spark-sql-LogicalPlan.md[logical plans].

Used exclusively as an extension point in <<plan, plan>>.

Overriden in [SparkPlanner](../SparkPlanner.md#collectPlaceholders)

| [[prunePlans]] `prunePlans`
| Prunes physical plans (e.g. bad or somehow incorrect plans).

Used exclusively as an extension point in <<plan, plan>>.
|===

=== [[plan]] Planning Logical Plan -- `plan` Method

[source, scala]
----
plan(plan: LogicalPlan): Iterator[PhysicalPlan]
----

`plan` converts the input `plan` spark-sql-LogicalPlan.md[logical plan] to zero or more `PhysicalPlan` plans.

Internally, `plan` applies <<strategies, planning strategies>> to the input `plan` (one by one collecting all as the plan candidates).

`plan` then walks over the plan candidates to <<collectPlaceholders, collect placeholders>>.

If a plan does not contain a placeholder, the plan is returned as is. Otherwise, `plan` walks over placeholders (as pairs of `PhysicalPlan` and unplanned spark-sql-LogicalPlan.md[logical plan]) and (recursively) <<plan, plans>> the child logical plan. `plan` then replaces the placeholders with the planned child logical plan.

In the end, `plan` <<prunePlans, prunes "bad" physical plans>>.

NOTE: `plan` is used exclusively (through the concrete [SparkPlanner](../SparkPlanner.md)) when a `QueryExecution` [is requested for a physical plan](../QueryExecution.md#sparkPlan).
