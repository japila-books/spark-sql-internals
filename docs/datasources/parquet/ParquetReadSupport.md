# ParquetReadSupport

`ParquetReadSupport` is a concrete `ReadSupport` (from Apache Parquet) of [UnsafeRows](../../UnsafeRow.md).

`ParquetReadSupport` is <<creating-instance, created>> exclusively when `ParquetFileFormat` is requested for a [data reader](ParquetFileFormat.md#buildReaderWithPartitionValues) (with no support for [Vectorized Parquet Decoding](../../vectorized-decoding/index.md) and so falling back to parquet-mr).

[[parquet.read.support.class]]
`ParquetReadSupport` is registered as the fully-qualified class name for [parquet.read.support.class](ParquetFileFormat.md#parquet.read.support.class) Hadoop configuration when `ParquetFileFormat` is requested for a [data reader](ParquetFileFormat.md#buildReaderWithPartitionValues).

[[creating-instance]]
[[convertTz]]
`ParquetReadSupport` takes an optional Java `TimeZone` to be created.

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.parquet.ParquetReadSupport` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.parquet.ParquetReadSupport=ALL
```

Refer to <<spark-logging.md#, Logging>>.
====

=== [[init]] Initializing ReadSupport -- `init` Method

[source, scala]
----
init(context: InitContext): ReadContext
----

NOTE: `init` is part of the `ReadSupport` Contract to...FIXME.

`init`...FIXME

=== [[prepareForRead]] `prepareForRead` Method

[source, scala]
----
prepareForRead(
  conf: Configuration,
  keyValueMetaData: JMap[String, String],
  fileSchema: MessageType,
  readContext: ReadContext): RecordMaterializer[UnsafeRow]
----

NOTE: `prepareForRead` is part of the `ReadSupport` Contract to...FIXME.

`prepareForRead`...FIXME
