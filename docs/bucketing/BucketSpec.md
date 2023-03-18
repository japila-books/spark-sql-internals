# BucketSpec

`BucketSpec` is the [bucketing specification](index.md) of a table (the metadata of a [bucketed table](index.md)).

`BucketSpec` is a [SQLConfHelper](../SQLConfHelper.md)

## Creating Instance

`BucketSpec` takes the following to be created:

* [Number of buckets](#numBuckets)
* <span id="bucketColumnNames"> Bucketing Columns
* <span id="sortColumnNames"> Sorting Columns

`BucketSpec` is created when:

* `CatalogUtils` is requested to [normalizeBucketSpec](../CatalogUtils.md#normalizeBucketSpec)
* `AstBuilder` is requested to [parse bucketing specification](../sql/AstBuilder.md#visitBucketSpec)
* `TransformHelper` is requested to [convertTransforms](../connector/TransformHelper.md#convertTransforms)
* `HiveExternalCatalog` is requested to [restoreTableMetadata](../hive/HiveExternalCatalog.md#restoreTableMetadata) (and [getBucketSpecFromTableProperties](../hive/HiveExternalCatalog.md#getBucketSpecFromTableProperties))
* `HiveClientImpl` is requested to [convertHiveTableToCatalogTable](../hive/HiveClientImpl.md#convertHiveTableToCatalogTable)
* `DataFrameWriter` is requested for the [BucketSpec](../DataFrameWriter.md#getBucketSpec)
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

[[toString]]
`BucketSpec` uses the following *text representation* (i.e. `toString`):

```
[numBuckets] buckets, bucket columns: [[bucketColumnNames]], sort columns: [[sortColumnNames]]
```

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
