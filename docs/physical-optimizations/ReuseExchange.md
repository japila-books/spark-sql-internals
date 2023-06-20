---
title: ReuseExchange
---

# ReuseExchange Physical Optimization

`ReuseExchange` is a *physical query optimization* (aka _physical query preparation rule_ or simply _preparation rule_) that `QueryExecution` [uses](../QueryExecution.md#preparations) to optimize the physical plan of a structured query.

Technically, `ReuseExchange` is just a catalyst/Rule.md[Catalyst rule] for transforming SparkPlan.md[physical query plans], i.e. `Rule[SparkPlan]`.

`ReuseExchange` is part of [preparations](../QueryExecution.md#preparations) batch of physical query plan rules and is executed when `QueryExecution` is requested for the [optimized physical query plan](../QueryExecution.md#executedPlan) (i.e. in *executedPlan* phase of a query execution).

=== [[apply]] `apply` Method

[source, scala]
----
apply(plan: SparkPlan): SparkPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a SparkPlan.md[physical plan].

`apply` finds all [Exchange](../physical-operators/Exchange.md) unary operators and...FIXME

`apply` does nothing and simply returns the input physical `plan` if [spark.sql.exchange.reuse](../configuration-properties.md#spark.sql.exchange.reuse) internal configuration property is disabled.
