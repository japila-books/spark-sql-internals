# ParquetFileFormat

[[shortName]]
`ParquetFileFormat` is the [FileFormat](../FileFormat.md) for **parquet** data source (i.e. [registers itself to handle files in parquet format](../../DataSourceRegister.md#shortName) and converts them to Spark SQL rows).

NOTE: `parquet` is the [default data source format](../../DataFrameReader.md#source) in Spark SQL.

!!! note
    [Apache Parquet](http://parquet.apache.org/) is a columnar storage format for the Apache Hadoop ecosystem with support for efficient storage and encoding of data.

```text
// All the following queries are equivalent
// schema has to be specified manually
import org.apache.spark.sql.types.StructType
val schema = StructType($"id".int :: Nil)

spark.read.schema(schema).format("parquet").load("parquet-datasets")

// The above is equivalent to the following shortcut
// Implicitly does format("parquet").load
spark.read.schema(schema).parquet("parquet-datasets")

// parquet is the default data source format
spark.read.schema(schema).load("parquet-datasets")
```

[[isSplitable]]
`ParquetFileFormat` is [splitable](../FileFormat.md#isSplitable), i.e. FIXME

[[supportBatch]]
`ParquetFileFormat` [supports vectorized parquet decoding in whole-stage code generation](../FileFormat.md#supportBatch) when all of the following hold:

* [spark.sql.parquet.enableVectorizedReader](../../configuration-properties.md#spark.sql.parquet.enableVectorizedReader) configuration property is enabled

* [spark.sql.codegen.wholeStage](../../configuration-properties.md#spark.sql.codegen.wholeStage) internal configuration property is enabled

* The number of fields in the schema is at most [spark.sql.codegen.maxFields](../../configuration-properties.md#spark.sql.codegen.maxFields) internal configuration property

* All the fields in the output schema are of [AtomicType](../../DataType.md#AtomicType)

`ParquetFileFormat` supports *filter predicate push-down optimization* (via <<createFilter, createFilter>>) as per the following <<ParquetFilters, table>>.

[[ParquetFilters]]
.Spark Data Source Filters to Parquet Filter Predicates Conversions (aka `ParquetFilters.createFilter`)
[cols="1m,2",options="header",width="100%"]
|===
| Data Source Filter
| Parquet FilterPredicate

| IsNull
| [[IsNull]] `FilterApi.eq`

| IsNotNull
| [[IsNotNull]] `FilterApi.notEq`

| EqualTo
| [[EqualTo]] `FilterApi.eq`

| Not EqualTo
| [[NotEqualTo]] `FilterApi.notEq`

| EqualNullSafe
| [[EqualNullSafe]] `FilterApi.eq`

| Not EqualNullSafe
| [[NotEqualNullSafe]] `FilterApi.notEq`

| LessThan
| [[LessThan]] `FilterApi.lt`

| LessThanOrEqual
| [[LessThanOrEqual]] `FilterApi.ltEq`

| GreaterThan
| [[GreaterThan]] `FilterApi.gt`

| GreaterThanOrEqual
| [[GreaterThanOrEqual]] `FilterApi.gtEq`

| And
| [[And]] `FilterApi.and`

| Or
| [[Or]] `FilterApi.or`

| No
| [[Not]] `FilterApi.not`
|===

[[logging]]
[TIP]
====
Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.parquet.ParquetFileFormat` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.parquet.ParquetFileFormat=ALL
```

Refer to <<spark-logging.md#, Logging>>.
====

=== [[prepareWrite]] Preparing Write Job -- `prepareWrite` Method

[source, scala]
----
prepareWrite(
  sparkSession: SparkSession,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
----

`prepareWrite`...FIXME

`prepareWrite` is part of the [FileFormat](../FileFormat.md#prepareWrite) abstraction.

=== [[inferSchema]] `inferSchema` Method

[source, scala]
----
inferSchema(
  sparkSession: SparkSession,
  parameters: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
----

`inferSchema`...FIXME

`inferSchema` is part of the [FileFormat](../FileFormat.md#inferSchema) abstraction.

=== [[vectorTypes]] `vectorTypes` Method

[source, scala]
----
vectorTypes(
  requiredSchema: StructType,
  partitionSchema: StructType,
  sqlConf: SQLConf): Option[Seq[String]]
----

`vectorTypes` creates a collection of the names of [OffHeapColumnVector](../../OffHeapColumnVector.md) or [OnHeapColumnVector](../../OnHeapColumnVector.md) when [spark.sql.columnVector.offheap.enabled](../../configuration-properties.md#spark.sql.columnVector.offheap.enabled) property is enabled or disabled, respectively.

The size of the collection are all the fields of the given `requiredSchema` and `partitionSchema` schemas.

`vectorTypes` is part of the [FileFormat](../FileFormat.md#vectorTypes) abstraction.

=== [[buildReaderWithPartitionValues]] Building Data Reader With Partition Column Values Appended -- `buildReaderWithPartitionValues` Method

[source, scala]
----
buildReaderWithPartitionValues(
  sparkSession: SparkSession,
  dataSchema: StructType,
  partitionSchema: StructType,
  requiredSchema: StructType,
  filters: Seq[Filter],
  options: Map[String, String],
  hadoopConf: Configuration): (PartitionedFile) => Iterator[InternalRow]
----

`buildReaderWithPartitionValues` is part of the [FileFormat](../FileFormat.md#buildReaderWithPartitionValues) abstraction.

`buildReaderWithPartitionValues` sets the <<options, configuration options>> in the input `hadoopConf`.

[[options]]
.Hadoop Configuration Options
[cols="1m,3",options="header",width="100%"]
|===
| Name
| Value

| parquet.read.support.class
| [[parquet.read.support.class]] [ParquetReadSupport](ParquetReadSupport.md)

| org.apache.spark.sql.parquet.row.requested_schema
| [[org.apache.spark.sql.parquet.row.requested_schema]] [JSON](../../DataType.md#json) representation of `requiredSchema`

| org.apache.spark.sql.parquet.row.attributes
| [[org.apache.spark.sql.parquet.row.attributes]] [JSON](../../DataType.md#json) representation of `requiredSchema`

| spark.sql.session.timeZone
| [[spark.sql.session.timeZone]] [spark.sql.session.timeZone](../../configuration-properties.md#spark.sql.session.timeZone)

| spark.sql.parquet.binaryAsString
| [[spark.sql.parquet.binaryAsString]] [spark.sql.parquet.binaryAsString](../../configuration-properties.md#spark.sql.parquet.binaryAsString)

| spark.sql.parquet.int96AsTimestamp
| [[spark.sql.parquet.int96AsTimestamp]] [spark.sql.parquet.int96AsTimestamp](../../configuration-properties.md#spark.sql.parquet.int96AsTimestamp)

|===

`buildReaderWithPartitionValues` requests `ParquetWriteSupport` to `setSchema`.

`buildReaderWithPartitionValues` tries to push filters down to create a Parquet `FilterPredicate` (aka `pushed`).

!!! note
    Filter predicate push-down optimization for parquet data sources uses [spark.sql.parquet.filterPushdown](../../configuration-properties.md#spark.sql.parquet.filterPushdown) configuration property (default: enabled).

With [spark.sql.parquet.filterPushdown](../../configuration-properties.md#spark.sql.parquet.filterPushdown) configuration property enabled, `buildReaderWithPartitionValues` takes the input Spark data source `filters` and converts them to Parquet filter predicates if possible (as described in the <<ParquetFilters, table>>). Otherwise, the Parquet filter predicate is not specified.

!!! note
    `buildReaderWithPartitionValues` creates filter predicates for the following types: [BooleanType](../../DataType.md#BooleanType), [IntegerType](../../DataType.md#IntegerType), ([LongType](../../DataType.md#LongType), [FloatType](../../DataType.md#FloatType), [DoubleType](../../DataType.md#DoubleType), [StringType](../../DataType.md#StringType), [BinaryType](../../DataType.md#BinaryType).

`buildReaderWithPartitionValues` broadcasts the input `hadoopConf` Hadoop `Configuration`.

In the end, `buildReaderWithPartitionValues` gives a function that takes a [PartitionedFile](../../PartitionedFile.md) and does the following:

. Creates a Hadoop `FileSplit` for the input `PartitionedFile`

. Creates a Parquet `ParquetInputSplit` for the Hadoop `FileSplit` created

. Gets the broadcast Hadoop `Configuration`

. Creates a flag that says whether to apply timezone conversions to int96 timestamps or not (aka `convertTz`)

. Creates a Hadoop `TaskAttemptContextImpl` (with the broadcast Hadoop `Configuration` and a Hadoop `TaskAttemptID` for a map task)

. Sets the Parquet `FilterPredicate` (only when [spark.sql.parquet.filterPushdown](../../configuration-properties.md#spark.sql.parquet.filterPushdown) configuration property is enabled and it is by default)

The function then branches off on whether [Parquet vectorized reader](VectorizedParquetRecordReader.md) is enabled or not.

With [Parquet vectorized reader](VectorizedParquetRecordReader.md) enabled, the function does the following:

* Creates a [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md) and a [RecordReaderIterator](../../RecordReaderIterator.md)

* Requests `VectorizedParquetRecordReader` to [initialize](VectorizedParquetRecordReader.md#initialize) (with the Parquet `ParquetInputSplit` and the Hadoop `TaskAttemptContextImpl`)

* Prints out the following DEBUG message to the logs:

    ```text
    Appending [partitionSchema] [partitionValues]
    ```

* Requests `VectorizedParquetRecordReader` to [initBatch](VectorizedParquetRecordReader.md#initBatch)

* (only with <<supportBatch, supportBatch>> enabled) Requests `VectorizedParquetRecordReader` to [enableReturningBatches](VectorizedParquetRecordReader.md#enableReturningBatches)

* In the end, the function gives the [RecordReaderIterator](../../RecordReaderIterator.md) (over the `VectorizedParquetRecordReader`) as the `Iterator[InternalRow]`

With [Parquet vectorized reader](VectorizedParquetRecordReader.md) disabled, the function does the following:

* FIXME (since Parquet vectorized reader is enabled by default it's of less interest currently)

=== [[mergeSchemasInParallel]] `mergeSchemasInParallel` Method

[source, scala]
----
mergeSchemasInParallel(
  filesToTouch: Seq[FileStatus],
  sparkSession: SparkSession): Option[StructType]
----

`mergeSchemasInParallel`...FIXME

NOTE: `mergeSchemasInParallel` is used when...FIXME
