# SimpleTableProvider

`SimpleTableProvider` is an [extension](#contract) of the [TableProvider](TableProvider.md) abstraction for [table providers](#implementations) that do not support custom table schema and partitioning.

## Contract

### <span id="getTable"> Creating Table

```scala
getTable(
  options: CaseInsensitiveStringMap): Table
```

Creates a [Table](Table.md)

Used for [getOrLoadTable](#getOrLoadTable)

## Implementations

* ConsoleSinkProvider (Spark Structured Streaming)
* [KafkaSourceProvider](../datasources/kafka/KafkaSourceProvider.md)
* MemoryStreamTableProvider (Spark Structured Streaming)
* [NoopDataSource](../datasources/NoopDataSource.md)
* RateStreamProvider (Spark Structured Streaming)
* TextSocketSourceProvider (Spark Structured Streaming)

## <span id="inferSchema"> Inferring Schema

```scala
inferSchema(
  options: CaseInsensitiveStringMap): StructType
```

`inferSchema` [creates a table](#getOrLoadTable) and requests it for the [schema](Table.md#schema).

`inferSchema` is part of the [TableProvider](TableProvider.md#inferSchema) abstraction.

## <span id="getTable-TableProvider"> Creating Table

```scala
getTable(
  schema: StructType,
  partitioning: Array[Transform],
  properties: util.Map[String, String]): Table
```

`getTable` [creates a table](#getOrLoadTable) (with the given `properties`).

`getTable` asserts that there are no `Transform`s in given `partitioning`.

`getTable` is part of the [TableProvider](TableProvider.md#getTable) abstraction.

## <span id="getOrLoadTable"> Looking Up Table Once

```scala
getOrLoadTable(
  options: CaseInsensitiveStringMap): Table
```

`getOrLoadTable` [creates a table](#getTable) and caches it for later use (in an internal variable).
