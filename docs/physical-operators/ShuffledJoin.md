# ShuffledJoin Physical Operators

`ShuffledJoin` is an extension of the [BaseJoinExec](BaseJoinExec.md) abstraction for [join operators](#implementations) that shuffle two child relations using the join keys.

## Implementations

* [ShuffledHashJoinExec](ShuffledHashJoinExec.md)
* [SortMergeJoinExec](SortMergeJoinExec.md)

## <span id="requiredChildDistribution"> Required Child Output Distribution

```scala
requiredChildDistribution: Seq[Distribution]
```

`requiredChildDistribution` is part of the [SparkPlan](SparkPlan.md#requiredChildDistribution) abstraction.

`requiredChildDistribution` are [HashClusteredDistribution](HashClusteredDistribution.md)s for the [left](BaseJoinExec.md#leftKeys) and [right](BaseJoinExec.md#rightKeys) keys.
