# ParquetReadSupport

`ParquetReadSupport` is a `ReadSupport` (Apache Parquet) of [UnsafeRows](../../UnsafeRow.md) for non-[Vectorized Parquet Decoding](../../vectorized-decoding/index.md).

`ParquetReadSupport` is the value of `parquet.read.support.class` Hadoop configuration property for the following:

* [ParquetFileFormat](ParquetFileFormat.md#buildReaderWithPartitionValues)
* [ParquetScan](ParquetScan.md#createReaderFactory)

## Creating Instance

`ParquetReadSupport` takes the following to be created:

* <span id="convertTz"> `ZoneId` (optional)
* <span id="enableVectorizedReader"> `enableVectorizedReader`
* <span id="datetimeRebaseSpec"> DateTime RebaseSpec
* <span id="int96RebaseSpec"> int96 RebaseSpec

`ParquetReadSupport` is created when:

* `ParquetFileFormat` is requested to [buildReaderWithPartitionValues](ParquetFileFormat.md#buildReaderWithPartitionValues) (with [enableVectorizedReader](ParquetFileFormat.md#enableVectorizedReader) disabled)
* `ParquetPartitionReaderFactory` is requested to [createRowBaseParquetReader](ParquetPartitionReaderFactory.md#createRowBaseParquetReader)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.parquet.ParquetReadSupport` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.ParquetReadSupport.name = org.apache.spark.sql.execution.datasources.parquet.ParquetReadSupport
logger.ParquetReadSupport.level = all
```

Refer to [Logging](../../spark-logging.md).

<!---
## Review Me

`ParquetReadSupport` is <<creating-instance, created>> exclusively when `ParquetFileFormat` is requested for a [data reader](ParquetFileFormat.md#buildReaderWithPartitionValues) (with no support for [Vectorized Parquet Decoding](../../vectorized-decoding/index.md) and so falling back to parquet-mr).

[[parquet.read.support.class]]
`ParquetReadSupport` is registered as the fully-qualified class name for [parquet.read.support.class](ParquetFileFormat.md#parquet.read.support.class) Hadoop configuration when `ParquetFileFormat` is requested for a [data reader](ParquetFileFormat.md#buildReaderWithPartitionValues).

[[creating-instance]]
[[convertTz]]
`ParquetReadSupport` takes an optional Java `TimeZone` to be created.
-->
