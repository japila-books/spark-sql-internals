title: LogicalRelation

# LogicalRelation Leaf Logical Operator -- Representing BaseRelations in Logical Plan

`LogicalRelation` is a spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] that represents a <<relation, BaseRelation>> in a spark-sql-LogicalPlan.md[logical query plan].

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

* `DataFrameReader` [loads data from a data source that supports multiple paths](../DataFrameReader.md#load) (through SparkSession.md#baseRelationToDataFrame[SparkSession.baseRelationToDataFrame])
* `DataFrameReader` is requested to load data from an external table using [JDBC](../DataFrameReader.md#jdbc) (through SparkSession.md#baseRelationToDataFrame[SparkSession.baseRelationToDataFrame])
* `TextInputCSVDataSource` and `TextInputJsonDataSource` are requested to infer schema
* `ResolveSQLOnFile` converts a logical plan
* [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md) logical evaluation rule is executed
* hive/RelationConversions.md[RelationConversions] logical evaluation rule is executed
* `CreateTempViewUsing` logical command is requested to <<spark-sql-LogicalPlan-CreateTempViewUsing.md#run, run>>
* Structured Streaming's `FileStreamSource` creates batches of records

[[simpleString]]
The catalyst/QueryPlan.md#simpleString[simple text representation] of a `LogicalRelation` (aka `simpleString`) is *Relation[output] [relation]* (that uses the <<output, output>> and <<relation, BaseRelation>>).

[source, scala]
----
val q = spark.read.text("README.md")
val logicalPlan = q.queryExecution.logical
scala> println(logicalPlan.simpleString)
Relation[value#2] text
----

=== [[creating-instance]] Creating LogicalRelation Instance

`LogicalRelation` takes the following when created:

* [[relation]] spark-sql-BaseRelation.md[BaseRelation]
* [[output]] Output schema `AttributeReferences`
* [[catalogTable]] Optional spark-sql-CatalogTable.md[CatalogTable]

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

`apply` <<creating-instance, creates>> a `LogicalRelation` for the input spark-sql-BaseRelation.md[BaseRelation] (and spark-sql-CatalogTable.md[CatalogTable] or optional `isStreaming` flag).

`apply` is used when:

* `SparkSession` is requested for a SparkSession.md#baseRelationToDataFrame[DataFrame for a BaseRelation]

* spark-sql-LogicalPlan-CreateTempViewUsing.md[CreateTempViewUsing] command is executed

* [ResolveSQLOnFile](../logical-analysis-rules/ResolveSQLOnFile.md) and [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md) logical evaluation rules are executed

* `HiveMetastoreCatalog` is requested to hive/HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation]

=== [[refresh]] `refresh` Method

[source, scala]
----
refresh(): Unit
----

NOTE: `refresh` is part of spark-sql-LogicalPlan.md#refresh[LogicalPlan Contract] to refresh itself.

`refresh` requests the spark-sql-BaseRelation-HadoopFsRelation.md#location[FileIndex] of a `HadoopFsRelation` <<relation, relation>> to refresh.

NOTE: `refresh` does the work for spark-sql-BaseRelation-HadoopFsRelation.md[HadoopFsRelation] relations only.
