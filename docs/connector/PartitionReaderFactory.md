# PartitionReaderFactory

`PartitionReaderFactory` is an [abstraction](#contract) of [partition reader factories](#implementations) that can create [partition](#createReader) or [columnar](#createColumnarReader) partition readers.

## Contract

### <span id="createColumnarReader"> createColumnarReader

```java
PartitionReader<ColumnarBatch> createColumnarReader(
    InputPartition partition)
```

Creates a columnar [partition reader](PartitionReader.md) to read data from the given [InputPartition](InputPartition.md).

By default, `createColumnarReader` throws an `UnsupportedOperationException`:

```text
Cannot create columnar reader.
```

Used when...FIXME

### <span id="createReader"> createReader

```java
PartitionReader<InternalRow> createReader(
    InputPartition partition)
```

Creates a row-based [partition reader](PartitionReader.md) to read data from the given [InputPartition](InputPartition.md).

Used when...FIXME

### <span id="supportColumnarReads"> supportColumnarReads

```java
boolean supportColumnarReads(
    InputPartition partition)
```

By default, `supportColumnarReads` indicates no support for columnar reads (and returns `false`).

Used when...FIXME

## Implementations

* `ContinuousPartitionReaderFactory`
* `FilePartitionReaderFactory`
* `KafkaBatchReaderFactory`
* `MemoryStreamReaderFactory`
* `RateStreamMicroBatchReaderFactory`
