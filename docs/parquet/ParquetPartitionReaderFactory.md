# ParquetPartitionReaderFactory

`ParquetPartitionReaderFactory` is a [FilePartitionReaderFactory](../files/FilePartitionReaderFactory.md) (of [ParquetScan](ParquetScan.md#createReaderFactory)) for batch queries in [Parquet Connector](index.md).

## Creating Instance

`ParquetPartitionReaderFactory` takes the following to be created:

* <span id="sqlConf"> [SQLConf](../SQLConf.md)
* <span id="broadcastedConf"> Broadcast variable with a Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
* <span id="dataSchema"> Data [schema](../types/StructType.md)
* <span id="readDataSchema"> Read data [schema](../types/StructType.md)
* <span id="partitionSchema"> Partition [schema](../types/StructType.md)
* <span id="filters"> [Filter](../Filter.md)s
* <span id="aggregation"> [Aggregation](../connector/expressions/Aggregation.md)
* <span id="options"> [ParquetOptions](ParquetOptions.md)

`ParquetPartitionReaderFactory` is created when:

* `ParquetScan` is requested for a [PartitionReaderFactory](ParquetScan.md#createReaderFactory)

### enableVectorizedReader { #enableVectorizedReader }

`ParquetPartitionReaderFactory` defines `enableVectorizedReader` internal flag to indicate whether [isBatchReadSupported](ParquetUtils.md#isBatchReadSupportedForSchema) for the [resultSchema](#resultSchema) or not.

`enableVectorizedReader` internal flag is used for the following:

* Indicate whether `ParquetPartitionReaderFactory` [supportsColumnar](#supportsColumnar)
* [Creating a vectorized parquet RecordReader](#createVectorizedReader) when requested for a [PartitionReader](#buildReader)

`ParquetPartitionReaderFactory` uses `enableVectorizedReader` flag to determine a Hadoop [RecordReader]({{ hadoop.api }}/org/apache/hadoop/mapred/RecordReader.html) to use when requested for a [PartitionReader](#buildReader).

## <span id="spark.sql.columnVector.offheap.enabled"> columnVector.offheap.enabled { #enableOffHeapColumnVector }

`ParquetPartitionReaderFactory` uses [spark.sql.columnVector.offheap.enabled](../configuration-properties.md#spark.sql.columnVector.offheap.enabled) configuration property when requested for the following:

* [Create a Vectorized Reader](#createParquetVectorizedReader) (and create a [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md#useOffHeap))
* [Build a Columnar Reader](#buildColumnarReader) (and `convertAggregatesRowToBatch`)

## <span id="supportsColumnar"> supportColumnarReads { #supportColumnarReads }

??? note "Signature"

    ```scala
    supportColumnarReads(
      partition: InputPartition): Boolean
    ```

    `supportColumnarReads` is part of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md#supportColumnarReads) abstraction.

`ParquetPartitionReaderFactory` supports columnar reads when the following all hold:

1. [spark.sql.parquet.enableVectorizedReader](../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) is enabled
1. [spark.sql.codegen.wholeStage](../configuration-properties.md#spark.sql.codegen.wholeStage) is enabled
1. The number of the [resultSchema](#resultSchema) fields is at most [spark.sql.codegen.maxFields](../configuration-properties.md#spark.sql.codegen.maxFields)

## Building Columnar PartitionReader { #buildColumnarReader }

??? note "Signature"

    ```scala
    buildColumnarReader(
      file: PartitionedFile): PartitionReader[ColumnarBatch]
    ```

    `buildColumnarReader` is part of the [FilePartitionReaderFactory](../files/FilePartitionReaderFactory.md#buildColumnarReader) abstraction.

`buildColumnarReader` [createVectorizedReader](#createVectorizedReader) (for the given [PartitionedFile](../files/PartitionedFile.md)) and requests it to [enableReturningBatches](VectorizedParquetRecordReader.md#enableReturningBatches).

In the end, `buildColumnarReader` returns a [PartitionReader](../connector/PartitionReader.md) that returns [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md)es (when [requested for records](../connector/PartitionReader.md#get)).

## Building PartitionReader { #buildReader }

??? note "Signature"

    ```scala
    buildReader(
      file: PartitionedFile): PartitionReader[InternalRow]
    ```

    `buildReader` is part of the [FilePartitionReaderFactory](../files/FilePartitionReaderFactory.md#buildReader) abstraction.

`buildReader` determines a Hadoop [RecordReader]({{ hadoop.api }}/org/apache/hadoop/mapred/RecordReader.html) to use based on the [enableVectorizedReader](#enableVectorizedReader) flag. When enabled, `buildReader` [createVectorizedReader](#createVectorizedReader) and [createRowBaseReader](#createRowBaseReader) otherwise.

In the end, `buildReader` creates a `PartitionReaderWithPartitionValues` (that is a [PartitionReader](../connector/PartitionReader.md) with partition values appended).

### Creating Row-Based RecordReader { #createRowBaseReader }

```scala
createRowBaseReader(
  file: PartitionedFile): RecordReader[Void, InternalRow]
```

`createRowBaseReader` [buildReaderBase](#buildReaderBase) for the given [PartitionedFile](../files/PartitionedFile.md) and with [createRowBaseParquetReader](#createRowBaseParquetReader) factory.

### createRowBaseParquetReader { #createRowBaseParquetReader }

```scala
createRowBaseParquetReader(
  partitionValues: InternalRow,
  pushed: Option[FilterPredicate],
  convertTz: Option[ZoneId],
  datetimeRebaseSpec: RebaseSpec,
  int96RebaseSpec: RebaseSpec): RecordReader[Void, InternalRow]
```

`createRowBaseParquetReader` prints out the following DEBUG message to the logs:

```text
Falling back to parquet-mr
```

`createRowBaseParquetReader` creates a [ParquetReadSupport](ParquetReadSupport.md) (with [enableVectorizedReader](ParquetReadSupport.md#enableVectorizedReader) flag disabled).

`createRowBaseParquetReader` creates a [RecordReaderIterator](../files/RecordReaderIterator.md) with a new `ParquetRecordReader`.

In the end, `createRowBaseParquetReader` returns the `ParquetRecordReader`.

## Creating Vectorized Parquet RecordReader { #createVectorizedReader }

```scala
createVectorizedReader(
  file: PartitionedFile): VectorizedParquetRecordReader
```

`createVectorizedReader` [buildReaderBase](#buildReaderBase) (for the given [PartitionedFile](../files/PartitionedFile.md) and [createParquetVectorizedReader](#createParquetVectorizedReader)).

In the end, `createVectorizedReader` requests the [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md) to [initBatch](VectorizedParquetRecordReader.md#initBatch) (with the [partitionSchema](#partitionSchema) and the [partitionValues](../files/PartitionedFile.md#partitionValues) of the given [PartitionedFile](../files/PartitionedFile.md)) and returns it.

---

`createVectorizedReader` is used when `ParquetPartitionReaderFactory` is requested for the following:

* [Build a partition reader (for a file)](#buildReader) (with [enableVectorizedReader](#enableVectorizedReader) enabled)
* [Build a columnar partition reader (for a file)](#buildColumnarReader)

### createParquetVectorizedReader { #createParquetVectorizedReader }

```scala
createParquetVectorizedReader(
  partitionValues: InternalRow,
  pushed: Option[FilterPredicate],
  convertTz: Option[ZoneId],
  datetimeRebaseSpec: RebaseSpec,
  int96RebaseSpec: RebaseSpec): VectorizedParquetRecordReader
```

`createParquetVectorizedReader` creates a [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md) (with [capacity](#capacity)).

`createParquetVectorizedReader` creates a [RecordReaderIterator](../files/RecordReaderIterator.md) (for the `VectorizedParquetRecordReader`).

`createParquetVectorizedReader` prints out the following DEBUG message to the logs (with the [partitionSchema](#partitionSchema) and the given `partitionValues`):

```text
Appending [partitionSchema] [partitionValues]
```

In the end, `createParquetVectorizedReader` returns the `VectorizedParquetRecordReader`.

??? note "Unused RecordReaderIterator?"
    It appears that the `RecordReaderIterator` is created but not used. _Feeling confused_.

## buildReaderBase { #buildReaderBase }

```scala
buildReaderBase[T](
  file: PartitionedFile,
  buildReaderFunc: (
    FileSplit,
    InternalRow,
    TaskAttemptContextImpl,
    Option[FilterPredicate],
    Option[ZoneId],
    RebaseSpec,
    RebaseSpec) => RecordReader[Void, T]): RecordReader[Void, T]
```

`buildReaderBase`...FIXME

---

`buildReaderBase` is used when:

* `ParquetPartitionReaderFactory` is requested to [createRowBaseReader](#createRowBaseReader) and [createVectorizedReader](#createVectorizedReader)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.v2.parquet.ParquetPartitionReaderFactory` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.ParquetPartitionReaderFactory.name = org.apache.spark.sql.execution.datasources.v2.parquet.ParquetPartitionReaderFactory
logger.ParquetPartitionReaderFactory.level = all
```

Refer to [Logging](../spark-logging.md).
