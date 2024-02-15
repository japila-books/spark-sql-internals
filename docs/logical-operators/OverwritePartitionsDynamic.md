---
title: OverwritePartitionsDynamic
---

# OverwritePartitionsDynamic Logical Command

`OverwritePartitionsDynamic` is a [V2WriteCommand](V2WriteCommand.md) for dynamically overwrite partitions in an existing [table](#table) (that [supports dynamic overwrite in batch mode](#tablecapabilitycheck)).

## Creating Instance

`OverwritePartitionsDynamic` takes the following to be created:

* <span id="table"> [NamedRelation](NamedRelation.md)
* <span id="query"> [Query](LogicalPlan.md)
* <span id="writeOptions"> Write Options
* <span id="isByName"> `isByName` flag

`OverwritePartitionsDynamic` is created (indirectly) using [byName](#byName) and [byPosition](#byPosition) utilities.

## <span id="byName"> Creating OverwritePartitionsDynamic by Name

```scala
byName(
  table: NamedRelation,
  df: LogicalPlan,
  writeOptions: Map[String, String] = Map.empty): OverwritePartitionsDynamic
```

`byName` creates a [OverwritePartitionsDynamic](#creating-instance) with the [isByName](#isByName) flag enabled (`true`).

`byName` is used when:

* `DataFrameWriterV2` is requested to [overwritePartitions](../DataFrameWriterV2.md#overwritePartitions)

## <span id="byPosition"> Creating OverwritePartitionsDynamic by Position

```scala
byPosition(
  table: NamedRelation,
  query: LogicalPlan,
  writeOptions: Map[String, String] = Map.empty): OverwritePartitionsDynamic
```

`byPosition` creates a [OverwritePartitionsDynamic](#creating-instance) with the [isByName](#isByName) flag disabled (`false`).

`byPosition` is used when:

* [ResolveInsertInto](../logical-analysis-rules/ResolveInsertInto.md) logical resolution rule is executed (for [InsertIntoStatement](InsertIntoStatement.md)s over [DataSourceV2Relation](DataSourceV2Relation.md))
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto)

## Execution Planning

`OverwritePartitionsDynamic` (over [DataSourceV2Relation](DataSourceV2Relation.md)) is planned as `OverwritePartitionsDynamicExec` physical operator by [DataSourceV2Strategy](../execution-planning-strategies/DataSourceV2Strategy.md) execution planning strategy.

## TableCapabilityCheck

[TableCapabilityCheck](../logical-analysis-rules/TableCapabilityCheck.md) extended analysis check asserts that `OverwritePartitionsDynamic` uses [DataSourceV2Relation](DataSourceV2Relation.md) that supports [dynamic overwrite](../connector/TableCapability.md#OVERWRITE_DYNAMIC) in [batch mode](../connector/TableCapability.md#BATCH_WRITE).
