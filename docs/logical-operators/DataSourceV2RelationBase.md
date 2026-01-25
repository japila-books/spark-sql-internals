---
title: DataSourceV2RelationBase
---

# DataSourceV2RelationBase Logical Operators

`DataSourceV2RelationBase` is an marker extension of the [LeafNode](LogicalPlan.md#LeafNode) abstraction for [leaf logical operators](#implementations) with support for [MultiInstanceRelation](MultiInstanceRelation.md) and [NamedRelation](NamedRelation.md).

## Implementations

* [DataSourceV2Relation](DataSourceV2Relation.md)
* `StreamingDataSourceV2Relation` ([Spark Structured Streaming]({{ book.structured_streaming }}/logical-operators/StreamingDataSourceV2Relation))

## Creating Instance

`DataSourceV2RelationBase` takes the following to be created:

* <span id="table"> [Table](../connector/Table.md)
* <span id="output"> Output Columns
* <span id="catalog"> [CatalogPlugin](../connector/catalog/CatalogPlugin.md)
* <span id="identifier"> `Identifier`
* <span id="options"> Options
* <span id="timeTravelSpec"> [TimeTravelSpec](../time-travel/TimeTravelSpec.md)

??? note "Abstract Class"
    `DataSourceV2RelationBase` is an abstract class and cannot be created directly.
    It is created indirectly for the [concrete DataSourceV2RelationBases](#implementations).

## skipSchemaResolution { #skipSchemaResolution }

??? note "NamedRelation"

    ```scala
    skipSchemaResolution: Boolean
    ```

    `skipSchemaResolution` is part of the [NamedRelation](NamedRelation.md#skipSchemaResolution) abstraction.

`skipSchemaResolution` is enabled (`true`) when this [Table](#table) supports [ACCEPT_ANY_SCHEMA](../connector/TableCapability.md#ACCEPT_ANY_SCHEMA) table capability.
