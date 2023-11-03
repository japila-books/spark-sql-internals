# FileSourceMetadataAttribute

## Cleaning Up Metadata { #cleanupFileSourceMetadataInformation }

```scala
cleanupFileSourceMetadataInformation(
  attr: Attribute): Attribute
cleanupFileSourceMetadataInformation(
  field: StructField): StructField
```

`cleanupFileSourceMetadataInformation` [removes internal metadata](#removeInternalMetadata) from (the metadata of) the given [Attribute](../expressions/Attribute.md) or [StructField](../types/StructField.md).

---

`cleanupFileSourceMetadataInformation` is used when:

* `FileFormatWriter` is requested to [write data out](../connectors/FileFormatWriter.md#write)
* `FileFormat` is requested to [create a FileFormat metadata struct column](../connectors/FileFormat.md#createFileMetadataCol)

### removeInternalMetadata { #removeInternalMetadata }

```scala
removeInternalMetadata(
  metadata: Metadata)
```

`removeInternalMetadata` creates a new [MetadataBuilder](../types/MetadataBuilder.md) to [build a metadata](../types/MetadataBuilder.md#build) for the given [Metadata](../types/Metadata.md) but without the following metadata entries:

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
