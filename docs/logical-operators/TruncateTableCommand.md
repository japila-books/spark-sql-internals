---
title: TruncateTableCommand
---

# TruncateTableCommand Logical Command

`TruncateTableCommand` is a [leaf logical runnable command](LeafRunnableCommand.md) that represents `TruncateTable` or `TruncatePartition` (over a [V1Table](../connector/V1Table.md) in the [spark_catalog](../connector/catalog/CatalogManager.md#SESSION_CATALOG_NAME) catalog) at execution time.

## Creating Instance

`TruncateTableCommand` takes the following to be created:

* <span id="tableName"> `TableIdentifier`
* <span id="partitionSpec"> Optional `TablePartitionSpec`

`TruncateTableCommand` is created when:

* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      spark: SparkSession): Seq[Row]
    ```

    `run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.

`run` requests the given [SparkSession](../SparkSession.md) for the [SessionCatalog](../SessionState.md#catalog) (via [SessionState](../SparkSession.md#sessionState)).

`run` requests the `SessionCatalog` for the [table metadata](../SessionCatalog.md#getTableMetadata) by the given [tableName](#tableName).

`run` finds the paths of the partitions (if specified) or the main directory of the table and deletes them one by one, recursively.

??? note "Uses Apache Hadoop to Delete Paths"
    `run` uses Apache Hadoop's [FileSystem.delete]({{ hadoop.api }}/org/apache/hadoop/fs/FileSystem.html#delete-org.apache.hadoop.fs.Path-boolean-) to delete the directories.

Once deleted, `run` re-creates the paths (so they are empty directories), possibly re-creating their file permissions (based on the [spark.sql.truncateTable.ignorePermissionAcl.enabled](../configuration-properties.md#spark.sql.truncateTable.ignorePermissionAcl.enabled) configuration property).

??? note "Uses Apache Hadoop to Re-Create Paths"
    `run` uses Apache Hadoop's [FileSystem.mkdirs]({{ hadoop.api }}/api/org/apache/hadoop/fs/FileSystem.html#mkdirs-org.apache.hadoop.fs.Path-) to re-create the directories.

After deleting the data, `run` requests the [Catalog](../SparkSession.md#catalog) to [refresh the table](../Catalog.md#refreshTable) followed by [updating the table statistics](../CommandUtils.md#updateTableStats).

`run` returns no `Row`s.

### Exceptions

`run` throws an `AnalysisException` when executed on [external tables](../CatalogTable.md#tableType):

```text
Operation not allowed: TRUNCATE TABLE on external tables: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed with the [TablePartitionSpec](#partitionSpec) on [non-partitioned tables](../CatalogTable.md#partitionColumnNames):

```text
Operation not allowed: TRUNCATE TABLE ... PARTITION is not supported for tables that are not partitioned: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed with the [TablePartitionSpec](#partitionSpec) with filesource partition disabled or partition metadata not in a Hive metastore.
