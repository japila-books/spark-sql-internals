# TextFileFormat

[[shortName]]
`TextFileFormat` is a TextBasedFileFormat.md[TextBasedFileFormat] for *text* format.

[source, scala]
----
spark.read.format("text").load("text-datasets")

// or the same as above using a shortcut
spark.read.text("text-datasets")
----

`TextFileFormat` uses <<TextOptions, text options>> while loading a dataset.

[[options]]
[[TextOptions]]
.TextFileFormat's Options
[cols="1,1,3",options="header",width="100%"]
|===
| Option
| Default Value
| Description

| [[compression]] `compression`
|
a| Compression codec that can be either one of the spark-sql-CompressionCodecs.md#shortCompressionCodecNames[known aliases] or a fully-qualified class name.

| [[wholetext]] `wholetext`
| `false`
| Enables loading a file as a single row (i.e. not splitting by "\n")
|===

=== [[prepareWrite]] `prepareWrite` Method

[source, scala]
----
prepareWrite(
  sparkSession: SparkSession,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
----

NOTE: `prepareWrite` is part of spark-sql-FileFormat.md#prepareWrite[FileFormat Contract] that is used when `FileFormatWriter` is requested to spark-sql-FileFormatWriter.md#write[write the result of a structured query].

`prepareWrite`...FIXME

=== [[buildReader]] Building Partitioned Data Reader -- `buildReader` Method

[source, scala]
----
buildReader(
  sparkSession: SparkSession,
  dataSchema: StructType,
  partitionSchema: StructType,
  requiredSchema: StructType,
  filters: Seq[Filter],
  options: Map[String, String],
  hadoopConf: Configuration): (PartitionedFile) => Iterator[InternalRow]
----

NOTE: `buildReader` is part of spark-sql-FileFormat.md#buildReader[FileFormat Contract] to...FIXME

`buildReader`...FIXME

=== [[readToUnsafeMem]] `readToUnsafeMem` Internal Method

[source, scala]
----
readToUnsafeMem(
  conf: Broadcast[SerializableConfiguration],
  requiredSchema: StructType,
  wholeTextMode: Boolean): (PartitionedFile) => Iterator[UnsafeRow]
----

`readToUnsafeMem`...FIXME

NOTE: `readToUnsafeMem` is used exclusively when `TextFileFormat` is requested to buildReader
