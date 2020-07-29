# ExternalCatalogUtils

`ExternalCatalogUtils` is...FIXME

=== [[prunePartitionsByFilter]] `prunePartitionsByFilter` Method

[source, scala]
----
prunePartitionsByFilter(
  catalogTable: CatalogTable,
  inputPartitions: Seq[CatalogTablePartition],
  predicates: Seq[Expression],
  defaultTimeZoneId: String): Seq[CatalogTablePartition]
----

`prunePartitionsByFilter`...FIXME

NOTE: `prunePartitionsByFilter` is used when spark-sql-InMemoryCatalog.md#listPartitionsByFilter[InMemoryCatalog] and hive/HiveExternalCatalog.md#listPartitionsByFilter[HiveExternalCatalog] are requested to list partitions by a filter.
