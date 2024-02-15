---
title: UpdateTable
---

# UpdateTable Logical Operator

`UpdateTable` is a [Command](Command.md) that represents [UPDATE](../sql/AstBuilder.md#visitUpdateTable) SQL statement.

`UpdateTable` is a [SupportsSubquery](SupportsSubquery.md).

## Creating Instance

`UpdateTable` takes the following to be created:

* <span id="table"> Table ([LogicalPlan](LogicalPlan.md))
* <span id="assignments"> `Assignment`s
* <span id="condition"> Condition [Expression](../expressions/Expression.md) (optional)

`UpdateTable` is created when:

* `AstBuilder` is requested to [parse UPDATE SQL statement](../sql/AstBuilder.md#visitUpdateTable)

## Execution Planning

`UpdateTable` command is not supported in Spark SQL and [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy throws an `UnsupportedOperationException` when finds any:

```text
UPDATE TABLE is not supported temporarily.
```

!!! note
    `UpdateTable` is to allow custom data sources to support `UPDATE` SQL statement (and so does [Delta Lake]({{ book.delta }}/commands/update)).
