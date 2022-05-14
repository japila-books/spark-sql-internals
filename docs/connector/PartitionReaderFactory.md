# PartitionReaderFactory

`PartitionReaderFactory` is an [abstraction](#contract) of [partition reader factories](#implementations) that can create [partition](#createReader) or [columnar](#createColumnarReader) partition readers.

## Contract

### <span id="createColumnarReader"> Creating Columnar PartitionReader

```java
PartitionReader<ColumnarBatch> createColumnarReader(
    InputPartition partition)
```

Creates a [PartitionReader](PartitionReader.md) for a columnar scan (to read data) from the given [InputPartition](InputPartition.md)

By default, `createColumnarReader` throws an `UnsupportedOperationException`:

```text
Cannot create columnar reader.
```

Used when:

* `DataSourceRDD` is requested to [compute a partition](../DataSourceRDD.md#compute)

### <span id="createReader"> Creating PartitionReader

```java
PartitionReader<InternalRow> createReader(
    InputPartition partition)
```

Creates a [PartitionReader](PartitionReader.md) for a row-based scan (to read data) from the given [InputPartition](InputPartition.md)

Used when:

* `DataSourceRDD` is requested to [compute a partition](../DataSourceRDD.md#compute)
* `ContinuousDataSourceRDD` (Spark Structured Streaming) is requested to `compute` a partition

### <span id="supportColumnarReads"> supportColumnarReads

```java
boolean supportColumnarReads(
    InputPartition partition)
```

Controls whether columnar scan can be used (and hence [createColumnarReader](#createColumnarReader)) or not

By default, `supportColumnarReads` indicates no support for columnar scans (and returns `false`).

Used when:

* `DataSourceV2ScanExecBase` is requested to [supportsColumnar](../physical-operators/DataSourceV2ScanExecBase.md#supportsColumnar)

## Implementations

* `ContinuousPartitionReaderFactory`
* [FilePartitionReaderFactory](../datasources/FilePartitionReaderFactory.md)
* `KafkaBatchReaderFactory`
* `MemoryStreamReaderFactory`
* `RateStreamMicroBatchReaderFactory`
