---
title: DeleteFromTable
---

# DeleteFromTable Logical Command

`DeleteFromTable` is a [Command](Command.md) that represents [DELETE FROM](../sql/AstBuilder.md#visitDeleteFromTable) SQL statement.

`DeleteFromTable` is a [SupportsSubquery](SupportsSubquery.md).

## Creating Instance

`DeleteFromTable` takes the following to be created:

* <span id="table"> [LogicalPlan](LogicalPlan.md) of the table
* <span id="condition"> Condition [Expression](../expressions/Expression.md) (optional)

`DeleteFromTable` is created when:

* `AstBuilder` is requested to [parse DELETE FROM SQL statement](../sql/AstBuilder.md#visitDeleteFromTable)

## Execution Planning

`DeleteFromTable` command is resolved to [DeleteFromTableExec](../physical-operators/DeleteFromTableExec.md) physical operator by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.

It is only supported for `DeleteFromTable` command over [DataSourceV2ScanRelation](DataSourceV2ScanRelation.md) relations (_v2 tables_).
