# OrcFileFormat

`OrcFileFormat` is a [FileFormat](FileFormat.md).

=== [[buildReaderWithPartitionValues]] `buildReaderWithPartitionValues` Method

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

`buildReaderWithPartitionValues`...FIXME

`buildReaderWithPartitionValues` is part of [FileFormat](FileFormat.md#buildReaderWithPartitionValues) abstraction.

=== [[inferSchema]] `inferSchema` Method

[source, scala]
----
inferSchema(
  sparkSession: SparkSession,
  options: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
----

`inferSchema`...FIXME

`inferSchema` is part of [FileFormat](FileFormat.md#inferSchema) abstraction.

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

`buildReader` is part of [FileFormat](FileFormat.md#buildReader) abstraction.
