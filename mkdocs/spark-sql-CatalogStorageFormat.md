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

* `HiveClientImpl` is requested for metadata of a link:hive/HiveClientImpl.adoc#getTableOption[table] or link:hive/HiveClientImpl.adoc#fromHivePartition[table partition]

* `SparkSqlAstBuilder` is requested to parse Hive-specific link:spark-sql-SparkSqlAstBuilder.adoc#visitCreateHiveTable[CREATE TABLE] or link:spark-sql-SparkSqlAstBuilder.adoc#visitInsertOverwriteHiveDir[INSERT OVERWRITE DIRECTORY] SQL statements

[[toString]]
`CatalogStorageFormat` uses the following *text representation* (i.e. `toString`)...FIXME

=== [[toLinkedHashMap]] Converting Storage Specification to LinkedHashMap -- `toLinkedHashMap` Method

[source, scala]
----
toLinkedHashMap: mutable.LinkedHashMap[String, String]
----

`toLinkedHashMap`...FIXME

[NOTE]
====
`toLinkedHashMap` is used when:

* `CatalogStorageFormat` is requested for a <<toString, text representation>>

* `CatalogTablePartition` is requested for link:spark-sql-CatalogTablePartition.adoc#toLinkedHashMap[toLinkedHashMap]

* `CatalogTable` is requested for link:spark-sql-CatalogTable.adoc#toLinkedHashMap[toLinkedHashMap]

* `DescribeTableCommand` is requested to link:spark-sql-LogicalPlan-DescribeTableCommand.adoc#run[run]
====
