# ParquetFileFormat

!!! important "Obsolete"
    `ParquetFileFormat` is a mere [fallbackFileFormat](ParquetDataSourceV2.md#fallbackFileFormat) of [ParquetDataSourceV2](ParquetDataSourceV2.md).

`ParquetFileFormat` is the [FileFormat](../connectors/FileFormat.md) of [Parquet Data Source](index.md).

`ParquetFileFormat` is [splitable](#isSplitable).

`ParquetFileFormat` is `Serializable`.

## <span id="DataSourceRegister"> Short Name { #shortName }

```scala
shortName(): String
```

`ParquetFileFormat` is a [DataSourceRegister](../DataSourceRegister.md) with the [short name](../DataSourceRegister.md#shortName):

```text
parquet
```

## Metadata Columns { #metadataSchemaFields }

??? note "FileFormat"

    ```scala
    metadataSchemaFields: Seq[StructField]
    ```

    `metadataSchemaFields` is part of the [FileFormat](../connectors/FileFormat.md#metadataSchemaFields) abstraction.

`metadataSchemaFields` is the following metadata columns:

* The default [FileFormat-specific metadata columns](../connectors/FileFormat.md#metadataSchemaFields)
* [row_index](#row_index)

### <span id="ROW_INDEX_FIELD"> row_index { #row_index }

`row_index` is a `ParquetFileFormat`-specific [metadata column](#metadataSchemaFields).

### <span id="ROW_INDEX_TEMPORARY_COLUMN_NAME"> _tmp_metadata_row_index

## isSplitable { #isSplitable }

??? note "FileFormat"

    ```scala
    isSplitable(
      sparkSession: SparkSession,
      options: Map[String, String],
      path: Path): Boolean
    ```

    `isSplitable` is part of the [FileFormat](../connectors/FileFormat.md#isSplitable) abstraction.

`ParquetFileFormat` is splitable (`true`).

## Building Data Reader With Partition Values { #buildReaderWithPartitionValues }

??? note "FileFormat"

    ```scala
    buildReaderWithPartitionValues(
      sparkSession: SparkSession,
      dataSchema: StructType,
      partitionSchema: StructType,
      requiredSchema: StructType,
      filters: Seq[Filter],
      options: Map[String, String],
      hadoopConf: Configuration): (PartitionedFile) => Iterator[InternalRow]
    ```

    `buildReaderWithPartitionValues` is part of the [FileFormat](../connectors/FileFormat.md#buildReaderWithPartitionValues) abstraction.

!!! FIXME
    Review Me

`buildReaderWithPartitionValues` sets the following configuration options in the input `hadoopConf`.

Name     | Value
---------|--------
parquet.read.support.class | [ParquetReadSupport](ParquetReadSupport.md)
org.apache.spark.sql.parquet.row.requested_schema | [JSON](../types/DataType.md#json) representation of `requiredSchema`
org.apache.spark.sql.parquet.row.attributes | [JSON](../types/DataType.md#json) representation of `requiredSchema`
spark.sql.session.timeZone | [spark.sql.session.timeZone](../configuration-properties.md#spark.sql.session.timeZone)
spark.sql.parquet.binaryAsString | [spark.sql.parquet.binaryAsString](../configuration-properties.md#spark.sql.parquet.binaryAsString)
spark.sql.parquet.int96AsTimestamp | [spark.sql.parquet.int96AsTimestamp](../configuration-properties.md#spark.sql.parquet.int96AsTimestamp)

`buildReaderWithPartitionValues` requests `ParquetWriteSupport` to `setSchema`.

`buildReaderWithPartitionValues` tries to push filters down to create a Parquet `FilterPredicate` (aka `pushed`).

With [spark.sql.parquet.filterPushdown](../configuration-properties.md#spark.sql.parquet.filterPushdown) configuration property enabled, `buildReaderWithPartitionValues` takes the input Spark data source `filters` and converts them to Parquet filter predicates if possible. Otherwise, the Parquet filter predicate is not specified.

!!! note
    `buildReaderWithPartitionValues` creates filter predicates for the following types: [BooleanType](../types/DataType.md#BooleanType), [IntegerType](../types/DataType.md#IntegerType), ([LongType](../types/DataType.md#LongType), [FloatType](../types/DataType.md#FloatType), [DoubleType](../types/DataType.md#DoubleType), [StringType](../types/DataType.md#StringType), [BinaryType](../types/DataType.md#BinaryType).

`buildReaderWithPartitionValues` broadcasts the input `hadoopConf` Hadoop `Configuration`.

In the end, `buildReaderWithPartitionValues` gives a function that takes a [PartitionedFile](../connectors/PartitionedFile.md) and does the following:

1. Creates a Hadoop `FileSplit` for the input `PartitionedFile`

1. Creates a Parquet `ParquetInputSplit` for the Hadoop `FileSplit` created

1. Gets the broadcast Hadoop `Configuration`

1. Creates a flag that says whether to apply timezone conversions to int96 timestamps or not (aka `convertTz`)

1. Creates a Hadoop `TaskAttemptContextImpl` (with the broadcast Hadoop `Configuration` and a Hadoop `TaskAttemptID` for a map task)

1. Sets the Parquet `FilterPredicate` (only when [spark.sql.parquet.filterPushdown](../configuration-properties.md#spark.sql.parquet.filterPushdown) configuration property is enabled and it is by default)

The function then branches off on whether [Parquet vectorized reader](VectorizedParquetRecordReader.md) is enabled or not.

With [Parquet vectorized reader](VectorizedParquetRecordReader.md) enabled, the function does the following:

* Creates a [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md) and a [RecordReaderIterator](../connectors/RecordReaderIterator.md)

* Requests `VectorizedParquetRecordReader` to [initialize](VectorizedParquetRecordReader.md#initialize) (with the Parquet `ParquetInputSplit` and the Hadoop `TaskAttemptContextImpl`)

* Prints out the following DEBUG message to the logs:

    ```text
    Appending [partitionSchema] [partitionValues]
    ```

* Requests `VectorizedParquetRecordReader` to [initBatch](VectorizedParquetRecordReader.md#initBatch)

* (only with [supportBatch](#supportBatch) enabled) Requests `VectorizedParquetRecordReader` to [enableReturningBatches](VectorizedParquetRecordReader.md#enableReturningBatches)

* In the end, the function gives the [RecordReaderIterator](../connectors/RecordReaderIterator.md) (over the `VectorizedParquetRecordReader`) as the `Iterator[InternalRow]`

With [Parquet vectorized reader](VectorizedParquetRecordReader.md) disabled, the function does the following:

* FIXME (since Parquet vectorized reader is enabled by default it's of less interest)

## supportBatch { #supportBatch }

??? note "FileFormat"

    ```scala
    supportBatch(
      sparkSession: SparkSession,
      schema: StructType): Boolean
    ```

    `supportBatch` is part of the [FileFormat](../connectors/FileFormat.md#supportBatch) abstraction.

!!! FIXME
    Review Me

`supportBatch` [supports vectorized parquet decoding in whole-stage code generation](../connectors/FileFormat.md#supportBatch) when the following all hold:

1. [spark.sql.parquet.enableVectorizedReader](../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) configuration property is enabled

1. [spark.sql.codegen.wholeStage](../configuration-properties.md#spark.sql.codegen.wholeStage) internal configuration property is enabled

1. The number of fields in the schema is at most [spark.sql.codegen.maxFields](../configuration-properties.md#spark.sql.codegen.maxFields) internal configuration property

1. All the fields in the output schema are of [AtomicType](../types/AtomicType.md)

## Vector Types { #vectorTypes }

??? note "FileFormat"

    ```scala
    vectorTypes(
      requiredSchema: StructType,
      partitionSchema: StructType,
      sqlConf: SQLConf): Option[Seq[String]]
    ```

    `vectorTypes` is part of the [FileFormat](../connectors/FileFormat.md#vectorTypes) abstraction.

!!! FIXME
    Review Me

`vectorTypes` creates a collection of the names of [OffHeapColumnVector](../vectorized-decoding/OffHeapColumnVector.md) or [OnHeapColumnVector](../vectorized-decoding/OnHeapColumnVector.md) when [spark.sql.columnVector.offheap.enabled](../configuration-properties.md#spark.sql.columnVector.offheap.enabled) property is enabled or disabled, respectively.

The size of the collection are all the fields of the given `requiredSchema` and `partitionSchema` schemas.

## mergeSchemasInParallel { #mergeSchemasInParallel }

```scala
mergeSchemasInParallel(
  parameters: Map[String, String],
  filesToTouch: Seq[FileStatus],
  sparkSession: SparkSession): Option[StructType]
```

`mergeSchemasInParallel` [mergeSchemasInParallel](../connectors/SchemaMergeUtils.md#mergeSchemasInParallel) with the given `filesToTouch` and a multi-threaded parquet footer reader.

!!! note "FIXME"
    Describe the multi-threaded parquet footer reader.

!!! note
    With the multi-threaded parquet footer reader, the whole `mergeSchemasInParallel` is distributed (using `RDD` while [mergeSchemasInParallel](../connectors/SchemaMergeUtils.md#mergeSchemasInParallel)) and multithreaded (per RDD partition).

---

`mergeSchemasInParallel` is used when:

* `ParquetUtils` is requested to [infer schema](ParquetUtils.md#inferSchema)

!!! note "Refactoring Needed?"
    `mergeSchemasInParallel` should be moved to `ParquetUtils` _if_ that's the only place it's called from, _huh?!_

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.parquet.ParquetFileFormat` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.ParquetFileFormat.name = org.apache.spark.sql.execution.datasources.parquet.ParquetFileFormat
logger.ParquetFileFormat.level = all
```

Refer to [Logging](../spark-logging.md).
