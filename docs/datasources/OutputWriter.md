# OutputWriter

`OutputWriter` is an [abstraction](#contract) of [output writers](#implementations) that [write rows to a file system](#write).

## Contract

### <span id="close"> Closing

```scala
close(): Unit
```

Closes this `OutputWriter`

Used when:

* `FileFormatDataWriter` is requested to [releaseCurrentWriter](FileFormatDataWriter.md#releaseCurrentWriter)
* `DynamicPartitionDataConcurrentWriter` is requested to `releaseResources`

### <span id="path"> Path

```scala
path(): String
```

The file path to write records to

Used when:

* `FileFormatDataWriter` is requested to [releaseCurrentWriter](FileFormatDataWriter.md#releaseCurrentWriter)
* `SingleDirectoryDataWriter` is requested to [write](SingleDirectoryDataWriter.md#write)
* `BaseDynamicPartitionDataWriter` is requested to `writeRecord`

### <span id="write"> Writing Row Out

```scala
write(
  row: InternalRow): Unit
```

Writes out a single [InternalRow](../InternalRow.md)

Used when:

* `SingleDirectoryDataWriter` is requested to [write](SingleDirectoryDataWriter.md#write)
* `BaseDynamicPartitionDataWriter` is requested to `writeRecord`

## Implementations

* `AvroOutputWriter`
* `CsvOutputWriter`
* `HiveOutputWriter`
* `JsonOutputWriter`
* `LibSVMOutputWriter`
* `OrcOutputWriter`
* `OrcOutputWriter`
* `ParquetOutputWriter`
* `TextOutputWriter`
