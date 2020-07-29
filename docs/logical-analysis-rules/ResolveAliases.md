# ResolveAliases Logical Resolution Rule

`ResolveAliases` is a logical resolution rule that the [logical query plan analyzer](../Analyzer.md#ResolveAliases) uses to <<apply, FIXME>> in an entire logical query plan.

Technically, `ResolveAliases` is just a catalyst/Rule.md[Catalyst rule] for transforming spark-sql-LogicalPlan.md[logical plans], i.e. `Rule[LogicalPlan]`.

`ResolveAliases` is part of [Resolution](../Analyzer.md#Resolution) fixed-point batch of rules.

## Example

```text
import spark.sessionState.analyzer.ResolveAliases

// FIXME Using ResolveAliases rule
```

=== [[apply]] Applying ResolveAliases to Logical Plan -- `apply` Method

[source, scala]
----
apply(plan: LogicalPlan): LogicalPlan
----

NOTE: `apply` is part of catalyst/Rule.md#apply[Rule Contract] to apply a rule to a spark-sql-LogicalPlan.md[logical plan].

`apply`...FIXME

=== [[assignAliases]] `assignAliases` Internal Method

[source, scala]
----
assignAliases(exprs: Seq[NamedExpression]): Seq[NamedExpression]
----

`assignAliases`...FIXME

NOTE: `assignAliases` is used when...FIXME
