# ExtractJoinWithBuckets Scala Extractor

## <span id="unapply"> Destructuring BaseJoinExec

```scala
unapply(
  plan: SparkPlan): Option[(BaseJoinExec, Int, Int)]
```

`unapply` makes sure that the given [SparkPlan](physical-operators/SparkPlan.md) is a [BaseJoinExec](physical-operators/BaseJoinExec.md) and [applicable](#isApplicable).

If so, `unapply` [getBucketSpec](#getBucketSpec) for the [left](physical-operators/BinaryExecNode.md#left) and [right](physical-operators/BinaryExecNode.md#right) join child operators.

`unapply`...FIXME

`unapply` is used when:

* [CoalesceBucketsInJoin](physical-optimizations/CoalesceBucketsInJoin.md) physical optimization is executed

### <span id="isApplicable"> isApplicable

```scala
isApplicable(
  j: BaseJoinExec): Boolean
```

`isApplicable` is `true` when the following all hold:

1. The given [BaseJoinExec](physical-operators/BaseJoinExec.md) physical operator is either a [SortMergeJoinExec](physical-operators/SortMergeJoinExec.md) or a [ShuffledHashJoinExec](physical-operators/ShuffledHashJoinExec.md)

1. The [left](physical-operators/BinaryExecNode.md#left) side of the join [has a FileSourceScanExec operator](ExtractJoinWithBuckets.md#hasScanOperation)

1. The [right](physical-operators/BinaryExecNode.md#right) side of the join [has a FileSourceScanExec operator](ExtractJoinWithBuckets.md#hasScanOperation)

1. [satisfiesOutputPartitioning](#satisfiesOutputPartitioning) on the [leftKeys](physical-operators/BaseJoinExec.md#leftKeys) and the [outputPartitioning](physical-operators/SparkPlan.md#outputPartitioning) of the left join operator

1. [satisfiesOutputPartitioning](#satisfiesOutputPartitioning) on the [rightKeys](physical-operators/BaseJoinExec.md#rightKeys) and the [outputPartitioning](physical-operators/SparkPlan.md#outputPartitioning) of the right join operator

### <span id="hasScanOperation"> hasScanOperation

```scala
hasScanOperation(
  plan: SparkPlan): Boolean
```

`hasScanOperation` holds `true` for [SparkPlan](physical-operators/SparkPlan.md) physical operators that are [FileSourceScanExec](physical-operators/FileSourceScanExec.md)s (possibly as the children of [FilterExec](physical-operators/FilterExec.md)s and [ProjectExec](physical-operators/ProjectExec.md)s).

### <span id="satisfiesOutputPartitioning"> satisfiesOutputPartitioning

```scala
satisfiesOutputPartitioning(
  keys: Seq[Expression],
  partitioning: Partitioning): Boolean
```

`satisfiesOutputPartitioning` holds `true` for [HashPartitioning](expressions/HashPartitioning.md) partitionings that match the given join keys (their number and equivalence).

### <span id="getBucketSpec"> Bucket Spec of FileSourceScanExec Operator

```scala
getBucketSpec(
  plan: SparkPlan): Option[BucketSpec]
```

`getBucketSpec` finds the [FileSourceScanExec](physical-operators/FileSourceScanExec.md) operator (in the given [SparkPlan](physical-operators/SparkPlan.md)) with a non-empty [bucket spec](HadoopFsRelation.md#bucketSpec) but an empty [optionalNumCoalescedBuckets](physical-operators/FileSourceScanExec.md#optionalNumCoalescedBuckets). When found, `getBucketSpec` returns the non-empty [bucket spec](HadoopFsRelation.md#bucketSpec).
