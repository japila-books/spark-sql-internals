# BucketSpec

`BucketSpec` is the [bucketing specification](index.md) of a table (the metadata of a [bucketed table](index.md)).

`BucketSpec` is a [SQLConfHelper](../SQLConfHelper.md)

## Creating Instance

`BucketSpec` takes the following to be created:

* [Number of buckets](#numBuckets)
* <span id="bucketColumnNames"> Bucketing Columns
* <span id="sortColumnNames"> Sorting Columns

`BucketSpec` is created when:

* `CatalogUtils` is requested to `normalizeBucketSpec`
* `AstBuilder` is requested to [parse bucketing specification](../sql/AstBuilder.md#visitBucketSpec)
* `TransformHelper` is requested to `convertTransforms`
* `HiveExternalCatalog` is requested to [getBucketSpecFromTableProperties](../hive/HiveExternalCatalog.md#getBucketSpecFromTableProperties)
* `HiveClientImpl` is requested to [convertHiveTableToCatalogTable](../hive/HiveClientImpl.md#convertHiveTableToCatalogTable)
* `DataFrameWriter` is requested to [getBucketSpec](../DataFrameWriter.md#getBucketSpec)
* `ShowCreateTableExec` is requested to [showTablePartitioning](../physical-operators/ShowCreateTableExec.md#showTablePartitioning)

### <span id="numBuckets"> Number of Buckets

`BucketSpec` is given the number of buckets when [created](#creating-instance).

The number of buckets has to be between `0` and [spark.sql.sources.bucketing.maxBuckets](../configuration-properties.md#spark.sql.sources.bucketing.maxBuckets) (inclusive) or an `AnalysisException` is reported:

```text
Number of buckets should be greater than 0 but less than or equal to bucketing.maxBuckets (`[bucketingMaxBuckets]`). Got `[numBuckets]`.
```

<!---
## Review Me

`BucketSpec` is <<creating-instance, created>> when:

. `DataFrameWriter` is requested to [saveAsTable](DataFrameWriter.md#saveAsTable) (and does [getBucketSpec](DataFrameWriter.md#getBucketSpec))

. `HiveExternalCatalog` is requested to [getBucketSpecFromTableProperties](hive/HiveExternalCatalog.md#getBucketSpecFromTableProperties) and [tableMetaToTableProps](hive/HiveExternalCatalog.md#tableMetaToTableProps)

. `HiveClientImpl` is requested to hive/HiveClientImpl.md#getTableOption[retrieve a table metadata]

. `SparkSqlAstBuilder` is requested to spark-sql-SparkSqlAstBuilder.md#visitBucketSpec[visitBucketSpec] (for `CREATE TABLE` SQL statement with `CLUSTERED BY` and `INTO n BUCKETS` with optional `SORTED BY` clauses)

[[toString]]
`BucketSpec` uses the following *text representation* (i.e. `toString`):

```
[numBuckets] buckets, bucket columns: [[bucketColumnNames]], sort columns: [[sortColumnNames]]
```

[source, scala]
----
import org.apache.spark.sql.catalyst.catalog.BucketSpec
val bucketSpec = BucketSpec(
  numBuckets = 8,
  bucketColumnNames = Seq("col1"),
  sortColumnNames = Seq("col2"))
scala> println(bucketSpec)
8 buckets, bucket columns: [col1], sort columns: [col2]
----

=== [[toLinkedHashMap]] Converting Bucketing Specification to LinkedHashMap -- `toLinkedHashMap` Method

[source, scala]
----
toLinkedHashMap: mutable.LinkedHashMap[String, String]
----

`toLinkedHashMap` converts the bucketing specification to a collection of pairs (`LinkedHashMap[String, String]`) with the following fields and their values:

* *Num Buckets* with the <<numBuckets, numBuckets>>
* *Bucket Columns* with the <<bucketColumnNames, bucketColumnNames>>
* *Sort Columns* with the <<sortColumnNames, sortColumnNames>>

`toLinkedHashMap` quotes the column names.

[source, scala]
----
scala> println(bucketSpec.toLinkedHashMap)
Map(Num Buckets -> 8, Bucket Columns -> [`col1`], Sort Columns -> [`col2`])
----

`toLinkedHashMap` is used when:

* `CatalogTable` is requested for [toLinkedHashMap](CatalogTable.md#toLinkedHashMap)

* `DescribeTableCommand` logical command is <<DescribeTableCommand.md#run, executed>> with a non-empty <<partitionSpec, partitionSpec>> and the <<DescribeTableCommand.md#isExtended, isExtended>> flag on (that uses <<DescribeTableCommand.md#describeFormattedDetailedPartitionInfo, describeFormattedDetailedPartitionInfo>>).
-->
