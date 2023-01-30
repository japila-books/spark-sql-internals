# BroadcastExchangeLike Physical Operators

`BroadcastExchangeLike` is an [extension](#contract) of the [Exchange](Exchange.md) abstraction for [physical operators](#implementations) that...FIXME

## Contract

### <span id="completionFuture"> completionFuture

```scala
completionFuture: Future[Broadcast[Any]]
```

Used when:

* `BroadcastQueryStageExec` physical operator is requested to [materializeWithTimeout](BroadcastQueryStageExec.md#materializeWithTimeout)

### <span id="relationFuture"> relationFuture

```scala
relationFuture: Future[Broadcast[Any]]
```

Used when:

* `AQEPropagateEmptyRelation` adaptive logical optimization is [executed](../logical-optimizations/AQEPropagateEmptyRelation.md#isRelationWithAllNullKeys)
* `BroadcastQueryStageExec` physical optimization is requested to [cancel](BroadcastQueryStageExec.md#cancel)

### <span id="runId"> runId

```scala
runId: UUID
```

Job group ID (for cancellation)

Used when:

* `BroadcastQueryStageExec` physical operator is requested to [cancel](BroadcastQueryStageExec.md#cancel)
* `BroadcastExchangeExec` physical operator is requested for the [relationFuture](BroadcastExchangeExec.md#relationFuture) and [doExecuteBroadcast](BroadcastExchangeExec.md#doExecuteBroadcast)

### <span id="runtimeStatistics"> Runtime Statistics

```scala
runtimeStatistics: Statistics
```

[Statistics](../logical-operators/Statistics.md) with data size and row count

See:

* [BroadcastExchangeExec](BroadcastExchangeExec.md#runtimeStatistics)

Used when:

* `BroadcastQueryStageExec` physical operator is requested for [runtime statistics](BroadcastQueryStageExec.md#getRuntimeStatistics)

## Implementations

* [BroadcastExchangeExec](BroadcastExchangeExec.md)
