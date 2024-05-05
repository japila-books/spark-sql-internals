---
title: ShuffledJoin
---

# ShuffledJoin Physical Operators

`ShuffledJoin` is an [extension](#contract) of the [JoinCodegenSupport](JoinCodegenSupport.md) abstraction for [join operators](#implementations) that shuffle two child relations using some join keys.

## Contract

### <span id="isSkewJoin"> isSkewJoin Flag

```scala
isSkewJoin: Boolean
```

Used when:

* `ShuffledJoin` is requested for [node name](#nodeName) and [requiredChildDistribution](#requiredChildDistribution)

## Implementations

* [ShuffledHashJoinExec](ShuffledHashJoinExec.md)
* [SortMergeJoinExec](SortMergeJoinExec.md)

## <span id="nodeName"> Node Name

```scala
nodeName: String
```

`nodeName` adds `(skew=true)` suffix to the default [node name](../catalyst/TreeNode.md#nodeName) when the [isSkewJoin](#isSkewJoin) flag is enabled.

`nodeName` is part of the [TreeNode](../catalyst/TreeNode.md#nodeName) abstraction.

## <span id="requiredChildDistribution"> Required Child Output Distribution

```scala
requiredChildDistribution: Seq[Distribution]
```

`requiredChildDistribution` are [HashClusteredDistribution](HashClusteredDistribution.md)s for the [left](BaseJoinExec.md#leftKeys) and [right](BaseJoinExec.md#rightKeys) keys.

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.
