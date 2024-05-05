---
title: ShowCreateTableExec
---

# ShowCreateTableExec Physical Command

`ShowCreateTableExec` is a [V2CommandExec](V2CommandExec.md) physical command that represents [ShowCreateTable](../logical-operators/ShowCreateTable.md) logical operator at execution.

`ShowCreateTableExec` is a `LeafExecNode`.

## Creating Instance

`ShowCreateTableExec` takes the following to be created:

* <span id="output"> Output [Attribute](../expressions/Attribute.md)s
* <span id="table"> [Table](../connector/Table.md)

`ShowCreateTableExec` is created when:

* [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed (to plan a logical query plan with a [ShowCreateTable](../logical-operators/ShowCreateTable.md) logical operator)

## <span id="run"> Executing Command

??? note "Signature"

    ```scala
    run(): Seq[InternalRow]
    ```

    `run` is part of the [V2CommandExec](V2CommandExec.md#run) abstraction.

---

`run` [showCreateTable](#showCreateTable).

### <span id="showCreateTable"> showCreateTable

```scala
showCreateTable(
  table: Table,
  builder: StringBuilder): Unit
```

`showCreateTable` adds the following (to the given `StringBuilder`):

```text
CREATE TABLE [tableName]
```

`showCreateTable` then does the following:

* [showTableDataColumns](#showTableDataColumns)
* [showTableUsing](#showTableUsing)
* [showTableOptions](#showTableOptions)
* [showTablePartitioning](#showTablePartitioning)
* [showTableComment](#showTableComment)
* [showTableLocation](#showTableLocation)
* [showTableProperties](#showTableProperties)

### <span id="showTableDataColumns"> showTableDataColumns

```scala
showTableDataColumns(
  table: Table,
  builder: StringBuilder): Unit
```

`showTableDataColumns` requests the given [Table](../connector/Table.md) for the [columns](../connector/Table.md#columns) that are [converted to DDL format](../types/StructField.md#toDDL).

### <span id="showTablePartitioning"> showTablePartitioning

```scala
showTablePartitioning(
  table: Table,
  builder: StringBuilder): Unit
```

??? note "Noop for a non-partitioned table"
    `showTablePartitioning` does nothing (_noop_) when the given [table](../connector/Table.md) has no [partitioning](../connector/Table.md#partitioning).

For a `BucketTransform` (among [partitioning transforms](../connector/Table.md#partitioning)), `showTablePartitioning` creates a [BucketSpec](../bucketing/BucketSpec.md) to add the following (to the given `StringBuilder`):

```text
CLUSTERED BY [bucketColumnNames]
SORTED BY [sortColumnNames]
INTO [numBuckets] BUCKETS
```

??? note "One BucketTransform Supported"
    In case there are more `BucketTransform`s, the last wins.

For all other [Transform](../connector/Transform.md)s, `showTablePartitioning` requests them to [describe](../connector/Expression.md#describe) and adds the following (to the given `StringBuilder`):

```text
PARTITIONED BY [transforms]
```
