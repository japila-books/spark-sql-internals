# DataSource V2

**DataSource V2** (_DataSource API V2_ or _Data Source V2_) is a new API for data sources in Spark SQL with the following abstractions:

* [DataFrameWriterV2](../DataFrameWriterV2.md)
* [SessionConfigSupport](../connector/SessionConfigSupport.md)
* [InputPartition](../connector/InputPartition.md)

DataSource V2 was tracked under [SPARK-15689 DataSource V2](https://issues.apache.org/jira/browse/SPARK-15689) and was marked as fixed in Apache Spark 2.3.0.

## Query Planning and Execution

DataSource V2 relies on the [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy for query planning.

## Data Reading

DataSource V2 uses [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) logical operator to represent data reading (aka _data scan_).

`DataSourceV2Relation` is planned (_translated_) to a [ProjectExec](../physical-operators/ProjectExec.md) with a [DataSourceV2ScanExec](../physical-operators/DataSourceV2ScanExec.md) physical operator (possibly under the [FilterExec](../physical-operators/FilterExec.md) operator) when [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy is executed.

When executed, `DataSourceV2ScanExec` physical operator creates a [DataSourceRDD](../DataSourceRDD.md) (or a `ContinuousReader` for Spark Structured Streaming).

`DataSourceRDD` uses [InputPartitions](../connector/InputPartition.md) for [partitions](../DataSourceRDD.md#getPartitions), [preferred locations](../DataSourceRDD.md#getPreferredLocations), and [computing partitions](../DataSourceRDD.md#compute).

## Data Writing

DataSource V2 uses [WriteToDataSourceV2](../logical-operators/WriteToDataSourceV2.md) and [AppendData](../logical-operators/AppendData.md) logical operators to represent data writing (over a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) logical operator). As of Spark SQL 2.4.0, `WriteToDataSourceV2` operator was deprecated for the more specific `AppendData` operator (compare _"data writing"_ to _"data append"_ which is certainly more specific).

NOTE: One of the differences between `WriteToDataSourceV2` and `AppendData` logical operators is that the former (`WriteToDataSourceV2`) uses [DataSourceWriter](../logical-operators/WriteToDataSourceV2.md#writer) directly while the latter (`AppendData`) uses [DataSourceV2Relation](../logical-operators/AppendData.md#table) to [get the DataSourceWriter from](../logical-operators/DataSourceV2Relation.md#newWriter).

[WriteToDataSourceV2](../logical-operators/WriteToDataSourceV2.md) and [AppendData](../logical-operators/AppendData.md) (with [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md)) logical operators are planned as (_translated to_) a [WriteToDataSourceV2Exec](../physical-operators/WriteToDataSourceV2Exec.md) physical operator.

When executed, `WriteToDataSourceV2Exec` physical operator...FIXME

## <span id="filter-pushdown"> Filter Pushdown Performance Optimization

DataSource V2 supports **filter pushdown** performance optimization for...FIXME

From [Parquet Filter Pushdown](https://drill.apache.org/docs/parquet-filter-pushdown/) in Apache Drill's documentation:

> Filter pushdown is a performance optimization that prunes extraneous data while reading from a data source to reduce the amount of data to scan and read for queries with [supported filter expressions](../execution-planning-strategies/DataSourceStrategy.md#translateFilter). Pruning data reduces the I/O, CPU, and network overhead to optimize query performance.

!!! tip
    Enable INFO logging level for the [DataSourceV2Strategy logger](../execution-planning-strategies/DataSourceV2Strategy.md#logging) to be informed [what filters were pushed down](../execution-planning-strategies/DataSourceV2Strategy.md#apply-DataSourceV2Relation).

## References

### Videos

* [Apache Spark DataSource V2](https://databricks.com/session/apache-spark-data-source-v2) by Wenchen Fan and Gengliang Wang (Databricks)
* [DataSource V2 and Cassandra – A Whole New World](https://youtu.be/CtFWVcuqm0g) by Russell Spitzer (Datastax)
