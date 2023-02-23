# ParquetUtils

## <span id="inferSchema"> Infering Schema (Schema Discovery)

```scala
inferSchema(
  sparkSession: SparkSession,
  parameters: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
```

`inferSchema`...FIXME

---

`inferSchema` is used when:

* `ParquetFileFormat` is requested to [infer schema](ParquetFileFormat.md#inferSchema)
* `ParquetTable` is requested to [infer schema](ParquetTable.md#inferSchema)
