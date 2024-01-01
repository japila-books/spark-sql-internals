---
title: ShowColumns
---

# ShowColumns Unary Command

`ShowColumns` is a `UnaryCommand` (and a [Logical Command](Command.md)) that represents [SHOW COLUMNS](../sql/AstBuilder.md#visitShowColumns) SQL statement in logical query plans.

## Creating Instance

`ShowColumns` takes the following to be created:

* <span id="child"> Child [Logical Operator](LogicalPlan.md)
* <span id="namespace"> Namespace
* [Output Schema](#output)

`ShowColumns` is created when:

* `AstBuilder` is requested to [parse SHOW COLUMNS statement](../sql/AstBuilder.md#visitShowColumns)

### Output Schema { #output }

`ShowColumns` can be given output [Attribute](../expressions/Attribute.md)s when [created](#creating-instance).

The output schema is by default as follows:

Column Name | Data Type | Nullable
------------|-----------|---------
 `col_name` | [StringType](../types/index.md#StringType) | ❌

## Logical Analysis

`ShowColumns` is resolved to [ShowColumnsCommand](ShowColumnsCommand.md) logical runnable command by [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule.

## Query Planning

[DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) throws an `AnalysisException` for `ShowColumns`s in query plans.
