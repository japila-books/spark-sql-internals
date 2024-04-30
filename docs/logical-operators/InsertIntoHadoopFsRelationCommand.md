---
title: InsertIntoHadoopFsRelationCommand
---

# InsertIntoHadoopFsRelationCommand Logical Command

`InsertIntoHadoopFsRelationCommand` is a [write command](V1WriteCommand.md) that is used to write the result of a [query](#query) to an [output path](#outputPath) (in the given [format](#fileFormat)).

## Creating Instance

`InsertIntoHadoopFsRelationCommand` takes the following to be created:

* <span id="outputPath"> Output Path (as a Hadoop [Path]({{ hadoop.api }}/index.html?org/apache/hadoop/fs/Path.html))
* [Static Partitions](#staticPartitions)
* <span id="ifPartitionNotExists"> `ifPartitionNotExists` Flag
* <span id="partitionColumns"> Partition Columns (`Seq[Attribute]`)
* <span id="bucketSpec"> [BucketSpec](../bucketing/BucketSpec.md) (optional)
* <span id="fileFormat"> [FileFormat](../files/FileFormat.md)
* <span id="options"> Options (`Map[String, String]`)
* <span id="query"> [Query](../logical-operators/LogicalPlan.md)
* <span id="mode"> [SaveMode](../DataFrameWriter.md#SaveMode)
* <span id="catalogTable"> [CatalogTable](../CatalogTable.md) (optional)
* <span id="fileIndex"> [FileIndex](../files/FileIndex.md) (optional)
* <span id="outputColumnNames"> Names of the output columns

`InsertIntoHadoopFsRelationCommand` is created when:

* `DataSource` is requested to [planForWritingFileFormat](../DataSource.md#planForWritingFileFormat)
* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (for a [InsertIntoStatement](InsertIntoStatement.md) over a [LogicalRelation](LogicalRelation.md) with a [HadoopFsRelation](../files/HadoopFsRelation.md))
* [RelationConversions](../hive/RelationConversions.md) logical evaluation rule is executed

## Static Partitions { #staticPartitions }

```scala
type TablePartitionSpec = Map[String, String]
staticPartitions: TablePartitionSpec
```

`InsertIntoHadoopFsRelationCommand` is given a specification of a table partition (as a mapping of column names to column values) when [created](#creating-instance).

Partitions can only be given when created for [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule when executed for a `InsertIntoStatement` over a [LogicalRelation](LogicalRelation.md) with a [HadoopFsRelation](../files/HadoopFsRelation.md)

There will be no partitions when created for the following:

* `OptimizedCreateHiveTableAsSelectCommand` logical command
* `DataSource` when requested to [planForWritingFileFormat](../DataSource.md#planForWritingFileFormat)

## Dynamic Partition Inserts and dynamicPartitionOverwrite Flag { #dynamicPartitionOverwrite }

```scala
dynamicPartitionOverwrite: Boolean
```

`InsertIntoHadoopFsRelationCommand` defines a `dynamicPartitionOverwrite` flag to indicate whether [dynamic partition inserts](../dynamic-partition-inserts.md) is enabled or not.

`dynamicPartitionOverwrite` is based on the following (in the order of precedence):

* **partitionOverwriteMode** option (`STATIC` or `DYNAMIC`) in the [parameters](#parameters) if available
* [spark.sql.sources.partitionOverwriteMode](../configuration-properties.md#spark.sql.sources.partitionOverwriteMode)

---

`dynamicPartitionOverwrite` is used when:

* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (for dynamic partition overwrite)
* `InsertIntoHadoopFsRelationCommand` is [executed](#run)

## Executing Command { #run }

??? note "DataWritingCommand"

    ```scala
    run(
      sparkSession: SparkSession,
      child: SparkPlan): Seq[Row]
    ```

    `run` is part of the [DataWritingCommand](DataWritingCommand.md#run) abstraction.

`run` creates a new Hadoop `Configuration` with the [options](#options) and resolves the [outputPath](#outputPath).

`run` uses the following to determine whether partitions are tracked by a catalog (`partitionsTrackedByCatalog`):

* [spark.sql.hive.manageFilesourcePartitions](../SQLConf.md#manageFilesourcePartitions) configuration property
* [catalogTable](#catalogTable) is defined with the [partitionColumnNames](../CatalogTable.md#partitionColumnNames) and [tracksPartitionsInCatalog](../CatalogTable.md#tracksPartitionsInCatalog) flag enabled

??? note "FIXME"
    When is the [catalogTable](#catalogTable) defined?

??? note "FIXME"
    When is [tracksPartitionsInCatalog](../CatalogTable.md#tracksPartitionsInCatalog) enabled?

With partitions tracked by a catalog, `run`...FIXME

`run` uses `FileCommitProtocol` utility to instantiate a `FileCommitProtocol` based on the [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass) with the following:

* Random job ID
* [outputPath](#outputPath)
* [dynamicPartitionOverwrite](#dynamicPartitionOverwrite)

For insertion (`doInsertion`), `run`...FIXME

Otherwise (for a non-insertion case), `run` does nothing but prints out the following INFO message to the logs and finishes.

```text
Skipping insertion into a relation that already exists.
```

---

`run` makes sure that there are no duplicates in the [outputColumnNames](#outputColumnNames).
