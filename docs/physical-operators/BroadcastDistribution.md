# BroadcastDistribution

`BroadcastDistribution` is a [data distribution requirement](Distribution.md) of the children of [BroadcastHashJoinExec](BroadcastHashJoinExec.md) and [BroadcastNestedLoopJoinExec](BroadcastNestedLoopJoinExec.md) physical operators.

## Creating Instance

`BroadcastDistribution` takes the following to be created:

* <span id="mode"> [BroadcastMode](BroadcastMode.md)

`BroadcastDistribution` is created when [BroadcastHashJoinExec](BroadcastHashJoinExec.md) and [BroadcastNestedLoopJoinExec](BroadcastNestedLoopJoinExec.md) physical operators are requested for the [required child distribution](SparkPlan.md#requiredChildDistribution).

## <span id="requiredNumPartitions"> Required Number of Partitions

```scala
requiredNumPartitions: Option[Int]
```

`requiredNumPartitions` is always `1`.

`requiredNumPartitions` is part of the [Distribution](Distribution.md#requiredNumPartitions) abstraction.

## <span id="createPartitioning"> Creating BroadcastPartitioning

```scala
createPartitioning(
  numPartitions: Int): Partitioning
```

`createPartitioning` creates a [BroadcastPartitioning](Partitioning.md#BroadcastPartitioning).

`createPartitioning` throws an `AssertionError` when the given `numPartitions` is not `1`:

```text
The default partitioning of BroadcastDistribution can only have 1 partition.
```

`createPartitioning` is part of the [Distribution](Distribution.md#createPartitioning) abstraction.
