# SupportsSubquery Logical Operators

`SupportsSubquery` is a marker interface (and an extension of the [LogicalPlan](LogicalPlan.md) abstraction) for [logical operators](#implementations) that support subqueries.

`SupportsSubquery` is resolved by [ResolveSubquery](../logical-analysis-rules/ResolveSubquery.md) logical resolution rule.

## Implementations

* [DeleteFromTable](DeleteFromTable.md)
* [MergeIntoTable](MergeIntoTable.md)
* UpdateTable
