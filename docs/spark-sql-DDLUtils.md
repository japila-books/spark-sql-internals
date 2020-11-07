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

`verifyPartitionProviderIsHive` requests the given [CatalogTable](CatalogTable.md) for the [TableIdentifier](CatalogTable.md#identifier) that is in turn requested for the table name.

`verifyPartitionProviderIsHive` throws an `AnalysisException` when [spark.sql.hive.manageFilesourcePartitions](hive/configuration-properties.md#spark.sql.hive.manageFilesourcePartitions) configuration property is disabled (`false`) and the input `CatalogTable` is a <<isDatasourceTable, data source table>>:

```text
[action] is not allowed on [tableName] since filesource partition management is disabled (spark.sql.hive.manageFilesourcePartitions = false).
```

`verifyPartitionProviderIsHive` throws an `AnalysisException` when the [tracksPartitionsInCatalog](CatalogTable.md#tracksPartitionsInCatalog) of the given `CatalogTable` is disabled (`false`) and the input `CatalogTable` is a <<isDatasourceTable, data source table>>:

```text
[action] is not allowed on [tableName] since its partition metadata is not stored in the Hive metastore. To import this information into the metastore, run `msck repair table [tableName]`
```

NOTE: `verifyPartitionProviderIsHive` is used when `AlterTableAddPartitionCommand`, `AlterTableRenamePartitionCommand`, `AlterTableDropPartitionCommand`, `AlterTableSetLocationCommand`, TruncateTableCommand.md[TruncateTableCommand], DescribeTableCommand.md[DescribeTableCommand], and `ShowPartitionsCommand` commands are executed.

## <span id="isDatasourceTable"> isDatasourceTable Utility

```scala
isDatasourceTable(
  table: CatalogTable): Boolean
```

`isDatasourceTable` is positive (`true`) when the [provider](CatalogTable.md#provider) of the input [CatalogTable](CatalogTable.md) is not [hive](#HIVE_PROVIDER) when defined. Otherwise, `isDatasourceTable` is negative (`false`).

`isDatasourceTable` is used when:

* `HiveExternalCatalog` is requested to [createTable](hive/HiveExternalCatalog.md#createTable) (and [saveTableIntoHive](hive/HiveExternalCatalog.md#saveTableIntoHive))

* `HiveUtils` utility is used to hive/HiveUtils.md#inferSchema[inferSchema]

* `AlterTableSerDePropertiesCommand`, `AlterTableAddColumnsCommand`, `LoadDataCommand`, ShowCreateTableCommand.md[ShowCreateTableCommand] commands are executed

* `DDLUtils` utility is used to <<verifyPartitionProviderIsHive, verifyPartitionProviderIsHive>>

* [DataSourceAnalysis](logical-analysis-rules/DataSourceAnalysis.md) and [FindDataSourceTable](logical-analysis-rules/FindDataSourceTable.md) logical rules are executed

## <span id="isHiveTable"> isHiveTable Utility

```scala
isHiveTable(
  provider: Option[String]): Boolean
```

`isHiveTable` is positive (`true`) when the [provider](CatalogTable.md#provider) is [hive](#HIVE_PROVIDER) when defined. Otherwise, `isHiveTable` is negative (`false`).

`isHiveTable` is used when:

* [HiveAnalysis](hive/HiveAnalysis.md) logical resolution rule is executed

* `DDLUtils` utility is used to [isHiveTable](#isHiveTable)

* `HiveOnlyCheck` extended check rule is executed

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
