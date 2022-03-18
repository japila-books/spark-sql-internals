# AlterTableAddColumnsCommand Logical Runnable Command

`AlterTableAddColumnsCommand` is a [LeafRunnableCommand](LeafRunnableCommand.md).

## Creating Instance

`AlterTableAddColumnsCommand` takes the following to be created:

* <span id="table"> Table (`TableIdentifier`)
* <span id="colsToAdd"> Columns to Add ([StructField](../types/StructField.md)s)

`AlterTableAddColumnsCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (and resolves an [AddColumns](AddColumns.md) logical operator)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession): Seq[Row]
```

`run` [verifyAlterTableAddColumn](#verifyAlterTableAddColumn) (with the [SessionCatalog](../SessionCatalog.md)).

`run` [uncaches](../CommandUtils.md#uncacheTableOrView) the [table](#table).

`run` requests the `SessionCatalog` to [refreshTable](../SessionCatalog.md#refreshTable).

`run` checks the column names (against any duplications) and types, and re-constructs the original schema of columns from their column metadata (if there is any).

`run` requests the `SessionCatalog` to [alterTableDataSchema](../SessionCatalog.md#alterTableDataSchema).

---

`run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.

### <span id="verifyAlterTableAddColumn"> verifyAlterTableAddColumn

```scala
verifyAlterTableAddColumn(
  conf: SQLConf,
  catalog: SessionCatalog,
  table: TableIdentifier): CatalogTable
```

`verifyAlterTableAddColumn`...FIXME
