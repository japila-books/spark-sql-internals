# ParquetScanBuilder

`ParquetScanBuilder` is a [FileScanBuilder](../../FileScanBuilder.md) that [SupportsPushDownFilters](../../connector/SupportsPushDownFilters.md).

## Creating Instance

`ParquetScanBuilder` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="fileIndex"> [PartitioningAwareFileIndex](../../PartitioningAwareFileIndex.md)
* <span id="schema"> [Schema](../../types/StructType.md)
* <span id="dataSchema"> [Data Schema](../../types/StructType.md)
* <span id="options"> Case-Insensitive Options

`ParquetScanBuilder` is created when:

* `ParquetTable` is requested to [newScanBuilder](ParquetTable.md#newScanBuilder)
