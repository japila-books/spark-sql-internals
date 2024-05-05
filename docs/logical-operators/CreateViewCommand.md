---
title: CreateViewCommand
---

# CreateViewCommand Logical Command

`CreateViewCommand` is a [RunnableCommand](RunnableCommand.md).

`CreateViewCommand` is a [AnalysisOnlyCommand](AnalysisOnlyCommand.md).

## Creating Instance

`CreateViewCommand` takes the following to be created:

* <span id="name"> Table name (`TableIdentifier`)
* <span id="userSpecifiedColumns"> User-specified columns (`Seq[(String, Option[String])]`)
* <span id="comment"> Optional comments
* <span id="properties"> Properties (`Map[String, String]`)
* <span id="originalText"> Optional "Original Text"
* <span id="plan"> [Logical query plan](LogicalPlan.md)
* <span id="allowExisting"> `allowExisting` flag
* <span id="replace"> `replace` flag
* <span id="viewType"> `ViewType`
* <span id="isAnalyzed"> `isAnalyzed` flag (default: `false`)
* <span id="referredTempFunctions"> `referredTempFunctions`

`CreateViewCommand` is created when:

* [CacheTableAsSelectExec](../physical-operators/CacheTableAsSelectExec.md) physical operator is executed (and requested for [planToCache](../physical-operators/CacheTableAsSelectExec.md#planToCache))
* [Dataset.createTempViewCommand](../dataset/index.md#createTempViewCommand) operator is used
* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical analysis rule is executed (to resolve [CreateView](CreateView.md) logical operator)
* `SparkConnectPlanner` is requested to [handleCreateViewCommand](../connect/SparkConnectPlanner.md#handleCreateViewCommand)
* `SparkSqlAstBuilder` is requested to [parse a CREATE VIEW AS statement](../sql/SparkSqlAstBuilder.md#visitCreateView)

## Executing Command { #run }

??? note "RunnableCommand"

    ```scala
    run(
      sparkSession: SparkSession): Seq[Row]
    ```

    `run` is part of the [RunnableCommand](RunnableCommand.md#run) abstraction.

`run` requests the given [SparkSession](../SparkSession.md) for the [SessionCatalog](../SessionState.md#catalog) (through the [SessionState](../SparkSession.md#sessionState)).

`run` branches off based on this [ViewType](#viewType).

For `LocalTempView`, `run` [creates a temporary view relation](#createTemporaryViewRelation) and requests the `SessionCatalog` to [create a local temporary view](../SessionCatalog.md#createTempView).

For `GlobalTempView`, `run` [creates a temporary view relation](#createTemporaryViewRelation) and requests the `SessionCatalog` to [create a global temporary view](../SessionCatalog.md#createGlobalTempView) (in the global temporary views database per [spark.sql.globalTempDatabase](../configuration-properties.md#spark.sql.globalTempDatabase) configuration property).

For a non-temporary view, `run` branches off based on whether the [view name is registered already or not](../SessionCatalog.md#tableExists).

When the view name is in use already and this [allowExisting](#allowExisting) flag is enabled, `run` does nothing.

When the view name is in use and this [replace](#replace) flag is enabled, `run` prints out the following DEBUG message to the logs:

```text
Try to uncache [name] before replacing.
```

`run` then requests the [Catalog](../SparkSession.md#catalog) to [remove the table from the in-memory cache](../Catalog.md#uncacheTable) followed by the `SessionCatalog` to [drop](../SessionCatalog.md#dropTable) and (re)[create](../SessionCatalog.md#createTable) it.

??? note "Extra Checks when View Name In Use"
    `run` may report exceptions with extra checks that are not covered here.

When neither temporary nor the view name is registered, `run` requests the `SessionCatalog` to [create a (metastore) table](../SessionCatalog.md#createTable).

In the end, `run` returns no rows (no metrics or similar).

??? note "AnalysisException"
    `run` throws an `AnalysisException` for the [isAnalyzed](#isAnalyzed) flag disabled.

### Preparing CatalogTable { #prepareTable }

```scala
prepareTable(
  session: SparkSession,
  analyzedPlan: LogicalPlan): CatalogTable
```

`prepareTable` creates a [CatalogTable](../CatalogTable.md).

Property Name | Property Value
-|-
 [identifier](../CatalogTable.md#identifier) | [Table name](#name)
 [tableType](../CatalogTable.md#tableType) | `VIEW`
 [storage](../CatalogTable.md#storage) | Empty [CatalogStorageFormat](../CatalogStorageFormat.md)
 [schema](../CatalogTable.md#schema) | Aliased schema of the given [LogicalPlan](#plan)
 [properties](../CatalogTable.md#properties) | [generateViewProperties](#generateViewProperties)
 [viewOriginalText](../CatalogTable.md#viewOriginalText) | [originalText](#originalText)
 [viewText](../CatalogTable.md#viewText) | [originalText](#originalText)
 [comment](../CatalogTable.md#comment) | [comment](#comment)

??? note "AnalysisException"
    `prepareTable` reports an `AnalysisException` when this [originalText](#originalText) is not defined.

## Demo

```scala
val tableName = "demo_source_table"

// Demo table for "AS query" part
sql(s"CREATE TABLE ${tableName} AS SELECT * FROM VALUES 1,2,3 t(id)")

// The "AS" query
val asQuery = s"SELECT * FROM ${tableName}"

val viewName = "demo_view"

sql(s"CREATE OR REPLACE VIEW ${viewName} AS ${asQuery}")
```

```scala
sql("SHOW VIEWS").show(truncate = false)
```

```text
+---------+---------+-----------+
|namespace|viewName |isTemporary|
+---------+---------+-----------+
|default  |demo_view|false      |
+---------+---------+-----------+
```

```scala
sql(s"DESC EXTENDED ${viewName}").show(truncate = false)
```

```text
+----------------------------+---------------------------------------------------------+-------+
|col_name                    |data_type                                                |comment|
+----------------------------+---------------------------------------------------------+-------+
|id                          |int                                                      |NULL   |
|                            |                                                         |       |
|# Detailed Table Information|                                                         |       |
|Catalog                     |spark_catalog                                            |       |
|Database                    |default                                                  |       |
|Table                       |demo_view                                                |       |
|Owner                       |jacek                                                    |       |
|Created Time                |Sun Apr 21 18:22:16 CEST 2024                            |       |
|Last Access                 |UNKNOWN                                                  |       |
|Created By                  |Spark 3.5.1                                              |       |
|Type                        |VIEW                                                     |       |
|View Text                   |SELECT * FROM demo_source_table                          |       |
|View Original Text          |SELECT * FROM demo_source_table                          |       |
|View Catalog and Namespace  |spark_catalog.default                                    |       |
|View Query Output Columns   |[id]                                                     |       |
|Table Properties            |[transient_lastDdlTime=1713716536]                       |       |
|Serde Library               |org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe       |       |
|InputFormat                 |org.apache.hadoop.mapred.SequenceFileInputFormat         |       |
|OutputFormat                |org.apache.hadoop.hive.ql.io.HiveSequenceFileOutputFormat|       |
|Storage Properties          |[serialization.format=1]                                 |       |
+----------------------------+---------------------------------------------------------+-------+
```

<!---
## Review Me

`CreateViewCommand` is <<creating-instance, created>> to represent the following:

* <<spark-sql-SparkSqlAstBuilder.md#visitCreateView, CREATE VIEW AS>> SQL statements

* `Dataset` operators: <<dataset/index.md#createTempView, Dataset.createTempView>>, <<dataset/index.md#createOrReplaceTempView, Dataset.createOrReplaceTempView>>, <<dataset/index.md#createGlobalTempView, Dataset.createGlobalTempView>> and <<dataset/index.md#createOrReplaceGlobalTempView, Dataset.createOrReplaceGlobalTempView>>

`CreateViewCommand` works with different <<viewType, view types>>.

[[viewType]]
.CreateViewCommand Behaviour Per View Type
[options="header",cols="1m,2",width="100%"]
|===
| View Type
| Description / Side Effect

| LocalTempView
| [[LocalTempView]] A session-scoped *local temporary view* that is available until the session, that has created it, is stopped.

When executed, `CreateViewCommand` requests the [current `SessionCatalog` to create a temporary view](../SessionCatalog.md#createTempView).

| GlobalTempView
| [[GlobalTempView]] A cross-session *global temporary view* that is available until the Spark application stops.

When executed, `CreateViewCommand` requests the [current `SessionCatalog` to create a global view](../SessionCatalog.md#createGlobalTempView).

| PersistedView
| [[PersistedView]] A cross-session *persisted view* that is available until dropped.

When executed, `CreateViewCommand` checks if the table exists. If it does and replace is enabled `CreateViewCommand` requests the [current `SessionCatalog` to alter a table](../SessionCatalog.md#alterTable). Otherwise, when the table does not exist, `CreateViewCommand` requests the [current `SessionCatalog` to create it](../SessionCatalog.md#createTable).
|===

```text
/* CREATE [OR REPLACE] [[GLOBAL] TEMPORARY]
VIEW [IF NOT EXISTS] tableIdentifier
[identifierCommentList] [COMMENT STRING]
[PARTITIONED ON identifierList]
[TBLPROPERTIES tablePropertyList] AS query */



// The following queries should all work fine

val q2 = "CREATE OR REPLACE VIEW v1 AS " + asQuery
sql(q2)

val q3 = "CREATE OR REPLACE TEMPORARY VIEW v1 " + asQuery
sql(q3)

val q4 = "CREATE OR REPLACE GLOBAL TEMPORARY VIEW v1 " + asQuery
sql(q4)

val q5 = "CREATE VIEW IF NOT EXISTS v1 AS " + asQuery
sql(q5)

// The following queries should all fail
// the number of user-specified columns does not match the schema of the AS query
val qf1 = "CREATE VIEW v1 (c1 COMMENT 'comment', c2) AS " + asQuery
scala> sql(qf1)
org.apache.spark.sql.AnalysisException: The number of columns produced by the SELECT clause (num: `1`) does not match the number of column names specified by CREATE VIEW (num: `2`).;
  at org.apache.spark.sql.execution.command.CreateViewCommand.run(views.scala:134)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.sideEffectResult$lzycompute(commands.scala:70)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.sideEffectResult(commands.scala:68)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.executeCollect(commands.scala:79)
  at org.apache.spark.sql.Dataset$$anonfun$6.apply(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$$anonfun$6.apply(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$$anonfun$52.apply(Dataset.scala:3254)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:77)
  at org.apache.spark.sql.Dataset.withAction(Dataset.scala:3253)
  at org.apache.spark.sql.Dataset.<init>(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$.ofRows(Dataset.scala:75)
  at org.apache.spark.sql.SparkSession.sql(SparkSession.scala:641)
  ... 49 elided

// CREATE VIEW ... PARTITIONED ON is not allowed
val qf2 = "CREATE VIEW v1 PARTITIONED ON (c1, c2) AS " + asQuery
scala> sql(qf2)
org.apache.spark.sql.catalyst.parser.ParseException:
Operation not allowed: CREATE VIEW ... PARTITIONED ON(line 1, pos 0)

// Use the same name of t1 for a new view
val qf3 = "CREATE VIEW t1 AS " + asQuery
scala> sql(qf3)
org.apache.spark.sql.AnalysisException: `t1` is not a view;
  at org.apache.spark.sql.execution.command.CreateViewCommand.run(views.scala:156)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.sideEffectResult$lzycompute(commands.scala:70)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.sideEffectResult(commands.scala:68)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.executeCollect(commands.scala:79)
  at org.apache.spark.sql.Dataset$$anonfun$6.apply(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$$anonfun$6.apply(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$$anonfun$52.apply(Dataset.scala:3254)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:77)
  at org.apache.spark.sql.Dataset.withAction(Dataset.scala:3253)
  at org.apache.spark.sql.Dataset.<init>(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$.ofRows(Dataset.scala:75)
  at org.apache.spark.sql.SparkSession.sql(SparkSession.scala:641)
  ... 49 elided

// View already exists
val qf4 = "CREATE VIEW v1 AS " + asQuery
scala> sql(qf4)
org.apache.spark.sql.AnalysisException: View `v1` already exists. If you want to update the view definition, please use ALTER VIEW AS or CREATE OR REPLACE VIEW AS;
  at org.apache.spark.sql.execution.command.CreateViewCommand.run(views.scala:169)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.sideEffectResult$lzycompute(commands.scala:70)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.sideEffectResult(commands.scala:68)
  at org.apache.spark.sql.execution.command.ExecutedCommandExec.executeCollect(commands.scala:79)
  at org.apache.spark.sql.Dataset$$anonfun$6.apply(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$$anonfun$6.apply(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$$anonfun$52.apply(Dataset.scala:3254)
  at org.apache.spark.sql.execution.SQLExecution$.withNewExecutionId(SQLExecution.scala:77)
  at org.apache.spark.sql.Dataset.withAction(Dataset.scala:3253)
  at org.apache.spark.sql.Dataset.<init>(Dataset.scala:190)
  at org.apache.spark.sql.Dataset$.ofRows(Dataset.scala:75)
  at org.apache.spark.sql.SparkSession.sql(SparkSession.scala:641)
  ... 49 elided
```

[[innerChildren]]
`CreateViewCommand` returns the <<child, child logical query plan>> when requested for the [inner nodes](../catalyst/TreeNode.md#innerChildren) (that should be shown as an inner nested tree of this node).

[source, scala]
----
val sqlText = "CREATE VIEW v1 AS " + asQuery
val plan = spark.sessionState.sqlParser.parsePlan(sqlText)
scala> println(plan.numberedTreeString)
00 CreateViewCommand `v1`, SELECT * FROM t1, false, false, PersistedView
01    +- 'Project [*]
02       +- 'UnresolvedRelation `t1`
----

=== [[run]] Executing Logical Command -- `run` Method

`run` requests the input `SparkSession` for the <<SparkSession.md#sessionState, SessionState>> that is in turn requested to ["execute"](../SessionState.md#executePlan) the <<child, child logical plan>> (which simply creates a [QueryExecution](../QueryExecution.md)).

[NOTE]
====
`run` uses a <<spark-sql-LogicalPlan.md#logical-plan-to-be-analyzed-idiom, common idiom>> in Spark SQL to make sure that a logical plan can be analyzed, i.e.

[source, scala]
----
val qe = sparkSession.sessionState.executePlan(child)
qe.assertAnalyzed()
val analyzedPlan = qe.analyzed
----
====

`run` <<verifyTemporaryObjectsNotExists, verifyTemporaryObjectsNotExists>>.

`run` requests the input `SparkSession` for the <<SparkSession.md#sessionState, SessionState>> that is in turn requested for the <<SessionState.md#catalog, SessionCatalog>>.

`run` then branches off per the <<viewType, ViewType>>:

* For <<LocalTempView, local temporary views>>, `run` <<aliasPlan, alias>> the analyzed plan and requests the `SessionCatalog` to [create or replace a local temporary view](../SessionCatalog.md#createTempView)

* For <<GlobalTempView, global temporary views>>, `run` also <<aliasPlan, alias>> the analyzed plan and requests the `SessionCatalog` to [create or replace a global temporary view](../SessionCatalog.md#createGlobalTempView)

* For <<PersistedView, persisted views>>, `run` asks the `SessionCatalog` whether the [table exists or not](../SessionCatalog.md#tableExists) (given <<name, TableIdentifier>>).

** If the <<name, table>> exists and the <<allowExisting, allowExisting>> flag is on, `run` simply does nothing (and exits)

** If the <<name, table>> exists and the <<replace, replace>> flag is on, `run` requests the `SessionCatalog` for the [table metadata](../SessionCatalog.md#getTableMetadata) and replaces the table, i.e. `run` requests the `SessionCatalog` to [drop the table](../SessionCatalog.md#dropTable) followed by [re-creating it](../SessionCatalog.md#createTable) (with a <<prepareTable, new CatalogTable>>)

** If however the <<name, table>> does not exist, `run` simply requests the `SessionCatalog` to [create it](../SessionCatalog.md#createTable) (with a <<prepareTable, new CatalogTable>>)

`run` throws an `AnalysisException` for <<PersistedView, persisted views>> when they already exist, the <<allowExisting, allowExisting>> flag is off and the table type is not a view.

```
[name] is not a view
```

`run` throws an `AnalysisException` for <<PersistedView, persisted views>> when they already exist and the <<allowExisting, allowExisting>> and <<replace, replace>> flags are off.

```
View [name] already exists. If you want to update the view definition, please use ALTER VIEW AS or CREATE OR REPLACE VIEW AS
```

`run` throws an `AnalysisException` if the <<userSpecifiedColumns, userSpecifiedColumns>> are defined and their numbers is different from the number of <<catalyst/QueryPlan.md#output, output schema attributes>> of the analyzed logical plan.

```
The number of columns produced by the SELECT clause (num: `[output.length]`) does not match the number of column names specified by CREATE VIEW (num: `[userSpecifiedColumns.length]`).
```
-->
