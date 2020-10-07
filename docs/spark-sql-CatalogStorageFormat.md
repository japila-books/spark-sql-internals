title: CatalogStorageFormat

# CatalogStorageFormat -- Storage Specification of Table or Partition

:java-version: 8
:java-api: https://docs.oracle.com/javase/{java-version}/docs/api

[[creating-instance]]
`CatalogStorageFormat` is the *storage specification* of a partition or a table, i.e. the metadata that includes the following:

* [[locationUri]] Location URI (as a Java {java-api}/java/net/URI.html[URI])
* [[inputFormat]] Input format
* [[outputFormat]] Output format
* [[serde]] SerDe
* [[compressed]] `compressed` flag
* [[properties]] Properties (as `Map[String, String]`)

`CatalogStorageFormat` is <<creating-instance, created>> when:

* `HiveClientImpl` is requested for metadata of a hive/HiveClientImpl.md#getTableOption[table] or hive/HiveClientImpl.md#fromHivePartition[table partition]

* `SparkSqlAstBuilder` is requested to parse Hive-specific spark-sql-SparkSqlAstBuilder.md#visitCreateHiveTable[CREATE TABLE] or spark-sql-SparkSqlAstBuilder.md#visitInsertOverwriteHiveDir[INSERT OVERWRITE DIRECTORY] SQL statements

[[toString]]
`CatalogStorageFormat` uses the following *text representation* (i.e. `toString`)...FIXME

=== [[toLinkedHashMap]] Converting Storage Specification to LinkedHashMap -- `toLinkedHashMap` Method

[source, scala]
----
toLinkedHashMap: mutable.LinkedHashMap[String, String]
----

`toLinkedHashMap`...FIXME

`toLinkedHashMap` is used when:

* `CatalogStorageFormat` is requested for a <<toString, text representation>>

* `CatalogTablePartition` is requested for spark-sql-CatalogTablePartition.md#toLinkedHashMap[toLinkedHashMap]

* `CatalogTable` is requested for [toLinkedHashMap](CatalogTable.md#toLinkedHashMap)

* `DescribeTableCommand` is requested to spark-sql-LogicalPlan-DescribeTableCommand.md#run[run]
