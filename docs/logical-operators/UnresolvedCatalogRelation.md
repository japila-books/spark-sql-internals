# UnresolvedCatalogRelation Leaf Logical Operator

`UnresolvedCatalogRelation` is a LeafNode.md[leaf logical operator] that acts as a placeholder in a logical query plan for [FindDataSourceTable](../logical-analysis-rules/FindDataSourceTable.md) logical evaluation rule to resolve it to a concrete relation logical operator (i.e. LogicalRelation.md[LogicalRelations] for data source tables or hive/HiveTableRelation.md[HiveTableRelations] for hive tables).

`UnresolvedCatalogRelation` is <<creating-instance, created>> when `SessionCatalog` is requested to [find a relation](../SessionCatalog.md#lookupRelation) (for DescribeTableCommand.md[DescribeTableCommand] logical command or [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical evaluation rule).

[source, scala]
----
// non-temporary global or local view
// database defined
// externalCatalog.getTable returns non-VIEW table
// Make the example reproducible
val tableName = "t1"
spark.sharedState.externalCatalog.dropTable(
  db = "default",
  table = tableName,
  ignoreIfNotExists = true,
  purge = true)
spark.range(10).write.saveAsTable(tableName)

scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog

import org.apache.spark.sql.catalyst.TableIdentifier
val plan = spark.sessionState.catalog.lookupRelation(TableIdentifier(tableName))
scala> println(plan.numberedTreeString)
00 'SubqueryAlias t1
01 +- 'UnresolvedCatalogRelation `default`.`t1`, org.apache.hadoop.hive.ql.io.parquet.serde.ParquetHiveSerDe
----

When <<creating-instance, created>>, `UnresolvedCatalogRelation` asserts that the database is specified.

[[resolved]]
`UnresolvedCatalogRelation` can never be <<spark-sql-LogicalPlan.md#resolved, resolved>> and is converted to a <<LogicalRelation.md#, LogicalRelation>> for a data source table or a hive/HiveTableRelation.md[HiveTableRelation] for a hive table at analysis phase.

[[output]]
`UnresolvedCatalogRelation` uses an empty <<catalyst/QueryPlan.md#output, output schema>>.

[[creating-instance]]
[[tableMeta]]
`UnresolvedCatalogRelation` takes a single [CatalogTable](../CatalogTable.md) when created.
