# SQLHadoopMapReduceCommitProtocol

`SQLHadoopMapReduceCommitProtocol` is a `HadoopMapReduceCommitProtocol` ([Spark Core]({{ book.spark_core }}/HadoopMapReduceCommitProtocol)) that [allows for a custom user-defined Hadoop OutputCommitter](#setupCommitter) based on [spark.sql.sources.outputCommitterClass](../configuration-properties.md#OUTPUT_COMMITTER_CLASS) configuration property.

`SQLHadoopMapReduceCommitProtocol` is the default value of [spark.sql.sources.commitProtocolClass](../configuration-properties.md#spark.sql.sources.commitProtocolClass) configuration property.

`SQLHadoopMapReduceCommitProtocol` is `Serializable`.

## Creating Instance

`SQLHadoopMapReduceCommitProtocol` takes the following to be created:

* <span id="jobId"> Job ID
* <span id="path"> Path
* [dynamicPartitionOverwrite](#dynamicPartitionOverwrite)

### dynamicPartitionOverwrite { #dynamicPartitionOverwrite }

`SQLHadoopMapReduceCommitProtocol` can be given `dynamicPartitionOverwrite` flag when [created](#creating-instance). Unless given, `dynamicPartitionOverwrite` is disabled (`false`).

## Setting Up OutputCommitter { #setupCommitter }

??? note "HadoopMapReduceCommitProtocol"

    ```scala
    setupCommitter(
      context: TaskAttemptContext): OutputCommitter
    ```

    `setupCommitter` is part of the `HadoopMapReduceCommitProtocol` ([Spark Core]({{ book.spark_core }}/HadoopMapReduceCommitProtocol#setupCommitter)) abstraction.

`setupCommitter` allows specifying a custom user-defined Hadoop [OutputCommitter]({{ hadoop.api }}/org/apache/hadoop/mapreduce/OutputCommitter.html) based on [spark.sql.sources.outputCommitterClass](../configuration-properties.md#OUTPUT_COMMITTER_CLASS) configuration property (in the Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html) of the given Hadoop [TaskAttemptContext]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html)).

---

`setupCommitter` takes the default parent `OutputCommitter` (for the given Hadoop [TaskAttemptContext]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html)) unless [spark.sql.sources.outputCommitterClass](../configuration-properties.md#spark.sql.sources.outputCommitterClass) configuration property is defined (that overrides the parent's `OutputCommitter`).

If [spark.sql.sources.outputCommitterClass](../SQLConf.md#OUTPUT_COMMITTER_CLASS) is defined, `setupCommitter` prints out the following INFO message to the logs:

```text
Using user defined output committer class [className]
```

In the end, `setupCommitter` prints out the following INFO message to the logs (and returns the `OutputCommitter`):

```text
Using output committer class [className]
```

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.SQLHadoopMapReduceCommitProtocol` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
logger.SQLHadoopMapReduceCommitProtocol.name = org.apache.spark.sql.execution.datasources.SQLHadoopMapReduceCommitProtocol
logger.SQLHadoopMapReduceCommitProtocol.level = all
```

Refer to [Logging](../spark-logging.md).
