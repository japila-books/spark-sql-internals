# ParquetScanBuilder

`ParquetScanBuilder` is a [FileScanBuilder](../files/FileScanBuilder.md) (of [ParquetTable](ParquetTable.md#newScanBuilder)) that [SupportsPushDownFilters](../connector/SupportsPushDownFilters.md).

`ParquetScanBuilder` [builds ParquetScans](#build).

`ParquetScanBuilder` [supportsNestedSchemaPruning](#supportsNestedSchemaPruning).

## Creating Instance

`ParquetScanBuilder` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)
* <span id="fileIndex"> [PartitioningAwareFileIndex](../files/PartitioningAwareFileIndex.md)
* <span id="schema"> [Schema](../types/StructType.md)
* <span id="dataSchema"> [Data Schema](../types/StructType.md)
* <span id="options"> Case-Insensitive Options

`ParquetScanBuilder` is created when:

* `ParquetTable` is requested to [newScanBuilder](ParquetTable.md#newScanBuilder)

## <span id="build"> Building Scan

??? note "Signature"

    ```scala
    build(): Scan
    ```

    `build` is part of the [ScanBuilder](../connector/ScanBuilder.md#build) abstraction.

`build` creates a [ParquetScan](ParquetScan.md) with the following:

ParquetScan | Value
------------|------
 [fileIndex](ParquetScan.md#fileIndex) | the given [fileIndex](#fileIndex)
 [dataSchema](ParquetScan.md#dataSchema) | the given [dataSchema](#dataSchema)
 [readDataSchema](ParquetScan.md#readDataSchema) | [finalSchema](#finalSchema)
 [readPartitionSchema](ParquetScan.md#readPartitionSchema) | [readPartitionSchema](../files/FileScanBuilder.md#readPartitionSchema)
 [pushedFilters](ParquetScan.md#pushedFilters) | [pushedDataFilters](../files/FileScanBuilder.md#pushedDataFilters)
 [options](ParquetScan.md#options) | the given [options](#options)
 [pushedAggregate](ParquetScan.md#pushedAggregate) | [pushedAggregations](#pushedAggregations)
 [partitionFilters](ParquetScan.md#partitionFilters) | [partitionFilters](../files/FileScanBuilder.md#partitionFilters)
 [dataFilters](ParquetScan.md#dataFilters) | [dataFilters](../files/FileScanBuilder.md#dataFilters)

## <span id="pushedAggregations"> pushedAggregations

```scala
pushedAggregations: Option[Aggregation]
```

`ParquetScanBuilder` defines `pushedAggregations` registry for an [Aggregation](../connector/expressions/Aggregation.md).

The `pushedAggregations` is undefined when `ParquetScanBuilder` is [created](#creating-instance) and can only be assigned when [pushAggregation](#pushAggregation).

`pushedAggregations` controls the [finalSchema](#finalSchema). When undefined, the [finalSchema](#finalSchema) is [readDataSchema](../files/FileScanBuilder.md#readDataSchema) when [building a ParquetScan](#build).

`pushedAggregations` is used to create a [ParquetScan](ParquetScan.md#pushedAggregate).

## <span id="pushAggregation"> pushAggregation

??? note "Signature"

    ```scala
    pushAggregation(
      aggregation: Aggregation): Boolean
    ```

    `pushAggregation` is part of the [SupportsPushDownAggregates](../connector/SupportsPushDownAggregates.md#pushAggregation) abstraction.

`pushAggregation` does nothing and returns `false` for [spark.sql.parquet.aggregatePushdown](../configuration-properties.md#spark.sql.parquet.aggregatePushdown) disabled.

`pushAggregation` [determines the data schema for aggregate to be pushed down](../files/AggregatePushDownUtils.md#getSchemaForPushedAggregation).

With the schema determined, `pushAggregation` registers it as [finalSchema](#finalSchema) and the given [Aggregation](../connector/expressions/Aggregation.md) as [pushedAggregations](#pushedAggregations). `pushAggregation` returns `true`.

Otherwise, `pushAggregation` returns `false`.

## <span id="pushDataFilters"> pushDataFilters

??? note "Signature"

    ```scala
    pushDataFilters(
      dataFilters: Array[Filter]): Array[Filter]
    ```

    `pushDataFilters` is part of the [FileScanBuilder](../files/FileScanBuilder.md#pushDataFilters) abstraction.

!!! note "spark.sql.parquet.filterPushdown"
    `pushDataFilters` does nothing and returns no [Catalyst Filter](../Filter.md)s with [spark.sql.parquet.filterPushdown](../configuration-properties.md#spark.sql.parquet.filterPushdown) disabled.

`pushDataFilters` creates a [ParquetFilters](ParquetFilters.md) with the [readDataSchema](../files/FileScanBuilder.md#readDataSchema) ([converted into the corresponding parquet schema](SparkToParquetSchemaConverter.md#convert)) and the following configuration properties:

* [spark.sql.parquet.filterPushdown.date](../SQLConf.md#parquetFilterPushDownDate)
* [spark.sql.parquet.filterPushdown.decimal](../SQLConf.md#parquetFilterPushDownDecimal)
* [spark.sql.parquet.filterPushdown.string.startsWith](../SQLConf.md#parquetFilterPushDownStringPredicate)
* [spark.sql.parquet.filterPushdown.timestamp](../SQLConf.md#parquetFilterPushDownTimestamp)
* [spark.sql.parquet.pushdown.inFilterThreshold](../SQLConf.md#parquetFilterPushDownInFilterThreshold)
* [spark.sql.caseSensitive](../SQLConf.md#caseSensitiveAnalysis)

In the end, `pushedParquetFilters` requests the `ParquetFilters` for the [convertibleFilters](ParquetFilters.md#convertibleFilters) for the given `dataFilters`.

## <span id="supportsNestedSchemaPruning"> supportsNestedSchemaPruning

??? note "Signature"

    ```scala
    supportsNestedSchemaPruning: Boolean
    ```

    `supportsNestedSchemaPruning` is part of the [FileScanBuilder](../files/FileScanBuilder.md#supportsNestedSchemaPruning) abstraction.

`supportsNestedSchemaPruning` is enabled (`true`).
