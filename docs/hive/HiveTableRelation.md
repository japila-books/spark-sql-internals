# HiveTableRelation Leaf Logical Operator -- Representing Hive Tables in Logical Plan

`HiveTableRelation` is a ../spark-sql-LogicalPlan-LeafNode.md[leaf logical operator] that represents a Hive table in a ../spark-sql-LogicalPlan.md[logical query plan].

`HiveTableRelation` is <<creating-instance, created>> when `FindDataSourceTable` logical evaluation rule is requested to ../spark-sql-Analyzer-FindDataSourceTable.md#apply[resolve UnresolvedCatalogRelations in a logical plan] (for ../spark-sql-Analyzer-FindDataSourceTable.md#readHiveTable[Hive tables]).

NOTE: `HiveTableRelation` can be RelationConversions.md#convert[converted to a HadoopFsRelation] based on configuration-properties.md#spark.sql.hive.convertMetastoreParquet[spark.sql.hive.convertMetastoreParquet] and configuration-properties.md#spark.sql.hive.convertMetastoreOrc[spark.sql.hive.convertMetastoreOrc] properties (and "disappears" from a logical plan when enabled).

`HiveTableRelation` is <<isPartitioned, partitioned>> when it has at least one <<partitionCols, partition column>>.

[[MultiInstanceRelation]]
`HiveTableRelation` is a ../spark-sql-MultiInstanceRelation.md[MultiInstanceRelation].

`HiveTableRelation` is converted (_resolved_) to as follows:

* HiveTableScanExec.md[HiveTableScanExec] physical operator in HiveTableScans.md[HiveTableScans] execution planning strategy

* InsertIntoHiveTable.md[InsertIntoHiveTable] command in HiveAnalysis.md[HiveAnalysis] logical resolution rule

[source, scala]
----
val tableName = "h1"

// Make the example reproducible
val db = spark.catalog.currentDatabase
import spark.sharedState.{externalCatalog => extCatalog}
extCatalog.dropTable(
  db, table = tableName, ignoreIfNotExists = true, purge = true)

// sql("CREATE TABLE h1 (id LONG) USING hive")
import org.apache.spark.sql.types.StructType
spark.catalog.createTable(
  tableName,
  source = "hive",
  schema = new StructType().add($"id".long),
  options = Map.empty[String, String])

val h1meta = extCatalog.getTable(db, tableName)
scala> println(h1meta.provider.get)
hive

// Looks like we've got the testing space ready for the experiment
val h1 = spark.table(tableName)

import org.apache.spark.sql.catalyst.dsl.plans._
val plan = table(tableName).insertInto("t2", overwrite = true)
scala> println(plan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'UnresolvedRelation `h1`

// ResolveRelations logical rule first to resolve UnresolvedRelations
import spark.sessionState.analyzer.ResolveRelations
val rrPlan = ResolveRelations(plan)
scala> println(rrPlan.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- 'SubqueryAlias h1
02    +- 'UnresolvedCatalogRelation `default`.`h1`, org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe

// FindDataSourceTable logical rule next to resolve UnresolvedCatalogRelations
import org.apache.spark.sql.execution.datasources.FindDataSourceTable
val findTablesRule = new FindDataSourceTable(spark)
val planWithTables = findTablesRule(rrPlan)

// At long last...
// Note HiveTableRelation in the logical plan
scala> println(planWithTables.numberedTreeString)
00 'InsertIntoTable 'UnresolvedRelation `t2`, true, false
01 +- SubqueryAlias h1
02    +- HiveTableRelation `default`.`h1`, org.apache.hadoop.hive.serde2.lazy.LazySimpleSerDe, [id#13L]
----

The ../spark-sql-CatalogTable.md[metadata] of a `HiveTableRelation` (in a catalog) has to meet the requirements:

* The ../spark-sql-CatalogTable.md#identifier[database] is defined
* The ../spark-sql-CatalogTable.md#partitionSchema[partition schema] is of the same type as <<partitionCols, partitionCols>>
* The ../spark-sql-CatalogTable.md#dataSchema[data schema] is of the same type as <<dataCols, dataCols>>

[[output]]
`HiveTableRelation` has the output attributes made up of <<dataCols, data>> followed by <<partitionCols, partition>> columns.

=== [[computeStats]] Computing Statistics -- `computeStats` Method

[source, scala]
----
computeStats(): Statistics
----

NOTE: `computeStats` is part of ../spark-sql-LogicalPlan-LeafNode.md#computeStats[LeafNode Contract] to compute statistics for ../spark-sql-cost-based-optimization.md[cost-based optimizer].

`computeStats` takes the ../spark-sql-CatalogTable.md#stats[table statistics] from the <<tableMeta, table metadata>> if defined and ../spark-sql-CatalogStatistics.md#toPlanStats[converts them to Spark statistics] (with <<output, output columns>>).

If the table statistics are not available, `computeStats` reports an `IllegalStateException`.

```
table stats must be specified.
```

=== [[creating-instance]] Creating HiveTableRelation Instance

`HiveTableRelation` takes the following when created:

* [[tableMeta]] ../spark-sql-CatalogTable.md[Table metadata]
* [[dataCols]] Columns (as a collection of `AttributeReferences`)
* [[partitionCols]] <<partition-columns, Partition columns>> (as a collection of `AttributeReferences`)

=== [[partition-columns]] Partition Columns

When created, `HiveTableRelation` is given the <<partitionCols, partition columns>>.

link:../spark-sql-Analyzer-FindDataSourceTable.md[FindDataSourceTable] logical evaluation rule creates a `HiveTableRelation` based on a ../spark-sql-CatalogTable.md[table specification] (from a catalog).

The <<partitionCols, partition columns>> are exactly ../spark-sql-CatalogTable.md#partitionSchema[partitions] of the ../spark-sql-CatalogTable.md[table specification].

=== [[isPartitioned]] `isPartitioned` Method

[source, scala]
----
isPartitioned: Boolean
----

`isPartitioned` is `true` when there is at least one <<partitionCols, partition column>>.

[NOTE]
====
`isPartitioned` is used when:

* `HiveMetastoreCatalog` is requested to HiveMetastoreCatalog.md#convertToLogicalRelation[convert a HiveTableRelation to a LogicalRelation over a HadoopFsRelation]

* RelationConversions.md[RelationConversions] logical posthoc evaluation rule is executed (on a RelationConversions.md#apply-InsertIntoTable[InsertIntoTable])

* `HiveTableScanExec` physical operator is HiveTableScanExec.md#doExecute[executed]
====
