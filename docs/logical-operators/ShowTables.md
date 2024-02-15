---
title: ShowTables
---

# ShowTables Logical Command

`ShowTables` is a [logical command](Command.md) that represents [SHOW TABLES](../sql/AstBuilder.md#visitShowTables) SQL statement.

```text
SHOW TABLES ((FROM | IN) multipartIdentifier)?
  (LIKE? pattern=STRING)?
```

!!! note
    `ShowTables` is resolved to [ShowTablesExec](../physical-operators/ShowTablesExec.md) physical command.

## Creating Instance

`ShowTables` takes the following to be created:

* <span id="namespace"> [Logical Operator](LogicalPlan.md)
* <span id="pattern"> Optional Pattern (of tables to show)

`ShowTables` is created when `AstBuilder` is requested to [visitShowTables](../sql/AstBuilder.md#visitShowTables).

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is the following [attributes](../expressions/Attribute.md):

* namespace
* tableName

`output` is part of the [Command](Command.md#output) abstraction.
