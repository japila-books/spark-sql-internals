---
title: FindDataSourceTable
---

# FindDataSourceTable Logical Resolution Rule

`FindDataSourceTable` is a [Catalyst rule](../catalyst/Rule.md) to [resolve UnresolvedCatalogRelation logical operators](#apply) (of Spark and Hive tables) in a logical query plan (`Rule[LogicalPlan]`).

`FindDataSourceTable` is used by [Hive](../hive/HiveSessionStateBuilder.md#analyzer) and [Spark](../BaseSessionStateBuilder.md#analyzer) Analyzers as part of their [extendedResolutionRules](../Analyzer.md#extendedResolutionRules).

## Creating Instance

`FindDataSourceTable` takes the following to be created:

* <span id="sparkSession"> [SparkSession](../SparkSession.md)

`FindDataSourceTable` is created when:

* `HiveSessionStateBuilder` is requested for the [Analyzer](../hive/HiveSessionStateBuilder.md#analyzer)
* `BaseSessionStateBuilder` is requested for the [Analyzer](../BaseSessionStateBuilder.md#analyzer)

## Execute Rule { #apply }

??? note "Rule"

    ```scala
    apply(
      plan: LogicalPlan): LogicalPlan
    ```

    `apply` is part of the [Rule](../catalyst/Rule.md#apply) abstraction.

`apply` traverses the given [LogicalPlan](../logical-operators/LogicalPlan.md) (from top to leaves) to resolve `UnresolvedCatalogRelation`s of the following logical operators:

1. [InsertIntoStatement](../logical-operators/InsertIntoStatement.md) with a non-streaming `UnresolvedCatalogRelation` of [Spark (DataSource) table](../connectors/DDLUtils.md#isDatasourceTable)
1. [InsertIntoStatement](../logical-operators/InsertIntoStatement.md) with a non-streaming `UnresolvedCatalogRelation` of a Hive table
1. [AppendData](../logical-operators/AppendData.md) (that is not [by name](../logical-operators/AppendData.md#isByName)) with a [DataSourceV2Relation](../logical-operators/DataSourceV2Relation.md) of [V1Table](../connector/V1Table.md)
1. A non-streaming `UnresolvedCatalogRelation` of [Spark (DataSource) table](../connectors/DDLUtils.md#isDatasourceTable)
1. A non-streaming `UnresolvedCatalogRelation` of a Hive table
1. A streaming `UnresolvedCatalogRelation`
1. A `StreamingRelationV2` ([Spark Structured Streaming]({{ book.structured_streaming }}/logical-operators/StreamingRelationV2/)) over a streaming `UnresolvedCatalogRelation`

??? note "Streaming and Non-Streaming `UnresolvedCatalogRelation`s"
    The difference between streaming and non-streaming `UnresolvedCatalogRelation`s is the [isStreaming](../logical-operators/LogicalPlan.md#isStreaming) flag that is disabled (`false`) by default.

`apply`...FIXME

### Create StreamingRelation  { #getStreamingRelation }

```scala
getStreamingRelation(
  table: CatalogTable,
  extraOptions: CaseInsensitiveStringMap): StreamingRelation
```

`getStreamingRelation` creates a `StreamingRelation` ([Spark Structured Streaming]({{ book.structured_streaming }}/logical-operators/StreamingRelation/)) with a [DataSource](../DataSource.md#creating-instance) with the following:

Property | Value
-|-
 [DataSource provider](../DataSource.md#className) | The [provider](../CatalogTable.md#provider) of the given [CatalogTable](../CatalogTable.md)
 [User-specified schema](../DataSource.md#userSpecifiedSchema) | The [schema](../CatalogTable.md#schema) of the given [CatalogTable](../CatalogTable.md)
 [Options](../DataSource.md#options) | [DataSource options](../connectors/DataSourceUtils.md#generateDatasourceOptions) based on the given `extraOptions` and the [CatalogTable](../CatalogTable.md)
 [CatalogTable](../DataSource.md#catalogTable) | The given [CatalogTable](../CatalogTable.md)

---

`getStreamingRelation` is used when:

* `FindDataSourceTable` is requested to resolve streaming `UnresolvedCatalogRelation`s

## Demo

```text
scala> :type spark
org.apache.spark.sql.SparkSession
```

```scala
// Example: InsertIntoTable with UnresolvedCatalogRelation
// Drop tables to make the example reproducible
val db = spark.catalog.currentDatabase
Seq("t1", "t2").foreach { t =>
  spark.sharedState.externalCatalog.dropTable(db, t, ignoreIfNotExists = true, purge = true)
}
```

```scala
// Create tables
sql("CREATE TABLE t1 (id LONG) USING parquet")
sql("CREATE TABLE t2 (id LONG) USING orc")
```

```text
import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table("t1").insertInto(tableName = "t2", overwrite = true)
scala> println(plan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'UnresolvedRelation `t1`
```

```text
// Transform the logical plan with ResolveRelations logical rule first
// so UnresolvedRelations become UnresolvedCatalogRelations
import spark.sessionState.analyzer.ResolveRelations
val planWithUnresolvedCatalogRelations = ResolveRelations(plan)
scala> println(planWithUnresolvedCatalogRelations.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'SubqueryAlias t1
02    +- 'UnresolvedCatalogRelation `default`.`t1`, org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe
```

```text
// Let's resolve UnresolvedCatalogRelations then
import org.apache.spark.sql.execution.datasources.FindDataSourceTable
val r = new FindDataSourceTable(spark)
val tablesResolvedPlan = r(planWithUnresolvedCatalogRelations)
// FIXME Why is t2 not resolved?!
scala> println(tablesResolvedPlan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- SubqueryAlias t1
02    +- Relation[id#10L] parquet
```

<!---
## Review Me

## Executing Rule { #apply }

`apply` resolves `UnresolvedCatalogRelation`s for Spark (Data Source) and Hive tables:

* `apply` [creates HiveTableRelation logical operators](#readDataSourceTable) for `UnresolvedCatalogRelation`s of Spark tables (incl. `InsertIntoTable`s)

* `apply` [creates LogicalRelation logical operators](#readHiveTable) for `InsertIntoTable`s with `UnresolvedCatalogRelation` of a Hive table or `UnresolvedCatalogRelation`s of a Hive table

=== [[readHiveTable]] Creating HiveTableRelation Logical Operator -- `readHiveTable` Internal Method

[source, scala]
----
readHiveTable(
  table: CatalogTable): LogicalPlan
----

`readHiveTable` creates a hive/HiveTableRelation.md[HiveTableRelation] for the input [CatalogTable](../CatalogTable.md).

NOTE: `readHiveTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for hive tables).

=== [[readDataSourceTable]] Creating LogicalRelation Logical Operator for CatalogTable -- `readDataSourceTable` Internal Method

[source, scala]
----
readDataSourceTable(
  table: CatalogTable): LogicalPlan
----

`readDataSourceTable` requests the <<sparkSession, SparkSession>> for SessionState.md#catalog[SessionCatalog].

`readDataSourceTable` requests the `SessionCatalog` for the [cached logical plan](../SessionCatalog.md#getCachedPlan) for the input [CatalogTable](../CatalogTable.md).

If not available, `readDataSourceTable` [creates a new DataSource](../DataSource.md) for the [provider](../CatalogTable.md#provider) (of the input `CatalogTable`) with the extra `path` option (based on the `locationUri` of the [storage](../CatalogTable.md#storage) of the input `CatalogTable`). `readDataSourceTable` requests the `DataSource` to [resolve the relation and create a corresponding BaseRelation](../DataSource.md#resolveRelation) that is then used to create a [LogicalRelation](../logical-operators/LogicalRelation.md) with the input [CatalogTable](../CatalogTable.md).

NOTE: `readDataSourceTable` is used when `FindDataSourceTable` is requested to <<apply, resolve an UnresolvedCatalogRelation in a logical plan>> (for data source tables).
-->
