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

## <span id="outputPartitioning"> Output Data Partitioning Requirements

```scala
outputPartitioning: Partitioning
```

`outputPartitioning` is part of the [SparkPlan](SparkPlan.md#outputPartitioning) abstraction.

`outputPartitioning`...FIXME

## <span id="output"> Output Attributes

```scala
output: Seq[Attribute]
```

`output` is part of the [QueryPlan](../catalyst/QueryPlan.md#output) abstraction.

`output`...FIXME
