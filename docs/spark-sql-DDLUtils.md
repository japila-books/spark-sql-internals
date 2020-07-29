# DDLUtils Utility

`DDLUtils` is a helper object that...FIXME

[[HIVE_PROVIDER]]
`DDLUtils` uses `hive` value to denote hive/index.md[Hive data source] (_Hive provider_).

=== [[verifyPartitionProviderIsHive]] `verifyPartitionProviderIsHive` Utility

[source, scala]
----
verifyPartitionProviderIsHive(
  spark: SparkSession,
  table: CatalogTable,
  action: String): Unit
----

`verifyPartitionProviderIsHive` requests the given spark-sql-CatalogTable.md[CatalogTable] for the spark-sql-CatalogTable.md#identifier[TableIdentifier] that is in turn requested for the table name.

`verifyPartitionProviderIsHive` throws an `AnalysisException` when hive/configuration-properties.md#spark.sql.hive.manageFilesourcePartitions[spark.sql.hive.manageFilesourcePartitions] configuration property is disabled (`false`) and the input `CatalogTable` is a <<isDatasourceTable, data source table>>:

```
[action] is not allowed on [tableName] since filesource partition management is disabled (spark.sql.hive.manageFilesourcePartitions = false).
```

`verifyPartitionProviderIsHive` throws an `AnalysisException` when the spark-sql-CatalogTable.md#tracksPartitionsInCatalog[tracksPartitionsInCatalog] of the given `CatalogTable` is disabled (`false`) and the input `CatalogTable` is a <<isDatasourceTable, data source table>>:

```
[action] is not allowed on [tableName] since its partition metadata is not stored in the Hive metastore. To import this information into the metastore, run `msck repair table [tableName]`
```

NOTE: `verifyPartitionProviderIsHive` is used when `AlterTableAddPartitionCommand`, `AlterTableRenamePartitionCommand`, `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand`, spark-sql-LogicalPlan-TruncateTableCommand.md[TruncateTableCommand], spark-sql-LogicalPlan-DescribeTableCommand.md[DescribeTableCommand], and `ShowPartitionsCommand` commands are executed.

=== [[isDatasourceTable]] `isDatasourceTable` Utility

[source, scala]
----
isDatasourceTable(
  table: CatalogTable): Boolean
----

`isDatasourceTable` is positive (`true`) when the spark-sql-CatalogTable.md#provider[provider] of the input spark-sql-CatalogTable.md[CatalogTable] is not <<HIVE_PROVIDER, hive>> when defined. Otherwise, `isDatasourceTable` is negative (`false`).

`isDatasourceTable` is used when:

* `HiveExternalCatalog` is requested to hive/HiveExternalCatalog.md#createTable[createTable] (and hive/HiveExternalCatalog.md#saveTableIntoHive[saveTableIntoHive])

* `HiveUtils` utility is used to hive/HiveUtils.md#inferSchema[inferSchema]

* `AlterTableSerDePropertiesCommand`, `AlterTableAddColumnsCommand`, `LoadDataCommand`, spark-sql-LogicalPlan-ShowCreateTableCommand.md[ShowCreateTableCommand] commands are executed

* `DDLUtils` utility is used to <<verifyPartitionProviderIsHive, verifyPartitionProviderIsHive>>

* [DataSourceAnalysis](logical-analysis-rules/DataSourceAnalysis.md) and [FindDataSourceTable](logical-analysis-rules/FindDataSourceTable.md) logical rules are executed

=== [[isHiveTable]] `isHiveTable` Utility

[source, scala]
----
isHiveTable(
  provider: Option[String]): Boolean
----

`isHiveTable` is positive (`true`) when the spark-sql-CatalogTable.md#provider[provider] is <<HIVE_PROVIDER, hive>> when defined. Otherwise, `isHiveTable` is negative (`false`).

[NOTE]
====
`isHiveTable` is used when:

* hive/HiveAnalysis.md[HiveAnalysis] logical resolution rule is executed

* `DDLUtils` utility is used to <<isHiveTable, isHiveTable>>

* `HiveOnlyCheck` extended check rule is executed
====

=== [[verifyNotReadPath]] `verifyNotReadPath` Utility

[source, scala]
----
verifyNotReadPath(
  query: LogicalPlan,
  outputPath: Path) : Unit
----

`verifyNotReadPath`...FIXME

[NOTE]
====
`verifyNotReadPath` is used when...FIXME
====
