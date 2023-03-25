# SingleDirectoryDataWriter

`SingleDirectoryDataWriter` is a [FileFormatDataWriter](FileFormatDataWriter.md) for [FileFormatWriter](FileFormatWriter.md) and [FileWriterFactory](FileWriterFactory.md).

## Creating Instance

`SingleDirectoryDataWriter` takes the following to be created:

* <span id="description"> `WriteJobDescription`
* <span id="taskAttemptContext"> Hadoop [TaskAttemptContext]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html)
* <span id="committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))
* <span id="customMetrics"> Custom [SQLMetric](../SQLMetric.md)s by name (`Map[String, SQLMetric]`)

While being created, `SingleDirectoryDataWriter` [creates a new OutputWriter](#newOutputWriter).

`SingleDirectoryDataWriter` is created when:

* `FileFormatWriter` is requested to [write data out (in a single Spark task)](FileFormatWriter.md#executeTask) (of a non-partitioned non-bucketed write job)
* `FileWriterFactory` is requested for a [DataWriter](FileWriterFactory.md#createWriter) (of a non-partitioned write job)

## <span id="recordsInFile"> recordsInFile Counter

`SingleDirectoryDataWriter` uses `recordsInFile` counter to track how many records have been [written out](#write).

`recordsInFile` counter is `0` when `SingleDirectoryDataWriter` [creates a new OutputWriter](#newOutputWriter) (and increments until `maxRecordsPerFile` threshold if defined).

## <span id="write"> Writing Record Out

```scala
write(
  record: InternalRow): Unit
```

`write` [creates a new OutputWriter](#newOutputWriter) for a positive `maxRecordsPerFile` (of the [WriteJobDescription](#description)) and the [recordsInFile](#recordsInFile) counter above the threshold.

`write` requests the current [OutputWriter](#currentWriter) to [write the record](OutputWriter.md#write) and informs the [WriteTaskStatsTrackers](#statsTrackers) that there was a [new row](WriteTaskStatsTracker.md#newRow).

`write` increments the [recordsInFile](#recordsInFile).

---

`write` is part of the [FileFormatDataWriter](FileFormatDataWriter.md#write) abstraction.

## <span id="newOutputWriter"> Creating New OutputWriter

```scala
newOutputWriter(): Unit
```

`newOutputWriter` sets the [recordsInFile](#recordsInFile) counter to `0`.

`newOutputWriter` [releaseResources](#releaseResources).

`newOutputWriter` uses the given [WriteJobDescription](#description) to access the `OutputWriterFactory` for a file extension (`ext`).

`newOutputWriter` requests the given [FileCommitProtocol](#committer) for a path of a new data file (with `-c[fileCounter][nnn][ext]` suffix).

`newOutputWriter` uses the given [WriteJobDescription](#description) to access the `OutputWriterFactory` for a new [OutputWriter](#currentWriter).

`newOutputWriter` informs the [WriteTaskStatsTrackers](#statsTrackers) that [a new file is about to be written](WriteTaskStatsTracker.md#newFile).

`newOutputWriter` is used when:

* `SingleDirectoryDataWriter` is [created](#creating-instance) and requested to [write](#write) (every `maxRecordsPerFile` threshold)
