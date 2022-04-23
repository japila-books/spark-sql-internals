# ParquetScan

`ParquetScan` is a [FileScan](../../FileScan.md).

## Creating Instance

`ParquetScan` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../../SparkSession.md)
* <span id="hadoopConf"> Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html)
* <span id="fileIndex"> [PartitioningAwareFileIndex](../../PartitioningAwareFileIndex.md)
* <span id="dataSchema"> Data [schema](../../types/StructType.md)
* <span id="readDataSchema"> Read data [schema](../../types/StructType.md)
* <span id="readPartitionSchema"> Read partition [schema](../../types/StructType.md)
* <span id="pushedFilters"> Pushed [Filter](../../Filter.md)s
* <span id="options"> Case-insensitive options
* <span id="partitionFilters"> Partition filter [expression](../../expressions/Expression.md)s (optional)
* <span id="dataFilters"> Data filter [expression](../../expressions/Expression.md)s (optional)

`ParquetScan` is created when:

* `ParquetScanBuilder` is requested to [build a Scan](ParquetScanBuilder.md#build)

## <span id="createReaderFactory"> createReaderFactory

```scala
createReaderFactory(): PartitionReaderFactory
```

`createReaderFactory` creates a [ParquetPartitionReaderFactory](ParquetPartitionReaderFactory.md) (with the [Hadoop Configuration](#hadoopConf) broadcast).

`createReaderFactory` adds the following properties to the [Hadoop Configuration](#hadoopConf) before broadcasting it (to executors).

Name | Value
-----|------
 `ParquetInputFormat.READ_SUPPORT_CLASS` | [ParquetReadSupport](ParquetReadSupport.md)
 _others_ |

---

`createReaderFactory` is part of the [Batch](../../connector/Batch.md#createReaderFactory) abstraction.

## <span id="isSplitable"> isSplitable

```scala
isSplitable(
  path: Path): Boolean
```

`isSplitable` is `true`.

`isSplitable` is part of the [FileScan](../../FileScan.md#isSplitable) abstraction.
