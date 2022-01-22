# KnownSizeEstimation

`KnownSizeEstimation` is an [abstraction](#contract) of [size estimators](#implementations) that can give a more precise [size estimation](#estimatedSize).

## Contract

### <span id="estimatedSize"> Estimated Size

```scala
estimatedSize: Long
```

`estimatedSize` is used when:

* `SizeEstimator` is requested to `visitSingleObject`
* [BroadcastExchangeExec](physical-operators/BroadcastExchangeExec.md) physical operator is requested for [relationFuture](physical-operators/BroadcastExchangeExec.md#relationFuture)
* [BroadcastHashJoinExec](physical-operators/BroadcastHashJoinExec.md) physical operator is [executed](physical-operators/BroadcastHashJoinExec.md#doExecute)
* [ShuffledHashJoinExec](physical-operators/ShuffledHashJoinExec.md) physical operator is requested to [buildHashedRelation](physical-operators/ShuffledHashJoinExec.md#buildHashedRelation)

## Implementations

* [HashedRelation](physical-operators/HashedRelation.md)
