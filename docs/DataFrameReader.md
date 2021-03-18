# DataFrameReader

`DataFrameReader` is a high-level interface for Spark SQL developers to describe the input node in a data processing graph.

`DataFrameReader` is used to describe the [input data source format](#format) to be used to ["load" data from a data source](#load) (e.g. files, Hive tables, JDBC or `Dataset[String]`).

`DataFrameReader` merely describes a process of loading a data (_pipeline_) and does not trigger a Spark job (until an action is called).

## Creating Instance

`DataFrameReader` takes the following to be created:

* <span id="sparkSession"> [SparkSession](SparkSession.md)

`DataFrameReader` is created when:

* [SparkSession.read](SparkSession.md#read)

### Demo

```text
import org.apache.spark.sql.SparkSession
assert(spark.isInstanceOf[SparkSession])

import org.apache.spark.sql.DataFrameReader
val reader = spark.read
assert(reader.isInstanceOf[DataFrameReader])
```

## <span id="format"><span id="source"> format

```scala
format(
  source: String): DataFrameReader
```

`format` specifies the input data source format.

Built-in data source formats:

* `json`
* `csv`
* `parquet`
* `orc`
* `text`
* `jdbc`
* `libsvm`

Use [spark.sql.sources.default](configuration-properties.md#spark.sql.sources.default) configuration property to specify the default format.

## <span id="load"> Loading Data

```scala
load(): DataFrame
load(
  path: String): DataFrame
load(
  paths: String*): DataFrame
```

`load` loads a dataset from a data source (with optional support for multiple `paths`) as an untyped [DataFrame](spark-sql-DataFrame.md).

Internally, `load` [lookupDataSource](DataSource.md#lookupDataSource) for the [data source format](#source). `load` then branches off per its type (i.e. whether it is of `DataSourceV2` marker type or not).

For a "DataSource V2" data source, `load`...FIXME

Otherwise, if the [source](#source) is not a "DataSource V2" data source, `load` [loadV1Source](#loadV1Source).

`load` throws a `AnalysisException` when the [source](#source) is `hive`.

```text
Hive data source can only be used with tables, you can not read files of Hive data source directly.
```

### <span id="loadV1Source"> loadV1Source

```scala
loadV1Source(
  paths: String*): DataFrame
```

`loadV1Source` [creates a DataSource](DataSource.md#apply) and requests it to [resolve the underlying relation (as a BaseRelation)](DataSource.md#resolveRelation).

In the end, `loadV1Source` requests the [SparkSession](#sparkSession) to [create a DataFrame from the BaseRelation](SparkSession.md#baseRelationToDataFrame).
