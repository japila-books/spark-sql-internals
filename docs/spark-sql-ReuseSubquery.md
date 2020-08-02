# ReuseSubquery Physical Optimization

`ReuseSubquery` is a *physical query optimization* (aka _physical query preparation rule_ or simply _preparation rule_) that `QueryExecution` spark-sql-QueryExecution.md#preparations[uses] to optimize the physical plan of a structured query by <<apply, FIXME>>.

Technically, `ReuseSubquery` is just a catalyst/Rule.md[Catalyst rule] for transforming SparkPlan.md[physical query plans], i.e. `Rule[SparkPlan]`.

`ReuseSubquery` is part of spark-sql-QueryExecution.md#preparations[preparations] batch of physical query plan rules and is executed when `QueryExecution` is requested for the spark-sql-QueryExecution.md#executedPlan[optimized physical query plan] (i.e. in *executedPlan* phase of a query execution).

=== [[apply]] `apply` Method

[source, scala]
----
apply(plan: SparkPlan): SparkPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a SparkPlan.md[physical plan].

`apply`...FIXME
