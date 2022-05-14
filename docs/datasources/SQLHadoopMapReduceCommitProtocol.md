# SQLHadoopMapReduceCommitProtocol

`SQLHadoopMapReduceCommitProtocol` is a `HadoopMapReduceCommitProtocol` ([Spark Core]({{ book.spark_core }}/HadoopMapReduceCommitProtocol)) that uses [spark.sql.sources.outputCommitterClass](../configuration-properties.md#OUTPUT_COMMITTER_CLASS) configuration property for the actual Hadoop [OutputCommitter]({{ hadoop.api }}/org/apache/hadoop/mapreduce/OutputCommitter.html).

## <span id="spark.sql.sources.commitProtocolClass"> spark.sql.sources.commitProtocolClass

`SQLHadoopMapReduceCommitProtocol` is the default value of [spark.sql.sources.commitProtocolClass](../SQLConf.md#FILE_COMMIT_PROTOCOL_CLASS) configuration property.

## Creating Instance

`SQLHadoopMapReduceCommitProtocol` takes the following to be created:

* <span id="jobId"> Job ID
* <span id="path"> Path
* <span id="dynamicPartitionOverwrite"> `dynamicPartitionOverwrite` flag (default: `false`)

## <span id="setupCommitter"> Setting Up OutputCommitter

```scala
setupCommitter(
  context: TaskAttemptContext): OutputCommitter
```

`setupCommitter` allows specifying a custom user-defined Hadoop [OutputCommitter]({{ hadoop.api }}/org/apache/hadoop/mapreduce/OutputCommitter.html) based on [spark.sql.sources.outputCommitterClass](../configuration-properties.md#OUTPUT_COMMITTER_CLASS) configuration property (in the Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html) of the given Hadoop [TaskAttemptContext]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html)).

---

`setupCommitter` takes the default parent `OutputCommitter` (for the given Hadoop [TaskAttemptContext]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html)).

If, for some reason, [spark.sql.sources.outputCommitterClass](../SQLConf.md#OUTPUT_COMMITTER_CLASS) configuration property is defined, `setupCommitter` uses it to create an `OutputCommitter`. `setupCommitter` prints out the following INFO message to the logs:

```text
Using user defined output committer class [className]
```

In the end, `setupCommitter` prints out the following INFO message to the logs:

```text
Using output committer class [className]
```

---

`setupCommitter` is part of the `HadoopMapReduceCommitProtocol` ([Spark Core]({{ book.spark_core }}/HadoopMapReduceCommitProtocol#setupCommitter)) abstraction.

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.SQLHadoopMapReduceCommitProtocol` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.SQLHadoopMapReduceCommitProtocol=ALL
```

Refer to [Logging](../spark-logging.md).
