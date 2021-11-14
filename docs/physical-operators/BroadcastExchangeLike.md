# BroadcastExchangeLike Physical Operators

`BroadcastExchangeLike` is an [extension](#contract) of the [Exchange](Exchange.md) abstraction for [physical operators](#implementations) that...FIXME

## Contract

### <span id="completionFuture"> completionFuture

```scala
completionFuture: Future[Broadcast[Any]]
```

Used when:

* `BroadcastQueryStageExec` physical operator is requested to [materializeWithTimeout](../adaptive-query-execution/BroadcastQueryStageExec.md#materializeWithTimeout)

### <span id="relationFuture"> relationFuture

```scala
relationFuture: Future[Broadcast[Any]]
```

Used when:

* `AQEPropagateEmptyRelation` adaptive logical optimization is [executed](../adaptive-query-execution/AQEPropagateEmptyRelation.md#isRelationWithAllNullKeys)
* `BroadcastQueryStageExec` physical optimization is requested to [cancel](../adaptive-query-execution/BroadcastQueryStageExec.md#cancel)

### <span id="runId"> runId

```scala
runId: UUID
```

Job group ID (for cancellation)

Used when:

* `BroadcastQueryStageExec` physical operator is requested to [cancel](../adaptive-query-execution/BroadcastQueryStageExec.md#cancel)
* `BroadcastExchangeExec` physical operator is requested for the [relationFuture](BroadcastExchangeExec.md#relationFuture) and [doExecuteBroadcast](BroadcastExchangeExec.md#doExecuteBroadcast)

### <span id="runtimeStatistics"> runtimeStatistics

```scala
runtimeStatistics: Statistics
```

Used when:

* `BroadcastQueryStageExec` physical operator is requested for [runtime statistics](../adaptive-query-execution/BroadcastQueryStageExec.md#getRuntimeStatistics)

## Implementations

* [BroadcastExchangeExec](BroadcastExchangeExec.md)
