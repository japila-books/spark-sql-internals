# Batch

`Batch` is an [abstraction](#contract) of [data source scans](#implementations) for batch queries.

## Contract

### <span id="createReaderFactory"> Creating PartitionReaderFactory

```java
PartitionReaderFactory createReaderFactory()
```

[PartitionReaderFactory](PartitionReaderFactory.md) to create a [PartitionReader](PartitionReader.md) to read records from the [input partitions](#planInputPartitions)

See:

* [ParquetScan](../datasources/parquet/ParquetScan.md#createReaderFactory)

Used when:

* `BatchScanExec` is requested for a [PartitionReaderFactory](../physical-operators/BatchScanExec.md#readerFactory)

### <span id="planInputPartitions"> Planning Input Partitions

```java
InputPartition[] planInputPartitions()
```

[InputPartition](InputPartition.md)s to scan this data source with

See:

* [FileScan](../datasources/FileScan.md#planInputPartitions)

Used when:

* `BatchScanExec` is requested for the [input partitions](../physical-operators/BatchScanExec.md#inputPartitions) and [filtered input partitions](../physical-operators/BatchScanExec.md#filteredPartitions)

## Implementations

* [FileScan](../datasources/FileScan.md)
* [KafkaBatch](../kafka/KafkaBatch.md)
