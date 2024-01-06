# OutputWriter

`OutputWriter` is an [abstraction](#contract) of [output writers](#implementations) that [write rows to a file system](#write).

## Contract

### Closing { #close }

```scala
close(): Unit
```

Closes this `OutputWriter`

Used when:

* `FileFormatDataWriter` is requested to [releaseCurrentWriter](../files/FileFormatDataWriter.md#releaseCurrentWriter)
* `DynamicPartitionDataConcurrentWriter` is requested to `releaseResources`

### Path { #path }

```scala
path(): String
```

The file path to write records to

Used when:

* `FileFormatDataWriter` is requested to [releaseCurrentWriter](../files/FileFormatDataWriter.md#releaseCurrentWriter)
* `SingleDirectoryDataWriter` is requested to [write](../files/SingleDirectoryDataWriter.md#write)
* `BaseDynamicPartitionDataWriter` is requested to [writeRecord](../files/BaseDynamicPartitionDataWriter.md#writeRecord)

### Writing Row Out { #write }

```scala
write(
  row: InternalRow): Unit
```

Writes out a single [InternalRow](../InternalRow.md)

Used when:

* `SingleDirectoryDataWriter` is requested to [write](../files/SingleDirectoryDataWriter.md#write)
* `BaseDynamicPartitionDataWriter` is requested to [writeRecord](../files/BaseDynamicPartitionDataWriter.md#writeRecord)

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
