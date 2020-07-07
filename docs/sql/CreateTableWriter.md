# CreateTableWriter

`CreateTableWriter` is an [extension](#contract) of the [WriteConfigMethods](WriteConfigMethods.md) abstraction for [writers](#implementations).

## Contract

### create

```scala
create(): Unit
```

### createOrReplace

```scala
createOrReplace(): Unit
```

### partitionedBy

```scala
partitionedBy(
  column: Column,
  columns: Column*): CreateTableWriter[T]
```

### replace

```scala
replace(): Unit
```

### tableProperty

```scala
tableProperty(
  property: String,
  value: String): CreateTableWriter[T]
```

### using

```scala
using(
  provider: String): CreateTableWriter[T]
```

## Implementations

[DataFrameWriterV2](DataFrameWriterV2.md) is the default and only known `CreateTableWriter`.
