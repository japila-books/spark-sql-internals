# BroadcastModes

`BroadcastMode` is an [abstraction](#contract) of [broadcast modes](#implementations) that can [transform internal rows (with optional size hint)](#transform).

`BroadcastMode` is used to create:

* [BroadcastDistribution](BroadcastDistribution.md)
* [BroadcastPartitioning](Partitioning.md#BroadcastPartitioning)
* [BroadcastExchangeExec](BroadcastExchangeExec.md) physical operator

## Contract

### <span id="canonicalized"> Canonicalized Form

```scala
canonicalized: BroadcastMode
```

### <span id="transform"> Transform Rows with Optional Size Hint

```scala
transform(
  rows: Iterator[InternalRow],
  sizeHint: Option[Long]): Any
```

Used when [BroadcastExchangeExec](BroadcastExchangeExec.md) physical operator is requested for [relationFuture](BroadcastExchangeExec.md#relationFuture)

### <span id="transform-rows"> Transform Rows

```scala
transform(
  rows: Array[InternalRow]): Any
```

!!! note
    `transform(rows)` does not seem to be used.

## Implementations

* [HashedRelationBroadcastMode](HashedRelationBroadcastMode.md)
* `IdentityBroadcastMode`
