# Data Source API V2

*Data Source API V2* (_DataSource API V2_ or _DataSource V2_) is a new API for data sources in Spark SQL with the following abstractions (_contracts_):

* <<spark-sql-DataSourceV2.md#, DataSourceV2>> marker interface

* <<spark-sql-ReadSupport.md#, ReadSupport>>

* <<spark-sql-DataSourceReader.md#, DataSourceReader>>

* <<spark-sql-WriteSupport.md#, WriteSupport>>

* <<spark-sql-DataSourceWriter.md#, DataSourceWriter>>

* <<spark-sql-SessionConfigSupport.md#, SessionConfigSupport>>

* <<spark-sql-DataSourceV2StringFormat.md#, DataSourceV2StringFormat>>

* [InputPartition](InputPartition.md)

NOTE: The work on Data Source API V2 was tracked under https://issues.apache.org/jira/browse/SPARK-15689[SPARK-15689 Data source API v2] that was fixed in Apache Spark 2.3.0.

NOTE: Data Source API V2 is already heavily used in Spark Structured Streaming.

## Query Planning and Execution

Data Source API V2 relies on the [DataSourceV2Strategy](execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy for query planning.

## Data Reading

Data Source API V2 uses <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>> logical operator to represent data reading (aka _data scan_).

`DataSourceV2Relation` is planned (_translated_) to a <<spark-sql-SparkPlan-ProjectExec.md#, ProjectExec>> with a <<spark-sql-SparkPlan-DataSourceV2ScanExec.md#, DataSourceV2ScanExec>> physical operator (possibly under the <<spark-sql-SparkPlan-FilterExec.md#, FilterExec>> operator) when [DataSourceV2Strategy](execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed.

<<spark-sql-SparkPlan-DataSourceV2ScanExec.md#doExecute, At execution>>, `DataSourceV2ScanExec` physical operator creates a <<spark-sql-DataSourceRDD.md#, DataSourceRDD>> (or a `ContinuousReader` for Spark Structured Streaming).

`DataSourceRDD` uses [InputPartitions](InputPartition.md) for <<spark-sql-DataSourceRDD.md#getPartitions, partitions>>, <<spark-sql-DataSourceRDD.md#getPreferredLocations, preferred locations>>, and <<spark-sql-DataSourceRDD.md#compute, computing partitions>>.

## Data Writing

Data Source API V2 uses <<spark-sql-LogicalPlan-WriteToDataSourceV2.md#, WriteToDataSourceV2>> and <<spark-sql-LogicalPlan-AppendData.md#, AppendData>> logical operators to represent data writing (over a <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>> logical operator). As of Spark SQL 2.4.0, `WriteToDataSourceV2` operator was deprecated for the more specific `AppendData` operator (compare _"data writing"_ to _"data append"_ which is certainly more specific).

NOTE: One of the differences between `WriteToDataSourceV2` and `AppendData` logical operators is that the former (`WriteToDataSourceV2`) uses <<spark-sql-LogicalPlan-WriteToDataSourceV2.md#writer, DataSourceWriter>> directly while the latter (`AppendData`) uses <<spark-sql-LogicalPlan-AppendData.md#table, DataSourceV2Relation>> to <<spark-sql-LogicalPlan-DataSourceV2Relation.md#newWriter, get the DataSourceWriter from>>.

<<spark-sql-LogicalPlan-WriteToDataSourceV2.md#, WriteToDataSourceV2>> and <<spark-sql-LogicalPlan-AppendData.md#, AppendData>> (with <<spark-sql-LogicalPlan-DataSourceV2Relation.md#, DataSourceV2Relation>>) logical operators are planned as (_translated to_) a <<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#, WriteToDataSourceV2Exec>> physical operator.

<<spark-sql-SparkPlan-WriteToDataSourceV2Exec.md#doExecute, At execution>>, `WriteToDataSourceV2Exec` physical operator...FIXME

## [[filter-pushdown]] Filter Pushdown Performance Optimization

Data Source API V2 supports *filter pushdown* performance optimization for <<spark-sql-DataSourceReader.md#, DataSourceReaders>> with <<spark-sql-SupportsPushDownFilters.md#, SupportsPushDownFilters>> (that is applied when [DataSourceV2Strategy](execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is requested to plan a [DataSourceV2Relation](execution-planning-strategies/DataSourceV2Strategy.md#apply-DataSourceV2Relation) logical operator).

(From https://drill.apache.org/docs/parquet-filter-pushdown/[Parquet Filter Pushdown] in Apache Drill's documentation) Filter pushdown is a performance optimization that prunes extraneous data while reading from a data source to reduce the amount of data to scan and read for queries with [supported filter expressions](execution-planning-strategies/DataSourceStrategy.md#translateFilter). Pruning data reduces the I/O, CPU, and network overhead to optimize query performance.

!!! tip
    Enable INFO logging level for the [DataSourceV2Strategy logger](execution-planning-strategies/DataSourceV2Strategy.md#logging) to be informed [what the pushed filters are](execution-planning-strategies/DataSourceV2Strategy.md#apply-DataSourceV2Relation).

## [[i-want-more]] Further Reading and Watching

. (video) https://databricks.com/session/apache-spark-data-source-v2[Apache Spark Data Source V2 by Wenchen Fan and Gengliang Wang]
