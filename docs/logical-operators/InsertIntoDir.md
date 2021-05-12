# InsertIntoDir Unary Logical Operator

`InsertIntoDir` is a spark-sql-LogicalPlan.md#UnaryNode[unary logical operator] that represents sql/AstBuilder.md#withInsertInto[INSERT OVERWRITE DIRECTORY] SQL statement.

NOTE: `InsertIntoDir` is similar to InsertIntoTable.md[InsertIntoTable] logical operator.

[[resolved]]
`InsertIntoDir` can never be spark-sql-LogicalPlan.md#resolved[resolved] (i.e. `InsertIntoTable` should not be part of a logical plan after analysis and is supposed to be <<logical-conversions, converted to logical commands>> at analysis phase).

[[logical-conversions]]
.InsertIntoDir's Logical Resolutions (Conversions)
[cols="30,70",options="header",width="100%"]
|===
| Logical Command
| Description

| hive/InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand]
| [[InsertIntoHiveDirCommand]] When hive/HiveAnalysis.md[HiveAnalysis] logical resolution rule transforms `InsertIntoDir` with a spark-sql-DDLUtils.md#isHiveTable[Hive table]

| InsertIntoDataSourceDirCommand
| [[InsertIntoDataSourceDirCommand]] When [DataSourceAnalysis](../logical-analysis-rules/DataSourceAnalysis.md) logical resolution rule transforms `InsertIntoDir` with a Spark table

|===

[[output]]
`InsertIntoDir` has no [output columns](../catalyst/QueryPlan.md#output).

## Creating Instance

`InsertIntoDir` takes the following to be created:

* [[isLocal]] `isLocal` Flag
* [[storage]] [CatalogStorageFormat](../CatalogStorageFormat.md)
* [[provider]] Table provider
* [[child]] Child [logical operator](LogicalPlan.md)
* [[overwrite]] `overwrite` Flag (default: `true`)
