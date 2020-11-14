# AvroFileFormat

`AvroFileFormat` is a [FileFormat](../../FileFormat.md) for Apache Avro, i.e. a data source format that can read and write Avro-encoded data in files.

[[shortName]]
`AvroFileFormat` is a [DataSourceRegister](../../DataSourceRegister.md) and [registers itself](../../DataSourceRegister.md#shortName) as *avro* data source.

```text
// ./bin/spark-shell --packages org.apache.spark:spark-avro_2.12:2.4.0

// Writing data to Avro file(s)
spark
  .range(1)
  .write
  .format("avro") // <-- Triggers AvroFileFormat
  .save("data.avro")

// Reading Avro data from file(s)
val q = spark
  .read
  .format("avro") // <-- Triggers AvroFileFormat
  .load("data.avro")
scala> q.show
+---+
| id|
+---+
|  0|
+---+
```

[[isSplitable]]
`AvroFileFormat` is [splitable](../../FileFormat.md#isSplitable), i.e. FIXME

=== [[buildReader]] Building Partitioned Data Reader -- `buildReader` Method

[source, scala]
----
buildReader(
  spark: SparkSession,
  dataSchema: StructType,
  partitionSchema: StructType,
  requiredSchema: StructType,
  filters: Seq[Filter],
  options: Map[String, String],
  hadoopConf: Configuration): (PartitionedFile) => Iterator[InternalRow]
----

`buildReader`...FIXME

`buildReader` is part of the [FileFormat](../../FileFormat.md#buildReader) abstraction.

=== [[inferSchema]] Inferring Schema -- `inferSchema` Method

[source, scala]
----
inferSchema(
  spark: SparkSession,
  options: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
----

`inferSchema`...FIXME

`inferSchema` is part of the [FileFormat](../../FileFormat.md#inferSchema) abstraction.

=== [[prepareWrite]] Preparing Write Job -- `prepareWrite` Method

[source, scala]
----
prepareWrite(
  spark: SparkSession,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
----

`prepareWrite`...FIXME

`prepareWrite` is part of the [FileFormat](../../FileFormat.md#prepareWrite) abstraction.
