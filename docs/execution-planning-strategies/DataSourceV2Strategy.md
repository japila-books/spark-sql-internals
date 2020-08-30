# DataSourceV2Strategy Execution Planning Strategy

`DataSourceV2Strategy` is an [execution planning strategy](SparkStrategy.md) that [SparkPlanner](../SparkPlanner.md) uses to <<apply, plan logical operators>> (from the <<spark-sql-data-source-api-v2.md#, Data Source API V2>>).

[[logical-operators]]
.DataSourceV2Strategy's Execution Planning
[cols="1,1",options="header",width="100%"]
|===
| Logical Operator
| Physical Operator

| <<apply-DataSourceV2Relation, DataSourceV2Relation>>
| <<spark-sql-SparkPlan-DataSourceV2ScanExec.md#, DataSourceV2ScanExec>>

| <<apply-StreamingDataSourceV2Relation, StreamingDataSourceV2Relation>>
| <<spark-sql-SparkPlan-DataSourceV2ScanExec.md#, DataSourceV2ScanExec>>

| <<apply-WriteToDataSourceV2, WriteToDataSourceV2>>
| <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>>

| <<apply-AppendData, AppendData>> with <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>>
| <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>>

| <<apply-WriteToContinuousDataSource, WriteToContinuousDataSource>>
| `WriteToContinuousDataSourceExec`

| <<apply-Repartition, Repartition>> with a `StreamingDataSourceV2Relation` and a `ContinuousReader`
| `ContinuousCoalesceExec`
|===

[[logging]]
[TIP]
====
Enable `INFO` logging level for `org.apache.spark.sql.execution.datasources.v2.DataSourceV2Strategy` logger to see what happens inside.

Add the following line to `conf/log4j.properties`:

```
log4j.logger.org.apache.spark.sql.execution.datasources.v2.DataSourceV2Strategy=INFO
```

Refer to spark-logging.md[Logging].
====

## <span id="apply"> Applying DataSourceV2Strategy Strategy to Logical Plan

```scala
apply(
  plan: LogicalPlan): Seq[SparkPlan]
```

`apply` branches off per the given <<spark-sql-LogicalPlan.md#, logical operator>>.

`apply` is part of [GenericStrategy](../catalyst/GenericStrategy.md#apply) abstraction.

==== [[apply-DataSourceV2Relation]] DataSourceV2Relation Logical Operator

For a <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>> logical operator, `apply` requests the `DataSourceV2Relation` for the <<spark-sql-LogicalPlan-DataSourceV2Relation.md#newReader, DataSourceReader>>.

`apply` then <<pushFilters, pushFilters>> followed by <<pruneColumns, pruneColumns>>.

`apply` prints out the following INFO message to the logs:

```
Pushing operators to [ClassName of DataSourceV2]
Pushed Filters: [pushedFilters]
Post-Scan Filters: [postScanFilters]
Output: [output]
```

`apply` uses the `DataSourceV2Relation` to create a <<spark-sql-SparkPlan-DataSourceV2ScanExec.md#, DataSourceV2ScanExec>> physical operator.

If there are any `postScanFilters`, `apply` creates a <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>> physical operator with the `DataSourceV2ScanExec` physical operator as the child.

In the end, `apply` creates a <<spark-sql-SparkPlan-ProjectExec.md#, ProjectExec>> physical operator with the `FilterExec` with the `DataSourceV2ScanExec` or directly with the `DataSourceV2ScanExec` physical operator.

==== [[apply-StreamingDataSourceV2Relation]] StreamingDataSourceV2Relation Logical Operator

For a `StreamingDataSourceV2Relation` logical operator, `apply`...FIXME

==== [[apply-WriteToDataSourceV2]] WriteToDataSourceV2 Logical Operator

For a <<spark-sql-LogicalPlan-WriteToDataSourceV2.md#, WriteToDataSourceV2>> logical operator, `apply` simply creates a <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator.

==== [[apply-AppendData]] AppendData Logical Operator

For a <<spark-sql-LogicalPlan-AppendData.md#, AppendData>> logical operator with a <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>>, `apply` requests the <<spark-sql-LogicalPlan-AppendData.md#table, DataSourceV2Relation>> to <<spark-sql-LogicalPlan-DataSourceV2Relation.md#newWriter, create a DataSourceWriter>> that is used to create a <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator.

==== [[apply-WriteToContinuousDataSource]] WriteToContinuousDataSource Logical Operator

For a `WriteToContinuousDataSource` logical operator, `apply`...FIXME

==== [[apply-Repartition]] Repartition Logical Operator

For a [Repartition](../logical-operators/RepartitionOperation.md#Repartition) logical operator, `apply`...FIXME

=== [[pushFilters]] `pushFilters` Internal Method

[source, scala]
----
pushFilters(
  reader: DataSourceReader,
  filters: Seq[Expression]): (Seq[Expression], Seq[Expression])
----

NOTE: `pushFilters` handles <<spark-sql-DataSourceReader.md#, DataSourceReaders>> with <<spark-sql-SupportsPushDownFilters.md#, SupportsPushDownFilters>> support only.

For the given `DataSourceReaders` with `SupportsPushDownFilters` support, `pushFilters` uses the `DataSourceStrategy` object to [translate every filter](DataSourceStrategy.md#translateFilter) in the given `filters`.

`pushFilters` requests the `SupportsPushDownFilters` reader to <<spark-sql-SupportsPushDownFilters.md#pushFilters, pushFilters>> first and then for the <<spark-sql-SupportsPushDownFilters.md#pushedFilters, pushedFilters>>.

In the end, `pushFilters` returns a pair of filters pushed and not.

NOTE: `pushFilters` is used exclusively when `DataSourceV2Strategy` execution planning strategy is <<apply, executed>> (applied to a <<apply-DataSourceV2Relation, DataSourceV2Relation>> logical operator).

=== [[pruneColumns]] Column Pruning -- `pruneColumns` Internal Method

[source, scala]
----
pruneColumns(
  reader: DataSourceReader,
  relation: DataSourceV2Relation,
  exprs: Seq[Expression]): Seq[AttributeReference]
----

`pruneColumns`...FIXME

NOTE: `pruneColumns` is used when...FIXME
