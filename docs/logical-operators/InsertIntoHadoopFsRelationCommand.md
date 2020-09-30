title: InsertIntoHadoopFsRelationCommand

# InsertIntoHadoopFsRelationCommand Logical Command

`InsertIntoHadoopFsRelationCommand` is a <<spark-sql-LogicalPlan-DataWritingCommand.md#, logical command>> that writes the result of executing a <<query, query>> to an <<outputPath, output path>> in the given <<fileFormat, FileFormat>> (and <<creating-instance, other properties>>).

`InsertIntoHadoopFsRelationCommand` is <<creating-instance, created>> when:

* `DataSource` is requested to spark-sql-DataSource.md#planForWritingFileFormat[plan for writing to a FileFormat-based data source] for the following:
** spark-sql-LogicalPlan-CreateDataSourceTableAsSelectCommand.md[CreateDataSourceTableAsSelectCommand] logical command
** spark-sql-LogicalPlan-InsertIntoDataSourceDirCommand.md[InsertIntoDataSourceDirCommand] logical command
** spark-sql-DataFrameWriter.md#save[DataFrameWriter.save] operator with DataSource V1 data sources

* [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) post-hoc logical resolution rule is executed (and resolves a InsertIntoTable.md[InsertIntoTable] logical operator with a [HadoopFsRelation](../HadoopFsRelation.md))

[[partitionOverwriteMode]][[PartitionOverwriteMode]]
`InsertIntoHadoopFsRelationCommand` uses *partitionOverwriteMode* option that overrides <<spark-sql-properties.md#spark.sql.sources.partitionOverwriteMode, spark.sql.sources.partitionOverwriteMode>> property for <<spark-sql-dynamic-partition-inserts.md#, dynamic partition inserts>>.

=== [[creating-instance]] Creating InsertIntoHadoopFsRelationCommand Instance

`InsertIntoHadoopFsRelationCommand` takes the following to be created:

* [[outputPath]] Output Hadoop's https://hadoop.apache.org/docs/r2.7.3/api/index.html?org/apache/hadoop/fs/Path.html[Path]
* [[staticPartitions]] Static table partitions (`Map[String, String]`)
* [[ifPartitionNotExists]] `ifPartitionNotExists` flag
* [[partitionColumns]] Partition columns (`Seq[Attribute]`)
* [[bucketSpec]] <<spark-sql-BucketSpec.md#, BucketSpec>>
* [[fileFormat]] <<spark-sql-FileFormat.md#, FileFormat>>
* [[options]] Options (`Map[String, String]`)
* [[query]] <<spark-sql-LogicalPlan.md#, Logical plan>>
* [[mode]] `SaveMode`
* [[catalogTable]] <<spark-sql-CatalogTable.md#, CatalogTable>>
* [[fileIndex]] `FileIndex`
* [[outputColumnNames]] Output column names

[NOTE]
====
<<staticPartitions, staticPartitions>> may hold zero or more partitions as follows:

* Always empty when <<creating-instance, created>> when `DataSource` is requested to <<spark-sql-DataSource.md#planForWritingFileFormat, planForWritingFileFormat>>

* Possibly with partitions when <<creating-instance, created>> when [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule is applied to an <<InsertIntoTable.md#, InsertIntoTable>> logical operator over a [HadoopFsRelation](../HadoopFsRelation.md) relation

With that, <<staticPartitions, staticPartitions>> are simply the partitions of an <<InsertIntoTable.md#, InsertIntoTable>> logical operator.
====

=== [[run]] Executing Data-Writing Logical Command -- `run` Method

[source, scala]
----
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
----

NOTE: `run` is part of spark-sql-LogicalPlan-DataWritingCommand.md#run[DataWritingCommand] contract.

`run` uses the [spark.sql.hive.manageFilesourcePartitions](../SQLConf.md#manageFilesourcePartitions) configuration property to...FIXME

CAUTION: FIXME When is the <<catalogTable, catalogTable>> defined?

CAUTION: FIXME When is `tracksPartitionsInCatalog` of `CatalogTable` enabled?

`run` gets the <<partitionOverwriteMode, partitionOverwriteMode>> option...FIXME

`run` uses `FileCommitProtocol` utility to instantiate a committer based on the <<spark-sql-properties.md#spark.sql.sources.commitProtocolClass, spark.sql.sources.commitProtocolClass>> (default: <<spark-sql-SQLHadoopMapReduceCommitProtocol.md#, SQLHadoopMapReduceCommitProtocol>>) and the <<outputPath, outputPath>>, the <<dynamicPartitionOverwrite, dynamicPartitionOverwrite>>, and random `jobId`.

For insertion, `run` simply uses the `FileFormatWriter` utility to `write` and then...FIXME (does some table-specific "tasks").

Otherwise (for non-insertion case), `run` simply prints out the following INFO message to the logs and finishes.

```
Skipping insertion into a relation that already exists.
```

`run` uses `SchemaUtils` to <<spark-sql-SchemaUtils.md#checkColumnNameDuplication, make sure that there are no duplicates>> in the <<outputColumnNames, outputColumnNames>>.
