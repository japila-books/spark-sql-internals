# ExtractJoinWithBuckets Scala Extractor

## <span id="unapply"> unapply

```scala
unapply(
  plan: SparkPlan): Option[(BaseJoinExec, Int, Int)]
```

`unapply`...FIXME

`unapply` is used when:

* [CoalesceBucketsInJoin](physical-optimizations/CoalesceBucketsInJoin.md) physical optimization is executed

### <span id="isApplicable"> isApplicable

```scala
isApplicable(
  j: BaseJoinExec): Boolean
```

`isApplicable` is `true` when the following all hold:

1. The given [BaseJoinExec](../physical-operators/BaseJoinExec.md) physical operator is either a [SortMergeJoinExec](../physical-operators/SortMergeJoinExec.md) or a [ShuffledHashJoinExec](../physical-operators/ShuffledHashJoinExec.md)

1. [hasScanOperation](../ExtractJoinWithBuckets.md#hasScanOperation) on the [left](../physical-operators/BinaryExecNode.md#left) side of the join operator

1. [hasScanOperation](../ExtractJoinWithBuckets.md#hasScanOperation) on the [right](../physical-operators/BinaryExecNode.md#right) side of the join operator

1. [satisfiesOutputPartitioning](#satisfiesOutputPartitioning) on the [leftKeys](../physical-operators/BaseJoinExec.md#leftKeys) and the [outputPartitioning](../physical-operators/SparkPlan.md#outputPartitioning) of the left join operator

1. [satisfiesOutputPartitioning](#satisfiesOutputPartitioning) on the [rightKeys](../physical-operators/BaseJoinExec.md#rightKeys) and the [outputPartitioning](../physical-operators/SparkPlan.md#outputPartitioning) of the right join operator

### <span id="hasScanOperation"> hasScanOperation

```scala
hasScanOperation(
  plan: SparkPlan): Boolean
```

`hasScanOperation`...FIXME
