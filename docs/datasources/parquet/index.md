# Parquet Data Source

[Apache Parquet](http://parquet.apache.org/) is a columnar storage format for the Apache Hadoop ecosystem with support for efficient storage and encoding of data.

Spark SQL supports `parquet`-encoded data using [ParquetDataSourceV2](ParquetDataSourceV2.md). There is also an older [ParquetFileFormat](ParquetFileFormat.md) that is used as a [fallbackFileFormat](ParquetDataSourceV2.md#fallbackFileFormat), for backward-compatibility and [Hive](../../hive/HiveMetastoreCatalog.md#convert) (to name a few use cases).

Parquet is the default data source format based on the [spark.sql.sources.default](../../configuration-properties.md#spark.sql.sources.default) configuration property.

Parquet data source uses `spark.sql.parquet` prefix for [parquet-specific configuration properties](../../configuration-properties.md).

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
