# WriteJobStatsTracker

`WriteJobStatsTracker` is an [abstraction](#contract) of [write job statistics trackers](#implementations).

`WriteJobStatsTracker` is a `Serializable`.

## Contract

### <span id="newTaskInstance"> Creating WriteTaskStatsTracker

```scala
newTaskInstance(): WriteTaskStatsTracker
```

Creates a new `WriteTaskStatsTracker`

Used when:

* `FileFormatDataWriter` is [created](FileFormatDataWriter.md#statsTrackers)

### <span id="processStats"> Processing Write Job Statistics

```scala
processStats(
  stats: Seq[WriteTaskStats],
  jobCommitTime: Long): Unit
```

Used when:

* `FileFormatWriter` utility is used to [process the statistics (of a write job)](FileFormatWriter.md#processStats)

## Implementations

* [BasicWriteJobStatsTracker](BasicWriteJobStatsTracker.md)
