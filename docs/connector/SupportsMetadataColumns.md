# SupportsMetadataColumns

`SupportsMetadataColumns` is an [extension](#contract) of the [Table](Table.md) abstraction for [tables](#implementations) with [metadata columns](#metadataColumns).

## Contract

### <span id="metadataColumns"> metadataColumns

```java
MetadataColumn[] metadataColumns()
```

[MetadataColumn](catalog/MetadataColumn.md)s of this table

Used when:

* `DataSourceV2Relation` is requested for the [metadata output](../logical-operators/DataSourceV2Relation.md#metadataOutput)
* [DescribeTableExec](../physical-operators/DescribeTableExec.md) physical command is [executed](../physical-operators/DescribeTableExec.md#addMetadataColumns)

## Implementations

!!! note
    No built-in implementations available.
