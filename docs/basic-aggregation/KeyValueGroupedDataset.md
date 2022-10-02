# KeyValueGroupedDataset

`KeyValueGroupedDataset` is an interface for **Typed Grouping** to calculate aggregates over groups of objects in a typed [Dataset](../Dataset.md).

!!! note
    [RelationalGroupedDataset](RelationalGroupedDataset.md) is used for untyped `Row`-based aggregates.

## Creating Instance

`KeyValueGroupedDataset` takes the following to be created:

* <span id="kEncoder"> Key [Encoder](../Encoder.md)
* <span id="vEncoder"> Value [Encoder](../Encoder.md)
* <span id="queryExecution"> [QueryExecution](../QueryExecution.md)
* <span id="dataAttributes"> Data [Attribute](../expressions/Attribute.md)s
* <span id="groupingAttributes"> Grouping [Attribute](../expressions/Attribute.md)s

`KeyValueGroupedDataset` is created for the following high-level operators:

* [Dataset.groupByKey](index.md#groupByKey)
* [KeyValueGroupedDataset.keyAs](#keyAs)
* [KeyValueGroupedDataset.mapValues](#mapValues)
* [RelationalGroupedDataset.as](RelationalGroupedDataset.md#as)

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

`flatMapGroupsWithState` creates a [Dataset](../Dataset.md#apply) with a [FlatMapGroupsWithState](../logical-operators/FlatMapGroupsWithState.md) logical operator (with the [isMapGroupsWithState](../logical-operators/FlatMapGroupsWithState.md#isMapGroupsWithState) disabled).

`flatMapGroupsWithState` accepts `Append` and `Update` output modes only, and throws an `IllegalArgumentException` for the others:

```text
The output mode of function should be append or update
```
