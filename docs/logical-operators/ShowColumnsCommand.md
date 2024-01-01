---
title: ShowColumnsCommand
---

# ShowColumnsCommand Leaf Logical Command

`ShowColumnsCommand` is a [LeafRunnableCommand](LeafRunnableCommand.md) that represents [ShowColumns](ShowColumns.md) logical command at logical query resolution phase.

```sql
SHOW COLUMNS (FROM | IN) table_identifier [(FROM | IN) database];
```

## Creating Instance

`ShowColumnsCommand` takes the following to be created:

* <span id="databaseName"> Database Name
* <span id="tableName"> Table Name
* <span id="output"> Output [Attribute](../expressions/Attribute.md)s

`ShowColumnsCommand` is created when:

* `ResolveSessionCatalog` logical resolution rule is requested to [resolve ShowColumns logical operator](../logical-analysis-rules/ResolveSessionCatalog.md#ShowColumns)
