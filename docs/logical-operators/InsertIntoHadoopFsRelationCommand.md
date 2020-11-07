# InsertIntoHadoopFsRelationCommand Logical Command

`InsertIntoHadoopFsRelationCommand` is a [logical command](DataWritingCommand.md) that writes the result of executing a [query](#query) to an [output path](#outputPath) in the given [format](#fileFormat).

## Creating Instance

`InsertIntoHadoopFsRelationCommand` takes the following to be created:

* <span id="outputPath"> Output Path (as a Hadoop [Path]({{ hadoop.api }}/index.html?org/apache/hadoop/fs/Path.html))
* [Static Partitions](#staticPartitions)
* <span id="ifPartitionNotExists"> `ifPartitionNotExists` Flag
* <span id="partitionColumns"> Partition Columns (`Seq[Attribute]`)
* <span id="bucketSpec"> [BucketSpec](../spark-sql-BucketSpec.md) if defined
* <span id="fileFormat"> [FileFormat](../FileFormat.md)
* <span id="options"> Options (`Map[String, String]`)
* <span id="query"> [Query](../logical-operators/LogicalPlan.md)
* <span id="mode"> [SaveMode](../DataFrameWriter.md#SaveMode)
* <span id="catalogTable"> [CatalogTable](../CatalogTable.md) if available
* <span id="fileIndex"> [FileIndex](../FileIndex.md) if defined
* <span id="outputColumnNames"> Names of the output columns

`InsertIntoHadoopFsRelationCommand` is created when:

* `OptimizedCreateHiveTableAsSelectCommand` logical command is executed
* `DataSource` is requested to [planForWritingFileFormat](../DataSource.md#planForWritingFileFormat)
* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (for a `InsertIntoStatement` over a [LogicalRelation](LogicalRelation.md) with a [HadoopFsRelation](../HadoopFsRelation.md))

## <span id="staticPartitions"> Static Partitions

```scala
type TablePartitionSpec = Map[String, String]
staticPartitions: TablePartitionSpec
```

`InsertIntoHadoopFsRelationCommand` is given a specification of a table partition (as a mapping of column names to column values) when [created](#creating-instance).

Partitions can only be given when created for [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule when executed for a `InsertIntoStatement` over a [LogicalRelation](LogicalRelation.md) with a [HadoopFsRelation](../HadoopFsRelation.md)

There will be no partitions when created for the following:

* `OptimizedCreateHiveTableAsSelectCommand` logical command
* `DataSource` when requested to [planForWritingFileFormat](../DataSource.md#planForWritingFileFormat)

## <span id="dynamicPartitionOverwrite"> Dynamic Partition Inserts and dynamicPartitionOverwrite Flag

```scala
dynamicPartitionOverwrite: Boolean
```

`InsertIntoHadoopFsRelationCommand` defines a `dynamicPartitionOverwrite` flag to indicate whether [dynamic partition inserts](../spark-sql-dynamic-partition-inserts.md) is enabled or not.

`dynamicPartitionOverwrite` is based on the following (in the order of precedence):

* **partitionOverwriteMode** option (`STATIC` or `DYNAMIC`) in the [parameters](#parameters) if available
* [spark.sql.sources.partitionOverwriteMode](../configuration-properties.md#spark.sql.sources.partitionOverwriteMode)

`dynamicPartitionOverwrite` is used when:

* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule is executed (for dynamic partition overwrite)
* `InsertIntoHadoopFsRelationCommand` is [executed](#run)

## <span id="run"> Executing Command

```scala
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
```

`run` uses the [spark.sql.hive.manageFilesourcePartitions](../SQLConf.md#manageFilesourcePartitions) configuration property to...FIXME

CAUTION: FIXME When is the `catalogTable` defined?

CAUTION: FIXME When is `tracksPartitionsInCatalog` of `CatalogTable` enabled?

`run` gets the [partitionOverwriteMode](#partitionOverwriteMode) option...FIXME

`run` uses `FileCommitProtocol` utility to instantiate a committer based on the [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass) and the [outputPath](#outputPath), the [dynamicPartitionOverwrite](#dynamicPartitionOverwrite), and random `jobId`.

For insertion, `run` simply uses the `FileFormatWriter` utility to `write` and then...FIXME (does some table-specific "tasks").

Otherwise (for non-insertion case), `run` simply prints out the following INFO message to the logs and finishes.

```text
Skipping insertion into a relation that already exists.
```

`run` [makes sure that there are no duplicates](../spark-sql-SchemaUtils.md#checkColumnNameDuplication) in the [outputColumnNames](#outputColumnNames).

`run` is part of the [DataWritingCommand](DataWritingCommand.md#run) abstraction.
