# FileSourceMetadataAttribute

## cleanupFileSourceMetadataInformation { #cleanupFileSourceMetadataInformation }

```scala
cleanupFileSourceMetadataInformation(
  attr: Attribute): Attribute
```

`cleanupFileSourceMetadataInformation` [removeInternalMetadata](#removeInternalMetadata).

---

`cleanupFileSourceMetadataInformation` is used when:

* `FileFormatWriter` is requested to [write data out](../connectors/FileFormatWriter.md#write)

### removeInternalMetadata { #removeInternalMetadata }

```scala
removeInternalMetadata(
  attr: Attribute): Attribute
```

`removeInternalMetadata` removes the following internal entries from the [metadata](../expressions/NamedExpression.md#metadata) of the given [Attribute](../expressions/Attribute.md):

* [__metadata_col](#METADATA_COL_ATTR_KEY)
* [__file_source_metadata_col](#FILE_SOURCE_METADATA_COL_ATTR_KEY)
* [__file_source_constant_metadata_col](FileSourceConstantMetadataAttribute.md#FILE_SOURCE_CONSTANT_METADATA_COL_ATTR_KEY)
* [__file_source_generated_metadata_col](FileSourceConstantMetadataAttribute.md#FILE_SOURCE_GENERATED_METADATA_COL_ATTR_KEY)

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
 [__file_source_metadata_col](#FILE_SOURCE_METADATA_COL_ATTR_KEY) | `true`

---

`apply` is used when:

* `FileFormat` is requested to [createFileMetadataCol](../connectors/FileFormat.md#createFileMetadataCol)
