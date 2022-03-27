# ShufflePartitionsUtil

## <span id="coalescePartitions"> coalescePartitions

```scala
coalescePartitions(
  mapOutputStatistics: Seq[Option[MapOutputStatistics]],
  inputPartitionSpecs: Seq[Option[Seq[ShufflePartitionSpec]]],
  advisoryTargetSize: Long,
  minNumPartitions: Int,
  minPartitionSize: Long): Seq[Seq[ShufflePartitionSpec]]
```

`coalescePartitions` does nothing and returns an empty result with empty `mapOutputStatistics`.

`coalescePartitions` calculates the total shuffle bytes (`totalPostShuffleInputSize`) by suming up the`bytesByPartitionId` (of a `shuffleId`) for every`MapOutputStatistics` (in `mapOutputStatistics`).

`coalescePartitions` calculates the maximum target size (`maxTargetSize`) to be a ratio of the total shuffle bytes and the given `minNumPartitions`.

`coalescePartitions` determines the target size (`targetSize`) to be not larger than the given `minPartitionSize`.

`coalescePartitions` prints out the following INFO message to the logs:

```text
For shuffle([shuffleIds]), advisory target size: [advisoryTargetSize],
actual target size [targetSize], minimum partition size: [minPartitionSize]
```

`coalescePartitions` [coalescePartitionsWithoutSkew](#coalescePartitionsWithoutSkew) with all the given `inputPartitionSpecs` empty or [coalescePartitionsWithSkew](#coalescePartitionsWithSkew).

!!! info "inputPartitionSpecs"
    `inputPartitionSpecs` can be empty for [ShuffleQueryStageExec](../physical-operators/ShuffleQueryStageExec.md)s and available for [AQEShuffleReadExec](../physical-operators/AQEShuffleReadExec.md)s.

`coalescePartitions` is used when:

* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md) adaptive physical optimization is executed

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.adaptive.ShufflePartitionsUtil` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.adaptive.ShufflePartitionsUtil=ALL
```

Refer to [Logging](../spark-logging.md).
