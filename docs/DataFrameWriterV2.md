# DataFrameWriterV2

`DataFrameWriterV2` is a [CreateTableWriter](CreateTableWriter.md).

## Creating Instance

DataFrameWriterV2 takes the following to be created:

* Table Name
* [Dataset](spark-sql-Dataset.md)

DataFrameWriterV2 is created when `Dataset` is requested to [writeTo](spark-sql-Dataset.md#writeTo).

## create

```scala
create(): Unit
```

create...FIXME

create is part of the [CreateTableWriter](CreateTableWriter.md#create) abstraction.

## createOrReplace

```scala
createOrReplace(): Unit
```

createOrReplace...FIXME

createOrReplace is part of the [CreateTableWriter](CreateTableWriter.md#createOrReplace) abstraction.

## partitionedBy

```scala
partitionedBy(
  column: Column,
  columns: Column*): CreateTableWriter[T]
```

partitionedBy...FIXME

partitionedBy is part of the [CreateTableWriter](CreateTableWriter.md#partitionedBy) abstraction.

## replace

```scala
replace(): Unit
```

replace...FIXME

replace is part of the [CreateTableWriter](CreateTableWriter.md#replace) abstraction.

## tableProperty

```scala
tableProperty(
  property: String,
  value: String): CreateTableWriter[T]
```

tableProperty...FIXME

tableProperty is part of the [CreateTableWriter](CreateTableWriter.md#tableProperty) abstraction.

## using

```scala
using(
  provider: String): CreateTableWriter[T]
```

using...FIXME

using is part of the [CreateTableWriter](CreateTableWriter.md#using) abstraction.
