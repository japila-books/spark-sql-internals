# ParquetPartitionReaderFactory

`ParquetPartitionReaderFactory` is a [FilePartitionReaderFactory](../FilePartitionReaderFactory.md).

## Creating Instance

`ParquetPartitionReaderFactory` takes the following to be created:

* <span id="sqlConf"> [SQLConf](../../SQLConf.md)
* <span id="broadcastedConf"> Broadcast variable with a Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
* <span id="dataSchema"> Data [schema](../../types/StructType.md)
* <span id="readDataSchema"> Read data [schema](../../types/StructType.md)
* <span id="partitionSchema"> Partition [schema](../../types/StructType.md)
* <span id="filters"> [Filter](../../Filter.md)s
* <span id="parquetOptions"> [ParquetOptions](ParquetOptions.md)

`ParquetPartitionReaderFactory` is created when:

* `ParquetScan` is requested to [create a PartitionReaderFactory](ParquetScan.md#createReaderFactory)

## <span id="supportColumnarReads"> supportColumnarReads

```scala
supportColumnarReads(
  partition: InputPartition): Boolean
```

`supportColumnarReads` is part of the [PartitionReaderFactory](../../connector/PartitionReaderFactory.md#supportColumnarReads) abstraction.

---

`supportColumnarReads` is enabled (`true`) when the following all hold:

1. [spark.sql.parquet.enableVectorizedReader](../../configuration-properties.md#spark.sql.parquet.enableVectorizedReader)
1. [spark.sql.codegen.wholeStage](../../configuration-properties.md#spark.sql.codegen.wholeStage)
1. The number of the [resultSchema](#resultSchema) fields is at most [spark.sql.codegen.maxFields](../../configuration-properties.md#spark.sql.codegen.maxFields)
1. All the [resultSchema](#resultSchema) fields are [AtomicType](../../types/AtomicType.md)s

## <span id="buildColumnarReader"> Building Columnar Reader

```scala
buildColumnarReader(
  file: PartitionedFile): PartitionReader[ColumnarBatch]
```

`buildColumnarReader` is part of the [FilePartitionReaderFactory](../FilePartitionReaderFactory.md#buildColumnarReader) abstraction.

---

`buildColumnarReader` [createVectorizedReader](#createVectorizedReader) (for the given [PartitionedFile](../PartitionedFile.md)) and requests it to [enableReturningBatches](VectorizedParquetRecordReader.md#enableReturningBatches).

In the end, `buildColumnarReader` returns a [PartitionReader](../../connector/PartitionReader.md) that returns [ColumnarBatch](../../ColumnarBatch.md)es (when [requested for records](../../connector/PartitionReader.md#get)).

## <span id="buildReader"> Building PartitionReader

```scala
buildReader(
  file: PartitionedFile): PartitionReader[InternalRow]
```

`buildReader` determines a Hadoop [RecordReader]({{ hadoop.api }}/org/apache/hadoop/mapred/RecordReader.html) to use based on the [enableVectorizedReader](#enableVectorizedReader) flag. When enabled, `buildReader` [createVectorizedReader](#createVectorizedReader) and [createRowBaseReader](#createRowBaseReader) otherwise.

In the end, `buildReader` creates a `PartitionReaderWithPartitionValues` (that is a [PartitionReader](../../connector/PartitionReader.md) with partition values appended).

---

`buildReader` is part of the [FilePartitionReaderFactory](../FilePartitionReaderFactory.md#buildReader) abstraction.

### <span id="enableVectorizedReader"> enableVectorizedReader

`ParquetPartitionReaderFactory` uses `enableVectorizedReader` flag to determines a Hadoop [RecordReader]({{ hadoop.api }}/org/apache/hadoop/mapred/RecordReader.html) to use when requested for a [PartitionReader](#buildReader).

`enableVectorizedReader` is enabled (`true`) when the following hold:

1. [spark.sql.parquet.enableVectorizedReader](../../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) is `true`
1. All data types in the [resultSchema](#resultSchema) are [AtomicType](../../types/AtomicType.md)s

### <span id="createRowBaseReader"> Creating Row-Based RecordReader

```scala
createRowBaseReader(
  file: PartitionedFile): RecordReader[Void, InternalRow]
```

`createRowBaseReader` [buildReaderBase](#buildReaderBase) (for the given [PartitionedFile](../PartitionedFile.md) and [createRowBaseParquetReader](#createRowBaseParquetReader)).

## <span id="createVectorizedReader"> Creating Vectorized Parquet RecordReader

```scala
createVectorizedReader(
  file: PartitionedFile): VectorizedParquetRecordReader
```

`createVectorizedReader` [buildReaderBase](#buildReaderBase) (for the given [PartitionedFile](../PartitionedFile.md) and [createParquetVectorizedReader](#createParquetVectorizedReader)).

In the end, `createVectorizedReader` requests the [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md) to [initBatch](VectorizedParquetRecordReader.md#initBatch) (with the [partitionSchema](#partitionSchema) and the [partitionValues](../PartitionedFile.md#partitionValues) of the given [PartitionedFile](../PartitionedFile.md)) and returns it.

`createVectorizedReader` is used when:

* `ParquetPartitionReaderFactory` is requested to [buildReader](#buildReader) and [buildColumnarReader](#buildColumnarReader)

## <span id="buildReaderBase"> buildReaderBase

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

`buildReaderBase` is used when:

* `ParquetPartitionReaderFactory` is requested to [createRowBaseReader](#createRowBaseReader) and [createVectorizedReader](#createVectorizedReader)
