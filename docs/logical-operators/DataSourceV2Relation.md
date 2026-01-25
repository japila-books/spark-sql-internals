---
title: DataSourceV2Relation
---

# DataSourceV2Relation Leaf Logical Operator

`DataSourceV2Relation` is a [leaf logical operator](DataSourceV2RelationBase.md) that represents a scan over [tables with support for BATCH_READ](#TableCapabilityCheck) ([at the very least](#TableCapabilityCheck)).

`DataSourceV2Relation` is an [ExposesMetadataColumns](ExposesMetadataColumns.md) and [can add extra metadata columns to the output columns](#withMetadataColumns).

## Creating Instance

`DataSourceV2Relation` takes the following to be created:

* <span id="table"> [Table](../connector/Table.md)
* <span id="output"> [Output Columns](../catalyst/QueryPlan.md#output)
* [CatalogPlugin](#catalog)
* <span id="identifier"> `Identifier`
* <span id="options"> Options
* <span id="timeTravelSpec"> [TimeTravelSpec](../time-travel/TimeTravelSpec.md)

`DataSourceV2Relation` is created (indirectly) using [create](#create) utility (and [withMetadataColumns](#withMetadataColumns)).

### CatalogPlugin { #catalog }

`DataSourceV2Relation` can be given a [CatalogPlugin](../connector/catalog/CatalogPlugin.md) when [created](#creating-instance).

The `CatalogPlugin` can be as follows:

* [Current Catalog](../connector/catalog/CatalogManager.md#currentCatalog) for a single-part table reference
* [v2SessionCatalog](../connector/catalog/CatalogManager.md#v2SessionCatalog) for global temp views
* [Custom Catalog by name](../connector/catalog/CatalogManager.md#catalog)

## Creating DataSourceV2Relation { #create }

```scala
create(
  table: Table,
  catalog: Option[CatalogPlugin],
  identifier: Option[Identifier]): DataSourceV2Relation
create(
  table: Table,
  catalog: Option[CatalogPlugin],
  identifier: Option[Identifier],
  options: CaseInsensitiveStringMap): DataSourceV2Relation
```

`create` replaces `CharType` and `VarcharType` types in the schema of the given [Table](../connector/Table.md) with "annotated" `StringType` (as the query engine doesn't support char/varchar).

In the end, `create` uses the new schema to [create a DataSourceV2Relation](#creating-instance).

---

`create` is used when:

* `CatalogV2Util` utility is used to [loadRelation](../connector/catalog/CatalogV2Util.md#loadRelation)
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto), [saveAsTable](../DataFrameWriter.md#saveAsTable) and [saveInternal](../DataFrameWriter.md#saveInternal)
* `DataSourceV2Strategy` execution planning strategy is requested to [invalidateCache](../execution-planning-strategies/DataSourceV2Strategy.md#invalidateCache)
* `RenameTableExec` physical command is executed
* `ResolveTables` logical resolution rule is executed
* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rule is executed (and requested to [lookupRelation](../logical-analysis-rules/ResolveRelations.md#lookupRelation))
* `DataFrameReader` is requested to [load data](../DataFrameReader.md#load)

## Metadata Columns { #metadataOutput }

??? note "LogicalPlan"

    ```scala
    metadataOutput: Seq[AttributeReference]
    ```

    `metadataOutput` is part of the [LogicalPlan](LogicalPlan.md#metadataOutput) abstraction.

`metadataOutput` checks out whether this [Table](#table) is a [SupportsMetadataColumns](../connector/SupportsMetadataColumns.md).
If so, `metadataOutput` requests this [Table](#table) for [metadata columns](../connector/SupportsMetadataColumns.md#metadataColumns).

Otherwise, `metadataOutput` returns no metadata columns (`Nil`).

??? note "Lazy Value"
    `metadataOutput` is a Scala **lazy value** to guarantee that the code to initialize it is executed once only (when accessed for the first time) and the computed value never changes afterwards.

    Learn more in the [Scala Language Specification]({{ scala.spec }}/05-classes-and-objects.html#lazy).

## Add Metadata Columns to Output Columns { #withMetadataColumns }

??? note "ExposesMetadataColumns"

    ```scala
    withMetadataColumns(): DataSourceV2Relation
    ```

    `withMetadataColumns` is part of the [ExposesMetadataColumns](ExposesMetadataColumns.md#withMetadataColumns) abstraction.

`withMetadataColumns` creates a `DataSourceV2Relation` with the extra [metadata columns](#metadataOutput) added (if there are any) to this [output columns](#output).

## Required Table Capabilities { #TableCapabilityCheck }

[TableCapabilityCheck](../logical-analysis-rules/TableCapabilityCheck.md) is used to assert the following regarding `DataSourceV2Relation` and the [Table](#table):

1. [Table](#table) supports [BATCH_READ](../connector/TableCapability.md#BATCH_READ)
1. [Table](#table) supports [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE) or [V1_BATCH_WRITE](../connector/TableCapability.md#V1_BATCH_WRITE) for [AppendData](AppendData.md) (_append in batch mode_)
1. [Table](#table) supports [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE) with [OVERWRITE_DYNAMIC](../connector/TableCapability.md#OVERWRITE_DYNAMIC) for [OverwritePartitionsDynamic](OverwritePartitionsDynamic.md) (_dynamic overwrite in batch mode_)
1. [Table](#table) supports [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE), [V1_BATCH_WRITE](../connector/TableCapability.md#V1_BATCH_WRITE) or [OVERWRITE_BY_FILTER](../connector/TableCapability.md#OVERWRITE_BY_FILTER) possibly with [TRUNCATE](../connector/TableCapability.md#TRUNCATE) for [OverwriteByExpression](OverwriteByExpression.md) (_truncate in batch mode_ and _overwrite by filter in batch mode_)
