# DataFrameWriterV2

`DataFrameWriterV2` is a [CreateTableWriter](CreateTableWriter.md).

## Creating Instance

DataFrameWriterV2 takes the following to be created:

* Table Name
* [Dataset](../spark-sql-Dataset.md)

DataFrameWriterV2 is created when `Dataset` is requested to [writeTo](../spark-sql-Dataset.md#writeTo).

## partitionedBy

```
partitionedBy(
  column: Column,
  columns: Column*): CreateTableWriter[T]
```

partitionedBy...FIXME

partitionedBy is part of the [CreateTableWriter](CreateTableWriter.md#partitionedBy) abstraction.
