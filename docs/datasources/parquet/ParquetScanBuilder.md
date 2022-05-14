# ParquetScanBuilder

`ParquetScanBuilder` is a [FileScanBuilder](../FileScanBuilder.md) that [SupportsPushDownFilters](../../connector/SupportsPushDownFilters.md).

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

```scala
build(): Scan
```

`build` creates a [ParquetScan](ParquetScan.md) (with the [readDataSchema](../FileScanBuilder.md#readDataSchema), the [readPartitionSchema](../FileScanBuilder.md#readPartitionSchema) and the [pushedParquetFilters](#pushedParquetFilters)).

`build` is part of the [ScanBuilder](../../connector/ScanBuilder.md#build) abstraction.

## <span id="pushedFilters"> Pushed Filters

```scala
pushedFilters(): Array[Filter]
```

`pushedFilters` is the [pushedParquetFilters](#pushedParquetFilters).

`pushedFilters` is part of the [SupportsPushDownFilters](../../connector/SupportsPushDownFilters.md#pushedFilters) abstraction.

## <span id="pushedParquetFilters"> pushedParquetFilters

```scala
pushedParquetFilters: Array[Filter]
```

??? note "Lazy Value"
    `pushedParquetFilters` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

`pushedParquetFilters` creates a [ParquetFilters](ParquetFilters.md) with the [readDataSchema](../FileScanBuilder.md#readDataSchema) ([converted](SparkToParquetSchemaConverter.md#convert)) and the following configuration properties:

* [spark.sql.parquet.filterPushdown.date](../../SQLConf.md#parquetFilterPushDownDate)
* [spark.sql.parquet.filterPushdown.timestamp](../../SQLConf.md#parquetFilterPushDownTimestamp)
* [spark.sql.parquet.filterPushdown.decimal](../../SQLConf.md#parquetFilterPushDownDecimal)
* [spark.sql.parquet.filterPushdown.string.startsWith](../../SQLConf.md#parquetFilterPushDownStringStartWith)
* [spark.sql.parquet.pushdown.inFilterThreshold](../../SQLConf.md#parquetFilterPushDownInFilterThreshold)
* [spark.sql.caseSensitive](../../SQLConf.md#caseSensitiveAnalysis)

`pushedParquetFilters` requests the `ParquetFilters` for the [convertibleFilters](ParquetFilters.md#convertibleFilters).

`pushedParquetFilters` is used when:

* `ParquetScanBuilder` is requested for the [pushedFilters](#pushedFilters) and to [build](#build)

## <span id="supportsNestedSchemaPruning"> supportsNestedSchemaPruning

```scala
supportsNestedSchemaPruning: Boolean
```

`supportsNestedSchemaPruning` is `true`.

`supportsNestedSchemaPruning` is part of the [FileScanBuilder](../FileScanBuilder.md#supportsNestedSchemaPruning) abstraction.
