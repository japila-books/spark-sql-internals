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

<!---
=== [[run]] Executing Logical Command -- `run` Method

[source, scala]
----
run(spark: SparkSession): Seq[Row]
----

NOTE: `run` is part of RunnableCommand.md#run[RunnableCommand Contract] to execute (_run_) a logical command.

`run`...FIXME

`run` throws an `AnalysisException` when executed on [external tables](../CatalogTable.md#tableType):

```text
Operation not allowed: TRUNCATE TABLE on external tables: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed on [views](../CatalogTable.md#tableType):

```text
Operation not allowed: TRUNCATE TABLE on views: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed with <<partitionSpec, TablePartitionSpec>> on [non-partitioned tables](../CatalogTable.md#partitionColumnNames):

```text
Operation not allowed: TRUNCATE TABLE ... PARTITION is not supported for tables that are not partitioned: [tableIdentWithDB]
```

`run` throws an `AnalysisException` when executed with <<partitionSpec, TablePartitionSpec>> with filesource partition disabled or partition metadata not in a Hive metastore.
-->
