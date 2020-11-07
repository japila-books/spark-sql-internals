# CatalogTable

`CatalogTable` is the **specification** (_metadata_) of a table.

`CatalogTable` is stored in a [SessionCatalog](SessionCatalog.md) (session-scoped catalog of relational entities).

```text
scala> :type spark.sessionState.catalog
org.apache.spark.sql.catalyst.catalog.SessionCatalog

// Using high-level user-friendly catalog interface
scala> spark.catalog.listTables.filter($"name" === "t1").show
+----+--------+-----------+---------+-----------+
|name|database|description|tableType|isTemporary|
+----+--------+-----------+---------+-----------+
|  t1| default|       null|  MANAGED|      false|
+----+--------+-----------+---------+-----------+

// Using low-level internal SessionCatalog interface to access CatalogTables
val t1Tid = spark.sessionState.sqlParser.parseTableIdentifier("t1")
val t1Metadata = spark.sessionState.catalog.getTempViewOrPermanentTableMetadata(t1Tid)
scala> :type t1Metadata
org.apache.spark.sql.catalyst.catalog.CatalogTable
```

`CatalogTable` is <<creating-instance, created>> when:

* `SessionCatalog` is requested for a [table metadata](SessionCatalog.md#getTempViewOrPermanentTableMetadata)

* `HiveClientImpl` is requested for hive/HiveClientImpl.md#getTableOption[looking up a table in a metastore]

* `DataFrameWriter` is requested to [create a table](DataFrameWriter.md#createTable)

* hive/InsertIntoHiveDirCommand.md[InsertIntoHiveDirCommand] logical command is executed

* `SparkSqlAstBuilder` does spark-sql-SparkSqlAstBuilder.md#visitCreateTable[visitCreateTable] and spark-sql-SparkSqlAstBuilder.md#visitCreateHiveTable[visitCreateHiveTable]

* `CreateTableLikeCommand` logical command is executed

* `CreateViewCommand` logical command is <<CreateViewCommand.md#run, executed>> (and <<CreateViewCommand.md#prepareTable, prepareTable>>)

* `CatalogImpl` is requested to [createTable](CatalogImpl.md#createTable)

[[simpleString]]
The *readable text representation* of a `CatalogTable` (aka `simpleString`) is...FIXME

NOTE: `simpleString` is used exclusively when `ShowTablesCommand` logical command is <<ShowTablesCommand.md#run, executed>> (with a partition specification).

[[toString]]
`CatalogTable` uses the following *text representation* (i.e. `toString`)...FIXME

`CatalogTable` is <<creating-instance, created>> with the optional <<bucketSpec, bucketing specification>> that is used for the following:

* `CatalogImpl` is requested to [list the columns of a table](CatalogImpl.md#listColumns-internal)

* `FindDataSourceTable` logical evaluation rule is requested to [readDataSourceTable](logical-analysis-rules/FindDataSourceTable.md#readDataSourceTable) (when [executed](logical-analysis-rules/FindDataSourceTable.md) for data source tables)

* `CreateTableLikeCommand` logical command is executed

* `DescribeTableCommand` logical command is requested to <<DescribeTableCommand.md#run, describe detailed partition and storage information>> (when <<DescribeTableCommand.md#run, executed>>)

* <<ShowCreateTableCommand.md#, ShowCreateTableCommand>> logical command is executed

* <<CreateDataSourceTableCommand.md#run, CreateDataSourceTableCommand>> and <<CreateDataSourceTableAsSelectCommand.md#run, CreateDataSourceTableAsSelectCommand>> logical commands are executed

* `CatalogTable` is requested to <<toLinkedHashMap, convert itself to LinkedHashMap>>

* `HiveExternalCatalog` is requested to [doCreateTable](hive/HiveExternalCatalog.md#doCreateTable), [tableMetaToTableProps](hive/HiveExternalCatalog.md#tableMetaToTableProps), [doAlterTable](hive/HiveExternalCatalog.md#doAlterTable), [restoreHiveSerdeTable](hive/HiveExternalCatalog.md#restoreHiveSerdeTable) and [restoreDataSourceTable](hive/HiveExternalCatalog.md#restoreDataSourceTable)

* `HiveClientImpl` is requested to hive/HiveClientImpl.md#getTableOption[retrieve a table metadata if available]>> and hive/HiveClientImpl.md#toHiveTable[toHiveTable]

* hive/InsertIntoHiveTable.md[InsertIntoHiveTable] logical command is executed

* `DataFrameWriter` is requested to [create a table](DataFrameWriter.md#createTable) (via [saveAsTable](DataFrameWriter.md#saveAsTable))

* `SparkSqlAstBuilder` is requested to <<spark-sql-SparkSqlAstBuilder.md#visitCreateTable, visitCreateTable>> and <<spark-sql-SparkSqlAstBuilder.md#visitCreateHiveTable, visitCreateHiveTable>>

## Creating Instance

`CatalogTable` takes the following to be created:

* [[identifier]] `TableIdentifier`
* [[tableType]] <<CatalogTableType, Table type>>
* [[storage]] spark-sql-CatalogStorageFormat.md[CatalogStorageFormat]
* [[schema]] [Schema](StructType.md)
* [[provider]] Name of the table provider (optional)
* [[partitionColumnNames]] Partition column names
* [[bucketSpec]] Optional <<spark-sql-BucketSpec.md#, Bucketing specification>> (default: `None`)
* [[owner]] Owner
* [[createTime]] Create time
* [[lastAccessTime]] Last access time
* [[createVersion]] Create version
* [[properties]] Properties
* [[stats]] Optional spark-sql-CatalogStatistics.md[table statistics]
* [[viewText]] Optional view text
* [[comment]] Optional comment
* [[unsupportedFeatures]] Unsupported features
* [[tracksPartitionsInCatalog]] `tracksPartitionsInCatalog` flag
* [[schemaPreservesCase]] `schemaPreservesCase` flag
* [[ignoredProperties]] Ignored properties

=== [[CatalogTableType]] Table Type

The type of a table (`CatalogTableType`) can be one of the following:

* `EXTERNAL` for external tables (hive/HiveClientImpl.md#getTableOption[EXTERNAL_TABLE] in Hive)
* `MANAGED` for managed tables (hive/HiveClientImpl.md#getTableOption[MANAGED_TABLE] in Hive)
* `VIEW` for views (hive/HiveClientImpl.md#getTableOption[VIRTUAL_VIEW] in Hive)

`CatalogTableType` is included when a `TreeNode` is requested for a [JSON representation](catalyst/TreeNode.md#shouldConvertToJson) for...FIXME

=== [[stats-metadata]] Table Statistics for Query Planning (Auto Broadcast Joins and Cost-Based Optimization)

You manage a table metadata using the [Catalog](Catalog.md) interface. Among the management tasks is to get the <<stats, statistics>> of a table (that are used for spark-sql-cost-based-optimization.md[cost-based query optimization]).

[source, scala]
----
scala> t1Metadata.stats.foreach(println)
CatalogStatistics(714,Some(2),Map(p1 -> ColumnStat(2,Some(0),Some(1),0,4,4,None), id -> ColumnStat(2,Some(0),Some(1),0,4,4,None)))

scala> t1Metadata.stats.map(_.simpleString).foreach(println)
714 bytes, 2 rows
----

NOTE: The <<stats, CatalogStatistics>> are optional when `CatalogTable` is <<creating-instance, created>>.

CAUTION: FIXME When are stats specified? What if there are not?

Unless <<stats, CatalogStatistics>> are available in a table metadata (in a catalog) for a non-streaming [file data source table](FileFormat.md), `DataSource` [creates](DataSource.md#resolveRelation) a `HadoopFsRelation` with the table size specified by [spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes) internal property (default: `Long.MaxValue`) for query planning of joins (and possibly to auto broadcast the table).

Internally, Spark alters table statistics using [ExternalCatalog.doAlterTableStats](ExternalCatalog.md#doAlterTableStats).

Unless <<stats, CatalogStatistics>> are available in a table metadata (in a catalog) for `HiveTableRelation` (and `hive` provider) `DetermineTableStats` logical resolution rule can compute the table size using HDFS (if [spark.sql.statistics.fallBackToHdfs](configuration-properties.md#spark.sql.statistics.fallBackToHdfs) property is turned on) or assume [spark.sql.defaultSizeInBytes](configuration-properties.md#spark.sql.defaultSizeInBytes) (that effectively disables table broadcasting).

When requested to hive/HiveClientImpl.md#getTableOption[look up a table in a metastore], `HiveClientImpl` hive/HiveClientImpl.md#readHiveStats[reads table or partition statistics directly from a Hive metastore].

You can use AnalyzeColumnCommand.md[AnalyzeColumnCommand], AnalyzePartitionCommand.md[AnalyzePartitionCommand], AnalyzeTableCommand.md[AnalyzeTableCommand] commands to record statistics in a catalog.

The table statistics can be [automatically updated](CommandUtils.md#updateTableStats) (after executing commands like `AlterTableAddPartitionCommand`) when [spark.sql.statistics.size.autoUpdate.enabled](configuration-properties.md#spark.sql.statistics.size.autoUpdate.enabled) property is turned on.

You can use `DESCRIBE` SQL command to show the histogram of a column if stored in a catalog.

=== [[dataSchema]] `dataSchema` Method

[source, scala]
----
dataSchema: StructType
----

`dataSchema`...FIXME

NOTE: `dataSchema` is used when...FIXME

=== [[partitionSchema]] `partitionSchema` Method

[source, scala]
----
partitionSchema: StructType
----

`partitionSchema`...FIXME

NOTE: `partitionSchema` is used when...FIXME

=== [[toLinkedHashMap]] Converting Table Specification to LinkedHashMap -- `toLinkedHashMap` Method

[source, scala]
----
toLinkedHashMap: mutable.LinkedHashMap[String, String]
----

`toLinkedHashMap` converts the table specification to a collection of pairs (`LinkedHashMap[String, String]`) with the following fields and their values:

* *Database* with the database of the <<identifier, TableIdentifier>>

* *Table* with the table of the <<identifier, TableIdentifier>>

* *Owner* with the <<owner, owner>> (if defined)

* *Created Time* with the <<createTime, createTime>>

* *Created By* with `Spark` and the <<createVersion, createVersion>>

* *Type* with the name of the <<tableType, CatalogTableType>>

* *Provider* with the <<provider, provider>> (if defined)

* <<spark-sql-BucketSpec.md#toLinkedHashMap, Bucket specification>> (of the <<bucketSpec, BucketSpec>> if defined)

* *Comment* with the <<comment, comment>> (if defined)

* *View Text*, *View Default Database* and *View Query Output Columns* for <<tableType, VIEW table type>>

* *Table Properties* with the <<tableProperties, tableProperties>> (if not empty)

* *Statistics* with the <<stats, CatalogStatistics>> (if defined)

* <<spark-sql-CatalogStorageFormat.md#toLinkedHashMap, Storage specification>> (of the <<storage, CatalogStorageFormat>> if defined)

* *Partition Provider* with *Catalog* if the <<tracksPartitionsInCatalog, tracksPartitionsInCatalog>> flag is on

* *Partition Columns* with the <<partitionColumns, partitionColumns>> (if not empty)

* *Schema* with the <<schema, schema>> (if not empty)

[NOTE]
====
`toLinkedHashMap` is used when:

* `DescribeTableCommand` is requested to DescribeTableCommand.md#describeFormattedTableInfo[describeFormattedTableInfo] (when `DescribeTableCommand` is requested to DescribeTableCommand.md#run[run] for a non-temporary table and the DescribeTableCommand.md#isExtended[isExtended] flag on)

* `CatalogTable` is requested for either a <<simpleString, simple>> or a <<toString, catalog>> text representation
====

=== [[database]] `database` Method

[source, scala]
----
database: String
----

`database` simply returns the database (of the <<identifier, TableIdentifier>>) or throws an `AnalysisException`:

```
table [identifier] did not specify database
```

NOTE: `database` is used when...FIXME
