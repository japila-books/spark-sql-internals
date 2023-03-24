# ParquetScanBuilder

`ParquetScanBuilder` is a [FileScanBuilder](../FileScanBuilder.md) (of [ParquetTable](ParquetTable.md#newScanBuilder)) that [SupportsPushDownFilters](../../connector/SupportsPushDownFilters.md).

`ParquetScanBuilder` [builds ParquetScans](#build).

`ParquetScanBuilder` [supportsNestedSchemaPruning](#supportsNestedSchemaPruning).

## Creating Instance

`ParquetScanBuilder` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="fileIndex"> [PartitioningAwareFileIndex](../PartitioningAwareFileIndex.md)
* <span id="schema"> [Schema](../../types/StructType.md)
* <span id="dataSchema"> [Data Schema](../../types/StructType.md)
* <span id="options"> Case-Insensitive Options

`ParquetScanBuilder` is created when:

* `ParquetTable` is requested to [newScanBuilder](ParquetTable.md#newScanBuilder)

## <span id="build"> Building Scan

??? note "Signature"

    ```scala
    build(): Scan
    ```

    `build` is part of the [ScanBuilder](../../connector/ScanBuilder.md#build) abstraction.

`build` creates a [ParquetScan](ParquetScan.md) with the following:

ParquetScan | Value
------------|------
 [fileIndex](ParquetScan.md#fileIndex) | the given [fileIndex](#fileIndex)
 [dataSchema](ParquetScan.md#dataSchema) | the given [dataSchema](#dataSchema)
 [readDataSchema](ParquetScan.md#readDataSchema) | [finalSchema](#finalSchema)
 [readPartitionSchema](ParquetScan.md#readPartitionSchema) | [readPartitionSchema](../FileScanBuilder.md#readPartitionSchema)
 [pushedFilters](ParquetScan.md#pushedFilters) | [pushedDataFilters](../FileScanBuilder.md#pushedDataFilters)
 [options](ParquetScan.md#options) | the given [options](#options)
 [pushedAggregate](ParquetScan.md#pushedAggregate) | [pushedAggregations](#pushedAggregations)
 [partitionFilters](ParquetScan.md#partitionFilters) | [partitionFilters](../FileScanBuilder.md#partitionFilters)
 [dataFilters](ParquetScan.md#dataFilters) | [dataFilters](../FileScanBuilder.md#dataFilters)

## <span id="pushAggregation"> pushAggregation

??? note "Signature"

    ```scala
    pushAggregation(
      aggregation: Aggregation): Boolean
    ```

    `pushAggregation` is part of the [SupportsPushDownAggregates](../../connector/SupportsPushDownAggregates.md#pushAggregation) abstraction.

`pushAggregation`...FIXME

## <span id="pushDataFilters"> pushDataFilters

??? note "Signature"

    ```scala
    pushDataFilters(
      dataFilters: Array[Filter]): Array[Filter]
    ```

    `pushDataFilters` is part of the [FileScanBuilder](../FileScanBuilder.md#pushDataFilters) abstraction.

!!! note "spark.sql.parquet.filterPushdown"
    `pushDataFilters` does nothing and returns no [Catalyst Filter](../../Filter.md)s with [spark.sql.parquet.filterPushdown](../../configuration-properties.md#spark.sql.parquet.filterPushdown) disabled.

`pushDataFilters` creates a [ParquetFilters](ParquetFilters.md) with the [readDataSchema](../FileScanBuilder.md#readDataSchema) ([converted into the corresponding parquet schema](SparkToParquetSchemaConverter.md#convert)) and the following configuration properties:

* [spark.sql.parquet.filterPushdown.date](../../SQLConf.md#parquetFilterPushDownDate)
* [spark.sql.parquet.filterPushdown.decimal](../../SQLConf.md#parquetFilterPushDownDecimal)
* [spark.sql.parquet.filterPushdown.string.startsWith](../../SQLConf.md#parquetFilterPushDownStringPredicate)
* [spark.sql.parquet.filterPushdown.timestamp](../../SQLConf.md#parquetFilterPushDownTimestamp)
* [spark.sql.parquet.pushdown.inFilterThreshold](../../SQLConf.md#parquetFilterPushDownInFilterThreshold)
* [spark.sql.caseSensitive](../../SQLConf.md#caseSensitiveAnalysis)

In the end, `pushedParquetFilters` requests the `ParquetFilters` for the [convertibleFilters](ParquetFilters.md#convertibleFilters) for the given `dataFilters`.

## <span id="supportsNestedSchemaPruning"> supportsNestedSchemaPruning

??? note "Signature"

    ```scala
    supportsNestedSchemaPruning: Boolean
    ```

    `supportsNestedSchemaPruning` is part of the [FileScanBuilder](../FileScanBuilder.md#supportsNestedSchemaPruning) abstraction.

`supportsNestedSchemaPruning` is enabled (`true`).
