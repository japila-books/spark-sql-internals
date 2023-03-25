# BasicWriteTaskStats

`BasicWriteTaskStats` is a [WriteTaskStats](WriteTaskStats.md).

## Creating Instance

`BasicWriteTaskStats` takes the following to be created:

* <span id="partitions"> Partitions (`Seq[InternalRow]`)
* <span id="numFiles"> Number of files
* <span id="numBytes"> Number of bytes
* <span id="numRows"> Number of rows

`BasicWriteTaskStats` is created when:

* `BasicWriteTaskStatsTracker` is requested for [getFinalStats](BasicWriteTaskStatsTracker.md#getFinalStats)
