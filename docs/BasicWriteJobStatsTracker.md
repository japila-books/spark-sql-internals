# BasicWriteJobStatsTracker

`BasicWriteJobStatsTracker` is a [WriteJobStatsTracker](WriteJobStatsTracker.md).

## Creating Instance

`BasicWriteJobStatsTracker` takes the following to be created:

* <span id="serializableHadoopConf"> Serializable Hadoop `Configuration` ([Hadoop]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html))
* <span id="driverSideMetrics"> Driver-side metrics (`Map[String, SQLMetric]`)
* <span id="taskCommitTimeMetric"> Task commit time [SQLMetric](physical-operators/SQLMetric.md)

`BasicWriteJobStatsTracker` is created when:

* `DataWritingCommand` is requested for a [BasicWriteJobStatsTracker](logical-operators/DataWritingCommand.md#basicWriteJobStatsTracker)
* `FileWrite` is requested to [createWriteJobDescription](FileWrite.md#createWriteJobDescription)
* `FileStreamSink` ([Spark Structured Streaming]({{ book.structured_streaming }}/datasources/file/FileStreamSink)) is requested for a `BasicWriteJobStatsTracker`

## <span id="newTaskInstance"> Creating WriteTaskStatsTracker

```scala
newTaskInstance(): WriteTaskStatsTracker
```

`newTaskInstance` creates a new [BasicWriteTaskStatsTracker](#creating-instance) (with the [serializable Hadoop Configuration](#serializableHadoopConf) and the [taskCommitTimeMetric](#taskCommitTimeMetric)).

`newTaskInstance` is part of the [WriteJobStatsTracker](WriteJobStatsTracker.md#newTaskInstance) abstraction.

## <span id="processStats"> Processing Write Job Statistics

```scala
processStats(
  stats: Seq[WriteTaskStats],
  jobCommitTime: Long): Unit
```

`processStats` uses the given [BasicWriteTaskStats](BasicWriteTaskStats.md)es to set the following [driverSideMetrics](#driverSideMetrics):

* `jobCommitTime`
* `numFiles`
* `numOutputBytes`
* `numOutputRows`
* `numParts`

`processStats` requests the active `SparkContext` for the [spark.sql.execution.id](SQLExecution.md#EXECUTION_ID_KEY).

In the end, `processStats` [posts the metric updates](physical-operators/SQLMetric.md#postDriverMetricUpdates).

---

`processStats` is part of the [WriteJobStatsTracker](WriteJobStatsTracker.md#processStats) abstraction.
