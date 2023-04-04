# FileWrite

`FileWrite` is an [extension](#contract) of the [Write](../connector/Write.md) abstraction for [file writers](#implementations).

## Contract

### Format Name { #formatName }

```scala
formatName: String
```

See:

* [ParquetWrite](../parquet/ParquetWrite.md#formatName)

Used when:

* `FileWrite` is requested for the [description](#description) and [validateInputs](#validateInputs)

### LogicalWriteInfo { #info }

```scala
info: LogicalWriteInfo
```

See:

* [ParquetWrite](../parquet/ParquetWrite.md#info)

Used when:

* `FileWrite` is requested for the [schema](#schema), the [queryId](#queryId) and the [options](#options)

### paths { #paths }

```scala
paths: Seq[String]
```

See:

* [ParquetWrite](../parquet/ParquetWrite.md#paths)

Used when:

* `FileWrite` is requested for a [BatchWrite](#toBatch) and to [validateInputs](#validateInputs)

### Preparing Write Job { #prepareWrite }

```scala
prepareWrite(
  sqlConf: SQLConf,
  job: Job,
  options: Map[String, String],
  dataSchema: StructType): OutputWriterFactory
```

Prepares a write job and returns an `OutputWriterFactory`

See:

* [ParquetWrite](../parquet/ParquetWrite.md#prepareWrite)

Used when:

* `FileWrite` is requested to [createWriteJobDescription](#createWriteJobDescription)

### supportsDataType { #supportsDataType }

```scala
supportsDataType: DataType => Boolean
```

See:

* [ParquetWrite](../parquet/ParquetWrite.md#supportsDataType)

Used when:

* `FileWrite` is requested to [validateInputs](#validateInputs)

## Implementations

* `AvroWrite`
* `CSVWrite`
* `JsonWrite`
* `OrcWrite`
* [ParquetWrite](../parquet/ParquetWrite.md)
* `TextWrite`

## Creating BatchWrite { #toBatch }

??? note "Write"

    ```scala
    toBatch: BatchWrite
    ```

    `toBatch` is part of the [Write](../connector/Write.md#toBatch) abstraction.

`toBatch` [validateInputs](#validateInputs).

`toBatch` creates a new Hadoop [Job]({{ hadoop.api }}/org/apache/hadoop/mapreduce/Job.html) for just a single path out of the [paths](#paths).

`toBatch` creates a `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol)) with the following:

1. [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass)
1. A random job ID
1. The first of the [paths](#paths)

`toBatch` [creates a WriteJobDescription](#createWriteJobDescription).

`toBatch` requests the `FileCommitProtocol` to `setupJob` (with the Hadoop `Job` instance).

In the end, `toBatch` creates a [FileBatchWrite](FileBatchWrite.md) (for the Hadoop `Job`, the `WriteJobDescription` and the `FileCommitProtocol`).

### Creating WriteJobDescription { #createWriteJobDescription }

```scala
createWriteJobDescription(
  sparkSession: SparkSession,
  hadoopConf: Configuration,
  job: Job,
  pathName: String,
  options: Map[String, String]): WriteJobDescription
```

`createWriteJobDescription`...FIXME
