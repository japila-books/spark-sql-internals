# BasicWriteTaskStatsTracker

`BasicWriteTaskStatsTracker` is a [WriteTaskStatsTracker](WriteTaskStatsTracker.md).

`BasicWriteTaskStatsTracker` is <<creating-instance, created>> exclusively when `BasicWriteJobStatsTracker` is requested for [one](BasicWriteJobStatsTracker.md#newTaskInstance).

[[creating-instance]]
[[hadoopConf]]
`BasicWriteTaskStatsTracker` takes a Hadoop `Configuration` when created.

=== [[getFinalStats]] Getting Final WriteTaskStats -- `getFinalStats` Method

[source, scala]
----
getFinalStats(): WriteTaskStats
----

NOTE: `getFinalStats` is part of the [WriteTaskStatsTracker](WriteTaskStatsTracker.md#getFinalStats) contract.

`getFinalStats`...FIXME
