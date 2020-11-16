# TextFileFormat

[[shortName]]
`TextFileFormat` is a [TextBasedFileFormat](../TextBasedFileFormat.md) for **text** format.

```text
spark.read.format("text").load("text-datasets")

// or the same as above using a shortcut
spark.read.text("text-datasets")
```

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
a| Compression codec that can be either one of the [known aliases](../../CompressionCodecs.md#shortCompressionCodecNames) or a fully-qualified class name.

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

`prepareWrite`...FIXME

`prepareWrite` is part of [FileFormat](../FileFormat.md#prepareWrite) abstraction.

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

`buildReader`...FIXME

`buildReader` is part of [FileFormat](../FileFormat.md#buildReader) abstraction.

=== [[readToUnsafeMem]] `readToUnsafeMem` Internal Method

[source, scala]
----
readToUnsafeMem(
  conf: Broadcast[SerializableConfiguration],
  requiredSchema: StructType,
  wholeTextMode: Boolean): (PartitionedFile) => Iterator[UnsafeRow]
----

`readToUnsafeMem`...FIXME

`readToUnsafeMem` is used when `TextFileFormat` is requested to `buildReader`
