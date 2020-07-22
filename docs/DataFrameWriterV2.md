# DataFrameWriterV2

`DataFrameWriterV2` is a [CreateTableWriter](new-in-300/CreateTableWriter.md).

```scala
val nums = spark.range(5)
scala> :type nums
org.apache.spark.sql.Dataset[Long]

// Create a DataFrameWriterV2
val writerV2 = nums.writeTo("t1")
scala> :type writerV2
org.apache.spark.sql.DataFrameWriterV2[Long]
```

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

create is part of the [CreateTableWriter](new-in-300/CreateTableWriter.md#create) abstraction.

## createOrReplace

```scala
createOrReplace(): Unit
```

createOrReplace...FIXME

createOrReplace is part of the [CreateTableWriter](new-in-300/CreateTableWriter.md#createOrReplace) abstraction.

## partitionedBy

```scala
partitionedBy(
  column: Column,
  columns: Column*): CreateTableWriter[T]
```

partitionedBy...FIXME

partitionedBy is part of the [CreateTableWriter](new-in-300/CreateTableWriter.md#partitionedBy) abstraction.

## replace

```scala
replace(): Unit
```

replace...FIXME

replace is part of the [CreateTableWriter](new-in-300/CreateTableWriter.md#replace) abstraction.

## tableProperty

```scala
tableProperty(
  property: String,
  value: String): CreateTableWriter[T]
```

tableProperty...FIXME

tableProperty is part of the [CreateTableWriter](new-in-300/CreateTableWriter.md#tableProperty) abstraction.

## using

```scala
using(
  provider: String): CreateTableWriter[T]
```

using...FIXME

using is part of the [CreateTableWriter](new-in-300/CreateTableWriter.md#using) abstraction.
