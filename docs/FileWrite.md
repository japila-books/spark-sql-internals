# FileWrite

`FileWrite` is an [extension](#contract) of the [Write](connector/Write.md) abstraction for [file writers](#implementations).

## Contract

### <span id="formatName"> Format Name

```scala
formatName: String
```

Used when:

* `FileWrite` is requested for the [description](#description) and [validateInputs](#validateInputs)

### <span id="info"> LogicalWriteInfo

```scala
info: LogicalWriteInfo
```

Used when:

* `FileWrite` is requested for the [schema](#schema), the [queryId](#queryId) and the [options](#options)

### <span id="paths"> paths

```scala
paths: Seq[String]
```

Used when:

* `FileWrite` is requested for a [BatchWrite](#toBatch) and to [validateInputs](#validateInputs)

### <span id="prepareWrite"> Preparing Write Job

```scala
prepareWrite(
  sqlConf: SQLConf,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
```

Prepares a write job and returns an `OutputWriterFactory`

Used when:

* `FileWrite` is requested to [createWriteJobDescription](#createWriteJobDescription)

### <span id="supportsDataType"> supportsDataType

```scala
supportsDataType: DataType => Boolean
```

Used when:

* `FileWrite` is requested to [validateInputs](#validateInputs)

## Implementations

* `AvroWrite`
* `CSVWrite`
* `JsonWrite`
* `OrcWrite`
* [ParquetWrite](datasources/parquet/ParquetWrite.md)
* `TextWrite`

## <span id="toBatch"> toBatch

```scala
toBatch: BatchWrite
```

`toBatch` [validateInputs](#validateInputs).

`toBatch` creates a new `Job` ([Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/Job.html)) for just a single path out of the [paths](#paths).

`toBatch` creates a `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol)) with the following:

1. [spark.sql.sources.commitProtocolClass](configuration-properties.md#spark.sql.sources.commitProtocolClass)
1. A random job ID
1. The first of the [paths](#paths)

`toBatch` [creates a WriteJobDescription](#createWriteJobDescription).

`toBatch` requests the `FileCommitProtocol` to `setupJob` (with the job instance).

In the end, `toBatch` creates a [FileBatchWrite](FileBatchWrite.md) (for the job, the description and the committer).

---

`toBatch` is part of the [Write](connector/Write.md#toBatch) abstraction.

### <span id="createWriteJobDescription"> createWriteJobDescription

```scala
createWriteJobDescription(
  sparkSession: SparkSession,
  hadoopConf: Configuration,
  job: Job,
  pathName: String,
  options: Map[String, String]): WriteJobDescription
```

`createWriteJobDescription`...FIXME
