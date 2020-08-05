# InferFiltersFromConstraints Logical Optimization Rule

`InferFiltersFromConstraints` is a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans] (i.e. `Rule[LogicalPlan]`).

[[apply]]
When catalyst/Rule.md#apply[executed], `InferFiltersFromConstraints` simply <<inferFilters, inferFilters>> when spark-sql-properties.md#spark.sql.constraintPropagation.enabled[spark.sql.constraintPropagation.enabled] configuration property is enabled (`true`).

`InferFiltersFromConstraints` is a part of the [Infer Filters](../catalyst/Optimizer.md#Infer-Filters) once-executed rule batch of the base [Logical Optimizer](../catalyst/Optimizer.md).

=== [[inferFilters]] `inferFilters` Internal Method

[source, scala]
----
inferFilters(
  plan: LogicalPlan): LogicalPlan
----

`inferFilters` supports <<inferFilters-Filter, Filter>> and <<inferFilters-Join, Join>> logical operators.

[[inferFilters-Filter]]
For spark-sql-LogicalPlan-Filter.md[Filter] logical operators, `inferFilters`...FIXME

[[inferFilters-Join]]
For spark-sql-LogicalPlan-Join.md[Join] logical operators, `inferFilters` branches off per the join type:

* For InnerLike and LeftSemi...FIXME

* For RightOuter...FIXME

* For LeftOuter and LeftAnti, `inferFilters` <<getAllConstraints, getAllConstraints>> and then replaces the right join operator with <<inferNewFilter, inferNewFilter>>

NOTE: `inferFilters` is used when `InferFiltersFromConstraints` is <<apply, executed>>.

=== [[getAllConstraints]] `getAllConstraints` Internal Method

[source, scala]
----
getAllConstraints(
  left: LogicalPlan,
  right: LogicalPlan,
  conditionOpt: Option[Expression]): Set[Expression]
----

`getAllConstraints`...FIXME

NOTE: `getAllConstraints` is used when...FIXME

=== [[inferNewFilter]] Adding Filter -- `inferNewFilter` Internal Method

[source, scala]
----
inferNewFilter(
  plan: LogicalPlan,
  constraints: Set[Expression]): LogicalPlan
----

`inferNewFilter`...FIXME

NOTE: `inferNewFilter` is used when...FIXME
