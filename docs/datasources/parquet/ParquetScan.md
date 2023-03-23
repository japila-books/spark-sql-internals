# ParquetScan

`ParquetScan` is a [FileScan](../FileScan.md) in [Parquet Data Source](index.md).

## Creating Instance

`ParquetScan` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="hadoopConf"> Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
* <span id="fileIndex"> [PartitioningAwareFileIndex](../PartitioningAwareFileIndex.md)
* <span id="dataSchema"> Data [schema](../../types/StructType.md)
* <span id="readDataSchema"> Read data [schema](../../types/StructType.md)
* <span id="readPartitionSchema"> Read partition [schema](../../types/StructType.md)
* <span id="pushedFilters"> Pushed [Filter](../../Filter.md)s
* <span id="options"> Case-insensitive options
* [Pushed Aggregation](#pushedAggregate)
* <span id="pushedAggregate"> Option[] = None
* <span id="partitionFilters"> Partition filter [expression](../../expressions/Expression.md)s (optional)
* <span id="dataFilters"> Data filter [expression](../../expressions/Expression.md)s (optional)

`ParquetScan` is created when:

* `ParquetScanBuilder` is requested to [build a Scan](ParquetScanBuilder.md#build)

### <span id="pushedAggregate"> Pushed Aggregation

`ParquetScan` can be given an [Aggregation](../../connector/expressions/Aggregation.md) expression when [created](#creating-instance).
The `Aggregation` is optional and undefined by default.

The `Aggregation` is used in the following:

* [getMetaData](#getMetaData) (as [pushedAggregationsStr](#pushedAggregationsStr) and [pushedGroupByStr](#pushedGroupByStr))
* [isSplitable](#isSplitable)
* [readSchema](#readSchema)
* [createReaderFactory](#createReaderFactory) (to create a [ParquetPartitionReaderFactory](ParquetPartitionReaderFactory.md#aggregation))

## <span id="createReaderFactory"> Creating PartitionReaderFactory

??? note "Signature"

    ```scala
    createReaderFactory(): PartitionReaderFactory
    ```

    `createReaderFactory` is part of the [Batch](../../connector/Batch.md#createReaderFactory) abstraction.

`createReaderFactory` creates a [ParquetPartitionReaderFactory](ParquetPartitionReaderFactory.md) (with the [Hadoop Configuration](#hadoopConf) broadcast).

`createReaderFactory` adds the following properties to the [Hadoop Configuration](#hadoopConf) before broadcasting it (to executors).

Name | Value
-----|------
 `ParquetInputFormat.READ_SUPPORT_CLASS` | [ParquetReadSupport](ParquetReadSupport.md)
 _others_ |

## <span id="isSplitable"> isSplitable

??? note "Signature"

    ```scala
    isSplitable(
      path: Path): Boolean
    ```

    `isSplitable` is part of the [FileScan](../FileScan.md#isSplitable) abstraction.

`isSplitable` is `true` when all the following hold:

1. [pushedAggregate](#pushedAggregate) is not specified
1. `RowIndexUtil.isNeededForSchema` is `false` for the [readSchema](#readSchema)

## <span id="getMetaData"> Custom Metadata

??? note "Signature"

    ```scala
    getMetaData(): Map[String, String]
    ```

    `getMetaData` is part of the [SupportsMetadata](../../connector/SupportsMetadata.md#getMetaData) abstraction.

`getMetaData` adds the following metadata to the default [file-based metadata](../FileScan.md#getMetaData):

Metadata | Value
---------|------
 `PushedFilters` | [pushedFilters](#pushedFilters)
 `PushedAggregation` | [pushedAggregationsStr](#pushedAggregationsStr)
 `PushedGroupBy` | [pushedGroupByStr](#pushedGroupByStr)
