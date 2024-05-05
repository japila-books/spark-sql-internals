---
tags:
  - DeveloperApi
---

# KeyValueGroupedDataset

`KeyValueGroupedDataset` is a high-level API for **Typed Grouping** (part of [Basic Aggregation](aggregations/index.md)) to calculate aggregates over groups of objects in a typed [Dataset](dataset/index.md).

`KeyValueGroupedDataset` represents a **grouped dataset** as a result of [Dataset.groupByKey](dataset/index.md#groupByKey) operator (that aggregates records by a grouping function).

```text
// Dataset[T]
groupByKey(
  func: T => K): KeyValueGroupedDataset[K, T]
```

`KeyValueGroupedDataset` works for batch and [streaming](#spark-structured-streaming) aggregations.

??? note "RelationalGroupedDataset"
    [RelationalGroupedDataset](RelationalGroupedDataset.md) is used for untyped `Row`-based aggregates.

## Creating Instance

`KeyValueGroupedDataset` takes the following to be created:

* <span id="kEncoder"> Key [Encoder](Encoder.md)
* <span id="vEncoder"> Value [Encoder](Encoder.md)
* <span id="queryExecution"> [QueryExecution](QueryExecution.md)
* <span id="dataAttributes"> Data [Attribute](expressions/Attribute.md)s
* <span id="groupingAttributes"> Grouping [Attribute](expressions/Attribute.md)s

`KeyValueGroupedDataset` is created for the following high-level operators:

* [Dataset.groupByKey](index.md#groupByKey)
* [KeyValueGroupedDataset.keyAs](#keyAs)
* [KeyValueGroupedDataset.mapValues](#mapValues)
* [RelationalGroupedDataset.as](RelationalGroupedDataset.md#as)

## agg { #agg }

```scala
agg[U1](
  col1: TypedColumn[V, U1]): Dataset[(K, U1)]
agg[U1, U2](
  col1: TypedColumn[V, U1],
  col2: TypedColumn[V, U2]): Dataset[(K, U1, U2)]
...
agg[U1, U2, U3, U4, U5, U6, U7, U8](
  col1: TypedColumn[V, U1],
  col2: TypedColumn[V, U2],
  col3: TypedColumn[V, U3],
  col4: TypedColumn[V, U4],
  col5: TypedColumn[V, U5],
  col6: TypedColumn[V, U6],
  col7: TypedColumn[V, U7],
  col8: TypedColumn[V, U8]): Dataset[(K, U1, U2, U3, U4, U5, U6, U7, U8)]
```

`agg` [aggUntyped](#aggUntyped).

### aggUntyped { #aggUntyped }

```scala
aggUntyped(
  columns: TypedColumn[_, _]*): Dataset[_]
```

`aggUntyped` creates a [Dataset](dataset/index.md) with an [Aggregate](logical-operators/Aggregate.md) logical operator (with the [grouping attributes](#groupingAttributes)).

## <span id="flatMapGroupsWithState"> flatMapGroupsWithState

```scala
flatMapGroupsWithState[S: Encoder, U: Encoder](
  outputMode: OutputMode,
  timeoutConf: GroupStateTimeout)(
  func: (K, Iterator[V], GroupState[S]) => Iterator[U]): Dataset[U]
flatMapGroupsWithState[S: Encoder, U: Encoder](
  outputMode: OutputMode,
  timeoutConf: GroupStateTimeout,
  initialState: KeyValueGroupedDataset[K, S])(
  func: (K, Iterator[V], GroupState[S]) => Iterator[U]): Dataset[U]
```

`flatMapGroupsWithState` creates a [Dataset](dataset/index.md#apply) with a [FlatMapGroupsWithState](logical-operators/FlatMapGroupsWithState.md) logical operator (with the [isMapGroupsWithState](logical-operators/FlatMapGroupsWithState.md#isMapGroupsWithState) disabled).

`flatMapGroupsWithState` accepts `Append` and `Update` output modes only, and throws an `IllegalArgumentException` for the others:

```text
The output mode of function should be append or update
```

## Spark Structured Streaming

`KeyValueGroupedDataset` can be used in streaming queries in Spark Structured Streaming:

* [Streaming Aggregation]({{ book.structured_streaming }}/streaming-aggregation)
* [Arbitrary Stateful Streaming Aggregation]({{ book.structured_streaming }}/arbitrary-stateful-streaming-aggregation)

## Demo

```text
import java.sql.Timestamp
val numGroups = spark.
  readStream.
  format("rate").
  load.
  as[(Timestamp, Long)].
  groupByKey { case (time, value) => value % 2 }

scala> :type numGroups
org.apache.spark.sql.KeyValueGroupedDataset[Long,(java.sql.Timestamp, Long)]
```
