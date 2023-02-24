# ParquetUtils

## <span id="inferSchema"> Infering Schema (Schema Discovery)

```scala
inferSchema(
  sparkSession: SparkSession,
  parameters: Map[String, String],
  files: Seq[FileStatus]): Option[StructType]
```

`inferSchema` determines which file(s) to touch in order to determine the schema:

* With [mergeSchema](ParquetOptions.md#mergeSchema) enabled, `inferSchema` merges part, metadata and common metadata files.

    Data part-files are skipped with [spark.sql.parquet.respectSummaryFiles](../../configuration-properties.md#spark.sql.parquet.respectSummaryFiles) enabled.

* With [mergeSchema](ParquetOptions.md#mergeSchema) disabled, `inferSchema` prefers summary files (with `_common_metadata`s preferable over `_metadata`s as they contain no extra row groups information and hence are smaller for large Parquet files with lots of row groups). 

    `inferSchema` falls back to a random part-file.
    
    `inferSchema` takes the very first parquet file (ordered by path) from the following (until a file is found):

    1. `_common_metadata` files
    1. `_metadata` files
    1. data part-files

---

`inferSchema` creates a [ParquetOptions](ParquetOptions.md) (with the input `parameters` and the `SparkSession`'s [SQLConf](../../SQLConf.md)) to read the value of [mergeSchema](ParquetOptions.md#mergeSchema) option.

`inferSchema` reads the value of [spark.sql.parquet.respectSummaryFiles](../../configuration-properties.md#spark.sql.parquet.respectSummaryFiles) configuration property.

`inferSchema` [organizes parquet files by type](#splitFiles) for the given `FileStatus`es ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)).

`inferSchema` [mergeSchemasInParallel](ParquetFileFormat.md#mergeSchemasInParallel) for the files to touch.

---

`inferSchema` is used when:

* `ParquetFileFormat` is requested to [infer schema](ParquetFileFormat.md#inferSchema)
* `ParquetTable` is requested to [infer schema](ParquetTable.md#inferSchema)

### <span id="splitFiles"> Organizing Parquet Files by Type

```scala
splitFiles(
  allFiles: Seq[FileStatus]): FileTypes
```

`splitFiles` sorts the given `FileStatus`es ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/fs/FileStatus.html)) by path.

`splitFiles` creates a `FileTypes` with the following:

* Data files (i.e., files that are not summary files so neither `_common_metadata` nor `_metadata`)
* Metadata files (`_metadata`)
* Common metadata files (`_common_metadata`)
