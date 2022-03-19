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

`verifyAlterTableAddColumn` asserts that the table is as follows:

1. The table is not a view
1. The table is a Hive table or one of the supported [FileFormat](../datasources/FileFormat.md)s

---

`verifyAlterTableAddColumn` requests the given [SessionCatalog](../SessionCatalog.md) for the [getTempViewOrPermanentTableMetadata](../SessionCatalog.md#getTempViewOrPermanentTableMetadata).

`verifyAlterTableAddColumn` throws an `AnalysisException` if the `table` is a `VIEW`:

```text
ALTER ADD COLUMNS does not support views.
You must drop and re-create the views for adding the new columns. Views: [table]
```

For a Spark table (that is non-Hive), `verifyAlterTableAddColumn` [finds the implementation of the table provider](../DataSource.md#lookupDataSource) and makes sure that the table provider is one of the following supported file formats:

* [CSVFileFormat](../datasources/csv/CSVFileFormat.md) or `CSVDataSourceV2`
* [JsonFileFormat](../datasources/json/JsonFileFormat.md) or `JsonDataSourceV2`
* [ParquetFileFormat](../datasources/parquet/ParquetFileFormat.md) or `ParquetDataSourceV2`
* [OrcFileFormat](../datasources/orc/OrcFileFormat.md) or `OrcDataSourceV2`

Otherwise, `verifyAlterTableAddColumn` throws an `AnalysisException`:

```text
ALTER ADD COLUMNS does not support datasource table with type [tableType].
You must drop and re-create the table for adding the new columns. Tables: [table]
```
