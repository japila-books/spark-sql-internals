# FilePartitionReaderFactory

`FilePartitionReaderFactory` is an [extension](#contract) of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md) abstraction for [file-based PartitionReader factories](#implementations).

## Implementations

* `AvroPartitionReaderFactory`
* `CSVPartitionReaderFactory`
* `JsonPartitionReaderFactory`
* `OrcPartitionReaderFactory`
* [ParquetPartitionReaderFactory](parquet/ParquetPartitionReaderFactory.md)
* `TextPartitionReaderFactory`

## <span id="createReader"> Creating PartitionReader

```scala
createReader(
  partition: InputPartition): PartitionReader[InternalRow]
```

`createReader`...FIXME

`createReader` is part of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md#createReader) abstraction.

## <span id="createColumnarReader"> Creating Columnar PartitionReader

```scala
createColumnarReader(
  partition: InputPartition): PartitionReader[ColumnarBatch]
```

`createColumnarReader`...FIXME

`createColumnarReader` is part of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md#createColumnarReader) abstraction.
