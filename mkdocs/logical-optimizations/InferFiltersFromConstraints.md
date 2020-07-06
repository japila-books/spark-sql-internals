# InferFiltersFromConstraints Logical Optimization Rule

`InferFiltersFromConstraints` is a link:spark-sql-catalyst-Rule.adoc[Catalyst rule] for transforming link:spark-sql-LogicalPlan.adoc[logical plans] (i.e. `Rule[LogicalPlan]`).

[[apply]]
When link:spark-sql-catalyst-Rule.adoc#apply[executed], `InferFiltersFromConstraints` simply <<inferFilters, inferFilters>> when link:spark-sql-properties.adoc#spark.sql.constraintPropagation.enabled[spark.sql.constraintPropagation.enabled] configuration property is enabled (`true`).

`InferFiltersFromConstraints` is a part of the link:spark-sql-Optimizer.adoc#Infer-Filters[Infer Filters] once-executed rule batch of the base link:spark-sql-Optimizer.adoc[Catalyst Optimizer].

=== [[inferFilters]] `inferFilters` Internal Method

[source, scala]
----
inferFilters(
  plan: LogicalPlan): LogicalPlan
----

`inferFilters` supports <<inferFilters-Filter, Filter>> and <<inferFilters-Join, Join>> logical operators.

[[inferFilters-Filter]]
For link:spark-sql-LogicalPlan-Filter.adoc[Filter] logical operators, `inferFilters`...FIXME

[[inferFilters-Join]]
For link:spark-sql-LogicalPlan-Join.adoc[Join] logical operators, `inferFilters` branches off per the join type:

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
