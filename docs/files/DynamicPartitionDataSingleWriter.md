# DynamicPartitionDataSingleWriter

`DynamicPartitionDataSingleWriter` is a [BaseDynamicPartitionDataWriter](BaseDynamicPartitionDataWriter.md).

## Creating Instance

`DynamicPartitionDataSingleWriter` takes the following to be created:

* <span id="description"> `WriteJobDescription`
* <span id="taskAttemptContext"> `TaskAttemptContext` ([Apache Hadoop]({{ hadoop.api }}/org/apache/hadoop/mapreduce/TaskAttemptContext.html))
* <span id="committer"> `FileCommitProtocol` ([Spark Core]({{ book.spark_core }}/FileCommitProtocol))
* <span id="customMetrics"> [SQLMetric](../SQLMetric.md)s

`DynamicPartitionDataSingleWriter` is created when:

* `FileFormatWriter` is requested to [write data out in a single Spark task](FileFormatWriter.md#executeTask)
* `FileWriterFactory` is requested to [create a DataWriter](FileWriterFactory.md#createWriter)
