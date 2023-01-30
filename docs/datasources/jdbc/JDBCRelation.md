# JDBCRelation

`JDBCRelation` is a [BaseRelation](../../BaseRelation.md) with support for [column pruning with filter pushdown](#PrunedFilteredScan) and [inserting or overwriting data](#InsertableRelation).

![JDBCRelation in web UI (Details for Query)](../../images/spark-sql-JDBCRelation-webui-query-details.png)

## <span id="PrunedFilteredScan"> PrunedFilteredScan

`JDBCRelation` is an [PrunedFilteredScan](../../PrunedFilteredScan.md) and supports supports [column pruning with filter pushdown](#buildScan).

## <span id="InsertableRelation"> InsertableRelation

`JDBCRelation` is an [InsertableRelation](../../InsertableRelation.md) and supports [inserting or overwriting data](#insert).

## Creating Instance

`JDBCRelation` takes the following to be created:

* <span id="schema"> [StructType](../../types/StructType.md)
* <span id="parts"> `Partition`s
* <span id="jdbcOptions"> [JDBCOptions](JDBCOptions.md)
* <span id="sparkSession"> [SparkSession](../../SparkSession.md)

`JDBCRelation` is created (possibly using [apply](#apply)) when:

* `DataFrameReader` is requested to [jdbc](../../DataFrameReader.md#jdbc)
* `JDBCRelation` utility is used to [apply](#apply)
* `JdbcRelationProvider` is requested to [create a BaseRelation (for reading)](JdbcRelationProvider.md#createRelation)
* `JDBCScanBuilder` is requested to [build a Scan](JDBCScanBuilder.md#build)

### <span id="apply"> Creating JDBCRelation

```scala
apply(
  parts: Array[Partition],
  jdbcOptions: JDBCOptions)(
  sparkSession: SparkSession): JDBCRelation
```

`apply` [gets the schema](#getSchema) (establishing a connection to the database system directly) and creates a [JDBCRelation](#creating-instance).

## <span id="getSchema"> getSchema

```scala
getSchema(
  resolver: Resolver,
  jdbcOptions: JDBCOptions): StructType
```

`getSchema` [resolves the table](JDBCRDD.md#resolveTable) (from the given [JDBCOptions](JDBCOptions.md)).

With the [customSchema](JDBCOptions.md#customSchema) option specified, `getSchema` gets the custom schema (based on the table schema from the database system). Otherwise, `getSchema` returns the table schema from the database system.

`getSchema` is used when:

* `JDBCRelation` utility is used to [create a JDBCRelation](#apply)
* `JdbcRelationProvider` is requested to [create a BaseRelation (for reading)](JdbcRelationProvider.md#createRelation)

## <span id="columnPartition"> columnPartition

```scala
columnPartition(
  schema: StructType,
  resolver: Resolver,
  timeZoneId: String,
  jdbcOptions: JDBCOptions): Array[Partition]
```

`columnPartition`...FIXME

In the end, `columnPartition` prints out the following INFO message to the logs:

```text
Number of partitions: [numPartitions], WHERE clauses of these partitions:
[whereClause]
```

`columnPartition` is used when:

* `JdbcRelationProvider` is requested to [create a BaseRelation (for reading)](JdbcRelationProvider.md#createRelation)
* `JDBCScanBuilder` is requested to [build a Scan](JDBCScanBuilder.md#build)

## Logging

Enable `ALL` logging level for `org.apache.spark.sql.execution.datasources.jdbc.JDBCRelation` logger to see what happens inside.

Add the following line to `conf/log4j2.properties`:

```text
log4j.logger.org.apache.spark.sql.execution.datasources.jdbc.JDBCRelation=ALL
```

Refer to [Logging](../../spark-logging.md).

## Review Me

[[toString]]
When requested for a human-friendly text representation, `JDBCRelation` requests the <<jdbcOptions, JDBCOptions>> for the name of the table and the <<parts, number of partitions>> (if defined).

```
JDBCRelation([table]) [numPartitions=[number]]
```

```
scala> df.explain
== Physical Plan ==
*Scan JDBCRelation(projects) [numPartitions=1] [id#0,name#1,website#2] ReadSchema: struct<id:int,name:string,website:string>
```

[[needConversion]]
`JDBCRelation` turns the [needConversion](../../BaseRelation.md#needConversion) flag off (to announce that <<buildScan, buildScan>> returns an `RDD[InternalRow]` already and `DataSourceStrategy` execution planning strategy does not have to do the [RDD conversion](../../execution-planning-strategies/DataSourceStrategy.md#PrunedFilteredScan)).

=== [[unhandledFilters]] Finding Unhandled Filter Predicates -- `unhandledFilters` Method

[source, scala]
----
unhandledFilters(filters: Array[Filter]): Array[Filter]
----

`unhandledFilters` is part of [BaseRelation](../../BaseRelation.md#unhandledFilters) abstraction.

`unhandledFilters` returns the [Filter predicates](../../Filter.md) in the input `filters` that could not be [converted to a SQL expression](JDBCRDD.md#compileFilter) (and are therefore unhandled by the JDBC data source natively).

=== [[schema]] Schema of Tuples (Data) -- `schema` Property

[source, scala]
----
schema: StructType
----

`schema` uses `JDBCRDD` to [resolveTable](JDBCRDD.md#resolveTable) given the [JDBCOptions](#jdbcOptions) (that simply returns the [schema](../../types/StructType.md) of the table, also known as the default table schema).

If [customSchema](JDBCOptions.md#customSchema) JDBC option was defined, `schema` uses `JdbcUtils` to replace the data types in the default table schema.

`schema` is part of [BaseRelation](../../BaseRelation.md#schema) abstraction.

=== [[insert]] Inserting or Overwriting Data to JDBC Table -- `insert` Method

[source, scala]
----
insert(data: DataFrame, overwrite: Boolean): Unit
----

`insert` is part of the [InsertableRelation](../../InsertableRelation.md#insert) abstraction.

`insert` simply requests the input `DataFrame` for a <<spark-sql-dataset-operators.md#write, DataFrameWriter>> that in turn is requested to [save the data to a table using the JDBC data source](../../DataFrameWriter.md#jdbc) (itself!) with the [url](JDBCOptions.md#url), [table](JDBCOptions.md#table) and [all options](JDBCOptions.md#asProperties).

`insert` also requests the `DataFrameWriter` to [set the save mode](../../DataFrameWriter.md#mode) as [Overwrite](../../DataFrameWriter.md#Overwrite) or [Append](../../DataFrameWriter.md#Append) per the input `overwrite` flag.

!!! note
    `insert` uses a "trick" to reuse a code that is responsible for [saving data to a JDBC table](JdbcRelationProvider.md#createRelation-CreatableRelationProvider).

=== [[buildScan]] Building Distributed Data Scan with Column Pruning and Filter Pushdown -- `buildScan` Method

[source, scala]
----
buildScan(requiredColumns: Array[String], filters: Array[Filter]): RDD[Row]
----

`buildScan` is part of the [PrunedFilteredScan](../../PrunedFilteredScan.md#buildScan) abstraction.

`buildScan` uses the `JDBCRDD` object to [create a RDD[Row] for a distributed data scan](JDBCRDD.md#scanTable).
