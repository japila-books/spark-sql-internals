# BasicWriteJobStatsTracker

`BasicWriteJobStatsTracker` is a [WriteJobStatsTracker](WriteJobStatsTracker.md).

`BasicWriteJobStatsTracker` is <<creating-instance, created>> when <<DataWritingCommand.md#basicWriteJobStatsTracker, DataWritingCommand>> and Spark Structured Streaming's `FileStreamSink` are requested for one.

[[newTaskInstance]]
When requested for a new [WriteTaskStatsTracker](WriteJobStatsTracker.md#newTaskInstance), `BasicWriteJobStatsTracker` creates a new [BasicWriteTaskStatsTracker](BasicWriteTaskStatsTracker.md).

## Creating Instance

`BasicWriteJobStatsTracker` takes the following when created:

* [[serializableHadoopConf]] Serializable Hadoop `Configuration`
* [[metrics]] Metrics (`Map[String, SQLMetric]`)
