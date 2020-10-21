# FileFormat

`FileFormat` is an [abstraction](#contract) of [data sources](#implementations) that can [read](#buildReader) and [write](#prepareWrite) data stored in files.

## Contract

### <span id="buildReader"> Building Data Reader

```scala
buildReader(
  sparkSession: SparkSession,
  dataSchema: StructType,
  partitionSchema: StructType,
  requiredSchema: StructType,
  filters: Seq[Filter],
  options: Map[String, String],
  hadoopConf: Configuration): PartitionedFile => Iterator[InternalRow]
```

Builds a Catalyst data reader (a function that reads a single [PartitionedFile](PartitionedFile.md) file in to produce [InternalRow](InternalRow.md)s).

`buildReader` throws an `UnsupportedOperationException` by default (and should therefore be overriden to work):

```text
buildReader is not supported for [this]
```

Used when `FileFormat` is requested to [buildReaderWithPartitionValues](#buildReaderWithPartitionValues).

### <span id="inferSchema"> Inferring Schema

```scala
inferSchema(
  sparkSession: SparkSession,
  options: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
```

Infers the [schema](StructType.md) of the given files (as Hadoop [FileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)es) if supported. Otherwise, `None` should be returned.

Used when:

* `HiveMetastoreCatalog` is requested to [inferIfNeeded](hive/HiveMetastoreCatalog.md#inferIfNeeded)
* `DataSource` is requested to [getOrInferFileFormatSchema](DataSource.md#getOrInferFileFormatSchema) and [resolveRelation](DataSource.md#resolveRelation)

### <span id="isSplitable"> isSplitable

```scala
isSplitable(
  sparkSession: SparkSession,
  options: Map[String, String],
  path: Path): Boolean
```

Controls whether the format (under the given path as Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html)) is splittable or not

Default: `false`

Used when `FileSourceScanExec` physical operator is requested to [create an RDD for non-bucketed reads](physical-operators/FileSourceScanExec.md#createNonBucketedReadRDD) (when requested for the [inputRDD](physical-operators/FileSourceScanExec.md#inputRDD))

### <span id="prepareWrite"> Preparing Write

```scala
prepareWrite(
  sparkSession: SparkSession,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
```

Prepares a write job and returns an `OutputWriterFactory`

Used when `FileFormatWriter` utility is used to [write out a query result](FileFormatWriter.md#write)

### <span id="supportBatch"> supportBatch

```scala
supportBatch(
  sparkSession: SparkSession,
  dataSchema: StructType): Boolean
```

Controls whether the format supports [vectorized decoding](spark-sql-vectorized-parquet-reader.md) (aka _columnar batch_) or not

Default: `false`

Used when:

* `FileSourceScanExec` physical operator is requested for the [supportsBatch](physical-operators/FileSourceScanExec.md#supportsBatch) flag
* `OrcFileFormat` is requested to [buildReaderWithPartitionValues](OrcFileFormat.md#buildReaderWithPartitionValues)
* `ParquetFileFormat` is requested to [buildReaderWithPartitionValues](ParquetFileFormat.md#buildReaderWithPartitionValues)

### <span id="supportDataType"> supportDataType

```scala
supportDataType(
  dataType: DataType): Boolean
```

Controls whether this format supports the given [DataType](DataType.md) in read or write paths

Default: `true` (all data types are supported)

Used when `DataSourceUtils` is used to `verifySchema`

### <span id="vectorTypes"> Vector Types

```scala
vectorTypes(
  requiredSchema: StructType,
  partitionSchema: StructType,
  sqlConf: SQLConf): Option[Seq[String]]
```

Defines the fully-qualified class names (_types_) of the concrete [ColumnVector](ColumnVector.md)s for every column in the input `requiredSchema` and `partitionSchema` schemas (to use in columnar processing mode)

Default: `None` (undefined)

Used when `FileSourceScanExec` physical operator is requested for the [vectorTypes](physical-operators/FileSourceScanExec.md#vectorTypes)

## Implementations

* [AvroFileFormat](AvroFileFormat.md)
* BinaryFileFormat
* [HiveFileFormat](hive/HiveFileFormat.md)
* ImageFileFormat
* [OrcFileFormat](OrcFileFormat.md)
* [ParquetFileFormat](ParquetFileFormat.md)
* [TextBasedFileFormat](TextBasedFileFormat.md)

## <span id="buildReaderWithPartitionValues"> Building Data Reader With Partition Values

```scala
buildReaderWithPartitionValues(
  sparkSession: SparkSession,
  dataSchema: StructType,
  partitionSchema: StructType,
  requiredSchema: StructType,
  filters: Seq[Filter],
  options: Map[String, String],
  hadoopConf: Configuration): PartitionedFile => Iterator[InternalRow]
```

`buildReaderWithPartitionValues` builds a data reader with partition column values appended.

!!! note
    `buildReaderWithPartitionValues` is simply an enhanced [buildReader](#buildReader) that appends [partition column values](PartitionedFile.md#partitionValues) to the internal rows produced by the reader function.

`buildReaderWithPartitionValues` [builds a data reader](#buildReader) with the input parameters and gives a **data reader function** (of a [PartitionedFile](PartitionedFile.md) to an `Iterator[InternalRow]`) that does the following:

1. Creates a converter by requesting `GenerateUnsafeProjection` to [generate an UnsafeProjection](physical-operators/GenerateUnsafeProjection.md#generate) for the attributes of the input `requiredSchema` and `partitionSchema`

1. Applies the data reader to a `PartitionedFile` and converts the result using the converter on the joined row with the [partition column values](PartitionedFile.md#partitionValues) appended.

`buildReaderWithPartitionValues` is used when `FileSourceScanExec` physical operator is requested for the [inputRDD](physical-operators/FileSourceScanExec.md#inputRDD).
