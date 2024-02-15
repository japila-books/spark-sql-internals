---
title: DataWritingCommand
---

# DataWritingCommand Logical Commands

`DataWritingCommand` is an [extension](#contract) of the `UnaryCommand` abstraction for [logical commands](#implementations) that write the result of executing [query](#query) (_query data_) to a relation (when [executed](#run)).

## Contract

### Output Column Names { #outputColumnNames }

```scala
outputColumnNames: Seq[String]
```

The names of the output columns of the [analyzed input query plan](#query)

Used when:

* `DataWritingCommand` is requested for the [output columns](#outputColumns)

### Query

```scala
query: LogicalPlan
```

The analyzed [LogicalPlan](LogicalPlan.md) representing the data to write (i.e. whose result will be inserted into a relation)

Used when:

* [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy is executed
* `DataWritingCommand` is requested for the [child logical operator](#child) and the [output columns](#outputColumns)

### Executing Command { #run }

```scala
run(
  sparkSession: SparkSession,
  child: SparkPlan): Seq[Row]
```

Used when:

* `CreateHiveTableAsSelectBase` is requested to `run`
* [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md) physical operator is requested for the [sideEffectResult](../physical-operators/DataWritingCommandExec.md#sideEffectResult)

## Implementations

* [CreateDataSourceTableAsSelectCommand](CreateDataSourceTableAsSelectCommand.md)
* `CreateHiveTableAsSelectBase`
* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md)
* [SaveAsHiveFile](../hive/SaveAsHiveFile.md)

## Performance Metrics { #metrics }

![DataWritingCommand's Performance Metrics](../images/DataWritingCommand-metrics.png)

### job commit time { #jobCommitTime }

### number of dynamic part { #numParts }

[Number of partitions](../files/BasicWriteTaskStats.md#partitions) (when [processing write job statistics](../files/BasicWriteJobStatsTracker.md#processStats))

Corresponds to the number of times when [newPartition](../files/BasicWriteTaskStatsTracker.md#newPartition) of [BasicWriteTaskStatsTracker](../files/BasicWriteTaskStatsTracker.md) was called (that is to announce the fact that a new partition is about to be written)

### number of output rows { #numOutputRows }

### number of written files { #numFiles }

### task commit time { #taskCommitTime }

### written output { #numOutputBytes }

## Execution Planning

`DataWritingCommand` is resolved to a [DataWritingCommandExec](../physical-operators/DataWritingCommandExec.md) physical operator by [BasicOperators](../execution-planning-strategies/BasicOperators.md) execution planning strategy.

## BasicWriteJobStatsTracker { #basicWriteJobStatsTracker }

```scala
basicWriteJobStatsTracker(
  hadoopConf: Configuration): BasicWriteJobStatsTracker // (1)!
basicWriteJobStatsTracker(
  metrics: Map[String, SQLMetric],
  hadoopConf: Configuration): BasicWriteJobStatsTracker
```

1. Uses the [metrics](#metrics)

`basicWriteJobStatsTracker` creates a new [BasicWriteJobStatsTracker](../files/BasicWriteJobStatsTracker.md) (with the given Hadoop [Configuration]({{ hadoop.api }}/org/apache/hadoop/conf/Configuration.html) and the [metrics](#metrics)).

---

`basicWriteJobStatsTracker` is used when:

* `FileFormatWriter` is requested to [write data out](../files/FileFormatWriter.md#write)
* [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md) logical command is executed
* [SaveAsHiveFile](../hive/SaveAsHiveFile.md) logical command is executed (and requested to [saveAsHiveFile](../hive/SaveAsHiveFile.md#saveAsHiveFile))
