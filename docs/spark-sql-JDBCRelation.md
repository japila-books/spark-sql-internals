# JDBCRelation

`JDBCRelation` is a <<BaseRelation, BaseRelation>> that supports <<InsertableRelation, inserting or overwriting data>> and <<PrunedFilteredScan, column pruning with filter pushdown>>.

[[BaseRelation]]
As a <<spark-sql-BaseRelation.md#,BaseRelation>>, `JDBCRelation` defines the <<schema, schema of tuples (data)>> and the <<sqlContext, SQLContext>>.

[[InsertableRelation]]
As a <<spark-sql-InsertableRelation.md#,InsertableRelation>>, `JDBCRelation` supports <<insert, inserting or overwriting data>>.

[[PrunedFilteredScan]]
As a <<spark-sql-PrunedFilteredScan.md#,PrunedFilteredScan>>, `JDBCRelation` supports <<buildScan, building distributed data scan with column pruning and filter pushdown>>.

`JDBCRelation` is <<creating-instance, created>> when:

* `DataFrameReader` is requested to [load data from an external table using JDBC data source](DataFrameReader.md#jdbc)

* `JdbcRelationProvider` is requested to [create a BaseRelation for reading data from a JDBC table](spark-sql-JdbcRelationProvider.md#createRelation-RelationProvider)

[[toString]]
When requested for a human-friendly text representation, `JDBCRelation` requests the <<jdbcOptions, JDBCOptions>> for the name of the table and the <<parts, number of partitions>> (if defined).

```
JDBCRelation([table]) [numPartitions=[number]]
```

.JDBCRelation in web UI (Details for Query)
image::images/spark-sql-JDBCRelation-webui-query-details.png[align="center"]

```
scala> df.explain
== Physical Plan ==
*Scan JDBCRelation(projects) [numPartitions=1] [id#0,name#1,website#2] ReadSchema: struct<id:int,name:string,website:string>
```

[[sqlContext]]
`JDBCRelation` uses the <<sparkSession, SparkSession>> to return a SparkSession.md#sqlContext[SQLContext].

[[needConversion]]
`JDBCRelation` turns the <<spark-sql-BaseRelation.md#needConversion, needConversion>> flag off (to announce that <<buildScan, buildScan>> returns an `RDD[InternalRow]` already and `DataSourceStrategy` execution planning strategy does not have to do the [RDD conversion](execution-planning-strategies/DataSourceStrategy.md#PrunedFilteredScan)).

=== [[creating-instance]] Creating JDBCRelation Instance

`JDBCRelation` takes the following when created:

* [[parts]] Array of Spark Core's `Partitions`
* [[jdbcOptions]] spark-sql-JDBCOptions.md[JDBCOptions]
* [[sparkSession]] SparkSession.md[SparkSession]

=== [[unhandledFilters]] Finding Unhandled Filter Predicates -- `unhandledFilters` Method

[source, scala]
----
unhandledFilters(filters: Array[Filter]): Array[Filter]
----

NOTE: `unhandledFilters` is part of <<spark-sql-BaseRelation.md#unhandledFilters, BaseRelation Contract>> to find unhandled <<spark-sql-Filter.md#, Filter predicates>>.

`unhandledFilters` returns the <<spark-sql-Filter.md#, Filter predicates>> in the input `filters` that could not be <<spark-sql-JDBCRDD.md#compileFilter, converted to a SQL expression>> (and are therefore unhandled by the JDBC data source natively).

=== [[schema]] Schema of Tuples (Data) -- `schema` Property

[source, scala]
----
schema: StructType
----

`schema` uses `JDBCRDD` to [resolveTable](spark-sql-JDBCRDD.md#resolveTable) given the [JDBCOptions](#jdbcOptions) (that simply returns the [schema](StructType.md) of the table, also known as the default table schema).

If [customSchema](spark-sql-JDBCOptions.md#customSchema) JDBC option was defined, `schema` uses `JdbcUtils` to [replace the data types in the default table schema](spark-sql-JdbcUtils.md#getCustomSchema).

`schema` is part of [BaseRelation](spark-sql-BaseRelation.md#schema) abstraction.

=== [[insert]] Inserting or Overwriting Data to JDBC Table -- `insert` Method

[source, scala]
----
insert(data: DataFrame, overwrite: Boolean): Unit
----

NOTE: `insert` is part of <<spark-sql-InsertableRelation.md#insert, InsertableRelation Contract>> that inserts or overwrites data in a <<spark-sql-BaseRelation.md#, relation>>.

`insert` simply requests the input `DataFrame` for a <<spark-sql-dataset-operators.md#write, DataFrameWriter>> that in turn is requested to [save the data to a table using the JDBC data source](DataFrameWriter.md#jdbc) (itself!) with the [url](spark-sql-JDBCOptions.md#url), [table](spark-sql-JDBCOptions.md#table) and [all options](spark-sql-JDBCOptions.md#asProperties).

`insert` also requests the `DataFrameWriter` to [set the save mode](DataFrameWriter.md#mode) as [Overwrite](DataFrameWriter.md#Overwrite) or [Append](DataFrameWriter.md#Append) per the input `overwrite` flag.

!!! note
    `insert` uses a "trick" to reuse a code that is responsible for [saving data to a JDBC table](spark-sql-JdbcRelationProvider.md#createRelation-CreatableRelationProvider).

=== [[buildScan]] Building Distributed Data Scan with Column Pruning and Filter Pushdown -- `buildScan` Method

[source, scala]
----
buildScan(requiredColumns: Array[String], filters: Array[Filter]): RDD[Row]
----

NOTE: `buildScan` is part of <<spark-sql-PrunedFilteredScan.md#buildScan, PrunedFilteredScan Contract>> to build a distributed data scan (as a `RDD[Row]`) with support for column pruning and filter pushdown.

`buildScan` uses the `JDBCRDD` object to <<spark-sql-JDBCRDD.md#scanTable, create a RDD[Row] for a distributed data scan>>.
