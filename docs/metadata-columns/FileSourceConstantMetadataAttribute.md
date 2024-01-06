# FileSourceConstantMetadataAttribute

## Creating Metadata AttributeReference { #apply }

```scala
apply(
  name: String,
  dataType: DataType,
  nullable: Boolean = false): AttributeReference
```

`apply` creates an `AttributeReference` with the following metadata:

Metadata Key | Value
-------------|------
 [__metadata_col](#METADATA_COL_ATTR_KEY) | `true`
 [__file_source_metadata_col](FileSourceMetadataAttribute.md#FILE_SOURCE_METADATA_COL_ATTR_KEY) | `true`
 [__file_source_constant_metadata_col](#FILE_SOURCE_CONSTANT_METADATA_COL_ATTR_KEY) | `true`

---

`apply` is used when:

* [FileSourceStrategy](../execution-planning-strategies/FileSourceStrategy.md) execution planning strategy is executed (to plan a [LogicalRelation](../logical-operators/LogicalRelation.md) over a [HadoopFsRelation](../files/HadoopFsRelation.md))
