# FilePartitionReaderFactory

`FilePartitionReaderFactory` is an [extension](#contract) of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md) abstraction for [PartitionReader factories of file-based connectors](#implementations).

## Contract

### <span id="buildReader"> Building PartitionReader

```scala
buildReader(
  partitionedFile: PartitionedFile): PartitionReader[InternalRow]
```

[PartitionReader](../connector/PartitionReader.md) (of [InternalRow](../InternalRow.md)s)

See:

* [ParquetPartitionReaderFactory](parquet/ParquetPartitionReaderFactory.md#buildReader)

Used when:

* `FilePartitionReaderFactory` is requested to [create a reader](#createReader)

### <span id="buildColumnarReader"> Building Columnar PartitionReader

```scala
buildColumnarReader(
  partitionedFile: PartitionedFile): PartitionReader[ColumnarBatch]
```

[PartitionReader](../connector/PartitionReader.md) (of [ColumnarBatch](../vectorized-query-execution/ColumnarBatch.md)s)

See:

* [ParquetPartitionReaderFactory](parquet/ParquetPartitionReaderFactory.md#buildColumnarReader)

Used when:

* `FilePartitionReaderFactory` is requested to [create a columnar reader](#createColumnarReader)

### <span id="options"> Options

```scala
options: FileSourceOptions
```

See:

* [ParquetPartitionReaderFactory](parquet/ParquetPartitionReaderFactory.md#options)

Used when:

* `FilePartitionReaderFactory` is requested to create a [reader](#createReader) and [columnar reader](#createColumnarReader)

## Implementations

* `AvroPartitionReaderFactory`
* `CSVPartitionReaderFactory`
* `JsonPartitionReaderFactory`
* `OrcPartitionReaderFactory`
* [ParquetPartitionReaderFactory](parquet/ParquetPartitionReaderFactory.md)
* `TextPartitionReaderFactory`

## <span id="createReader"> Creating PartitionReader

??? note "Signature"

    ```scala
    createReader(
      partition: InputPartition): PartitionReader[InternalRow]
    ```

    `createReader` is part of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md#createReader) abstraction.

`createReader`...FIXME

## <span id="createColumnarReader"> Creating Columnar PartitionReader

??? note "Signature"

    ```scala
    createColumnarReader(
      partition: InputPartition): PartitionReader[ColumnarBatch]
    ```

    `createColumnarReader` is part of the [PartitionReaderFactory](../connector/PartitionReaderFactory.md#createColumnarReader) abstraction.

`createColumnarReader` makes sure that the given [InputPartition](../connector/InputPartition.md) is a [FilePartition](FilePartition.md) (or throws an `AssertionError`).

`createColumnarReader` creates a new [columnar PartitionReader](#buildColumnarReader) for every [PartitionedFile](FilePartition.md#files) (of the `FilePartition`).

In the end, `createColumnarReader` creates a `FilePartitionReader` for the files.
