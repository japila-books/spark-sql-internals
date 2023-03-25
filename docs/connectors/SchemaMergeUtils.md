# SchemaMergeUtils

## <span id="mergeSchemasInParallel"> mergeSchemasInParallel

```scala
mergeSchemasInParallel(
  sparkSession: SparkSession,
  parameters: Map[String, String],
  files: Seq[FileStatus],
  schemaReader: (Seq[FileStatus], Configuration, Boolean) => Seq[StructType]): Option[StructType]
```

`mergeSchemasInParallel` determines a merged schema with a distributed Spark job.

---

`mergeSchemasInParallel` creates an RDD with file paths and their lenght with the number of partitions up to the default parallelism (_number of CPU cores in a cluster_).

In the end, `mergeSchemasInParallel` collects the RDD result that are [merged schemas](../types/StructType.md#merge) for files (per partition) that `mergeSchemasInParallel` merge all together to give the final merge schema.

---

`mergeSchemasInParallel` is used when:

* `OrcFileFormat` is requested to `inferSchema`
* `OrcUtils` is requested to infer schema
* `ParquetFileFormat` is requested to [infer schema](../parquet/ParquetFileFormat.md#inferSchema)
