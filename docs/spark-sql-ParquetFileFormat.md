# ParquetFileFormat

[[shortName]]
`ParquetFileFormat` is the [FileFormat](FileFormat.md) for **parquet** data source (i.e. [registers itself to handle files in parquet format](spark-sql-DataSourceRegister.md#shortName) and converts them to Spark SQL rows).

NOTE: `parquet` is the [default data source format](DataFrameReader.md#source) in Spark SQL.

NOTE: http://parquet.apache.org/[Apache Parquet] is a columnar storage format for the Apache Hadoop ecosystem with support for efficient storage and encoding of data.

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
`ParquetFileFormat` is [splitable](FileFormat.md#isSplitable), i.e. FIXME

[[supportBatch]]
`ParquetFileFormat` [supports vectorized parquet decoding in whole-stage code generation](FileFormat.md#supportBatch) when all of the following hold:

* [spark.sql.parquet.enableVectorizedReader](spark-sql-properties.md#spark.sql.parquet.enableVectorizedReader) configuration property is enabled

* [spark.sql.codegen.wholeStage](spark-sql-properties.md#spark.sql.codegen.wholeStage) internal configuration property is enabled

* The number of fields in the schema is at most [spark.sql.codegen.maxFields](spark-sql-properties.md#spark.sql.codegen.maxFields) internal configuration property

* All the fields in the output schema are of [AtomicType](spark-sql-DataType.md#AtomicType)

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

`prepareWrite` is part of the [FileFormat](FileFormat.md#prepareWrite) abstraction.

=== [[inferSchema]] `inferSchema` Method

[source, scala]
----
inferSchema(
  sparkSession: SparkSession,
  parameters: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
----

`inferSchema`...FIXME

`inferSchema` is part of the [FileFormat](FileFormat.md#inferSchema) abstraction.

=== [[vectorTypes]] `vectorTypes` Method

[source, scala]
----
vectorTypes(
  requiredSchema: StructType,
  partitionSchema: StructType,
  sqlConf: SQLConf): Option[Seq[String]]
----

`vectorTypes` creates a collection of the names of <<spark-sql-OffHeapColumnVector.md#, OffHeapColumnVector>> or <<spark-sql-OnHeapColumnVector.md#, OnHeapColumnVector>> when <<spark-sql-properties.md#spark.sql.columnVector.offheap.enabled, spark.sql.columnVector.offheap.enabled>> property is enabled or disabled, respectively.

<<spark-sql-properties.md#spark.sql.columnVector.offheap.enabled, spark.sql.columnVector.offheap.enabled>> property is disabled (`false`) by default.

The size of the collection are all the fields of the given `requiredSchema` and `partitionSchema` schemas.

`vectorTypes` is part of the [FileFormat](FileFormat.md#vectorTypes) abstraction.

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

`buildReaderWithPartitionValues` is part of the [FileFormat](FileFormat.md#buildReaderWithPartitionValues) abstraction.

`buildReaderWithPartitionValues` sets the <<options, configuration options>> in the input `hadoopConf`.

[[options]]
.Hadoop Configuration Options
[cols="1m,3",options="header",width="100%"]
|===
| Name
| Value

| parquet.read.support.class
| [[parquet.read.support.class]] <<spark-sql-ParquetReadSupport.md#, ParquetReadSupport>>

| org.apache.spark.sql.parquet.row.requested_schema
| [[org.apache.spark.sql.parquet.row.requested_schema]] spark-sql-DataType.md#json[JSON] representation of `requiredSchema`

| org.apache.spark.sql.parquet.row.attributes
| [[org.apache.spark.sql.parquet.row.attributes]] spark-sql-DataType.md#json[JSON] representation of `requiredSchema`

| spark.sql.session.timeZone
| [[spark.sql.session.timeZone]] <<spark-sql-properties.md#spark.sql.session.timeZone, spark.sql.session.timeZone>>

| spark.sql.parquet.binaryAsString
| [[spark.sql.parquet.binaryAsString]] <<spark-sql-properties.md#spark.sql.parquet.binaryAsString, spark.sql.parquet.binaryAsString>>

| spark.sql.parquet.int96AsTimestamp
| [[spark.sql.parquet.int96AsTimestamp]] <<spark-sql-properties.md#spark.sql.parquet.int96AsTimestamp, spark.sql.parquet.int96AsTimestamp>>

|===

`buildReaderWithPartitionValues` requests `ParquetWriteSupport` to `setSchema`.

`buildReaderWithPartitionValues` tries to push filters down to create a Parquet `FilterPredicate` (aka `pushed`).

NOTE: Filter predicate push-down optimization for parquet data sources uses spark-sql-properties.md#spark.sql.parquet.filterPushdown[spark.sql.parquet.filterPushdown] configuration property (default: enabled).

With spark-sql-properties.md#spark.sql.parquet.filterPushdown[spark.sql.parquet.filterPushdown] configuration property enabled, `buildReaderWithPartitionValues` takes the input Spark data source `filters` and converts them to Parquet filter predicates if possible (as described in the <<ParquetFilters, table>>). Otherwise, the Parquet filter predicate is not specified.

NOTE: `buildReaderWithPartitionValues` creates filter predicates for the following types: spark-sql-DataType.md#BooleanType[BooleanType], spark-sql-DataType.md#IntegerType[IntegerType], spark-sql-DataType.md#LongType[LongType], spark-sql-DataType.md#FloatType[FloatType], spark-sql-DataType.md#DoubleType[DoubleType], spark-sql-DataType.md#StringType[StringType], spark-sql-DataType.md#BinaryType[BinaryType].

`buildReaderWithPartitionValues` broadcasts the input `hadoopConf` Hadoop `Configuration`.

In the end, `buildReaderWithPartitionValues` gives a function that takes a spark-sql-PartitionedFile.md[PartitionedFile] and does the following:

. Creates a Hadoop `FileSplit` for the input `PartitionedFile`

. Creates a Parquet `ParquetInputSplit` for the Hadoop `FileSplit` created

. Gets the broadcast Hadoop `Configuration`

. Creates a flag that says whether to apply timezone conversions to int96 timestamps or not (aka `convertTz`)

. Creates a Hadoop `TaskAttemptContextImpl` (with the broadcast Hadoop `Configuration` and a Hadoop `TaskAttemptID` for a map task)

. Sets the Parquet `FilterPredicate` (only when spark-sql-properties.md#spark.sql.parquet.filterPushdown[spark.sql.parquet.filterPushdown] configuration property is enabled and it is by default)

The function then branches off on whether spark-sql-VectorizedParquetRecordReader.md[Parquet vectorized reader] is enabled or not.

NOTE: spark-sql-VectorizedParquetRecordReader.md[Parquet vectorized reader] is enabled by default.

With spark-sql-VectorizedParquetRecordReader.md[Parquet vectorized reader] enabled, the function does the following:

. Creates a spark-sql-VectorizedParquetRecordReader.md#creating-instance[VectorizedParquetRecordReader] and a <<spark-sql-RecordReaderIterator.md#, RecordReaderIterator>>

. Requests `VectorizedParquetRecordReader` to spark-sql-VectorizedParquetRecordReader.md#initialize[initialize] (with the Parquet `ParquetInputSplit` and the Hadoop `TaskAttemptContextImpl`)

. Prints out the following DEBUG message to the logs:
+
```
Appending [partitionSchema] [partitionValues]
```

. Requests `VectorizedParquetRecordReader` to spark-sql-VectorizedParquetRecordReader.md#initBatch[initBatch]

. (only with <<supportBatch, supportBatch>> enabled) Requests `VectorizedParquetRecordReader` to spark-sql-VectorizedParquetRecordReader.md#enableReturningBatches[enableReturningBatches]

. In the end, the function gives the <<spark-sql-RecordReaderIterator.md#, RecordReaderIterator>> (over the `VectorizedParquetRecordReader`) as the `Iterator[InternalRow]`

With spark-sql-VectorizedParquetRecordReader.md[Parquet vectorized reader] disabled, the function does the following:

. FIXME (since Parquet vectorized reader is enabled by default it's of less interest currently)

=== [[mergeSchemasInParallel]] `mergeSchemasInParallel` Method

[source, scala]
----
mergeSchemasInParallel(
  filesToTouch: Seq[FileStatus],
  sparkSession: SparkSession): Option[StructType]
----

`mergeSchemasInParallel`...FIXME

NOTE: `mergeSchemasInParallel` is used when...FIXME
