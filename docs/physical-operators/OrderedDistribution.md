# OrderedDistribution

`OrderedDistribution` is a [Distribution](Distribution.md) for [ordered](#ordering) data distribution requirement (of [SortExec](SortExec.md#requiredChildDistribution) physical operator with global sort).

## Creating Instance

`OrderedDistribution` takes the following to be created:

* <span id="ordering"> [SortOrder](../expressions/SortOrder.md) expressions (for ordering)

`OrderedDistribution` is created when:

* `SortExec` physical operator is requested for the [requiredChildDistribution](SortExec.md#requiredChildDistribution) (with global sort)

## <span id="requiredNumPartitions"> Required Number of Partitions

```scala
requiredNumPartitions: Option[Int]
```

`requiredNumPartitions` is undefined (`None`).

`requiredNumPartitions` is part of the [Distribution](Distribution.md#requiredNumPartitions) abstraction.

## <span id="createPartitioning"> Creating Partitioning

```scala
createPartitioning(
  numPartitions: Int): Partitioning
```

`createPartitioning` creates a [RangePartitioning](../expressions/RangePartitioning.md) expression.

`createPartitioning` is part of the [Distribution](Distribution.md#createPartitioning) abstraction.
