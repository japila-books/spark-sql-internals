title: InsertIntoDir

# InsertIntoDir Unary Logical Operator

`InsertIntoDir` is a link:spark-sql-LogicalPlan.adoc#UnaryNode[unary logical operator] that represents link:spark-sql-AstBuilder.adoc#withInsertInto[INSERT OVERWRITE DIRECTORY] SQL statement.

NOTE: `InsertIntoDir` is similar to link:InsertIntoTable.adoc[InsertIntoTable] logical operator.

[[resolved]]
`InsertIntoDir` can never be link:spark-sql-LogicalPlan.adoc#resolved[resolved] (i.e. `InsertIntoTable` should not be part of a logical plan after analysis and is supposed to be <<logical-conversions, converted to logical commands>> at analysis phase).

[[logical-conversions]]
.InsertIntoDir's Logical Resolutions (Conversions)
[cols="30,70",options="header",width="100%"]
|===
| Logical Command
| Description

| link:hive/InsertIntoHiveDirCommand.adoc[InsertIntoHiveDirCommand]
| [[InsertIntoHiveDirCommand]] When link:hive/HiveAnalysis.adoc[HiveAnalysis] logical resolution rule transforms `InsertIntoDir` with a link:spark-sql-DDLUtils.adoc#isHiveTable[Hive table]

| link:spark-sql-LogicalPlan-InsertIntoDataSourceDirCommand.adoc[InsertIntoDataSourceDirCommand]
| [[InsertIntoDataSourceDirCommand]] When link:spark-sql-Analyzer-DataSourceAnalysis.adoc[DataSourceAnalysis] logical resolution rule transforms `InsertIntoDir` with a Spark table

|===

[[output]]
`InsertIntoDir` has no link:spark-sql-catalyst-QueryPlan.adoc#output[output columns].

=== [[creating-instance]] Creating InsertIntoDir Instance

`InsertIntoDir` takes the following to be created:

* [[isLocal]] `isLocal` Flag
* [[storage]] link:spark-sql-CatalogStorageFormat.adoc[CatalogStorageFormat]
* [[provider]] Table provider
* [[child]] Child link:spark-sql-LogicalPlan.adoc[logical operator]
* [[overwrite]] `overwrite` Flag (default: `true`)
