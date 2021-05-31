# DataSourceV2Relation Leaf Logical Operator

`DataSourceV2Relation` is a [leaf logical operator](LeafNode.md) that represents a data scan over [tables with support for BATCH_READ](#TableCapabilityCheck) ([at the very least](#TableCapabilityCheck)).

## Creating Instance

`DataSourceV2Relation` takes the following to be created:

* <span id="table"> [Table](../connector/Table.md)
* <span id="output"> Output [AttributeReference](../expressions/AttributeReference.md)s
* <span id="catalog"> (optional) [CatalogPlugin](../connector/catalog/CatalogPlugin.md)
* <span id="identifier"> (optional) `Identifier`
* <span id="options"> Case-Insensitive Options

`DataSourceV2Relation` is created (indirectly) using [create](#create) utility and [withMetadataColumns](#withMetadataColumns).

## <span id="create"> Creating DataSourceV2Relation

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

`create` is used when:

* `CatalogV2Util` utility is used to [loadRelation](../connector/catalog/CatalogV2Util.md#loadRelation)
* `DataFrameWriter` is requested to [insertInto](../DataFrameWriter.md#insertInto), [saveAsTable](../DataFrameWriter.md#saveAsTable) and [saveInternal](../DataFrameWriter.md#saveInternal)
* `DataSourceV2Strategy` execution planning strategy is requested to [invalidateCache](../execution-planning-strategies/DataSourceV2Strategy.md#invalidateCache)
* [RenameTableExec](../physical-operators/RenameTableExec.md) physical command is executed
* [ResolveTables](../logical-analysis-rules/ResolveTables.md) logical resolution rule is executed (and requested to [lookupV2Relation](../logical-analysis-rules/ResolveTables.md#lookupV2Relation))
* [ResolveRelations](../logical-analysis-rules/ResolveRelations.md) logical resolution rule is executed (and requested to [lookupRelation](../logical-analysis-rules/ResolveRelations.md#lookupRelation))
* `DataFrameReader` is requested to [load data](../DataFrameReader.md#load)

## <span id="MultiInstanceRelation"> MultiInstanceRelation

`DataSourceV2Relation` is a [MultiInstanceRelation](MultiInstanceRelation.md).

## <span id="metadataOutput"> Metadata Columns

```scala
metadataOutput: Seq[AttributeReference]
```

`metadataOutput` is part of the [LogicalPlan](LogicalPlan.md#metadataOutput) abstraction.

`metadataOutput` requests the [Table](#table) for the [metadata columns](../connector/SupportsMetadataColumns.md#metadataColumns) (if it is a [SupportsMetadataColumns](../connector/SupportsMetadataColumns.md)).

`metadataOutput` filters out metadata columns with the same name as regular [output columns](../catalyst/QueryPlan.md#output).

## <span id="withMetadataColumns"> Creating DataSourceV2Relation with Metadata Columns

```scala
withMetadataColumns(): DataSourceV2Relation
```

`withMetadataColumns` [creates a DataSourceV2Relation](#creating-instance) with the extra [metadataOutput](#metadataOutput) (for the [output attributes](#output)) if defined.

`withMetadataColumns` is used when:

* [AddMetadataColumns](../logical-analysis-rules/AddMetadataColumns.md) logical resolution rule is executed

## <span id="TableCapabilityCheck"> Required Table Capabilities

[TableCapabilityCheck](../logical-analysis-rules/TableCapabilityCheck.md) is used to assert the following regarding `DataSourceV2Relation` and the [Table](#table):

1. [Table](#table) supports [BATCH_READ](../connector/TableCapability.md#BATCH_READ)
1. [Table](#table) supports [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE) or [V1_BATCH_WRITE](../connector/TableCapability.md#V1_BATCH_WRITE) for [AppendData](AppendData.md) (_append in batch mode_)
1. [Table](#table) supports [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE) with [OVERWRITE_DYNAMIC](../connector/TableCapability.md#OVERWRITE_DYNAMIC) for [OverwritePartitionsDynamic](OverwritePartitionsDynamic.md) (_dynamic overwrite in batch mode_)
1. [Table](#table) supports [BATCH_WRITE](../connector/TableCapability.md#BATCH_WRITE), [V1_BATCH_WRITE](../connector/TableCapability.md#V1_BATCH_WRITE) or [OVERWRITE_BY_FILTER](../connector/TableCapability.md#OVERWRITE_BY_FILTER) possibly with [TRUNCATE](../connector/TableCapability.md#TRUNCATE) for [OverwriteByExpression](OverwriteByExpression.md) (_truncate in batch mode_ and _overwrite by filter in batch mode_)

## <span id="name"> Name

```scala
name: String
```

`name` is part of the [NamedRelation](NamedRelation.md#name) abstraction.

`name` requests the [Table](#table) for the [name](../connector/Table.md#name)

## <span id="simpleString"> Simple Node Description

```scala
simpleString(
  maxFields: Int): String
```

`simpleString` is part of the [TreeNode](../catalyst/TreeNode.md#simpleString) abstraction.

`simpleString` gives the following (with the [output](#output) and the [name](#name)):

```text
RelationV2[output] [name]
```
