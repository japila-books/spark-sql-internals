# PruneHiveTablePartitions Logical Optimization

`PruneHiveTablePartitions` is a logical optimization for partitioned Hive tables.

## Creating Instance

`PruneHiveTablePartitions` takes the following to be created:

* <span id="session"> [SparkSession](../SparkSession.md)

`PruneHiveTablePartitions` is created when:

* `HiveSessionStateBuilder` is requested to [customEarlyScanPushDownRules](../hive/HiveSessionStateBuilder.md#customEarlyScanPushDownRules)

## <span id="updateTableMeta"> updateTableMeta

```scala
updateTableMeta(
  relation: HiveTableRelation,
  prunedPartitions: Seq[CatalogTablePartition],
  partitionKeyFilters: ExpressionSet): CatalogTable
```

`updateTableMeta`...FIXME

---

`updateTableMeta` is used when:

* `PruneHiveTablePartitions` is [executed](#apply) (for a partitioned [HiveTableRelation](../hive/HiveTableRelation.md) logical operator under a filter)
