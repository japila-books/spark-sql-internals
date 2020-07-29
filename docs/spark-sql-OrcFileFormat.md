# OrcFileFormat

`OrcFileFormat` is a <<spark-sql-FileFormat.md#, FileFormat>> that...FIXME

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

NOTE: `buildReaderWithPartitionValues` is part of spark-sql-FileFormat.md#buildReaderWithPartitionValues[FileFormat Contract] to build a data reader with partition column values appended.

`buildReaderWithPartitionValues`...FIXME

=== [[inferSchema]] `inferSchema` Method

[source, scala]
----
inferSchema(
  sparkSession: SparkSession,
  options: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
----

NOTE: `inferSchema` is part of spark-sql-FileFormat.md#inferSchema[FileFormat Contract] to...FIXME.

`inferSchema`...FIXME

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
