# CatalogStorageFormat

[[creating-instance]]
`CatalogStorageFormat` is the **storage specification** of a partition or a table, i.e. the metadata that includes the following:

* [[locationUri]] Location URI (Java [URI]({{ java.api }}/java.base/java/net/URI.html))
* [[inputFormat]] Input format
* [[outputFormat]] Output format
* [[serde]] SerDe
* [[compressed]] `compressed` flag
* [[properties]] Properties (as `Map[String, String]`)

`CatalogStorageFormat` is <<creating-instance, created>> when:

* `HiveClientImpl` is requested for metadata of a [table](hive/HiveClientImpl.md#getTableOption) or [table partition](hive/HiveClientImpl.md#fromHivePartition)

* `SparkSqlAstBuilder` is requested to parse Hive-specific [CREATE TABLE](sql/SparkSqlAstBuilder.md#visitCreateHiveTable) or [INSERT OVERWRITE DIRECTORY](sql/SparkSqlAstBuilder.md#visitInsertOverwriteHiveDir) SQL statements

[[toString]]
`CatalogStorageFormat` uses the following *text representation* (i.e. `toString`)...FIXME

=== [[toLinkedHashMap]] Converting Storage Specification to LinkedHashMap -- `toLinkedHashMap` Method

[source, scala]
----
toLinkedHashMap: mutable.LinkedHashMap[String, String]
----

`toLinkedHashMap`...FIXME

`toLinkedHashMap` is used when:

* `CatalogStorageFormat` is requested for a [text representation](#toString)
* `CatalogTablePartition` is requested for [toLinkedHashMap](CatalogTablePartition.md#toLinkedHashMap)
* `CatalogTable` is requested for [toLinkedHashMap](CatalogTable.md#toLinkedHashMap)
* [DescribeTableCommand](logical-operators/DescribeTableCommand.md) is executed
