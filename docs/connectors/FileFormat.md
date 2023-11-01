# FileFormat

`FileFormat` is an [abstraction](#contract) of [connectors](#implementations) that can [read](#buildReader) and [write](#prepareWrite) data stored in files.

## Contract

### Schema Inference { #inferSchema }

```scala
inferSchema(
  sparkSession: SparkSession,
  options: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
```

Infers the [schema](../types/StructType.md) of the given files (as Hadoop [FileStatus]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)es), if supported. Otherwise, `None` should be returned.

See:

* [ParquetFileFormat](../parquet/ParquetFileFormat.md#inferSchema)

Used when:

* `HiveMetastoreCatalog` is requested to [inferIfNeeded](../hive/HiveMetastoreCatalog.md#inferIfNeeded)
* `DataSource` is requested to [getOrInferFileFormatSchema](../DataSource.md#getOrInferFileFormatSchema) and [resolveRelation](../DataSource.md#resolveRelation)

### Preparing Write { #prepareWrite }

```scala
prepareWrite(
  sparkSession: SparkSession,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
```

Prepares a write job and returns an `OutputWriterFactory`

See:

* [ParquetFileFormat](../parquet/ParquetFileFormat.md#prepareWrite)

Used when:

* `FileFormatWriter` utility is used to [write out a query result](FileFormatWriter.md#write)

## Implementations

* [AvroFileFormat](../avro/AvroFileFormat.md)
* `BinaryFileFormat`
* [HiveFileFormat](../hive/HiveFileFormat.md)
* `ImageFileFormat`
* `OrcFileFormat`
* [ParquetFileFormat](../parquet/ParquetFileFormat.md)
* `TextBasedFileFormat`

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

1. Creates a converter by requesting `GenerateUnsafeProjection` to [generate an UnsafeProjection](../whole-stage-code-generation/GenerateUnsafeProjection.md#generate) for the attributes of the input `requiredSchema` and `partitionSchema`

1. Applies the data reader to a `PartitionedFile` and converts the result using the converter on the joined row with the [partition column values](PartitionedFile.md#partitionValues) appended.

`buildReaderWithPartitionValues` is used when `FileSourceScanExec` physical operator is requested for the [inputRDD](../physical-operators/FileSourceScanExec.md#inputRDD).

## createFileMetadataCol { #createFileMetadataCol }

```scala
createFileMetadataCol(
  fileFormat: FileFormat): AttributeReference
```

`createFileMetadataCol`...FIXME

---

`createFileMetadataCol` is used when:

* `LogicalRelation` logical operator is requested for the [metadataOutput](../logical-operators/LogicalRelation.md#metadataOutput)
* `StreamingRelation` ([Spark Structured Streaming]({{ book.structured_streaming }}/logical-operators/StreamingRelation)) logical operator is requested for the `metadataOutput`

## Building Data Reader { #buildReader }

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

Builds a Catalyst data reader (a function that reads a single [PartitionedFile](PartitionedFile.md) file in to produce [InternalRow](../InternalRow.md)s).

`buildReader` throws an `UnsupportedOperationException` by default (and should therefore be overriden to work):

```text
buildReader is not supported for [this]
```

Used when:

* `FileFormat` is requested to [buildReaderWithPartitionValues](#buildReaderWithPartitionValues)

## isSplitable { #isSplitable }

```scala
isSplitable(
  sparkSession: SparkSession,
  options: Map[String, String],
  path: Path): Boolean
```

Controls whether this format (under the given Hadoop [Path]({{ hadoop.api }}/org/apache/hadoop/fs/Path.html) and the `options`) is splittable or not

Default: `false`

Always splitable:

* [AvroFileFormat](../avro/AvroFileFormat.md#isSplitable)
* `OrcFileFormat`
* [ParquetFileFormat](../parquet/ParquetFileFormat.md#isSplitable)

Never splitable:

* `BinaryFileFormat`

Used when:

* `FileSourceScanExec` physical operator is requested to [create an RDD for a non-bucketed read](../physical-operators/FileSourceScanExec.md#createNonBucketedReadRDD) (when requested for the [inputRDD](../physical-operators/FileSourceScanExec.md#inputRDD))

## supportBatch { #supportBatch }

```scala
supportBatch(
  sparkSession: SparkSession,
  dataSchema: StructType): Boolean
```

Whether this format supports [vectorized decoding](../vectorized-decoding/index.md) or not

Default: `false`

Used when:

* `FileSourceScanExec` physical operator is requested for the [supportsBatch](../physical-operators/FileSourceScanExec.md#supportsBatch) flag
* `OrcFileFormat` is requested to `buildReaderWithPartitionValues`
* `ParquetFileFormat` is requested to [buildReaderWithPartitionValues](../parquet/ParquetFileFormat.md#buildReaderWithPartitionValues)

## supportDataType { #supportDataType }

```scala
supportDataType(
  dataType: DataType): Boolean
```

Controls whether this format supports the given [DataType](../types/DataType.md) in read or write paths

Default: `true` (all data types are supported)

Used when:

* `DataSourceUtils` is used to `verifySchema`

## supportFieldName { #supportFieldName }

```scala
supportFieldName(
  name: String): Boolean
```

`supportFieldName` controls whether this format supports the given field name in read or write paths.

`supportFieldName` is `true` (all field names are supported) by default.

See:

* `DeltaParquetFileFormat` ([Delta Lake]({{ book.delta }}/DeltaParquetFileFormat/#supportFieldName))

---

`supportFieldName` is used when:

* `DataSourceUtils` is requested to [checkFieldNames](DataSourceUtils.md#checkFieldNames)

## Vector Types { #vectorTypes }

```scala
vectorTypes(
  requiredSchema: StructType,
  partitionSchema: StructType,
  sqlConf: SQLConf): Option[Seq[String]]
```

Defines the fully-qualified class names (_types_) of the concrete [ColumnVector](../vectorized-decoding/ColumnVector.md)s for every column in the input `requiredSchema` and `partitionSchema` schemas (to use in columnar processing mode)

Default: `None` (undefined)

Used when:

* `FileSourceScanExec` physical operator is requested for the [vectorTypes](../physical-operators/FileSourceScanExec.md#vectorTypes)

## <span id="BASE_METADATA_FIELDS"> Metadata Schema (Fields) { #metadataSchemaFields }

```scala
metadataSchemaFields: Seq[StructField]
```

`metadataSchemaFields` is the following schema of non-`nullable` **constant metadata columns**.

Name | Data Type
-----|----------
 `file_path` | `StringType`
 `file_name` | `StringType`
 `file_size` | `LongType`
 `file_block_start` | `LongType`
 `file_block_length` | `LongType`
 `file_modification_time` | `TimestampType`

See:

* [ParquetFileFormat](../parquet/ParquetFileFormat.md#metadataSchemaFields)
* `DeltaParquetFileFormat` ([Delta Lake]({{ book.delta }}/DeltaParquetFileFormat/#metadataSchemaFields))

---

`metadataSchemaFields` is used when:

* `FileFormat` is requested to [createFileMetadataCol](#createFileMetadataCol)
* [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy is executed
