# File-Based Data Scanning

Spark SQL uses [FileScanRDD](../rdds/FileScanRDD.md) for table scans of File-Based Data Sources (e.g., [parquet](../parquet/index.md)).

The number of partitions in data scanning is based on the following:

* [maxSplitBytes hint](../files/FilePartition.md#maxSplitBytes)
* [Whether FileFormat is splitable or not](../files/FileFormat.md#isSplitable)
* [Number of split files](../files/PartitionedFileUtil.md#splitFiles)
* Bucket Pruning

File-Based Data Scanning can be [bucketed or not](../physical-operators/FileSourceScanExec.md#bucketedScan).
