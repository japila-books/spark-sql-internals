# Parquet Connector

[Apache Parquet](http://parquet.apache.org/) is a columnar storage format for the Apache Hadoop ecosystem with support for efficient storage and encoding of data.

Parquet Connector uses [ParquetDataSourceV2](ParquetDataSourceV2.md) for `parquet` datasets and tables with [ParquetScan](ParquetScan.md) for table scanning (_reading_) and [ParquetWrite](ParquetWrite.md) for data writing.

??? note "ParquetFileFormat is Fallback FileFormat"
    The older [ParquetFileFormat](ParquetFileFormat.md) is used as a [fallbackFileFormat](ParquetDataSourceV2.md#fallbackFileFormat) for backward-compatibility and [Hive](../../hive/HiveMetastoreCatalog.md#convert) (_to name a few use cases_).

Parquet is the default connector format based on the [spark.sql.sources.default](../../configuration-properties.md#spark.sql.sources.default) configuration property.

Parquet connector uses `spark.sql.parquet` prefix for [parquet-specific configuration properties](../../configuration-properties.md).

## Options

[ParquetOptions](ParquetOptions.md)

## Configuration Properties

### Reading

* [spark.sql.files.maxPartitionBytes](../../configuration-properties.md#spark.sql.files.maxPartitionBytes)
* [spark.sql.files.minPartitionNum](../../configuration-properties.md#spark.sql.files.minPartitionNum)
* [spark.sql.files.openCostInBytes](../../configuration-properties.md#spark.sql.files.openCostInBytes)

## Schema Discovery (Inference)

Parquet Connector uses distributed and multi-threaded (_concurrent_) process for [schema discovery](ParquetUtils.md#inferSchema).

Schema discovery can be configured using the following:

* [mergeSchema](ParquetOptions.md#mergeSchema) option
* [spark.sql.parquet.respectSummaryFiles](../../configuration-properties.md#spark.sql.parquet.respectSummaryFiles)

## Vectorized Parquet Decoding

Parquet Connector uses [VectorizedParquetRecordReader](VectorizedParquetRecordReader.md) for [Vectorized Parquet Decoding](../../vectorized-decoding/index.md) (and [ParquetReadSupport](ParquetReadSupport.md) otherwise).

## Parquet CLI

[parquet-cli](https://formulae.brew.sh/formula/parquet-cli) is Apache Parquet's command-line tools and utilities

```console
brew install parquet-cli
```

### Print Parquet Metadata

```console
$ parquet help meta

Usage: parquet [general options] meta <parquet path> [command options]

  Description:

    Print a Parquet file's metadata
```

```scala
spark.range(0, 5, 1, numPartitions = 1)
  .write
  .mode("overwrite")
  .parquet("demo.parquet")
```

```console
$ parquet meta demo.parquet/part-00000-9cb6054e-9986-4f04-8ae7-730aac93e7db-c000.snappy.parquet

File path:  demo.parquet/part-00000-9cb6054e-9986-4f04-8ae7-730aac93e7db-c000.snappy.parquet
Created by: parquet-mr version 1.12.3 (build f8dced182c4c1fbdec6ccb3185537b5a01e6ed6b)
Properties:
                   org.apache.spark.version: 3.4.0
  org.apache.spark.sql.parquet.row.metadata: {"type":"struct","fields":[{"name":"id","type":"long","nullable":false,"metadata":{}}]}
Schema:
message spark_schema {
  required int64 id;
}


Row group 0:  count: 5  10.60 B records  start: 4  total(compressed): 53 B total(uncompressed):63 B
--------------------------------------------------------------------------------
    type      encodings count     avg size   nulls   min / max
id  INT64     S   _     5         10.60 B    0       "0" / "4"
```

## Demo

```scala
val p = spark.read.parquet("/tmp/nums.parquet")
```

```text
scala> p.explain
== Physical Plan ==
*(1) ColumnarToRow
+- FileScan parquet [id#3L] Batched: true, DataFilters: [], Format: Parquet, Location: InMemoryFileIndex(1 paths)[file:/tmp/nums.parquet], PartitionFilters: [], PushedFilters: [], ReadSchema: struct<id:bigint>
```

```scala
val executedPlan = p.queryExecution.executedPlan
```

```scala
scala> executedPlan.foreachUp { op => println(op.getClass) }
class org.apache.spark.sql.execution.FileSourceScanExec
class org.apache.spark.sql.execution.InputAdapter
class org.apache.spark.sql.execution.ColumnarToRowExec
class org.apache.spark.sql.execution.WholeStageCodegenExec
```

```scala
import org.apache.spark.sql.execution.FileSourceScanExec
val scan = executedPlan.collectFirst { case scan: FileSourceScanExec => scan }.get

import org.apache.spark.sql.execution.datasources.parquet.ParquetFileFormat
val parquetFF = scan.relation.fileFormat.asInstanceOf[ParquetFileFormat]
```
