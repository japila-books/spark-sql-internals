# ParquetPartitionReaderFactory

`ParquetPartitionReaderFactory` is...FIXME

## <span id="buildReaderBase"> buildReaderBase

```scala
buildReaderBase[T](
  file: PartitionedFile,
  buildReaderFunc: (
    FileSplit,
    InternalRow,
    TaskAttemptContextImpl,
    Option[FilterPredicate],
    Option[ZoneId],
    RebaseSpec,
    RebaseSpec) => RecordReader[Void, T]): RecordReader[Void, T]
```

`buildReaderBase`...FIXME

`buildReaderBase` is used when:

* FIXME
