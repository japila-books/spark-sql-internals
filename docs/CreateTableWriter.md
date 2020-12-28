# CreateTableWriter

`CreateTableWriter` is an [extension](#contract) of the [WriteConfigMethods](WriteConfigMethods.md) abstraction for [table writers](#implementations).

## Contract

### create

```scala
create(): Unit
```

Creates a new table from the contents of the dataframe

### createOrReplace

```scala
createOrReplace(): Unit
```

Creates a new table or replaces an existing table with the contents of the dataframe

### partitionedBy

```scala
partitionedBy(
  column: Column,
  columns: Column*): CreateTableWriter[T]
```

Defines partition(s) of the output table

### replace

```scala
replace(): Unit
```

Replaces an existing table with the contents of the dataframe

### tableProperty

```scala
tableProperty(
  property: String,
  value: String): CreateTableWriter[T]
```

Adds a table property

### using

```scala
using(
  provider: String): CreateTableWriter[T]
```

Specifies the provider for the underlying output data source

## Implementations

* [DataFrameWriterV2](DataFrameWriterV2.md)
