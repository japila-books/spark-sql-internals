# ReuseSubquery Physical Query Optimization

`ReuseSubquery` is a *physical query optimization* (aka _physical query preparation rule_ or simply _preparation rule_) that `QueryExecution` link:spark-sql-QueryExecution.adoc#preparations[uses] to optimize the physical plan of a structured query by <<apply, FIXME>>.

Technically, `ReuseSubquery` is just a link:catalyst/Rule.md[Catalyst rule] for transforming link:SparkPlan.md[physical query plans], i.e. `Rule[SparkPlan]`.

`ReuseSubquery` is part of link:spark-sql-QueryExecution.adoc#preparations[preparations] batch of physical query plan rules and is executed when `QueryExecution` is requested for the link:spark-sql-QueryExecution.adoc#executedPlan[optimized physical query plan] (i.e. in *executedPlan* phase of a query execution).

=== [[apply]] `apply` Method

[source, scala]
----
apply(plan: SparkPlan): SparkPlan
----

NOTE: `apply` is part of link:catalyst/Rule.md#apply[Rule Contract] to apply a rule to a link:SparkPlan.md[physical plan].

`apply`...FIXME
