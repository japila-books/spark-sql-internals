title: BaseRelation

# BaseRelation -- Collection of Tuples with Schema

`BaseRelation` is the <<contract, contract>> of <<implementations, relations>> (aka _collections of tuples_) with a known <<schema, schema>>.

NOTE: "Data source", "relation" and "table" are often used as synonyms.

[[contract]]
[source, scala]
----
package org.apache.spark.sql.sources

abstract class BaseRelation {
  // only required properties (vals and methods) that have no implementation
  // the others follow
  def schema: StructType
  def sqlContext: SQLContext
}
----

.(Subset of) BaseRelation Contract
[cols="1,2",options="header",width="100%"]
|===
| Method
| Description

| `schema`
| [[schema]] [StructType](StructType.md) that describes the schema of tuples

| `sqlContext`
| [[sqlContext]] [SQLContext](spark-sql-SQLContext.md)
|===

`BaseRelation` is "created" when `DataSource` is requested to spark-sql-DataSource.md#resolveRelation[resolve a relation].

`BaseRelation` is transformed into a `DataFrame` when `SparkSession` is requested to SparkSession.md#baseRelationToDataFrame[create a DataFrame].

`BaseRelation` uses <<needConversion, needConversion>> flag to control type conversion of objects inside spark-sql-Row.md[Rows] to Catalyst types, e.g. `java.lang.String` to `UTF8String`.

NOTE: It is recommended that custom data sources (outside Spark SQL) should leave <<needConversion, needConversion>> flag enabled, i.e. `true`.

`BaseRelation` can optionally give an <<sizeInBytes, estimated size>> (in bytes).

[[implementations]]
.BaseRelations
[width="100%",cols="1,2",options="header"]
|===
| BaseRelation
| Description

| `ConsoleRelation`
| [[ConsoleRelation]] Used in Spark Structured Streaming

| [HadoopFsRelation](HadoopFsRelation.md)
| [[HadoopFsRelation]]

| spark-sql-JDBCRelation.md[JDBCRelation]
| [[JDBCRelation]]

| <<spark-sql-KafkaRelation.md#, KafkaRelation>>
| [[KafkaRelation]] Datasets with records from Apache Kafka
|===

=== [[needConversion]] Should JVM Objects Inside Rows Be Converted to Catalyst Types? -- `needConversion` Method

[source, scala]
----
needConversion: Boolean
----

`needConversion` flag is enabled (`true`) by default.

NOTE: It is recommended to leave `needConversion` enabled for data sources outside Spark SQL.

`needConversion` is used when [DataSourceStrategy](execution-planning-strategies/DataSourceStrategy.md) execution planning strategy is executed (and [does the RDD conversion](execution-planning-strategies/DataSourceStrategy.md#toCatalystRDD) from `RDD[Row]` to `RDD[InternalRow]`).

=== [[unhandledFilters]] Finding Unhandled Filter Predicates -- `unhandledFilters` Method

[source, scala]
----
unhandledFilters(filters: Array[Filter]): Array[Filter]
----

`unhandledFilters` returns <<spark-sql-Filter.md#, Filter predicates>> that the data source does not support (handle) natively.

NOTE: `unhandledFilters` returns the input `filters` by default as it is considered safe to double evaluate filters regardless whether they could be supported or not.

`unhandledFilters` is used when `DataSourceStrategy` execution planning strategy is requested to [selectFilters](execution-planning-strategies/DataSourceStrategy.md#selectFilters).

=== [[sizeInBytes]] Estimated Size Of Relation (In Bytes) -- `sizeInBytes` Method

[source, scala]
----
sizeInBytes: Long
----

`sizeInBytes` is the estimated size of a relation (used in query planning).

NOTE: `sizeInBytes` defaults to spark-sql-properties.md#spark.sql.defaultSizeInBytes[spark.sql.defaultSizeInBytes] internal property (i.e. infinite).

NOTE: `sizeInBytes` is used exclusively when `LogicalRelation` is requested to spark-sql-LogicalPlan-LogicalRelation.md#computeStats[computeStats] (and they are not available in spark-sql-LogicalPlan-LogicalRelation.md#catalogTable[CatalogTable]).
