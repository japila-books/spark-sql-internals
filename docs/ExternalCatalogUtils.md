# ExternalCatalogUtils

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

`prunePartitionsByFilter` is used when [InMemoryCatalog](InMemoryCatalog.md#listPartitionsByFilter) and [HiveExternalCatalog](hive/HiveExternalCatalog.md#listPartitionsByFilter) are requested to list partitions by a filter.
