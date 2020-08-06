title: CreateTable

# CreateTable Logical Operator

`CreateTable` is a spark-sql-LogicalPlan.md[logical operator] that represents (is <<creating-instance, created>> for) the following:

* `DataFrameWriter` is requested to spark-sql-DataFrameWriter.md#createTable[create a table] (for spark-sql-DataFrameWriter.md#saveAsTable[DataFrameWriter.saveAsTable] operator)

* `SparkSqlAstBuilder` is requested to spark-sql-SparkSqlAstBuilder.md#visitCreateTable[visitCreateTable] (for `CREATE TABLE` SQL command) or spark-sql-SparkSqlAstBuilder.md#visitCreateHiveTable[visitCreateHiveTable] (for `CREATE EXTERNAL TABLE` SQL command)

* `CatalogImpl` is requested to [create a table](../CatalogImpl.md#createTable) (for [Catalog.createTable](../Catalog.md#createTable) operator)

`CreateTable` requires that the <<spark-sql-CatalogTable.md#provider, table provider>> of the <<tableDesc, CatalogTable>> is defined or throws an `AssertionError`:

```
assertion failed: The table to be created must have a provider.
```

The optional <<query, AS query>> is defined when used for the following:

* `DataFrameWriter` is requested to spark-sql-DataFrameWriter.md#createTable[create a table] (for spark-sql-DataFrameWriter.md#saveAsTable[DataFrameWriter.saveAsTable] operator)

* `SparkSqlAstBuilder` is requested to spark-sql-SparkSqlAstBuilder.md#visitCreateTable[visitCreateTable] (for `CREATE TABLE` SQL command) or spark-sql-SparkSqlAstBuilder.md#visitCreateHiveTable[visitCreateHiveTable] (for `CREATE EXTERNAL TABLE` SQL command) with an AS clause

[[resolved]]
`CreateTable` can never be <<expressions/Expression.md#resolved, resolved>> and is replaced (_resolved_) with a logical command at analysis phase in the following rules:

* (for non-hive data source tables) [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) posthoc logical resolution rule to a <<spark-sql-LogicalPlan-CreateDataSourceTableCommand.md#, CreateDataSourceTableCommand>> or a <<spark-sql-LogicalPlan-CreateDataSourceTableAsSelectCommand.md#, CreateDataSourceTableAsSelectCommand>> logical command (when the <<query, query>> was defined or not, respectively)

* (for hive tables) hive/HiveAnalysis.md[HiveAnalysis] post-hoc logical resolution rule to a <<spark-sql-LogicalPlan-CreateTableCommand.md#, CreateTableCommand>> or a hive/CreateHiveTableAsSelectCommand.md[CreateHiveTableAsSelectCommand] logical command (when <<query, query>> was defined or not, respectively)

=== [[creating-instance]] Creating CreateTable Instance

`CreateTable` takes the following to be created:

* [[tableDesc]] spark-sql-CatalogTable.md[Table metadata]
* [[mode]] spark-sql-DataFrameWriter.md#SaveMode[SaveMode]
* [[query]] Optional AS query (spark-sql-LogicalPlan.md[Logical query plan])

When created, `CreateTable` makes sure that the optional <<query, logical query plan>> is undefined only when the <<mode, mode>> is `ErrorIfExists` or `Ignore`. `CreateTable` throws an `AssertionError` otherwise:

```
assertion failed: create table without data insertion can only use ErrorIfExists or Ignore as SaveMode.
```
