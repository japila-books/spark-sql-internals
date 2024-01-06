# WriteJobStatsTracker

`WriteJobStatsTracker` is an [abstraction](#contract) of [write job statistics trackers](#implementations).

`WriteJobStatsTracker` is a `Serializable`.

## Contract

### Creating WriteTaskStatsTracker { #newTaskInstance }

```scala
newTaskInstance(): WriteTaskStatsTracker
```

Creates a new [WriteTaskStatsTracker](WriteTaskStatsTracker.md)

See:

* [BasicWriteJobStatsTracker](BasicWriteJobStatsTracker.md#newTaskInstance)

Used when:

* `FileFormatDataWriter` is [created](FileFormatDataWriter.md#statsTrackers)

### Processing Write Job Statistics { #processStats }

```scala
processStats(
  stats: Seq[WriteTaskStats],
  jobCommitTime: Long): Unit
```

See:

* [BasicWriteJobStatsTracker](BasicWriteJobStatsTracker.md#processStats)

Used when:

* `FileFormatWriter` utility is used to [process the statistics (of a write job)](FileFormatWriter.md#processStats)

## Implementations

* [BasicWriteJobStatsTracker](BasicWriteJobStatsTracker.md)
