---
title: CreateTable
---

# CreateTable Logical Operator

`CreateTable` is a [LogicalPlan](LogicalPlan.md).

## Creating Instance

`CreateTable` takes the following to be created:

* <span id="tableDesc"> [CatalogTable](../CatalogTable.md)
* <span id="mode"> [SaveMode](../DataFrameWriter.md#SaveMode)
* <span id="query"> Optional Query ([LogicalPlan](LogicalPlan.md))

While being created, `CreateTable` asserts the following:

* The [table](#tableDesc) to be created must have the [provider](../CatalogTable.md#provider)
* With no [query](#query), the [SaveMode](#mode) must be `ErrorIfExists` or `Ignore`

`CreateTable` is created when:

* [DataFrameWriter.saveAsTable](../DataFrameWriter.md#saveAsTable) operator is used (to [create a table](../DataFrameWriter.md#createTable))
* [ResolveSessionCatalog](../logical-analysis-rules/ResolveSessionCatalog.md) logical resolution rule is executed (to [constructV1TableCmd](../logical-analysis-rules/ResolveSessionCatalog.md#constructV1TableCmd))

<!---
## Review Me

`CreateTable` is a [logical operator](LogicalPlan.md) that represents (is <<creating-instance, created>> for) the following:

* `DataFrameWriter` is requested to [create a table](../DataFrameWriter.md#createTable) (for [DataFrameWriter.saveAsTable](../DataFrameWriter.md#saveAsTable) operator)

* `SparkSqlAstBuilder` is requested to [visitCreateTable](../sql/SparkSqlAstBuilder.md#visitCreateTable) (for `CREATE TABLE` SQL command) or [visitCreateHiveTable](../sql/SparkSqlAstBuilder.md#visitCreateHiveTable) (for `CREATE EXTERNAL TABLE` SQL command)

* `CatalogImpl` is requested to [create a table](../CatalogImpl.md#createTable) (for [Catalog.createTable](../Catalog.md#createTable) operator)

`CreateTable` requires that the [table provider](../CatalogTable.md#provider) of the [CatalogTable](#tableDesc) is defined or throws an `AssertionError`:

```text
assertion failed: The table to be created must have a provider.
```

The optional <<query, AS query>> is defined when used for the following:

* `DataFrameWriter` is requested to [create a table](../DataFrameWriter.md#createTable) (for [DataFrameWriter.saveAsTable](../DataFrameWriter.md#saveAsTable) operator)

* `SparkSqlAstBuilder` is requested to [visitCreateTable](../sql/SparkSqlAstBuilder.md#visitCreateTable) (for `CREATE TABLE` SQL command) or [visitCreateHiveTable](../sql/SparkSqlAstBuilder.md#visitCreateHiveTable) (for `CREATE EXTERNAL TABLE` SQL command) with an AS clause

[[resolved]]
`CreateTable` can never be [resolved](../expressions/Expression.md#resolved) and is replaced (_resolved_) with a logical command at analysis phase in the following rules:

* (for non-hive data source tables) [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule to a <<CreateDataSourceTableCommand.md#, CreateDataSourceTableCommand>> or a <<CreateDataSourceTableAsSelectCommand.md#, CreateDataSourceTableAsSelectCommand>> logical command (when the <<query, query>> was defined or not, respectively)

* (for hive tables) hive/HiveAnalysis.md[HiveAnalysis] post-hoc logical resolution rule to a `CreateTableCommand` or a [CreateHiveTableAsSelectCommand](../hive/CreateHiveTableAsSelectCommand.md) logical command (when <<query, query>> was defined or not, respectively)

=== [[creating-instance]] Creating CreateTable Instance

`CreateTable` takes the following to be created:

* [[tableDesc]] [Table metadata](../CatalogTable.md)
* [[mode]] [SaveMode](../DataFrameWriter.md#SaveMode)
* [[query]] Optional AS query ([Logical query plan](../logical-operators/LogicalPlan.md))
-->
