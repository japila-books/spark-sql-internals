# WriteToDataSourceV2Exec Physical Operator

`WriteToDataSourceV2Exec` is a [physical operator](SparkPlan.md) that represents an [AppendData](../logical-operators/AppendData.md) logical operator (and a deprecated [WriteToDataSourceV2](../logical-operators/WriteToDataSourceV2.md) logical operator) at execution time.

`WriteToDataSourceV2Exec` is <<creating-instance, created>> when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to plan an [AppendData](../execution-planning-strategies/DataSourceV2Strategy.md#apply-AppendData) logical operator (and a deprecated [WriteToDataSourceV2](../execution-planning-strategies/DataSourceV2Strategy.md#apply-WriteToDataSourceV2)).

NOTE: Although <<WriteToDataSourceV2.md#, WriteToDataSourceV2>> logical operator is deprecated since Spark SQL 2.4.0 (for <<AppendData.md#, AppendData>> logical operator), the `AppendData` logical operator is currently used in tests only. That makes `WriteToDataSourceV2` logical operator still relevant.

[[creating-instance]]
`WriteToDataSourceV2Exec` takes the following to be created:

* [[writer]] FIXME
* [[query]] Child <<SparkPlan.md#, physical plan>>

[[children]]
When requested for the [child operators](../catalyst/TreeNode.md#children), `WriteToDataSourceV2Exec` gives the one <<query, child physical plan>>.

[[output]]
When requested for the <<catalyst/QueryPlan.md#output, output attributes>>, `WriteToDataSourceV2Exec` gives no attributes (an empty collection).

[[logging]]
[TIP]
====
Enable `INFO` logging level for `org.apache.spark.sql.execution.datasources.v2.WriteToDataSourceV2Exec` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.v2.WriteToDataSourceV2Exec=INFO
```

Refer to <<spark-logging.md#, Logging>>.
====

=== [[doExecute]] Executing Physical Operator (Generating RDD[InternalRow]) -- `doExecute` Method

[source, scala]
----
doExecute(): RDD[InternalRow]
----

`doExecute` is part of the [SparkPlan](SparkPlan.md#doExecute) abstraction.

`doExecute`...FIXME

`doExecute` requests the <<query, child physical plan>> to <<SparkPlan.md#execute, execute>> (that triggers physical query planning and in the end generates an `RDD` of [InternalRow](../InternalRow.md)s).

`doExecute` prints out the following INFO message to the logs:

```text
Start processing data source writer: [writer]. The input RDD has [length] partitions.
```

[[doExecute-runJob]]
`doExecute` requests the <<SparkPlan.md#sparkContext, SparkContext>> to run a Spark job with the following:

* The `RDD[InternalRow]` of the <<query, child physical plan>>

* A partition processing function that requests the `DataWritingSparkTask` object to [run](../DataWritingSparkTask.md#run) the writing task (of the <<writer, DataSourceWriter>>) with or with no commit coordinator

* A result handler function that records the result `WriterCommitMessage` from a successful data writer and requests FIXME

`doExecute` prints out the following INFO message to the logs:

```text
Data source writer [writer] is committing.
```

`doExecute`...FIXME

In the end, `doExecute` prints out the following INFO message to the logs:

```
Data source writer [writer] committed.
```

In case of any error (`Throwable`), `doExecute`...FIXME
