# BasicWriteTaskStatsTracker

`BasicWriteTaskStatsTracker` is a concrete <<spark-sql-WriteTaskStatsTracker.md#, WriteTaskStatsTracker>>.

`BasicWriteTaskStatsTracker` is <<creating-instance, created>> exclusively when `BasicWriteJobStatsTracker` is requested for [one](BasicWriteJobStatsTracker.md#newTaskInstance).

[[creating-instance]]
[[hadoopConf]]
`BasicWriteTaskStatsTracker` takes a Hadoop `Configuration` when created.

=== [[getFinalStats]] Getting Final WriteTaskStats -- `getFinalStats` Method

[source, scala]
----
getFinalStats(): WriteTaskStats
----

NOTE: `getFinalStats` is part of the <<spark-sql-WriteTaskStatsTracker.md#getFinalStats, WriteTaskStatsTracker Contract>> to get the final <<spark-sql-WriteTaskStats.md#, WriteTaskStats>> statistics computed so far.

`getFinalStats`...FIXME
