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

`coalescePartitions`...FIXME

`coalescePartitions` is used when:

* [CoalesceShufflePartitions](../physical-optimizations/CoalesceShufflePartitions.md) adaptive physical optimization is executed
