title: LogicalRelation

# LogicalRelation Leaf Logical Operator -- Representing BaseRelations in Logical Plan

`LogicalRelation` is a link:spark-sql-LogicalPlan-LeafNode.adoc[leaf logical operator] that represents a <<relation, BaseRelation>> in a link:spark-sql-LogicalPlan.adoc[logical query plan].

[source, scala]
----
val q1 = spark.read.option("header", true).csv("../datasets/people.csv")
scala> println(q1.queryExecution.logical.numberedTreeString)
00 Relation[id#72,name#73,age#74] csv

val q2 = sql("select * from `csv`.`../datasets/people.csv`")
scala> println(q2.queryExecution.optimizedPlan.numberedTreeString)
00 Relation[_c0#175,_c1#176,_c2#177] csv
----

`LogicalRelation` is <<creating-instance, created>> when:

* `DataFrameReader` [loads data from a data source that supports multiple paths](../DataFrameReader.md#load) (through link:spark-sql-SparkSession.adoc#baseRelationToDataFrame[SparkSession.baseRelationToDataFrame])
* `DataFrameReader` is requested to load data from an external table using [JDBC](../DataFrameReader.md#jdbc) (through link:spark-sql-SparkSession.adoc#baseRelationToDataFrame[SparkSession.baseRelationToDataFrame])
* `TextInputCSVDataSource` and `TextInputJsonDataSource` are requested to infer schema
* `ResolveSQLOnFile` converts a logical plan
* `FindDataSourceTable` logical evaluation rule is link:spark-sql-Analyzer-FindDataSourceTable.adoc#apply[executed]
* link:hive/RelationConversions.adoc[RelationConversions] logical evaluation rule is executed
* `CreateTempViewUsing` logical command is requested to <<spark-sql-LogicalPlan-CreateTempViewUsing.adoc#run, run>>
* Structured Streaming's `FileStreamSource` creates batches of records

[[simpleString]]
The link:spark-sql-catalyst-QueryPlan.adoc#simpleString[simple text representation] of a `LogicalRelation` (aka `simpleString`) is *Relation[output] [relation]* (that uses the <<output, output>> and <<relation, BaseRelation>>).

[source, scala]
----
val q = spark.read.text("README.md")
val logicalPlan = q.queryExecution.logical
scala> println(logicalPlan.simpleString)
Relation[value#2] text
----

=== [[creating-instance]] Creating LogicalRelation Instance

`LogicalRelation` takes the following when created:

* [[relation]] link:spark-sql-BaseRelation.adoc[BaseRelation]
* [[output]] Output schema `AttributeReferences`
* [[catalogTable]] Optional link:spark-sql-CatalogTable.adoc[CatalogTable]

=== [[apply]] `apply` Factory Utility

[source, scala]
----
apply(
  relation: BaseRelation,
  isStreaming: Boolean = false): LogicalRelation
apply(
  relation: BaseRelation,
  table: CatalogTable): LogicalRelation
----

`apply` <<creating-instance, creates>> a `LogicalRelation` for the input link:spark-sql-BaseRelation.adoc[BaseRelation] (and link:spark-sql-CatalogTable.adoc[CatalogTable] or optional `isStreaming` flag).

[NOTE]
====
`apply` is used when:

* `SparkSession` is requested for a link:spark-sql-SparkSession.adoc#baseRelationToDataFrame[DataFrame for a BaseRelation]

* link:spark-sql-LogicalPlan-CreateTempViewUsing.adoc[CreateTempViewUsing] command is executed

* link:spark-sql-Analyzer-ResolveSQLOnFile.adoc[ResolveSQLOnFile] and link:spark-sql-Analyzer-FindDataSourceTable.adoc[FindDataSourceTable] logical evaluation rules are executed

* `HiveMetastoreCatalog` is requested to link:hive/HiveMetastoreCatalog.adoc#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation]
====

=== [[refresh]] `refresh` Method

[source, scala]
----
refresh(): Unit
----

NOTE: `refresh` is part of link:spark-sql-LogicalPlan.adoc#refresh[LogicalPlan Contract] to refresh itself.

`refresh` requests the link:spark-sql-BaseRelation-HadoopFsRelation.adoc#location[FileIndex] of a `HadoopFsRelation` <<relation, relation>> to refresh.

NOTE: `refresh` does the work for link:spark-sql-BaseRelation-HadoopFsRelation.adoc[HadoopFsRelation] relations only.
