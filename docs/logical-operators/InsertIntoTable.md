# InsertIntoTable Unary Logical Operator

`InsertIntoTable` is an [unary logical operator](LogicalPlan.md#UnaryNode) that represents the following high-level operators in a logical plan:

* [INSERT INTO](#INSERT_INTO_TABLE) and [INSERT OVERWRITE TABLE](#INSERT_OVERWRITE_TABLE) SQL statements

* [DataFrameWriter.insertInto](../DataFrameWriter.md#insertInto) high-level operator

`InsertIntoTable` is <<creating-instance, created>> with <<partition, partition keys>> that correspond to the `partitionSpec` part of the following SQL statements:

* `INSERT INTO TABLE` (with the <<overwrite, overwrite>> and <<ifPartitionNotExists, ifPartitionNotExists>> flags off)

* `INSERT OVERWRITE TABLE` (with the <<overwrite, overwrite>> and <<ifPartitionNotExists, ifPartitionNotExists>> flags off)

`InsertIntoTable` has no <<partition, partition keys>> when <<creating-instance, created>> as follows:

* <<insertInto, insertInto>> operator from the [Catalyst DSL](../catalyst-dsl/index.md)

* [DataFrameWriter.insertInto](../DataFrameWriter.md#insertInto) operator

[[resolved]]
`InsertIntoTable` can never be spark-sql-LogicalPlan.md#resolved[resolved] (i.e. `InsertIntoTable` should not be part of a logical plan after analysis and is supposed to be <<logical-conversions, converted to logical commands>> at analysis phase).

[[logical-conversions]]
.InsertIntoTable's Logical Resolutions (Conversions)
[cols="1,2",options="header",width="100%"]
|===
| Logical Command
| Description

| hive/InsertIntoHiveTable.md[InsertIntoHiveTable]
| [[InsertIntoHiveTable]] When hive/HiveAnalysis.md#apply[HiveAnalysis] resolution rule transforms `InsertIntoTable` with a hive/HiveTableRelation.md[HiveTableRelation]

| <<InsertIntoDataSourceCommand.md#, InsertIntoDataSourceCommand>>
| [[InsertIntoDataSourceCommand]] When [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution resolves an `InsertIntoTable` with a <<LogicalRelation.md#, LogicalRelation>> over an [InsertableRelation](../InsertableRelation.md) (with no partitions defined)

| [InsertIntoHadoopFsRelationCommand](InsertIntoHadoopFsRelationCommand.md)
| [[InsertIntoHadoopFsRelationCommand]] When [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution transforms `InsertIntoTable` with a <<LogicalRelation.md#, LogicalRelation>> over a [HadoopFsRelation](../HadoopFsRelation.md)

|===

CAUTION: FIXME What's the difference between HiveAnalysis that converts `InsertIntoTable(r: HiveTableRelation...)` to `InsertIntoHiveTable` and `RelationConversions` that converts `InsertIntoTable(r: HiveTableRelation,...)` to `InsertIntoTable` (with `LogicalRelation`)?

NOTE: Inserting into <<inserting-into-view-not-allowed, views>> or <<inserting-into-rdd-based-table-not-allowed, RDD-based tables>> is not allowed (and fails at analysis).

`InsertIntoTable` (with UnresolvedRelation.md[UnresolvedRelation] leaf logical operator) is <<creating-instance, created>> when:

* [[INSERT_INTO_TABLE]][[INSERT_OVERWRITE_TABLE]] `INSERT INTO` or `INSERT OVERWRITE TABLE` SQL statements are executed (as a spark-sql-AstBuilder.md#visitSingleInsertQuery[single insert] or a spark-sql-AstBuilder.md#visitMultiInsertQuery[multi-insert] query)

* `DataFrameWriter` is requested to [insert a DataFrame into a table](../DataFrameWriter.md#insertInto)

* `RelationConversions` logical evaluation rule is hive/RelationConversions.md#apply[executed] (and transforms `InsertIntoTable` operators)

* hive/CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand] logical command is executed

[[output]]
`InsertIntoTable` has an empty [output schema](../catalyst/QueryPlan.md#output).

=== [[catalyst-dsl]][[insertInto]] Catalyst DSL -- `insertInto` Operator

[source, scala]
----
insertInto(
  tableName: String,
  overwrite: Boolean = false): LogicalPlan
----

[insertInto](../catalyst-dsl/index.md#insertInto) operator in [Catalyst DSL](../catalyst-dsl/index.md) creates an `InsertIntoTable` logical operator, e.g. for testing or Spark SQL internals exploration.

[source,plaintext]
----
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("a").insertInto(tableName = "t1", overwrite = true)
scala> println(plan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t1`, true, false
01 +- 'UnresolvedRelation `a`

import org.apache.spark.sql.catalyst.plans.logical.InsertIntoTable
val op = plan.p(0)
assert(op.isInstanceOf[InsertIntoTable])
----

=== [[creating-instance]] Creating InsertIntoTable Instance

`InsertIntoTable` takes the following when created:

* [[table]] spark-sql-LogicalPlan.md[Logical plan] for the table to insert into
* [[partition]] Partition keys (with optional partition values for <<spark-sql-dynamic-partition-inserts.md#, dynamic partition insert>>)
* [[query]] spark-sql-LogicalPlan.md[Logical plan] representing the data to be written
* [[overwrite]] `overwrite` flag that indicates whether to overwrite an existing table or partitions (`true`) or not (`false`)
* [[ifPartitionNotExists]] `ifPartitionNotExists` flag

=== [[inserting-into-view-not-allowed]] Inserting Into View Not Allowed

Inserting into a view is not allowed, i.e. a query plan with an `InsertIntoTable` operator with a <<UnresolvedRelation.md#, UnresolvedRelation>> leaf operator that is resolved to a <<View.md#, View>> unary operator fails at analysis (when [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution is executed).

```
Inserting into a view is not allowed. View: [name].
```

[source, scala]
----
// Create a view
val viewName = "demo_view"
sql(s"DROP VIEW IF EXISTS $viewName")
assert(spark.catalog.tableExists(viewName) == false)
sql(s"CREATE VIEW $viewName COMMENT 'demo view' AS SELECT 1,2,3")
assert(spark.catalog.tableExists(viewName))

// The following should fail with an AnalysisException
scala> spark.range(0).write.insertInto(viewName)
org.apache.spark.sql.AnalysisException: Inserting into a view is not allowed. View: `default`.`demo_view`.;
  at org.apache.spark.sql.catalyst.analysis.package$AnalysisErrorAt.failAnalysis(package.scala:42)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ResolveRelations$$anonfun$apply$8.applyOrElse(Analyzer.scala:644)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ResolveRelations$$anonfun$apply$8.applyOrElse(Analyzer.scala:640)
  at org.apache.spark.sql.catalyst.trees.TreeNode$$anonfun$transformUp$1.apply(TreeNode.scala:289)
  at org.apache.spark.sql.catalyst.trees.TreeNode$$anonfun$transformUp$1.apply(TreeNode.scala:289)
  at org.apache.spark.sql.catalyst.trees.CurrentOrigin$.withOrigin(TreeNode.scala:70)
  at org.apache.spark.sql.catalyst.trees.TreeNode.transformUp(TreeNode.scala:288)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ResolveRelations$.apply(Analyzer.scala:640)
  at org.apache.spark.sql.catalyst.analysis.Analyzer$ResolveRelations$.apply(Analyzer.scala:586)
  at org.apache.spark.sql.catalyst.rules.RuleExecutor$$anonfun$execute$1$$anonfun$apply$1.apply(RuleExecutor.scala:87)
  at org.apache.spark.sql.catalyst.rules.RuleExecutor$$anonfun$execute$1$$anonfun$apply$1.apply(RuleExecutor.scala:84)
  at scala.collection.LinearSeqOptimized$class.foldLeft(LinearSeqOptimized.scala:124)
  at scala.collection.immutable.List.foldLeft(List.scala:84)
  at org.apache.spark.sql.catalyst.rules.RuleExecutor$$anonfun$execute$1.apply(RuleExecutor.scala:84)
  at org.apache.spark.sql.catalyst.rules.RuleExecutor$$anonfun$execute$1.apply(RuleExecutor.scala:76)
  at scala.collection.immutable.List.foreach(List.scala:381)
  at org.apache.spark.sql.catalyst.rules.RuleExecutor.execute(RuleExecutor.scala:76)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.org$apache$spark$sql$catalyst$analysis$Analyzer$$executeSameContext(Analyzer.scala:124)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.execute(Analyzer.scala:118)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.executeAndCheck(Analyzer.scala:103)
  at org.apache.spark.sql.execution.QueryExecution.analyzed$lzycompute(QueryExecution.scala:57)
  at org.apache.spark.sql.execution.QueryExecution.analyzed(QueryExecution.scala:55)
  at org.apache.spark.sql.execution.QueryExecution.assertAnalyzed(QueryExecution.scala:47)
  at org.apache.spark.sql.execution.QueryExecution.withCachedData$lzycompute(QueryExecution.scala:61)
  at org.apache.spark.sql.execution.QueryExecution.withCachedData(QueryExecution.scala:60)
  at org.apache.spark.sql.execution.QueryExecution.optimizedPlan$lzycompute(QueryExecution.scala:66)
  at org.apache.spark.sql.execution.QueryExecution.optimizedPlan(QueryExecution.scala:66)
  at org.apache.spark.sql.execution.QueryExecution.sparkPlan$lzycompute(QueryExecution.scala:72)
  at org.apache.spark.sql.execution.QueryExecution.sparkPlan(QueryExecution.scala:68)
  at org.apache.spark.sql.execution.QueryExecution.executedPlan$lzycompute(QueryExecution.scala:77)
  at org.apache.spark.sql.execution.QueryExecution.executedPlan(QueryExecution.scala:77)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:75)
  at org.apache.spark.sql.DataFrameWriter.runCommand(DataFrameWriter.scala:654)
  at org.apache.spark.sql.DataFrameWriter.insertInto(DataFrameWriter.scala:322)
  at org.apache.spark.sql.DataFrameWriter.insertInto(DataFrameWriter.scala:308)
  ... 49 elided
----

=== [[inserting-into-rdd-based-table-not-allowed]] Inserting Into RDD-Based Table Not Allowed

Inserting into an RDD-based table is not allowed, i.e. a query plan with an `InsertIntoTable` operator with one of the following logical operators (as the <<table, logical plan representing the table>>) fails at analysis (when [PreWriteCheck](../logical-analysis-rules/PreWriteCheck.md) extended logical check is executed):

* Logical operator is not a <<LeafNode.md#, leaf node>>

* [Range](Range.md) leaf operator

* [OneRowRelation](OneRowRelation.md) leaf operator

* [LocalRelation](LocalRelation.md) leaf operator

[source, scala]
----
// Create a temporary view
val data = spark.range(1)
data.createOrReplaceTempView("demo")

scala> spark.range(0).write.insertInto("demo")
org.apache.spark.sql.AnalysisException: Inserting into an RDD-based table is not allowed.;;
'InsertIntoTable Range (0, 1, step=1, splits=Some(8)), false, false
+- Range (0, 0, step=1, splits=Some(8))

  at org.apache.spark.sql.execution.datasources.PreWriteCheck$.failAnalysis(rules.scala:442)
  at org.apache.spark.sql.execution.datasources.PreWriteCheck$$anonfun$apply$14.apply(rules.scala:473)
  at org.apache.spark.sql.execution.datasources.PreWriteCheck$$anonfun$apply$14.apply(rules.scala:445)
  at org.apache.spark.sql.catalyst.trees.TreeNode.foreach(TreeNode.scala:117)
  at org.apache.spark.sql.execution.datasources.PreWriteCheck$.apply(rules.scala:445)
  at org.apache.spark.sql.execution.datasources.PreWriteCheck$.apply(rules.scala:440)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis$$anonfun$checkAnalysis$2.apply(CheckAnalysis.scala:349)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis$$anonfun$checkAnalysis$2.apply(CheckAnalysis.scala:349)
  at scala.collection.mutable.ResizableArray$class.foreach(ResizableArray.scala:59)
  at scala.collection.mutable.ArrayBuffer.foreach(ArrayBuffer.scala:48)
  at org.apache.spark.sql.catalyst.analysis.CheckAnalysis$class.checkAnalysis(CheckAnalysis.scala:349)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.checkAnalysis(Analyzer.scala:92)
  at org.apache.spark.sql.catalyst.analysis.Analyzer.executeAndCheck(Analyzer.scala:105)
  at org.apache.spark.sql.execution.QueryExecution.analyzed$lzycompute(QueryExecution.scala:57)
  at org.apache.spark.sql.execution.QueryExecution.analyzed(QueryExecution.scala:55)
  at org.apache.spark.sql.execution.QueryExecution.assertAnalyzed(QueryExecution.scala:47)
  at org.apache.spark.sql.execution.QueryExecution.withCachedData$lzycompute(QueryExecution.scala:61)
  at org.apache.spark.sql.execution.QueryExecution.withCachedData(QueryExecution.scala:60)
  at org.apache.spark.sql.execution.QueryExecution.optimizedPlan$lzycompute(QueryExecution.scala:66)
  at org.apache.spark.sql.execution.QueryExecution.optimizedPlan(QueryExecution.scala:66)
  at org.apache.spark.sql.execution.QueryExecution.sparkPlan$lzycompute(QueryExecution.scala:72)
  at org.apache.spark.sql.execution.QueryExecution.sparkPlan(QueryExecution.scala:68)
  at org.apache.spark.sql.execution.QueryExecution.executedPlan$lzycompute(QueryExecution.scala:77)
  at org.apache.spark.sql.execution.QueryExecution.executedPlan(QueryExecution.scala:77)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:75)
  at org.apache.spark.sql.DataFrameWriter.runCommand(DataFrameWriter.scala:654)
  at org.apache.spark.sql.DataFrameWriter.insertInto(DataFrameWriter.scala:322)
  at org.apache.spark.sql.DataFrameWriter.insertInto(DataFrameWriter.scala:308)
  ... 49 elided
----

## Demo

```text
// make sure that the tables are available in a catalog
sql("CREATE TABLE IF NOT EXISTS t1(id long)")
sql("CREATE TABLE IF NOT EXISTS t2(id long)")

val q = sql("INSERT INTO TABLE t2 SELECT * from t1 LIMIT 100")
val plan = q.queryExecution.logical
scala> println(plan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, false, false
01 +- 'GlobalLimit 100
02    +- 'LocalLimit 100
03       +- 'Project [*]
04          +- 'UnresolvedRelation `t1`

// Dataset API's version of "INSERT OVERWRITE TABLE" in SQL
spark.range(10).write.mode("overwrite").insertInto("t2")
```

## Demo: INSERT INTO partitioned_table

```text
spark.range(10)
  .withColumn("p1", 'id % 2)
  .write
  .mode("overwrite")
  .partitionBy("p1")
  .saveAsTable("partitioned_table")

val insertIntoQ = sql("INSERT INTO TABLE partitioned_table PARTITION (p1 = 4) VALUES 41, 42")
scala> println(insertIntoQ.queryExecution.logical.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `partitioned_table`, Map(p1 -> Some(4)), false, false
01 +- 'UnresolvedInlineTable [col1], [List(41), List(42)]
```

## Demo: INSERT OVERWRITE TABLE partitioned_table

```text
spark.range(10)
  .withColumn("p1", 'id % 2)
  .write
  .mode("overwrite")
  .partitionBy("p1")
  .saveAsTable("partitioned_table")

val insertOverwriteQ = sql("INSERT OVERWRITE TABLE partitioned_table PARTITION (p1 = 4) VALUES 40")
scala> println(insertOverwriteQ.queryExecution.logical.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `partitioned_table`, Map(p1 -> Some(4)), true, false
01 +- 'UnresolvedInlineTable [col1], [List(40)]
```
