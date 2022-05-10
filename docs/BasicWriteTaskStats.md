# BasicWriteTaskStats

[[creating-instance]]
`BasicWriteTaskStats` is a basic [WriteTaskStats](WriteTaskStats.md) that carries the following statistics:

* [[numPartitions]] `numPartitions`
* [[numFiles]] `numFiles`
* [[numBytes]] `numBytes`
* [[numRows]] `numRows`

`BasicWriteTaskStats` is <<creating-instance, created>> exclusively when `BasicWriteTaskStatsTracker` is requested for [getFinalStats](BasicWriteTaskStatsTracker.md#getFinalStats).
