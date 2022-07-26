# StagingTableCatalog

`StagingTableCatalog` is an [extension](#contract) of the [TableCatalog](TableCatalog.md) abstraction for [table catalogs](#implementations) that can stage [Create](#stageCreate), [CreateOrReplace](#stageCreateOrReplace) and [Replace](#stageReplace) operations (for atomic `CREATE TABLE AS SELECT` and `REPLACE TABLE` and `REPLACE TABLE AS SELECT` queries).

1. `AtomicCreateTableAsSelectExec` is created for [CreateTableAsSelect](../../logical-operators/CreateTableAsSelect.md)s on a `StagingTableCatalog` (otherwise, it is a [CreateTableAsSelectExec](../../physical-operators/CreateTableAsSelectExec.md))
1. `AtomicReplaceTableExec` is created for `ReplaceTable`s on a `StagingTableCatalog` (otherwise, it is a `ReplaceTableExec`)
1. `AtomicReplaceTableAsSelectExec` is created for `ReplaceTableAsSelect`s on a `StagingTableCatalog` (otherwise, it is a `ReplaceTableAsSelectExec`)

## Contract

### <span id="stageCreate"> stageCreate

```java
StagedTable stageCreate(
  Identifier ident,
  StructType schema,
  Transform[] partitions,
  Map<String, String> properties)
```

Creates a [StagedTable](../StagedTable.md)

Used when:

* `AtomicCreateTableAsSelectExec` unary physical command is executed

### <span id="stageCreateOrReplace"> stageCreateOrReplace

```java
StagedTable stageCreateOrReplace(
  Identifier ident,
  StructType schema,
  Transform[] partitions,
  Map<String, String> properties)
```

Creates a [StagedTable](../StagedTable.md)

Used when:

* `AtomicReplaceTableExec` leaf physical command is executed
* `AtomicReplaceTableAsSelectExec` unary physical command is executed

### <span id="stageReplace"> stageReplace

```java
StagedTable stageReplace(
  Identifier ident,
  StructType schema,
  Transform[] partitions,
  Map<String, String> properties)
```

Creates a [StagedTable](../StagedTable.md)

Used when:

* `AtomicReplaceTableExec` leaf physical command is executed
* `AtomicReplaceTableAsSelectExec` unary physical command is executed

## Implementations

!!! note
    No known native Spark SQL implementations.
